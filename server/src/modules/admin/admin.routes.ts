import { Router } from 'express';
import { z } from 'zod';
import { requireAuth, requireRole } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { asyncHandler } from '../../utils/asyncHandler';
import { created, ok } from '../../utils/response';
import { ApiError } from '../../utils/ApiError';
import { buildPage, skipFor } from '../../utils/pagination';
import { destroyImage } from '../../config/cloudinary';
import { idParams, objectId } from '../orders/order.schema';

import * as analytics from './admin.service';
import * as orderService from '../orders/order.service';
import * as agentService from '../agents/agent.service';
import { hashPassword } from '../auth/auth.service';

import { Order } from '../orders/order.model';
import { Category } from '../categories/category.model';
import { MenuSection, Vendor } from '../vendors/vendor.model';
import { Product } from '../products/product.model';
import { Offer } from '../offers/offer.model';
import { Voucher } from '../vouchers/voucher.model';
import { User } from '../users/user.model';
import { AgentStatus } from '../agents/agent.model';
import { point } from '../../utils/geo';
import { createVendorSchema, menuSectionSchema, updateVendorSchema } from '../vendors/vendor.schema';
import * as settingsService from '../settings/settings.service';
import {
  adminOrdersQuerySchema,
  adminStatusSchema,
  assignSchema,
  availableAgentsQuerySchema,
  bulkAvailabilitySchema,
  createAgentSchema,
  createOfferSchema,
  createProductSchema,
  createVoucherSchema,
  listUsersQuerySchema,
  rangeQuerySchema,
  reorderSchema,
  updateAgentSchema,
  updateCustomerSchema,
  updateOfferSchema,
  updateProductSchema,
  updateSettingsSchema,
  updateVoucherSchema,
} from './admin.schema';

export const adminRouter = Router();
adminRouter.use(requireAuth, requireRole('admin'));

function range(query: { from?: Date; to?: Date }) {
  const to = query.to ?? new Date();
  const from = query.from ?? new Date(to.getTime() - 30 * 24 * 60 * 60 * 1000);
  return { from, to };
}

// ─────────────────────────── dashboard & orders ───────────────────────────

adminRouter.get(
  '/stats',
  asyncHandler(async (_req, res) => ok(res, await analytics.dashboardStats())),
);

adminRouter.get(
  '/orders',
  validate({ query: adminOrdersQuerySchema }),
  asyncHandler(async (req, res) => {
    const q = req.query as unknown as Record<string, never>;
    return ok(res, await orderService.listOrders({ ...q, paymentMethod: (q as any).payment }));
  }),
);

adminRouter.get(
  '/orders/export',
  validate({ query: adminOrdersQuerySchema }),
  asyncHandler(async (req, res) => {
    const q = req.query as unknown as Record<string, never>;
    const filter = orderService.buildOrderFilter({ ...q, paymentMethod: (q as any).payment });
    const docs = await Order.find(filter)
      .sort({ createdAt: -1 })
      .limit(5000)
      .populate(orderService.ORDER_POPULATE);
    const csv = analytics.ordersToCsv(docs.map((d) => d.toJSON() as Record<string, any>));
    res.setHeader('Content-Type', 'text/csv; charset=utf-8');
    res.setHeader('Content-Disposition', 'attachment; filename="saji-orders.csv"');
    // BOM so Excel opens the Arabic columns correctly.
    return res.send(`\uFEFF${csv}`);
  }),
);

adminRouter.get(
  '/orders/:id',
  validate({ params: idParams }),
  asyncHandler(async (req, res) =>
    ok(res, await orderService.getOrderFor(req.params.id, req.user!.sub, 'admin')),
  ),
);

