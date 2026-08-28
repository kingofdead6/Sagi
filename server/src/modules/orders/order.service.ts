import mongoose, { type ClientSession, type FilterQuery, type Types } from 'mongoose';
import { Order, type OrderDoc } from './order.model';
import { actorAllowed, canTransition, isTerminal, type OrderStatus } from './order.state';
import { priceOrder, type QuoteInput } from './pricing.service';
import { Address } from '../addresses/address.model';
import { User, type Role } from '../users/user.model';
import { Voucher, VoucherRedemption } from '../vouchers/voucher.model';
import { Assignment } from '../assignments/assignment.model';
import { AgentStatus } from '../agents/agent.model';
import { ApiError } from '../../utils/ApiError';
import { generateUniqueOrderCode } from '../../utils/orderCode';
import { supportsTransactions } from '../../config/db';
import { logger } from '../../config/logger';
import { realtime } from '../../realtime/emitter';
import { pushToUser } from '../../realtime/push.service';
import { getSettings } from '../settings/settings.service';
import { buildPage, skipFor, type Page } from '../../utils/pagination';

export const ORDER_POPULATE = [
  { path: 'vendor', select: 'name slug logo cover phone addressText location prepTimeMin prepTimeMax' },
  { path: 'customer', select: 'fullName phone avatar' },
  { path: 'agent', select: 'fullName phone avatar' },
];

export interface CreateOrderInput extends QuoteInput {
  addressId: string;
  customerNote?: string;
}

/** Public quote — prices a basket without creating anything. */
export async function quote(customerId: string, input: QuoteInput) {
  const priced = await priceOrder(customerId, input);
  return {
    vendorId: String(priced.vendor._id),
    items: priced.items.map((i) => ({
      productId: i.productId,
      name: i.nameSnapshot,
      qty: i.qty,
      unitPriceCentimes: i.unitPriceCentimes,
      lineTotalCentimes: i.lineTotalCentimes,
      selectedOptions: i.selectedOptions,
    })),
    subtotalCentimes: priced.subtotalCentimes,
    serviceFeeCentimes: priced.serviceFeeCentimes,
    deliveryFeeCentimes: priced.deliveryFeeCentimes,
    discountCentimes: priced.discountCentimes,
    voucherDiscountCentimes: priced.voucherDiscountCentimes,
    pointsUsed: priced.pointsUsed,
    pointsDiscountCentimes: priced.pointsDiscountCentimes,
    pointsEarned: priced.pointsEarned,
    totalCentimes: priced.totalCentimes,
    voucherCode: priced.voucher?.code ?? null,
    warnings: priced.warnings,
  };
}

async function withSession<T>(fn: (session: ClientSession | null) => Promise<T>): Promise<T> {
  if (!supportsTransactions()) {
    // Standalone Mongo: run without a transaction and rely on the compensating
    // writes in createOrder (see DECISIONS.md).
    return fn(null);
  }
  const session = await mongoose.startSession();
  try {
    let result!: T;
    await session.withTransaction(async () => {
      result = await fn(session);
    });
    return result;
  } finally {
    await session.endSession();
  }
}

