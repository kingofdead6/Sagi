import multer from 'multer';
import { ApiError } from '../utils/ApiError';

const ALLOWED = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];

/**
 * Images are buffered in memory then streamed to Cloudinary by the service —
 * the Cloudinary secret never leaves the server.
 */
export const uploadImage = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 8 * 1024 * 1024, files: 1 },
  fileFilter(_req, file, cb) {
    if (!ALLOWED.includes(file.mimetype)) {
      return cb(ApiError.badRequest('نوع الملف غير مدعوم، استعمل JPG أو PNG أو WEBP'));
    }
    cb(null, true);
  },
}).single('image');