adminRouter.patch(
  '/orders/:id/status',
  validate({ params: idParams, body: adminStatusSchema }),
  asyncHandler(async (req, res) => {
    const updated = await orderService.transition(req.params.id, req.body.status, {
      actorId: req.user!.sub,
      actorRole: 'admin',
      note: req.body.note,
    });
    const full = await Order.findById(updated._id).populate(orderService.ORDER_POPULATE);
    return ok(res, full!.toJSON(), 'تم تحديث حالة الطلب');
  }),
);

adminRouter.post(
  '/orders/:id/assign',
  validate({ params: idParams, body: assignSchema }),
  asyncHandler(async (req, res) =>
    ok(
      res,
      await orderService.assignAgent(req.params.id, req.body.agentId, req.user!.sub),
      'تم إرسال الطلب إلى السائق',
    ),
  ),
);

adminRouter.get(
  '/agents/available',
  validate({ query: availableAgentsQuerySchema }),
  asyncHandler(async (req, res) =>
    ok(res, await agentService.availableAgents((req.query as { vendorId?: string }).vendorId)),
  ),
);

adminRouter.get(
  '/agents/locations',
  asyncHandler(async (_req, res) => ok(res, await agentService.liveLocations())),
);

// ─────────────────────────── categories ───────────────────────────

const categoryBody = z
  .object({
    nameAr: z.string().trim().min(2).max(40),
    nameFr: z.string().trim().min(2).max(40),
    iconKey: z.string().trim().min(1).max(40),
    sortOrder: z.number().int().default(0),
    isActive: z.boolean().default(true),
  })
  .strict();

adminRouter.get(
  '/categories',
  asyncHandler(async (_req, res) => {
    const items = await Category.find().sort({ sortOrder: 1 });
    return ok(res, items.map((c) => c.toJSON()));
  }),
);

adminRouter.post(
  '/categories',
  validate({ body: categoryBody }),
  asyncHandler(async (req, res) => created(res, (await Category.create(req.body)).toJSON())),
);

adminRouter.patch(
  '/categories/:id',
  validate({ params: idParams, body: categoryBody.partial() }),
  asyncHandler(async (req, res) => {
    const doc = await Category.findByIdAndUpdate(req.params.id, { $set: req.body }, { new: true });
    if (!doc) throw ApiError.notFound('الفئة غير موجودة');
    return ok(res, doc.toJSON());
  }),
);

adminRouter.delete(
  '/categories/:id',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => {
    const inUse = await Vendor.countDocuments({ category: req.params.id });
    if (inUse > 0) throw ApiError.conflict('لا يمكن حذف فئة مرتبطة بمتاجر');
    await Category.findByIdAndDelete(req.params.id);
    return ok(res, null, 'تم حذف الفئة');
  }),
);

// ─────────────────────────── vendors & sections ───────────────────────────

function vendorPayload(body: Record<string, any>) {
  const { lat, lng, ...rest } = body;
  const payload: Record<string, unknown> = { ...rest };
  if (lat !== undefined && lng !== undefined) payload.location = point(lng, lat);
  return payload;
}

adminRouter.get(
  '/vendors',
  validate({ query: listUsersQuerySchema }),
  asyncHandler(async (req, res) => {
    const { q, page, limit } = req.query as unknown as { q?: string; page: number; limit: number };
    const filter: Record<string, unknown> = {};
    if (q) filter.name = new RegExp(q.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'i');
    const [docs, total] = await Promise.all([
      Vendor.find(filter).sort({ sortOrder: 1, name: 1 }).skip(skipFor(page, limit)).limit(limit).populate('category'),
      Vendor.countDocuments(filter),
    ]);
    return ok(res, buildPage(docs.map((d) => d.toJSON()), page, limit, total));
  }),
);

adminRouter.get(
  '/vendors/:id',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => {
    const doc = await Vendor.findById(req.params.id).populate('category');
    if (!doc) throw ApiError.notFound('المتجر غير موجود');
    return ok(res, doc.toJSON());
  }),
);

