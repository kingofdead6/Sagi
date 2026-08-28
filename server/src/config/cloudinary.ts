import { v2 as cloudinary } from 'cloudinary';
import { env } from './env';
import { logger } from './logger';

if (env.cloudinaryEnabled) {
  cloudinary.config({
    cloud_name: env.CLOUDINARY_CLOUD_NAME,
    api_key: env.CLOUDINARY_API_KEY,
    api_secret: env.CLOUDINARY_API_SECRET,
    secure: true,
  });
} else {
  logger.warn('Cloudinary is not configured — image uploads will be rejected with 503.');
}

export { cloudinary };

export type UploadFolder = 'saji/vendors' | 'saji/products' | 'saji/offers' | 'saji/avatars';

export interface UploadedImage {
  url: string;
  publicId: string;
  width: number;
  height: number;
}

/** Streams a buffer to Cloudinary — the API secret never leaves the server. */
export function uploadBuffer(buffer: Buffer, folder: UploadFolder): Promise<UploadedImage> {
  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      { folder, resource_type: 'image', overwrite: false },
      (error, result) => {
        if (error || !result) return reject(error ?? new Error('Cloudinary upload failed'));
        resolve({
          url: result.secure_url,
          publicId: result.public_id,
          width: result.width,
          height: result.height,
        });
      },
    );
    stream.end(buffer);
  });
}

export async function destroyImage(publicId: string): Promise<void> {
  if (!env.cloudinaryEnabled || !publicId) return;
  try {
    await cloudinary.uploader.destroy(publicId);
  } catch (err) {
    logger.warn({ err, publicId }, 'Failed to delete Cloudinary asset');
  }
}

/** Card-sized transformed delivery URL: f_auto,q_auto,w_684. */
export function transformedUrl(url: string, width = 684): string {
  return url.replace('/upload/', `/upload/f_auto,q_auto,w_${width}/`);
}

/** Tiny blurred placeholder used while the real image loads. */
export function blurPlaceholderUrl(url: string): string {
  return url.replace('/upload/', '/upload/e_blur:1000,f_auto,q_auto,w_24/');
}
