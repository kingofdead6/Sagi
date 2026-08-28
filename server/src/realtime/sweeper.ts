import { logger } from '../config/logger';
import { env } from '../config/env';
import { expireStaleOffers } from '../modules/agents/agent.service';
import { findLateOrders } from '../modules/admin/admin.service';
import { realtime } from './emitter';
import { pushToRole } from './push.service';

const alreadyFlagged = new Set<string>();

/**
 * Returns unanswered offers to the pool and raises `order:late` once per order
 * so the admin board can badge it and ring.
 */
export async function sweepOnce(): Promise<void> {
  try {
    const released = await expireStaleOffers();
    if (released) logger.info({ released }, 'Expired stale delivery offers');
  } catch (err) {
    logger.warn({ err }, 'Offer expiry sweep failed');
  }

  try {
    const late = await findLateOrders();
    for (const order of late) {
      const id = String(order._id);
      if (alreadyFlagged.has(id)) continue;
      alreadyFlagged.add(id);
      realtime.orderLate({ orderId: id, code: order.code, status: order.status });
      await pushToRole('admin', {
        title: 'طلب متأخر',
        body: `الطلب ${order.code} تجاوز المدة المحددة`,
        data: { type: 'late', orderId: id },
      });
    }
    // Forget orders that are no longer late so a later delay re-alerts.
    const liveIds = new Set(late.map((o) => String(o._id)));
    for (const id of alreadyFlagged) if (!liveIds.has(id)) alreadyFlagged.delete(id);
  } catch (err) {
    logger.warn({ err }, 'Late-order sweep failed');
  }
}

let timer: NodeJS.Timeout | null = null;

export function startSweeper(): void {
  if (timer) return;
  timer = setInterval(() => void sweepOnce(), env.LATE_SWEEPER_INTERVAL_MS);
  timer.unref?.();
  logger.info({ intervalMs: env.LATE_SWEEPER_INTERVAL_MS }, 'Order sweeper started');
}

export function stopSweeper(): void {
  if (timer) clearInterval(timer);
  timer = null;
}