adminRouter.post(
  '/vendors',
  validate({ body: createVendorSchema }),
  asyncHandler(async (req, res) =>
    created(res, (await Vendor.create(vendorPayload(req.body))).toJSON(), 'تمت إضافة المتجر'),
  ),
);

adminRouter.patch(
  '/vendors/:id',
  validate({ params: idParams, body: updateVendorSchema }),
  asyncHandler(async (req, res) => {
    const existing = await Vendor.findById(req.params.id);
    if (!existing) throw ApiError.notFound('المتجر غير موجود');

    const payload = vendorPayload(req.body);
    // Replacing an image deletes the asset it replaces.
    for (const field of ['logo', 'cover'] as const) {
      const next = payload[field] as { publicId?: string } | null | undefined;
      const prev = existing[field];
      if (next !== undefined && prev?.publicId && prev.publicId !== next?.publicId) {
        await destroyImage(prev.publicId);
      }
    }

    const doc = await Vendor.findByIdAndUpdate(req.params.id, { $set: payload }, { new: true });
    return ok(res, doc!.toJSON(), 'تم تحديث المتجر');
  }),
);

adminRouter.delete(
  '/vendors/:id',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => {
    const openOrders = await Order.countDocuments({
      vendor: req.params.id,
      status: { $nin: ['delivered', 'cancelled'] },
    });
    if (openOrders > 0) throw ApiError.conflict('لا يمكن حذف متجر لديه طلبات جارية');
    // Soft delete keeps historical orders readable.
    const doc = await Vendor.findByIdAndUpdate(
      req.params.id,
      { $set: { isActive: false, isOpen: false } },
      { new: true },
    );
    if (!doc) throw ApiError.notFound('المتجر غير موجود');
    return ok(res, doc.toJSON(), 'تم تعطيل المتجر');
  }),
);

adminRouter.get(
  '/vendors/:id/sections',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => {
    const items = await MenuSection.find({ vendor: req.params.id }).sort({ sortOrder: 1 });
    return ok(res, items.map((s) => s.toJSON()));
  }),
);

adminRouter.post(
  '/vendors/:id/sections',
  validate({ params: idParams, body: menuSectionSchema }),
  asyncHandler(async (req, res) => {
    const vendor = await Vendor.findById(req.params.id);
    if (!vendor) throw ApiError.notFound('المتجر غير موجود');
    const doc = await MenuSection.create({ ...req.body, vendor: vendor._id });
    return created(res, doc.toJSON());
  }),
);

adminRouter.patch(
  '/sections/:id',
  validate({ params: idParams, body: menuSectionSchema.partial() }),
  asyncHandler(async (req, res) => {
    const doc = await MenuSection.findByIdAndUpdate(req.params.id, { $set: req.body }, { new: true });
    if (!doc) throw ApiError.notFound('القسم غير موجود');
    return ok(res, doc.toJSON());
  }),
);

adminRouter.delete(
  '/sections/:id',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => {
    await Product.updateMany({ section: req.params.id }, { $set: { section: null } });
    const doc = await MenuSection.findByIdAndDelete(req.params.id);
    if (!doc) throw ApiError.notFound('القسم غير موجود');
    return ok(res, null, 'تم حذف القسم');
  }),
);

// ─────────────────────────── products ───────────────────────────

adminRouter.get(
  '/products',
  validate({
    query: listUsersQuerySchema.extend({ vendor: objectId.optional(), section: objectId.optional() }),
  }),
  asyncHandler(async (req, res) => {
    const { q, page, limit, vendor, section } = req.query as unknown as {
      q?: string;
      page: number;
      limit: number;
      vendor?: string;
      section?: string;
    };
    const filter: Record<string, unknown> = {};
    if (vendor) filter.vendor = vendor;
    if (section) filter.section = section;
    if (q) filter.name = new RegExp(q.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'i');
    const [docs, total] = await Promise.all([
      Product.find(filter).sort({ sortOrder: 1, name: 1 }).skip(skipFor(page, limit)).limit(limit),
      Product.countDocuments(filter),
    ]);
    return ok(res, buildPage(docs.map((d) => d.toJSON()), page, limit, total));
  }),
);

