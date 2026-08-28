import { Router } from 'express';
import { z } from 'zod';
import { requireAuth, requireRole } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { asyncHandler } from '../../utils/asyncHandler';
import { ok } from '../../utils/response';
import * as service from './agent.service';
import * as orderService from '../orders/order.service';
import { ORDER_POPULATE } from '../orders/order.service';
import { Order } from '../orders/order.model';
import { idParams, objectId } from '../orders/order.schema';
import { ApiError } from '../../utils/ApiError';

export const agentRouter = Router();

agentRouter.use(requireAuth, requireRole('agent'));

const orderIdParams = z.object({ orderId: objectId });

const rejectBody = z.object({
  reason: z.string().trim().min(2, 'سبب الرفض مطلوب').max(160),
});

const locationBody = z.object({
  lat: z.number().min(-90).max(90),
  lng: z.number().min(-180).max(180),
  heading: z.number().min(0).max(360).optional(),
  speed: z.number().min(0).optional(),
  battery: z.number().min(0).max(100).optional(),
  recordedAt: z.string().datetime().optional(),
});

/** Batched breadcrumbs, so a reconnecting phone can flush its queue. */
const locationBatchBody = z.object({ points: z.array(locationBody).min(1).max(50) });

const statusBody = z.object({
  status: z.enum(['picked_up', 'on_the_way', 'delivered']),
  cashCollected: z.boolean().optional(),
  note: z.string().trim().max(200).optional(),
});

const historyQuery = z.object({
  from: z.coerce.date().optional(),
  to: z.coerce.date().optional(),
  status: z.enum(['delivered', 'cancelled']).optional(),
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
});

agentRouter.get(
  '/me/status',
  asyncHandler(async (req, res) => ok(res, (await service.ensureStatus(req.user!.sub)).toJSON())),
);

agentRouter.patch(
  '/status',
  validate({ body: z.object({ isOnline: z.boolean() }) }),
  asyncHandler(async (req, res) => ok(res, await service.setOnline(req.user!.sub, req.body.isOnline))),
);

agentRouter.get(
  '/offers',
  asyncHandler(async (req, res) => ok(res, await service.listOffers(req.user!.sub))),
);

agentRouter.post(
  '/offers/:orderId/accept',
  validate({ params: orderIdParams }),
  asyncHandler(async (req, res) =>
    ok(res, await service.respondToOffer(req.user!.sub, req.params.orderId, true), 'تم قبول الطلب'),
  ),
);

agentRouter.post(
  '/offers/:orderId/reject',
  validate({ params: orderIdParams, body: rejectBody }),
  asyncHandler(async (req, res) =>
    ok(
      res,
      await service.respondToOffer(req.user!.sub, req.params.orderId, false, req.body.reason),
      'تم رفض الطلب',
    ),
  ),
);

agentRouter.get(
  '/orders/active',
  asyncHandler(async (req, res) => ok(res, await service.activeOrder(req.user!.sub))),
);

agentRouter.patch(
  '/orders/:id/status',
  validate({ params: idParams, body: statusBody }),
  asyncHandler(async (req, res) => {
    await service.assertAgentOwnsOrder(req.user!.sub, req.params.id);

    if (req.body.status === 'delivered') {
      const order = await Order.findById(req.params.id).select('paymentMethod');
      if (order?.paymentMethod === 'cash' && req.body.cashCollected !== true) {
        throw ApiError.badRequest('يجب تأكيد استلام المبلغ نقداً');
      }
    }

    const updated = await orderService.transition(req.params.id, req.body.status, {
      actorId: req.user!.sub,
      actorRole: 'agent',
      note: req.body.note,
    });
    const full = await Order.findById(updated._id).populate(ORDER_POPULATE);
    return ok(res, full!.toJSON());
  }),
);

agentRouter.get(
  '/orders/history',
  validate({ query: historyQuery }),
  asyncHandler(async (req, res) => ok(res, await service.history(req.user!.sub, req.query as never))),
);

agentRouter.get(
  '/stats',
  validate({ query: z.object({ from: z.coerce.date().optional(), to: z.coerce.date().optional() }) }),
  asyncHandler(async (req, res) => {
    const { from, to } = req.query as unknown as { from?: Date; to?: Date };
    return ok(res, await service.stats(req.user!.sub, from, to));
  }),
);

agentRouter.post(
  '/location',
  validate({ body: locationBody }),
  asyncHandler(async (req, res) => ok(res, await service.recordLocation(req.user!.sub, req.body))),
);

agentRouter.post(
  '/location/batch',
  validate({ body: locationBatchBody }),
  asyncHandler(async (req, res) => {
    for (const p of req.body.points) {
      await service.recordLocation(req.user!.sub, p);
    }
    return ok(res, { recorded: req.body.points.length });
  }),
);