export async function createOrder(customerId: string, input: CreateOrderInput) {
  const settings = await getSettings();

  const address = await Address.findOne({ _id: input.addressId, user: customerId });
  if (!address) throw ApiError.notFound('العنوان غير موجود');

  if (input.paymentMethod === 'electronic' && !settings.electronicPaymentEnabled) {
    throw ApiError.badRequest('الدفع الإلكتروني غير متوفر حالياً');
  }

  const priced = await priceOrder(customerId, input);

  const code = await generateUniqueOrderCode(
    async (candidate) => (await Order.countDocuments({ code: candidate })) > 0,
  );

  const created = await withSession(async (session) => {
    const opts = session ? { session } : {};

    // Deduct points first so a concurrent order cannot spend the same balance.
    if (priced.pointsUsed > 0) {
      const res = await User.updateOne(
        { _id: customerId, points: { $gte: priced.pointsUsed } },
        { $inc: { points: -priced.pointsUsed } },
        opts,
      );
      if (res.modifiedCount === 0) throw ApiError.conflict('رصيد النقاط غير كافٍ');
    }

    if (priced.voucher) {
      const res = await Voucher.updateOne(
        {
          _id: priced.voucher._id,
          isActive: true,
          $or: [{ maxUses: 0 }, { $expr: { $lt: ['$usedCount', '$maxUses'] } }],
        },
        { $inc: { usedCount: 1 } },
        opts,
      );
      if (res.modifiedCount === 0) {
        if (priced.pointsUsed > 0) {
          await User.updateOne({ _id: customerId }, { $inc: { points: priced.pointsUsed } }, opts);
        }
        throw ApiError.conflict('لم تعد القسيمة صالحة');
      }
    }

    const docs = await Order.create(
      [
        {
          code,
          customer: customerId,
          vendor: priced.vendor._id,
          status: 'pending' as OrderStatus,
          deliveryType: input.deliveryType,
          paymentMethod: input.paymentMethod ?? 'cash',
          address: {
            label: address.label,
            wilaya: address.wilaya,
            commune: address.commune,
            street: address.street,
            notes: address.notes,
          },
          deliveryLocation: address.location,
          customerNote: input.customerNote,
          items: priced.orderItems,
          subtotalCentimes: priced.subtotalCentimes,
          serviceFeeCentimes: priced.serviceFeeCentimes,
          deliveryFeeCentimes: priced.deliveryFeeCentimes,
          discountCentimes: priced.discountCentimes,
          pointsUsed: priced.pointsUsed,
          pointsEarned: priced.pointsEarned,
          totalCentimes: priced.totalCentimes,
          voucher: priced.voucher?._id ?? null,
          events: [
            { from: null, to: 'pending', actor: customerId, actorRole: 'customer', at: new Date() },
          ],
        },
      ],
      session ? { session, ordered: true } : {},
    );

    const order = docs[0]!;

    if (priced.voucher) {
      await VoucherRedemption.create(
        [{ voucher: priced.voucher._id, user: customerId, order: order._id }],
        session ? { session, ordered: true } : {},
      );
    }

    return order;
  });

  const full = await Order.findById(created._id).populate(ORDER_POPULATE);
  realtime.orderNew(full?.toJSON());
  logger.info({ orderId: String(created._id), code }, 'Order created');
  return full!.toJSON();
}

export interface TransitionContext {
  actorId: string;
  actorRole: Role;
  note?: string;
  /** Extra whitelisted fields written alongside the status. */
  extra?: Record<string, unknown>;
}

/**
 * The ONE place a status is ever written. Validates the transition, the actor's
 * role, then appends an audit event and emits the realtime update.
 */
export async function transition(
  orderId: string,
  to: OrderStatus,
  ctx: TransitionContext,
): Promise<OrderDoc> {
  const order = await Order.findById(orderId);
  if (!order) throw ApiError.notFound('الطلب غير موجود');

  const from = order.status;

  if (from === to) throw ApiError.illegalTransition('الطلب في هذه الحالة بالفعل');
  if (isTerminal(from)) throw ApiError.illegalTransition('الطلب منتهٍ ولا يمكن تغييره');
  if (!canTransition(from, to)) {
    throw ApiError.illegalTransition(`لا يمكن الانتقال من ${from} إلى ${to}`);
  }
  if (!actorAllowed(from, to, ctx.actorRole)) {
    throw ApiError.forbidden('لا تملك صلاحية تنفيذ هذا التغيير');
  }
  if (to === 'cancelled' && !ctx.note) {
    throw ApiError.badRequest('سبب الإلغاء مطلوب');
  }

  const now = new Date();
  order.status = to;

  switch (to) {
    case 'confirmed':
      order.confirmedBy = ctx.actorId as unknown as Types.ObjectId;
      order.confirmedAt = now;
      break;
    case 'assigned':
      order.assignedAt = now;
      break;
    case 'accepted':
      order.acceptedAt = now;
      break;
    case 'picked_up':
      order.pickedUpAt = now;
      break;
    case 'delivered':
      order.deliveredAt = now;
      break;
    case 'cancelled':
      order.cancelledReason = ctx.note ?? null;
      break;
    default:
      break;
  }

  if (ctx.extra) {
    for (const [key, value] of Object.entries(ctx.extra)) {
      (order as unknown as Record<string, unknown>)[key] = value;
    }
  }

  order.events.push({
    from,
    to,
    actor: ctx.actorId as unknown as Types.ObjectId,
    actorRole: ctx.actorRole,
    note: ctx.note,
    at: now,
  });

  await order.save();

  await afterTransition(order, from, to);
  return order;
}