adminRouter.post(
  '/products',
  validate({ body: createProductSchema }),
  asyncHandler(async (req, res) => created(res, (await Product.create(req.body)).toJSON(), 'تمت إضافة المنتج')),
);

adminRouter.patch(
  '/products/:id',
  validate({ params: idParams, body: updateProductSchema }),
  asyncHandler(async (req, res) => {
    const existing = await Product.findById(req.params.id);
    if (!existing) throw ApiError.notFound('المنتج غير موجود');
    const nextImage = req.body.image as { publicId?: string } | null | undefined;
    if (nextImage !== undefined && existing.image?.publicId && existing.image.publicId !== nextImage?.publicId) {
      await destroyImage(existing.image.publicId);
    }
    const doc = await Product.findByIdAndUpdate(req.params.id, { $set: req.body }, { new: true });
    return ok(res, doc!.toJSON(), 'تم تحديث المنتج');
  }),
);

adminRouter.post(
  '/products/reorder',
  validate({ body: reorderSchema }),
  asyncHandler(async (req, res) => {
    await Product.bulkWrite(
      req.body.items.map((i: { id: string; sortOrder: number }) => ({
        updateOne: { filter: { _id: i.id }, update: { $set: { sortOrder: i.sortOrder } } },
      })),
    );
    return ok(res, null, 'تم تحديث الترتيب');
  }),
);

adminRouter.post(
  '/products/availability',
  validate({ body: bulkAvailabilitySchema }),
  asyncHandler(async (req, res) => {
    const result = await Product.updateMany(
      { _id: { $in: req.body.ids } },
      { $set: { isAvailable: req.body.isAvailable } },
    );
    return ok(res, { updated: result.modifiedCount });
  }),
);

adminRouter.delete(
  '/products/:id',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => {
    const doc = await Product.findByIdAndDelete(req.params.id);
    if (!doc) throw ApiError.notFound('المنتج غير موجود');
    if (doc.image?.publicId) await destroyImage(doc.image.publicId);
    return ok(res, null, 'تم حذف المنتج');
  }),
);

// ─────────────────────────── offers ───────────────────────────

adminRouter.get(
  '/offers',
  asyncHandler(async (_req, res) => {
    const items = await Offer.find().sort({ sortOrder: 1, createdAt: -1 }).populate({ path: 'vendor', select: 'name logo' });
    return ok(res, items.map((o) => o.toJSON()));
  }),
);

adminRouter.post(
  '/offers',
  validate({ body: createOfferSchema }),
  asyncHandler(async (req, res) => created(res, (await Offer.create(req.body)).toJSON(), 'تمت إضافة العرض')),
);

adminRouter.patch(
  '/offers/:id',
  validate({ params: idParams, body: updateOfferSchema }),
  asyncHandler(async (req, res) => {
    const existing = await Offer.findById(req.params.id);
    if (!existing) throw ApiError.notFound('العرض غير موجود');
    const nextImage = req.body.image as { publicId?: string } | null | undefined;
    if (nextImage !== undefined && existing.image?.publicId && existing.image.publicId !== nextImage?.publicId) {
      await destroyImage(existing.image.publicId);
    }
    const doc = await Offer.findByIdAndUpdate(req.params.id, { $set: req.body }, { new: true });
    return ok(res, doc!.toJSON(), 'تم تحديث العرض');
  }),
);

adminRouter.delete(
  '/offers/:id',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => {
    const doc = await Offer.findByIdAndDelete(req.params.id);
    if (!doc) throw ApiError.notFound('العرض غير موجود');
    if (doc.image?.publicId) await destroyImage(doc.image.publicId);
    return ok(res, null, 'تم حذف العرض');
  }),
);

// ─────────────────────────── vouchers ───────────────────────────

