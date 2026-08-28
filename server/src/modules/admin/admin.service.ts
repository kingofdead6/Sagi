import { Types } from 'mongoose';
import { Order } from '../orders/order.model';
import { User } from '../users/user.model';
import { Vendor } from '../vendors/vendor.model';
import { AgentStatus } from '../agents/agent.model';
import { getLateThreshold } from '../orders/order.model';
import { formatCentimes } from '../../utils/money';

const ACTIVE_DELIVERY = ['assigned', 'accepted', 'picked_up', 'on_the_way'];
const OPEN_STATUSES = [
  'pending',
  'confirmed',
  'sent_to_vendor',
  'preparing',
  'ready',
  ...ACTIVE_DELIVERY,
];

function startOfToday(): Date {
  const d = new Date();
  d.setHours(0, 0, 0, 0);
  return d;
}

export async function dashboardStats() {
  const since = startOfToday();
  const lateCutoff = new Date(Date.now() - getLateThreshold() * 60_000);

  const [todayOrders, revenueRow, activeDeliveries, avgRow, lateOrders, pendingOrders, onlineAgents] =
    await Promise.all([
      Order.countDocuments({ createdAt: { $gte: since } }),
      Order.aggregate([
        { $match: { status: 'delivered', deliveredAt: { $gte: since } } },
        { $group: { _id: null, total: { $sum: '$totalCentimes' }, count: { $sum: 1 } } },
      ]),
      Order.countDocuments({ status: { $in: ACTIVE_DELIVERY } }),
      Order.aggregate([
        { $match: { status: 'delivered', deliveredAt: { $gte: since }, confirmedAt: { $ne: null } } },
        {
          $group: {
            _id: null,
            avgMinutes: {
              $avg: { $divide: [{ $subtract: ['$deliveredAt', '$confirmedAt'] }, 60000] },
            },
          },
        },
      ]),
      Order.countDocuments({
        status: { $in: OPEN_STATUSES },
        confirmedAt: { $ne: null, $lte: lateCutoff },
      }),
      Order.countDocuments({ status: 'pending' }),
      AgentStatus.countDocuments({ isOnline: true }),
    ]);

  const revenueCentimes = revenueRow[0]?.total ?? 0;

  return {
    todayOrders,
    revenueCentimes,
    revenueLabel: formatCentimes(revenueCentimes),
    deliveredToday: revenueRow[0]?.count ?? 0,
    activeDeliveries,
    avgDeliveryMinutes: avgRow[0]?.avgMinutes ? Math.round(avgRow[0].avgMinutes) : 0,
    lateOrders,
    pendingOrders,
    onlineAgents,
  };
}

export async function ordersOverTime(from: Date, to: Date) {
  return Order.aggregate([
    { $match: { createdAt: { $gte: from, $lte: to } } },
    {
      $group: {
        _id: { $dateToString: { format: '%Y-%m-%d', date: '$createdAt' } },
        orders: { $sum: 1 },
        revenueCentimes: {
          $sum: { $cond: [{ $eq: ['$status', 'delivered'] }, '$totalCentimes', 0] },
        },
        cancelled: { $sum: { $cond: [{ $eq: ['$status', 'cancelled'] }, 1, 0] } },
      },
    },
    { $sort: { _id: 1 } },
    { $project: { _id: 0, date: '$_id', orders: 1, revenueCentimes: 1, cancelled: 1 } },
  ]);
}

export async function topVendors(from: Date, to: Date, limit = 10) {
  const rows = await Order.aggregate([
    { $match: { status: 'delivered', deliveredAt: { $gte: from, $lte: to } } },
    {
      $group: {
        _id: '$vendor',
        orders: { $sum: 1 },
        revenueCentimes: { $sum: '$totalCentimes' },
      },
    },
    { $sort: { revenueCentimes: -1 } },
    { $limit: limit },
  ]);

  const vendors = await Vendor.find({ _id: { $in: rows.map((r) => r._id) } })
    .select('name logo')
    .lean();
  const byId = new Map(vendors.map((v) => [String(v._id), v]));

  return rows.map((r) => ({
    vendorId: String(r._id),
    name: byId.get(String(r._id))?.name ?? '—',
    orders: r.orders,
    revenueCentimes: r.revenueCentimes,
  }));
}

