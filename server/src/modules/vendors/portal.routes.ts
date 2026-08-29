import { Router } from 'express';
import { z } from 'zod';
import { requireAuth, requireRole } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { asyncHandler } from '../../utils/asyncHandler';
import { created, ok } from '../../utils/response';
import { ApiError } from '../../utils/ApiError';
import { destroyImage } from '../../config/cloudinary';
import { idParams } from '../orders/order.schema';
import { MenuSection, Vendor, type VendorDoc } from './vendor.model';
import { Product } from '../products/product.model';
import { menuSectionSchema } from './vendor.schema';
import { createProductSchema, reorderSchema } from '../admin/admin.schema';
import { getSettings } from '../settings/settings.service';
import type { Request } from 'express';

/**
 * The shop owner's portal.
 *
 * A vendor signs in and manages their own menu — sections, products, prices
 * and availability — plus the commercial terms of their own delivery: the fee
 * they charge and the minimum order they accept. Everything else (delivery
 * area, orders, assignment) stays with the admin, so none of it is exposed.
 *
 * Every route resolves the caller's own shop first and scopes the query to it;
 * an id in the URL is never trusted on its own.
 */
export const vendorPortalRouter = Router();

vendorPortalRouter.use(requireAuth, requireRole('vendor'));

/** The shop this user owns, or 403 if the account is not linked to one yet. */
async function myVendor(req: Request): Promise<VendorDoc> {
  const vendor = await Vendor.findOne({ owner: req.user!.sub });
  if (!vendor) {
    throw new ApiError(403, 'FORBIDDEN', 'هذا الحساب غير مرتبط بأي متجر');
  }
  return vendor;
}

// ── my shop ─────────────────────────────────────────────────────────────────

vendorPortalRouter.get(
  '/me',
  asyncHandler(async (req, res) => {
    const vendor = await myVendor(req);
    return ok(res, vendor.toJSON());
  }),
);

/**
 * The shop-level fields a vendor controls for themselves: whether they are
 * accepting orders, and the commercial terms of their own delivery.
 *
 * The fee is bounded by platform settings rather than left free — a shop that
 * sets it below the agent payout, or high enough to look like a mistake to a
 * customer, is a support ticket either way. The pickup point and delivery
 * area remain admin-owned.
 */
vendorPortalRouter.patch(
  '/me',
  validate({
    body: z
      .object({
        isOpen: z.boolean(),
        deliveryFeeCentimes: z.number().int().min(0),
        minOrderCentimes: z.number().int().min(0).max(1_000_000),
        prepTimeMin: z.number().int().min(0).max(240),
        prepTimeMax: z.number().int().min(0).max(240),
      })
      .partial()
      // An empty body would silently "succeed" without changing anything.
      .refine((body) => Object.keys(body).length > 0, 'لا يوجد أي تغيير'),
  }),
  asyncHandler(async (req, res) => {
    const vendor = await myVendor(req);
    const body = req.body as {
      isOpen?: boolean;
      deliveryFeeCentimes?: number;
      minOrderCentimes?: number;
      prepTimeMin?: number;
      prepTimeMax?: number;
    };

    if (body.deliveryFeeCentimes !== undefined) {
      const settings = await getSettings();
      const { minVendorDeliveryFeeCentimes: min, maxVendorDeliveryFeeCentimes: max } =
        settings;
      if (body.deliveryFeeCentimes < min || body.deliveryFeeCentimes > max) {
        throw ApiError.badRequest(
          `سعر التوصيل يجب أن يكون بين ${min / 100} و ${max / 100} د.ج`,
        );
      }
      vendor.deliveryFeeCentimes = body.deliveryFeeCentimes;
    }

    if (body.isOpen !== undefined) vendor.isOpen = body.isOpen;
    if (body.minOrderCentimes !== undefined) vendor.minOrderCentimes = body.minOrderCentimes;
    if (body.prepTimeMin !== undefined) vendor.prepTimeMin = body.prepTimeMin;
    if (body.prepTimeMax !== undefined) vendor.prepTimeMax = body.prepTimeMax;

    // A window that closes before it opens would make every quoted ETA wrong.
    if (vendor.prepTimeMax < vendor.prepTimeMin) {
      throw ApiError.badRequest('أقصى مدة تحضير لا يمكن أن تكون أقل من أدناها');
    }

    await vendor.save();
    return ok(res, vendor.toJSON(), 'تم تحديث المتجر');
  }),
);

/** The bounds the fee above is checked against, for the portal's own UI. */
vendorPortalRouter.get(
  '/limits',
  asyncHandler(async (_req, res) => {
    const settings = await getSettings();
    return ok(res, {
      minDeliveryFeeCentimes: settings.minVendorDeliveryFeeCentimes,
      maxDeliveryFeeCentimes: settings.maxVendorDeliveryFeeCentimes,
    });
  }),
);