async function afterTransition(order: OrderDoc, from: OrderStatus, to: OrderStatus) {
  const orderId = String(order._id);
  const customerId = String(order.customer);

  realtime.orderStatus(orderId, customerId, {
    orderId,
    code: order.code,
    from,
    to,
    at: new Date().toISOString(),
    agentId: order.agent ? String(order.agent) : null,
  });

  // Free the agent and award loyalty points once the delivery is finished.
  if (to === 'delivered') {
    if (order.agent) {
      await AgentStatus.updateOne({ agent: order.agent }, { $set: { currentOrder: null } });
    }
    if (order.pointsEarned > 0) {
      await User.updateOne({ _id: order.customer }, { $inc: { points: order.pointsEarned } });
    }
  }

  if (to === 'cancelled') {
    if (order.agent) {
      await AgentStatus.updateOne({ agent: order.agent }, { $set: { currentOrder: null } });
    }
    // Give the customer their points back; the voucher use stands.
    if (order.pointsUsed > 0) {
      await User.updateOne({ _id: order.customer }, { $inc: { points: order.pointsUsed } });
    }
  }

  const notices: Record<string, { title: string; body: string } | undefined> = {
    confirmed: { title: 'تم تأكيد طلبك', body: `طلبك ${order.code} قيد التحضير الآن` },
    on_the_way: { title: 'طلبك في الطريق', body: `السائق في طريقه إليك بطلب ${order.code}` },
    delivered: { title: 'تم توصيل طلبك', body: `نتمنى أن ينال إعجابك — ${order.code}` },
    cancelled: { title: 'تم إلغاء طلبك', body: order.cancelledReason ?? `الطلب ${order.code} أُلغي` },
  };
  const notice = notices[to];
  if (notice) {
    await pushToUser(customerId, {
      ...notice,
      data: { orderId, code: order.code, status: to },
    });
  }
}

export async function assignAgent(orderId: string, agentId: string, adminId: string) {
  const settings = await getSettings();

  const agent = await User.findOne({ _id: agentId, role: 'agent', isActive: true });
  if (!agent) throw ApiError.notFound('السائق غير موجود');

  const status = await AgentStatus.findOne({ agent: agentId });
  if (!status?.isOnline) throw ApiError.conflict('السائق غير متصل حالياً');
  if (status.currentOrder) throw ApiError.conflict('السائق مشغول بطلب آخر');

  const order = await transition(orderId, 'assigned', {
    actorId: adminId,
    actorRole: 'admin',
    extra: { agent: agentId },
    note: `أُسند إلى ${agent.fullName}`,
  });

  const expiresAt = new Date(Date.now() + settings.assignTimeoutSec * 1000);
  const assignment = await Assignment.create({
    order: order._id,
    agent: agentId,
    state: 'offered',
    offeredAt: new Date(),
    expiresAt,
  });

  await AgentStatus.updateOne({ agent: agentId }, { $set: { currentOrder: order._id } });

  const populated = await Order.findById(order._id).populate(ORDER_POPULATE);
  realtime.orderAssigned(agentId, {
    assignmentId: String(assignment._id),
    order: populated?.toJSON(),
    expiresAt: expiresAt.toISOString(),
    timeoutSec: settings.assignTimeoutSec,
  });

  await pushToUser(agentId, {
    title: 'طلب توصيل جديد',
    body: `${(populated?.vendor as unknown as { name?: string })?.name ?? 'متجر'} — ${order.code}`,
    highPriority: true,
    data: { type: 'offer', orderId: String(order._id), assignmentId: String(assignment._id) },
  });

  return { order: populated!.toJSON(), assignment: assignment.toJSON() };
}

