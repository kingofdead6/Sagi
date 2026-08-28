import type { Request, Response } from 'express';
import { asyncHandler } from '../../utils/asyncHandler';
import { created, ok } from '../../utils/response';
import * as service from './order.service';
import { Order } from './order.model';
import { Rating } from '../ratings/rating.model';
import { Vendor } from '../vendors/vendor.model';
import { ApiError } from '../../utils/ApiError';
import { buildPage, skipFor } from '../../utils/pagination';

export const quoteCtrl = asyncHandler(async (req: Request, res: Response) => {
  return ok(res, await service.quote(req.user!.sub, req.body));
});

export const createOrderCtrl = asyncHandler(async (req: Request, res: Response) => {
  const order = await service.createOrder(req.user!.sub, req.body);
  return created(res, order, 'سنتصل بك لتأكيد الطلب');
});

export const myOrdersCtrl = asyncHandler(async (req: Request, res: Response) => {
  const { status, page, limit } = req.query as unknown as {
    status?: string;
    page: number;
    limit: number;
  };
  const result = await service.listOrders({
    customer: req.user!.sub,
    status: status as never,
    page,
    limit,
  });
  return ok(res, result);
});

export const getOrderCtrl = asyncHandler(async (req: Request, res: Response) => {
  const order = await service.getOrderFor(req.params.id, req.user!.sub, req.user!.role);
  return ok(res, order);
});

export const cancelOrderCtrl = asyncHandler(async (req: Request, res: Response) => {
  const order = await Order.findById(req.params.id).select('customer status');
  if (!order) throw ApiError.notFound('الطلب غير موجود');
  if (String(order.customer) !== req.user!.sub) throw ApiError.forbidden();
  // A customer may only cancel while the order is still pending.
  if (order.status !== 'pending') {
    throw ApiError.illegalTransition('لا يمكن إلغاء الطلب بعد تأكيده، اتصل بالدعم');
  }

  const updated = await service.transition(req.params.id, 'cancelled', {
    actorId: req.user!.sub,
    actorRole: 'customer',
    note: req.body.reason,
  });
  return ok(res, updated.toJSON(), 'تم إلغاء الطلب');
});

export const rateOrderCtrl = asyncHandler(async (req: Request, res: Response) => {
  const order = await Order.findById(req.params.id);
  if (!order) throw ApiError.notFound('الطلب غير موجود');
  if (String(order.customer) !== req.user!.sub) throw ApiError.forbidden();
  if (order.status !== 'delivered') {
    throw ApiError.conflict('يمكن التقييم بعد استلام الطلب فقط');
  }
  if (await Rating.exists({ order: order._id })) {
    throw ApiError.conflict('تم تقييم هذا الطلب من قبل');
  }

  const rating = await Rating.create({
    order: order._id,
    customer: order.customer,
    vendor: order.vendor,
    agent: order.agent,
    vendorRating: req.body.vendorRating,
    agentRating: req.body.agentRating ?? null,
    comment: req.body.comment,
  });

  // Keep the vendor's running average in sync.
  const vendor = await Vendor.findById(order.vendor);
  if (vendor) {
    const total = vendor.rating * vendor.ratingCount + req.body.vendorRating;
    vendor.ratingCount += 1;
    vendor.rating = Math.round((total / vendor.ratingCount) * 10) / 10;
    await vendor.save();
  }

  return created(res, rating.toJSON(), 'شكراً على تقييمك');
});

/** Orders the customer can reorder from — delivered ones, newest first. */
export const reorderableCtrl = asyncHandler(async (req: Request, res: Response) => {
  const page = Number(req.query.page ?? 1);
  const limit = Number(req.query.limit ?? 20);
  const filter = { customer: req.user!.sub, status: 'delivered' as const };
  const [docs, total] = await Promise.all([
    Order.find(filter).sort({ createdAt: -1 }).skip(skipFor(page, limit)).limit(limit).populate(service.ORDER_POPULATE),
    Order.countDocuments(filter),
  ]);
  return ok(res, buildPage(docs.map((d) => d.toJSON()), page, limit, total));
});