adminRouter.get(
  '/vouchers',
  asyncHandler(async (_req, res) => {
    const items = await Voucher.find().sort({ createdAt: -1 });
    return ok(res, items.map((v) => v.toJSON()));
  }),
);

adminRouter.post(
  '/vouchers',
  validate({ body: createVoucherSchema }),
  asyncHandler(async (req, res) => created(res, (await Voucher.create(req.body)).toJSON(), 'تمت إضافة القسيمة')),
);

adminRouter.patch(
  '/vouchers/:id',
  validate({ params: idParams, body: updateVoucherSchema }),
  asyncHandler(async (req, res) => {
    const doc = await Voucher.findByIdAndUpdate(req.params.id, { $set: req.body }, { new: true });
    if (!doc) throw ApiError.notFound('القسيمة غير موجودة');
    return ok(res, doc.toJSON());
  }),
);

adminRouter.delete(
  '/vouchers/:id',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => {
    const doc = await Voucher.findByIdAndDelete(req.params.id);
    if (!doc) throw ApiError.notFound('القسيمة غير موجودة');
    return ok(res, null, 'تم حذف القسيمة');
  }),
);

// ─────────────────────────── agents ───────────────────────────

adminRouter.get(
  '/agents',
  validate({ query: listUsersQuerySchema }),
  asyncHandler(async (req, res) => {
    const { q, page, limit } = req.query as unknown as { q?: string; page: number; limit: number };
    const filter: Record<string, unknown> = { role: 'agent' };
    if (q) {
      const rx = new RegExp(q.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'i');
      filter.$or = [{ fullName: rx }, { phone: rx }];
    }
    const [docs, total] = await Promise.all([
      User.find(filter).sort({ createdAt: -1 }).skip(skipFor(page, limit)).limit(limit),
      User.countDocuments(filter),
    ]);
    const statuses = await AgentStatus.find({ agent: { $in: docs.map((d) => d._id) } }).lean();
    const byAgent = new Map(statuses.map((s) => [String(s.agent), s]));
    const items = docs.map((d) => ({
      ...d.toJSON(),
      isOnline: byAgent.get(String(d._id))?.isOnline ?? false,
      currentOrder: byAgent.get(String(d._id))?.currentOrder ?? null,
    }));
    return ok(res, buildPage(items, page, limit, total));
  }),
);

adminRouter.post(
  '/agents',
  validate({ body: createAgentSchema }),
  asyncHandler(async (req, res) => {
    const user = await agentService.createAgentUser({
      fullName: req.body.fullName,
      phone: req.body.phone,
      passwordHash: await hashPassword(req.body.password),
    });
    return created(res, user.toJSON(), 'تمت إضافة السائق');
  }),
);

adminRouter.patch(
  '/agents/:id',
  validate({ params: idParams, body: updateAgentSchema }),
  asyncHandler(async (req, res) => {
    const update: Record<string, unknown> = {};
    if (req.body.fullName !== undefined) update.fullName = req.body.fullName;
    if (req.body.isActive !== undefined) update.isActive = req.body.isActive;
    if (req.body.isBlocked !== undefined) update.isBlocked = req.body.isBlocked;
    if (req.body.password) update.passwordHash = await hashPassword(req.body.password);

    const doc = await User.findOneAndUpdate(
      { _id: req.params.id, role: 'agent' },
      { $set: update },
      { new: true },
    );
    if (!doc) throw ApiError.notFound('السائق غير موجود');
    if (update.isActive === false || update.isBlocked === true) {
      await AgentStatus.updateOne({ agent: doc._id }, { $set: { isOnline: false } });
    }
    return ok(res, doc.toJSON(), 'تم تحديث السائق');
  }),
);

adminRouter.get(
  '/agents/:id/stats',
  validate({ params: idParams, query: rangeQuerySchema }),
  asyncHandler(async (req, res) => {
    const { from, to } = range(req.query as never);
    return ok(res, await agentService.stats(req.params.id, from, to));
  }),
);