export async function topProducts(from: Date, to: Date, limit = 10) {
  return Order.aggregate([
    { $match: { status: 'delivered', deliveredAt: { $gte: from, $lte: to } } },
    { $unwind: '$items' },
    {
      $group: {
        _id: '$items.product',
        name: { $first: '$items.nameSnapshot' },
        qty: { $sum: '$items.qty' },
        revenueCentimes: { $sum: '$items.lineTotalCentimes' },
      },
    },
    { $sort: { qty: -1 } },
    { $limit: limit },
    { $project: { _id: 0, productId: '$_id', name: 1, qty: 1, revenueCentimes: 1 } },
  ]);
}

export async function agentLeaderboard(from: Date, to: Date, limit = 20) {
  const rows = await Order.aggregate([
    {
      $match: {
        status: 'delivered',
        agent: { $ne: null },
        deliveredAt: { $gte: from, $lte: to },
      },
    },
    {
      $group: {
        _id: '$agent',
        deliveries: { $sum: 1 },
        earningsCentimes: { $sum: '$deliveryFeeCentimes' },
        avgMinutes: {
          $avg: { $divide: [{ $subtract: ['$deliveredAt', '$acceptedAt'] }, 60000] },
        },
      },
    },
    { $sort: { deliveries: -1 } },
    { $limit: limit },
  ]);

  const agents = await User.find({ _id: { $in: rows.map((r) => r._id) } })
    .select('fullName phone avatar')
    .lean();
  const byId = new Map(agents.map((a) => [String(a._id), a]));

  return rows.map((r) => ({
    agentId: String(r._id),
    fullName: byId.get(String(r._id))?.fullName ?? '—',
    phone: byId.get(String(r._id))?.phone ?? '',
    deliveries: r.deliveries,
    earningsCentimes: r.earningsCentimes,
    avgMinutes: r.avgMinutes ? Math.round(r.avgMinutes) : 0,
  }));
}

export async function cancellationReasons(from: Date, to: Date) {
  return Order.aggregate([
    { $match: { status: 'cancelled', updatedAt: { $gte: from, $lte: to } } },
    { $group: { _id: { $ifNull: ['$cancelledReason', 'غير محدد'] }, count: { $sum: 1 } } },
    { $sort: { count: -1 } },
    { $limit: 15 },
    { $project: { _id: 0, reason: '$_id', count: 1 } },
  ]);
}

export async function customerSummary(customerId: string) {
  const [row] = await Order.aggregate([
    { $match: { customer: new Types.ObjectId(customerId) } },
    {
      $group: {
        _id: null,
        orders: { $sum: 1 },
        delivered: { $sum: { $cond: [{ $eq: ['$status', 'delivered'] }, 1, 0] } },
        cancelled: { $sum: { $cond: [{ $eq: ['$status', 'cancelled'] }, 1, 0] } },
        spentCentimes: {
          $sum: { $cond: [{ $eq: ['$status', 'delivered'] }, '$totalCentimes', 0] },
        },
      },
    },
  ]);
  return {
    orders: row?.orders ?? 0,
    delivered: row?.delivered ?? 0,
    cancelled: row?.cancelled ?? 0,
    spentCentimes: row?.spentCentimes ?? 0,
  };
}

/** Orders overdue against the late threshold — the board's "Late Delivery" chip. */
export async function findLateOrders() {
  const cutoff = new Date(Date.now() - getLateThreshold() * 60_000);
  return Order.find({
    status: { $in: OPEN_STATUSES },
    confirmedAt: { $ne: null, $lte: cutoff },
  })
    .select('code status confirmedAt vendor customer totalCentimes')
    .lean();
}

/** CSV export of the orders board — semicolon-separated for Excel in Algeria. */
export function ordersToCsv(orders: Record<string, any>[]): string {
  const header = [
    'code',
    'status',
    'created_at',
    'customer',
    'phone',
    'vendor',
    'agent',
    'delivery_type',
    'payment',
    'subtotal_dz',
    'delivery_dz',
    'total_dz',
  ];
  const rows = orders.map((o) => [
    o.code,
    o.status,
    new Date(o.createdAt).toISOString(),
    o.customer?.fullName ?? '',
    o.customer?.phone ?? '',
    o.vendor?.name ?? '',
    o.agent?.fullName ?? '',
    o.deliveryType,
    o.paymentMethod,
    (o.subtotalCentimes / 100).toFixed(2),
    (o.deliveryFeeCentimes / 100).toFixed(2),
    (o.totalCentimes / 100).toFixed(2),
  ]);
  const escape = (v: unknown) => `"${String(v ?? '').replace(/"/g, '""')}"`;
  return [header, ...rows].map((r) => r.map(escape).join(';')).join('\n');
}
