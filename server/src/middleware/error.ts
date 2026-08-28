import type { NextFunction, Request, Response } from 'express';
import { ZodError } from 'zod';
import mongoose from 'mongoose';
import { ApiError } from '../utils/ApiError';
import { logger } from '../config/logger';
import { env } from '../config/env';

export function notFoundHandler(_req: Request, res: Response) {
  res.status(404).json({ success: false, message: 'المسار غير موجود', code: 'NOT_FOUND' });
}

/** The single place an error becomes an HTTP response. */
export function errorHandler(err: unknown, _req: Request, res: Response, _next: NextFunction) {
  if (err instanceof ApiError) {
    return res.status(err.status).json({
      success: false,
      message: err.message,
      code: err.code,
      ...(err.details ? { details: err.details } : {}),
    });
  }

  if (err instanceof ZodError) {
    return res.status(400).json({
      success: false,
      message: 'البيانات المُرسلة غير صالحة',
      code: 'VALIDATION_ERROR',
      details: err.issues.map((i) => ({ path: i.path.join('.'), message: i.message })),
    });
  }

  if (err instanceof mongoose.Error.ValidationError) {
    return res.status(400).json({
      success: false,
      message: 'البيانات المُرسلة غير صالحة',
      code: 'VALIDATION_ERROR',
      details: Object.values(err.errors).map((e) => ({ path: e.path, message: e.message })),
    });
  }

  if (err instanceof mongoose.Error.CastError) {
    return res.status(400).json({ success: false, message: 'معرّف غير صالح', code: 'VALIDATION_ERROR' });
  }

  const anyErr = err as { code?: number; keyValue?: Record<string, unknown> };
  if (anyErr?.code === 11000) {
    const field = Object.keys(anyErr.keyValue ?? {})[0] ?? 'قيمة';
    return res.status(409).json({
      success: false,
      message: `${field} مستعمل من قبل`,
      code: 'CONFLICT',
    });
  }

  logger.error({ err }, 'Unhandled error');
  return res.status(500).json({
    success: false,
    message: 'خطأ في الخادم',
    code: 'INTERNAL',
    ...(env.isProd ? {} : { details: (err as Error)?.message }),
  });
}