// ─────────────────────────── customers ───────────────────────────

adminRouter.get(
  '/customers',
  validate({ query: listUsersQuerySchema }),
  asyncHandler(async (req, res) => {
    const { q, page, limit, isBlocked } = req.query as unknown as {
      q?: string;
      page: number;
      limit: number;
      isBlocked?: string;
    };
    const filter: Record<string, unknown> = { role: 'customer' };
    if (isBlocked) filter.isBlocked = isBlocked === 'true';
    if (q) {
      const rx = new RegExp(q.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'i');
      filter.$or = [{ fullName: rx }, { phone: rx }];
    }
    const [docs, total] = await Promise.all([
      User.find(filter).sort({ createdAt: -1 }).skip(skipFor(page, limit)).limit(limit),
      User.countDocuments(filter),
    ]);
    return ok(res, buildPage(docs.map((d) => d.toJSON()), page, limit, total));
  }),
);

adminRouter.get(
  '/customers/:id',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => {
    const user = await User.findOne({ _id: req.params.id, role: 'customer' });
    if (!user) throw ApiError.notFound('العميل غير موجود');
    const [summary, orders] = await Promise.all([
      analytics.customerSummary(req.params.id),
      Order.find({ customer: req.params.id })
        .sort({ createdAt: -1 })
        .limit(20)
        .populate(orderService.ORDER_POPULATE),
    ]);
    return ok(res, { customer: user.toJSON(), summary, orders: orders.map((o) => o.toJSON()) });
  }),
);

adminRouter.patch(
  '/customers/:id',
  validate({ params: idParams, body: updateCustomerSchema }),
  asyncHandler(async (req, res) => {
    const doc = await User.findOneAndUpdate(
      { _id: req.params.id, role: 'customer' },
      { $set: req.body },
      { new: true },
    );
    if (!doc) throw ApiError.notFound('العميل غير موجود');
    return ok(res, doc.toJSON(), 'تم تحديث العميل');
  }),
);

// ─────────────────────────── analytics ───────────────────────────

adminRouter.get(
  '/analytics/orders',
  validate({ query: rangeQuerySchema }),
  asyncHandler(async (req, res) => {
    const { from, to } = range(req.query as never);
    return ok(res, await analytics.ordersOverTime(from, to));
  }),
);

adminRouter.get(
  '/analytics/top-vendors',
  validate({ query: rangeQuerySchema }),
  asyncHandler(async (req, res) => {
    const { from, to } = range(req.query as never);
    return ok(res, await analytics.topVendors(from, to, (req.query as any).limit));
  }),
);

adminRouter.get(
  '/analytics/top-products',
  validate({ query: rangeQuerySchema }),
  asyncHandler(async (req, res) => {
    const { from, to } = range(req.query as never);
    return ok(res, await analytics.topProducts(from, to, (req.query as any).limit));
  }),
);

adminRouter.get(
  '/analytics/agents',
  validate({ query: rangeQuerySchema }),
  asyncHandler(async (req, res) => {
    const { from, to } = range(req.query as never);
    return ok(res, await analytics.agentLeaderboard(from, to));
  }),
);

adminRouter.get(
  '/analytics/cancellations',
  validate({ query: rangeQuerySchema }),
  asyncHandler(async (req, res) => {
    const { from, to } = range(req.query as never);
    return ok(res, await analytics.cancellationReasons(from, to));
  }),
);

// ─────────────────────────── settings ───────────────────────────

adminRouter.get(
  '/settings',
  asyncHandler(async (_req, res) => ok(res, await settingsService.getSettings(true))),
);

adminRouter.patch(
  '/settings',
  validate({ body: updateSettingsSchema }),
  asyncHandler(async (req, res) =>
    ok(res, await settingsService.updateSettings(req.body), 'تم حفظ الإعدادات'),
  ),
);
