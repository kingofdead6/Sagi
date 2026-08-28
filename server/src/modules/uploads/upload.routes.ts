import { Router, type NextFunction, type Request, type Response } from 'express';
import { z } from 'zod';
import { requireAuth, requireRole } from '../../middleware/auth';
import { uploadImage } from '../../middleware/upload';
import { asyncHandler } from '../../utils/asyncHandler';
import { created, ok } from '../../utils/response';
import { blurPlaceholderUrl, destroyImage, transformedUrl, uploadBuffer, type UploadFolder } from '../../config/cloudinary';
import { ApiError } from '../../utils/ApiError';
import { env } from '../../config/env';

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

uploadRouter.post(
  '/image',
  requireAuth,
  requireRole('admin'),
  multerAdapter,
  asyncHandler(async (req, res) => {
    if (!env.cloudinaryEnabled) {
      throw new ApiError(503, 'INTERNAL', 'خدمة الصور غير مهيأة على الخادم');
    }
    if (!req.file) throw ApiError.badRequest('لم يتم إرسال أي صورة');

    const parsed = folderSchema.safeParse(req.body?.folder ?? 'products');
    if (!parsed.success) throw ApiError.badRequest('مجلد غير صالح');

    const image = await uploadBuffer(req.file.buffer, FOLDERS[parsed.data]!);

    // Replacing an image? Delete the old asset so Cloudinary does not leak.
    const replaces = typeof req.body?.replacesPublicId === 'string' ? req.body.replacesPublicId : null;
    if (replaces) await destroyImage(replaces);

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
  requireRole('admin'),
  asyncHandler(async (req, res) => {
    await destroyImage(req.params.publicId);
    return ok(res, null, 'تم حذف الصورة');
  }),
);
