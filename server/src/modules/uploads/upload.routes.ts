import { Router, type NextFunction, type Request, type Response } from 'express';
import { z } from 'zod';
import { requireAuth, requireRole } from '../../middleware/auth';
import { uploadImage } from '../../middleware/upload';
import { asyncHandler } from '../../utils/asyncHandler';
import { created, ok } from '../../utils/response';
import { blurPlaceholderUrl, destroyImage, transformedUrl, uploadBuffer, type UploadFolder } from '../../config/cloudinary';
import { ApiError } from '../../utils/ApiError';
import { env } from '../../config/env';
import { Vendor } from '../vendors/vendor.model';
import { Product } from '../products/product.model';

export const uploadRouter = Router();

const FOLDERS: Record<string, UploadFolder> = {
  vendors: 'saji/vendors',
  products: 'saji/products',
  offers: 'saji/offers',
  avatars: 'saji/avatars',
};

const folderSchema = z.enum(['vendors', 'products', 'offers', 'avatars']);

function multerAdapter(req: Request, res: Response, next: NextFunction) {
  uploadImage(req, res, (err: unknown) => {
    if (!err) return next();
    if (err instanceof ApiError) return next(err);
    const code = (err as { code?: string }).code;
    if (code === 'LIMIT_FILE_SIZE') return next(ApiError.badRequest('حجم الصورة يتجاوز 8 ميغابايت'));
    next(ApiError.badRequest('تعذّر رفع الصورة'));
  });
}

/**
 * Folders a shop owner may upload into.
 *
 * A vendor manages their own menu, so product images are theirs to set. Store
 * logos and covers, promotional offers and avatars stay with the admin — those
 * are brand-level decisions, not menu upkeep.
 */
const VENDOR_FOLDERS = new Set(['products']);

/**
 * True when `publicId` is an image on one of this vendor's own products.
 *
 * Without this check a shop owner could pass any Cloudinary id as
 * `replacesPublicId` and delete another store's artwork.
 */
async function vendorOwnsImage(userId: string, publicId: string): Promise<boolean> {
  const vendor = await Vendor.findOne({ owner: userId }).select('_id').lean();
  if (!vendor) return false;
  const product = await Product.exists({ vendor: vendor._id, 'image.publicId': publicId });
  return product !== null;
}

uploadRouter.post(
  '/image',
  requireAuth,
  requireRole('admin', 'vendor'),
  multerAdapter,
  asyncHandler(async (req, res) => {
    if (!env.cloudinaryEnabled) {
      throw new ApiError(503, 'INTERNAL', 'خدمة الصور غير مهيأة على الخادم');
    }
    if (!req.file) throw ApiError.badRequest('لم يتم إرسال أي صورة');

    const parsed = folderSchema.safeParse(req.body?.folder ?? 'products');
    if (!parsed.success) throw ApiError.badRequest('مجلد غير صالح');

    const isVendor = req.user!.role === 'vendor';
    if (isVendor && !VENDOR_FOLDERS.has(parsed.data)) {
      throw ApiError.forbidden();
    }

    const image = await uploadBuffer(req.file.buffer, FOLDERS[parsed.data]!);

    // Replacing an image? Delete the old asset so Cloudinary does not leak.
    // A vendor may only retire an image that is actually on their own product.
    const replaces = typeof req.body?.replacesPublicId === 'string' ? req.body.replacesPublicId : null;
    if (replaces && (!isVendor || (await vendorOwnsImage(req.user!.sub, replaces)))) {
      await destroyImage(replaces);
    }

    return created(res, {
      ...image,
      cardUrl: transformedUrl(image.url),
      blurUrl: blurPlaceholderUrl(image.url),
    });
  }),
);

uploadRouter.delete(
  '/:publicId(*)',
  requireAuth,
  requireRole('admin', 'vendor'),
  asyncHandler(async (req, res) => {
    const publicId = req.params.publicId;
    // The id is free-form, so a vendor must prove the image is on their own
    // product before it can be destroyed.
    if (req.user!.role === 'vendor' && !(await vendorOwnsImage(req.user!.sub, publicId))) {
      throw ApiError.forbidden();
    }
    await destroyImage(publicId);
    return ok(res, null, 'تم حذف الصورة');
  }),
);
