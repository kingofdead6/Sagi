import type { Request, Response } from 'express';
import { asyncHandler } from '../../utils/asyncHandler';
import { created, ok } from '../../utils/response';
import * as service from './auth.service';
import { env } from '../../config/env';
import { ApiError } from '../../utils/ApiError';

export const registerCtrl = asyncHandler(async (req: Request, res: Response) => {
  const result = await service.register(req.body);
  return created(res, result, 'تم إنشاء الحساب بنجاح');
});

export const loginCtrl = asyncHandler(async (req: Request, res: Response) => {
  const result = await service.login(req.body);
  return ok(res, result, 'مرحباً بك في ساجي');
});

export const refreshCtrl = asyncHandler(async (req: Request, res: Response) => {
  const result = await service.refresh(req.body.refreshToken);
  return ok(res, result);
});

export const logoutCtrl = asyncHandler(async (req: Request, res: Response) => {
  await service.logout(req.body?.refreshToken, req.user?.sub);
  return ok(res, null, 'تم تسجيل الخروج');
});

export const meCtrl = asyncHandler(async (req: Request, res: Response) => {
  return ok(res, await service.me(req.user!.sub));
});

export const updateMeCtrl = asyncHandler(async (req: Request, res: Response) => {
  return ok(res, await service.updateMe(req.user!.sub, req.body), 'تم تحديث الملف الشخصي');
});

export const changePasswordCtrl = asyncHandler(async (req: Request, res: Response) => {
  await service.changePassword(req.user!.sub, req.body.currentPassword, req.body.newPassword);
  return ok(res, null, 'تم تغيير كلمة المرور');
});

export const fcmTokenCtrl = asyncHandler(async (req: Request, res: Response) => {
  await service.saveFcmToken(req.user!.sub, req.body.token, req.body.platform);
  return ok(res, null);
});

export const deleteFcmTokenCtrl = asyncHandler(async (req: Request, res: Response) => {
  await service.removeFcmToken(req.user!.sub, req.body.token);
  return ok(res, null);
});

/**
 * OTP is built but disabled at v1 (OTP_ENABLED=false): Algerian SMS delivery is
 * unreliable and the admin phones every customer anyway.
 */
export const requestOtpCtrl = asyncHandler(async (_req: Request, res: Response) => {
  if (!env.OTP_ENABLED) {
    throw new ApiError(503, 'CONFLICT', 'التحقق عبر الرمز غير مفعّل حالياً');
  }
  return ok(res, { sent: true, ttlSeconds: 120 });
});

export const verifyOtpCtrl = asyncHandler(async (_req: Request, res: Response) => {
  if (!env.OTP_ENABLED) {
    throw new ApiError(503, 'CONFLICT', 'التحقق عبر الرمز غير مفعّل حالياً');
  }
  return ok(res, { verified: true });
});
