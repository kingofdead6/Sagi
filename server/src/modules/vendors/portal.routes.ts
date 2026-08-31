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
import type { Request } from 'express';

/**
 * The shop owner's portal.
 *
 * A vendor signs in and manages exactly one thing: their own menu — sections,
 * products, prices and availability. Everything else (fees, delivery area,
 * orders, assignment) stays with the admin, so none of it is exposed here.
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
 * The only shop-level field a vendor controls: whether they are accepting
 * orders right now. Fees, minimum order, prep time and the pickup point are
 * set by the admin per shop — a vendor cannot touch its own delivery pricing.
 */
vendorPortalRouter.patch(
  '/me',
  validate({ body: z.object({ isOpen: z.boolean() }) }),
  asyncHandler(async (req, res) => {
    const vendor = await myVendor(req);
    vendor.isOpen = req.body.isOpen as boolean;
    await vendor.save();
    return ok(res, vendor.toJSON(), 'تم تحديث حالة المتجر');
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
