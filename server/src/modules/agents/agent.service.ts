import { Types } from 'mongoose';
import { AgentLocation, AgentStatus } from './agent.model';
import { Assignment } from '../assignments/assignment.model';
import { Order } from '../orders/order.model';
import { User } from '../users/user.model';
import { Vendor } from '../vendors/vendor.model';
import { ApiError } from '../../utils/ApiError';
import { distanceKm, fromGeoPoint, point } from '../../utils/geo';
import { realtime } from '../../realtime/emitter';
import { acceptAssignment, ORDER_POPULATE, releaseAssignment } from '../orders/order.service';
import { getSettings } from '../settings/settings.service';
import { buildPage, skipFor } from '../../utils/pagination';
import { logger } from '../../config/logger';

const ACTIVE_STATUSES = ['assigned', 'accepted', 'picked_up', 'on_the_way'] as const;

export async function ensureStatus(agentId: string) {
  const existing = await AgentStatus.findOne({ agent: agentId });
  if (existing) return existing;
  return AgentStatus.create({ agent: agentId, isOnline: false });
}

export async function setOnline(agentId: string, isOnline: boolean) {
  const status = await AgentStatus.findOneAndUpdate(
    { agent: agentId },
    { $set: { isOnline, lastSeenAt: new Date() } },
    { new: true, upsert: true },
  );
  realtime.agentStatus({ agentId, isOnline, at: new Date().toISOString() });
  return status!.toJSON();
}

/** Open offers waiting for this agent's answer, expired ones filtered out. */
export async function listOffers(agentId: string) {
  const now = new Date();
  const assignments = await Assignment.find({
    agent: agentId,
    state: 'offered',
    expiresAt: { $gt: now },
  }).sort({ offeredAt: -1 });

  const settings = await getSettings();
  const results = [];

  for (const assignment of assignments) {
    const order = await Order.findById(assignment.order).populate(ORDER_POPULATE);
    if (!order || order.status !== 'assigned') continue;

    const vendor = await Vendor.findById(order.vendor).lean();
    const pickup = fromGeoPoint(vendor?.location ?? null);
    const dropoff = fromGeoPoint(order.deliveryLocation);
    const legKm = pickup && dropoff ? Math.round(distanceKm(pickup, dropoff) * 10) / 10 : null;

    results.push({
      assignmentId: String(assignment._id),
      order: order.toJSON(),
      pickup: pickup ? { ...pickup, name: vendor?.name, address: vendor?.addressText } : null,
      dropoff: dropoff ? { ...dropoff, address: order.address } : null,
      distanceKm: legKm,
      payoutCentimes: order.deliveryFeeCentimes,
      expiresAt: assignment.expiresAt.toISOString(),
      timeoutSec: settings.assignTimeoutSec,
    });
  }

  return results;
}

export async function respondToOffer(
  agentId: string,
  orderId: string,
  accept: boolean,
  reason?: string,
) {
  if (accept) {
    const order = await acceptAssignment(orderId, agentId);
    return (await Order.findById(order._id).populate(ORDER_POPULATE))!.toJSON();
  }
  const order = await releaseAssignment(
    orderId,
    agentId,
    'agent',
    reason ?? 'رفض السائق الطلب',
    'rejected',
  );
  return (await Order.findById(order._id).populate(ORDER_POPULATE))!.toJSON();
}

export async function activeOrder(agentId: string) {
  const order = await Order.findOne({
    agent: agentId,
    status: { $in: ACTIVE_STATUSES },
  }).populate(ORDER_POPULATE);
  if (!order) return null;

  const vendor = await Vendor.findById(order.vendor).lean();
  return {
    order: order.toJSON(),
    pickup: vendor
      ? { ...fromGeoPoint(vendor.location), name: vendor.name, phone: vendor.phone, address: vendor.addressText }
      : null,
    dropoff: { ...fromGeoPoint(order.deliveryLocation), address: order.address },
  };
}

export async function recordLocation(
  agentId: string,
  input: { lat: number; lng: number; heading?: number; speed?: number; battery?: number; recordedAt?: string },
) {
  const status = await ensureStatus(agentId);
  const location = point(input.lng, input.lat);

  const current = await Order.findOne({
    agent: agentId,
    status: { $in: ACTIVE_STATUSES },
  }).select('_id customer status');

  await AgentLocation.create({
    agent: agentId,
    order: current?._id ?? null,
    location,
    heading: input.heading,
    speed: input.speed,
    battery: input.battery,
    recordedAt: input.recordedAt ? new Date(input.recordedAt) : new Date(),
  });

  status.lastLocation = location;
  status.lastSeenAt = new Date();
  await status.save();

  // The customer only sees the marker once the courier is actually en route.
  const shareWithCustomer = current?.status === 'on_the_way';
  realtime.agentLocation({
    agentId,
    lat: input.lat,
    lng: input.lng,
    orderId: current ? String(current._id) : null,
    customerId: shareWithCustomer ? String(current!.customer) : null,
  });

  return { recorded: true };
}

export async function history(
  agentId: string,
  filters: { from?: Date; to?: Date; status?: string; page?: number; limit?: number },
) {
  const page = Math.max(1, filters.page ?? 1);
  const limit = Math.min(100, Math.max(1, filters.limit ?? 20));

  const query: Record<string, unknown> = { agent: agentId };
  query.status = filters.status ?? { $in: ['delivered', 'cancelled'] };
  if (filters.from || filters.to) {
    query.createdAt = {
      ...(filters.from ? { $gte: filters.from } : {}),
      ...(filters.to ? { $lte: filters.to } : {}),
    };
  }

  const [docs, total] = await Promise.all([
    Order.find(query).sort({ createdAt: -1 }).skip(skipFor(page, limit)).limit(limit).populate(ORDER_POPULATE),
    Order.countDocuments(query),
  ]);

  return buildPage(docs.map((d) => d.toJSON()), page, limit, total);
}

