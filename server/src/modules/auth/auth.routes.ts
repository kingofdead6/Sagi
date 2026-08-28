import { Router } from 'express';
import { validate } from '../../middleware/validate';
import { requireAuth } from '../../middleware/auth';
import { authLimiter } from '../../middleware/rateLimit';
import * as ctrl from './auth.controller';
import {
  changePasswordSchema,
  fcmTokenSchema,
  loginSchema,
  refreshSchema,
  registerSchema,
  requestOtpSchema,
  updateMeSchema,
  verifyOtpSchema,
} from './auth.schema';

export const authRouter = Router();

authRouter.post('/register', authLimiter, validate({ body: registerSchema }), ctrl.registerCtrl);
authRouter.post('/login', authLimiter, validate({ body: loginSchema }), ctrl.loginCtrl);
authRouter.post('/refresh', validate({ body: refreshSchema }), ctrl.refreshCtrl);
authRouter.post('/logout', ctrl.logoutCtrl);

authRouter.post('/otp/request', authLimiter, validate({ body: requestOtpSchema }), ctrl.requestOtpCtrl);
authRouter.post('/otp/verify', authLimiter, validate({ body: verifyOtpSchema }), ctrl.verifyOtpCtrl);

authRouter.get('/me', requireAuth, ctrl.meCtrl);
authRouter.patch('/me', requireAuth, validate({ body: updateMeSchema }), ctrl.updateMeCtrl);
authRouter.post(
  '/change-password',
  requireAuth,
  validate({ body: changePasswordSchema }),
  ctrl.changePasswordCtrl,
);
authRouter.post('/fcm-token', requireAuth, validate({ body: fcmTokenSchema }), ctrl.fcmTokenCtrl);
authRouter.delete(
  '/fcm-token',
  requireAuth,
  validate({ body: fcmTokenSchema.pick({ token: true }) }),
  ctrl.deleteFcmTokenCtrl,
);