// ── sections ────────────────────────────────────────────────────────────────

vendorPortalRouter.get(
  '/sections',
  asyncHandler(async (req, res) => {
    const vendor = await myVendor(req);
    const items = await MenuSection.find({ vendor: vendor._id }).sort({ sortOrder: 1 });
    return ok(res, items.map((s) => s.toJSON()));
  }),
);

vendorPortalRouter.post(
  '/sections',
  validate({ body: menuSectionSchema }),
  asyncHandler(async (req, res) => {
    const vendor = await myVendor(req);
    const doc = await MenuSection.create({ ...req.body, vendor: vendor._id });
    return created(res, doc.toJSON(), 'تمت إضافة القسم');
  }),
);

vendorPortalRouter.patch(
  '/sections/:id',
  validate({ params: idParams, body: menuSectionSchema.partial() }),
  asyncHandler(async (req, res) => {
    const vendor = await myVendor(req);
    // Scoped by vendor as well as id: one shop cannot rename another's section.
    const doc = await MenuSection.findOneAndUpdate(
      { _id: req.params.id, vendor: vendor._id },
      { $set: req.body },
      { new: true },
    );
    if (!doc) throw ApiError.notFound('القسم غير موجود');
    return ok(res, doc.toJSON(), 'تم تحديث القسم');
  }),
);

vendorPortalRouter.delete(
  '/sections/:id',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => {
    const vendor = await myVendor(req);
    const doc = await MenuSection.findOneAndDelete({ _id: req.params.id, vendor: vendor._id });
    if (!doc) throw ApiError.notFound('القسم غير موجود');
    // Products outlive their section — they just become unsectioned.
    await Product.updateMany(
      { section: doc._id, vendor: vendor._id },
      { $set: { section: null } },
    );
    return ok(res, null, 'تم حذف القسم');
  }),
);

// ── products ────────────────────────────────────────────────────────────────

vendorPortalRouter.get(
  '/products',
  asyncHandler(async (req, res) => {
    const vendor = await myVendor(req);
    const items = await Product.find({ vendor: vendor._id }).sort({ sortOrder: 1, createdAt: -1 });
    return ok(res, items.map((p) => p.toJSON()));
  }),
);

vendorPortalRouter.post(
  '/products',
  // `vendor` comes from the session, never the body — omit it so a payload
  // naming someone else's shop cannot be smuggled through.
  validate({ body: createProductSchema.omit({ vendor: true }) }),
  asyncHandler(async (req, res) => {
    const vendor = await myVendor(req);
    const doc = await Product.create({ ...req.body, vendor: vendor._id });
    return created(res, doc.toJSON(), 'تمت إضافة المنتج');
  }),
);

vendorPortalRouter.patch(
  '/products/:id',
  validate({
    params: idParams,
    body: createProductSchema.omit({ vendor: true }).partial(),
  }),
  asyncHandler(async (req, res) => {
    const vendor = await myVendor(req);
    const existing = await Product.findOne({ _id: req.params.id, vendor: vendor._id });
    if (!existing) throw ApiError.notFound('المنتج غير موجود');

    // Replacing the image deletes the asset it replaces, as the admin route does.
    const nextImage = req.body.image as { publicId?: string } | null | undefined;
    if (
      nextImage !== undefined &&
      existing.image?.publicId &&
      existing.image.publicId !== nextImage?.publicId
    ) {
      await destroyImage(existing.image.publicId);
    }

    const doc = await Product.findOneAndUpdate(
      { _id: req.params.id, vendor: vendor._id },
      { $set: req.body },
      { new: true },
    );
    return ok(res, doc!.toJSON(), 'تم تحديث المنتج');
  }),
);

vendorPortalRouter.delete(
  '/products/:id',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => {
    const vendor = await myVendor(req);
    const doc = await Product.findOneAndDelete({ _id: req.params.id, vendor: vendor._id });
    if (!doc) throw ApiError.notFound('المنتج غير موجود');
    if (doc.image?.publicId) await destroyImage(doc.image.publicId);
    return ok(res, null, 'تم حذف المنتج');
  }),
);

vendorPortalRouter.post(
  '/products/reorder',
  validate({ body: reorderSchema }),
  asyncHandler(async (req, res) => {
    const vendor = await myVendor(req);
    const items = req.body.items as { id: string; sortOrder: number }[];
    await Product.bulkWrite(
      items.map((item) => ({
        updateOne: {
          filter: { _id: item.id, vendor: vendor._id },
          update: { $set: { sortOrder: item.sortOrder } },
        },
      })),
    );
    return ok(res, null);
  }),
);