export async function stats(agentId: string, from?: Date, to?: Date) {
  const match: Record<string, unknown> = {
    agent: new Types.ObjectId(agentId),
    status: 'delivered',
  };
  if (from || to) {
    match.deliveredAt = {
      ...(from ? { $gte: from } : {}),
      ...(to ? { $lte: to } : {}),
    };
  }

  const [row] = await Order.aggregate([
    { $match: match },
    {
      $group: {
        _id: null,
        deliveries: { $sum: 1 },
        earningsCentimes: { $sum: '$deliveryFeeCentimes' },
        avgMinutes: {
          $avg: {
            $divide: [{ $subtract: ['$deliveredAt', '$acceptedAt'] }, 60000],
          },
        },
      },
    },
  ]);

  const startOfDay = new Date();
  startOfDay.setHours(0, 0, 0, 0);
  const todayCount = await Order.countDocuments({
    agent: agentId,
    status: 'delivered',
    deliveredAt: { $gte: startOfDay },
  });

  const rejected = await Assignment.countDocuments({ agent: agentId, state: 'rejected' });

  return {
    deliveries: row?.deliveries ?? 0,
    earningsCentimes: row?.earningsCentimes ?? 0,
    avgMinutes: row?.avgMinutes ? Math.round(row.avgMinutes) : 0,
    todayDeliveries: todayCount,
    rejectedOffers: rejected,
  };
}

/** Online agents ordered by how close they are to the pickup vendor. */
export async function availableAgents(vendorId?: string) {
  const statuses = await AgentStatus.find({ isOnline: true }).populate({
    path: 'agent',
    select: 'fullName phone avatar isActive',
  });

  const vendor = vendorId ? await Vendor.findById(vendorId).lean() : null;
  const origin = vendor ? fromGeoPoint(vendor.location) : null;

  const rows = await Promise.all(
    statuses
      .filter((s) => s.agent && (s.agent as unknown as { isActive: boolean }).isActive)
      .map(async (s) => {
        const agentDoc = s.agent as unknown as { _id: Types.ObjectId; fullName: string; phone: string };
        const here = fromGeoPoint(s.lastLocation ?? null);
        const load = await Order.countDocuments({
          agent: agentDoc._id,
          status: { $in: ACTIVE_STATUSES },
        });
        return {
          agentId: String(agentDoc._id),
          fullName: agentDoc.fullName,
          phone: agentDoc.phone,
          isOnline: s.isOnline,
          currentOrder: s.currentOrder ? String(s.currentOrder) : null,
          currentLoad: load,
          lastSeenAt: s.lastSeenAt,
          location: here,
          distanceKm: origin && here ? Math.round(distanceKm(origin, here) * 10) / 10 : null,
        };
      }),
  );

  return rows.sort((a, b) => {
    if (a.currentLoad !== b.currentLoad) return a.currentLoad - b.currentLoad;
    if (a.distanceKm === null) return 1;
    if (b.distanceKm === null) return -1;
    return a.distanceKm - b.distanceKm;
  });
}

export async function liveLocations() {
  const statuses = await AgentStatus.find({ isOnline: true }).populate({
    path: 'agent',
    select: 'fullName phone avatar',
  });

  return Promise.all(
    statuses.map(async (s) => {
      const agentDoc = s.agent as unknown as { _id: Types.ObjectId; fullName: string; phone: string };
      const order = s.currentOrder
        ? await Order.findById(s.currentOrder).select('code status vendor totalCentimes')
        : null;
      return {
        agentId: String(agentDoc._id),
        fullName: agentDoc.fullName,
        phone: agentDoc.phone,
        location: fromGeoPoint(s.lastLocation ?? null),
        lastSeenAt: s.lastSeenAt,
        state: order ? 'on_delivery' : 'idle',
        currentOrder: order ? order.toJSON() : null,
      };
    }),
  );
}

/**
 * Returns offers nobody answered in time to the pool. Runs on an interval so a
 * dead phone never strands an order.
 */
export async function expireStaleOffers(): Promise<number> {
  const stale = await Assignment.find({ state: 'offered', expiresAt: { $lte: new Date() } });
  let released = 0;
  for (const assignment of stale) {
    try {
      await releaseAssignment(
        String(assignment.order),
        String(assignment.agent),
        'admin',
        'انتهت مهلة الاستجابة',
        'expired',
      );
      released += 1;
    } catch (err) {
      logger.warn({ err, assignmentId: String(assignment._id) }, 'Failed to expire assignment');
      assignment.state = 'expired';
      assignment.respondedAt = new Date();
      await assignment.save();
    }
  }
  return released;
}

export async function assertAgentOwnsOrder(agentId: string, orderId: string) {
  const order = await Order.findById(orderId).select('agent');
  if (!order) throw ApiError.notFound('الطلب غير موجود');
  if (String(order.agent) !== agentId) throw ApiError.forbidden('هذا الطلب غير مُسند إليك');
  return order;
}

export async function createAgentUser(input: {
  fullName: string;
  phone: string;
  passwordHash: string;
}) {
  const existing = await User.findOne({ phone: input.phone });
  if (existing) throw ApiError.conflict('رقم الهاتف مسجّل من قبل');
  const user = await User.create({ ...input, role: 'agent' });
  await AgentStatus.create({ agent: user._id, isOnline: false });
  return user;
}