/** Returns a rejected/expired order to the pool so the admin can reassign it. */
export async function releaseAssignment(
  orderId: string,
  agentId: string,
  actorRole: Role,
  reason: string,
  state: 'rejected' | 'expired',
) {
  const assignment = await Assignment.findOne({
    order: orderId,
    agent: agentId,
    state: 'offered',
  });
  if (!assignment) throw ApiError.notFound('لا يوجد عرض توصيل مفتوح');

  assignment.state = state;
  assignment.respondedAt = new Date();
  assignment.rejectReason = reason;
  await assignment.save();

  await AgentStatus.updateOne({ agent: agentId }, { $set: { currentOrder: null } });

  const order = await transition(orderId, 'ready', {
    actorId: agentId,
    actorRole,
    note: state === 'expired' ? 'انتهت مهلة الاستجابة' : reason,
    extra: { agent: null },
  });

  return order;
}

export async function acceptAssignment(orderId: string, agentId: string) {
  const assignment = await Assignment.findOne({
    order: orderId,
    agent: agentId,
    state: 'offered',
  });
  if (!assignment) throw ApiError.notFound('لا يوجد عرض توصيل مفتوح');
  if (assignment.expiresAt.getTime() < Date.now()) {
    throw ApiError.conflict('انتهت مهلة قبول هذا الطلب');
  }

  assignment.state = 'accepted';
  assignment.respondedAt = new Date();
  await assignment.save();

  return transition(orderId, 'accepted', { actorId: agentId, actorRole: 'agent' });
}

export interface OrderListFilters {
  status?: OrderStatus | OrderStatus[];
  vendor?: string;
  agent?: string;
  customer?: string;
  from?: Date;
  to?: Date;
  paymentMethod?: string;
  deliveryType?: string;
  q?: string;
  page?: number;
  limit?: number;
}

export function buildOrderFilter(filters: OrderListFilters): FilterQuery<OrderDoc> {
  const query: FilterQuery<OrderDoc> = {};
  if (filters.status) {
    query.status = Array.isArray(filters.status) ? { $in: filters.status } : filters.status;
  }
  if (filters.vendor) query.vendor = filters.vendor;
  if (filters.agent) query.agent = filters.agent;
  if (filters.customer) query.customer = filters.customer;
  if (filters.paymentMethod) query.paymentMethod = filters.paymentMethod;
  if (filters.deliveryType) query.deliveryType = filters.deliveryType;
  if (filters.from || filters.to) {
    query.createdAt = {
      ...(filters.from ? { $gte: filters.from } : {}),
      ...(filters.to ? { $lte: filters.to } : {}),
    };
  }
  if (filters.q) {
    const escaped = filters.q.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    query.code = new RegExp(escaped, 'i');
  }
  return query;
}

export async function listOrders(filters: OrderListFilters): Promise<Page<unknown>> {
  const page = Math.max(1, filters.page ?? 1);
  const limit = Math.min(100, Math.max(1, filters.limit ?? 20));
  const query = buildOrderFilter(filters);

  const [docs, total] = await Promise.all([
    Order.find(query)
      // VIP first, newest first — matching the admin board ordering.
      .sort({ deliveryType: -1, createdAt: -1 })
      .skip(skipFor(page, limit))
      .limit(limit)
      .populate(ORDER_POPULATE),
    Order.countDocuments(query),
  ]);

  return buildPage(
    docs.map((d) => d.toJSON()),
    page,
    limit,
    total,
  );
}

/** Loads one order, enforcing ownership in the service layer (never the client). */
export async function getOrderFor(
  orderId: string,
  actorId: string,
  actorRole: Role,
): Promise<unknown> {
  const order = await Order.findById(orderId).populate(ORDER_POPULATE);
  if (!order) throw ApiError.notFound('الطلب غير موجود');

  if (actorRole === 'customer' && String(order.customer._id ?? order.customer) !== actorId) {
    throw ApiError.forbidden();
  }
  if (actorRole === 'agent') {
    const assignedTo = order.agent ? String((order.agent as any)._id ?? order.agent) : null;
    if (assignedTo !== actorId) {
      const everOffered = await Assignment.exists({ order: orderId, agent: actorId });
      if (!everOffered) throw ApiError.forbidden();
    }
  }
  return order.toJSON();
}
