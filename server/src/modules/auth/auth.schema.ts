import { z } from 'zod';
import { isValidAlgerianPhone, normalizePhone } from '../../utils/phone';

export const phoneField = z
  .string()
  .trim()
  .refine(isValidAlgerianPhone, 'رقم الهاتف يجب أن يكون جزائرياً صالحاً (05/06/07)')
  .transform(normalizePhone);

export const passwordField = z.string().min(6, 'كلمة المرور يجب أن تحتوي 6 أحرف على الأقل').max(128);

export const registerSchema = z.object({
  phone: phoneField,
  password: passwordField,
  fullName: z.string().trim().min(2, 'الاسم قصير جداً').max(80),
});

export const loginSchema = z.object({
  phone: phoneField,
  password: z.string().min(1, 'كلمة المرور مطلوبة'),
});

export const refreshSchema = z.object({
  refreshToken: z.string().min(20, 'رمز التحديث غير صالح'),
});

export const updateMeSchema = z
  .object({
    fullName: z.string().trim().min(2).max(80).optional(),
    avatar: z
      .object({
        url: z.string().url(),
        publicId: z.string().min(1),
        width: z.number().int().positive().optional(),
        height: z.number().int().positive().optional(),
      })
      .nullable()
      .optional(),
    defaultAddress: z.string().regex(/^[0-9a-fA-F]{24}$/).nullable().optional(),
  })
  .strict();

export const fcmTokenSchema = z.object({
  token: z.string().min(10),
  platform: z.enum(['android', 'ios', 'web']).default('android'),
});

export const changePasswordSchema = z.object({
  currentPassword: z.string().min(1),
  newPassword: passwordField,
});

export const requestOtpSchema = z.object({ phone: phoneField });

export const verifyOtpSchema = z.object({
  phone: phoneField,
  code: z.string().regex(/^\d{4,6}$/, 'رمز التحقق غير صالح'),
});

export type RegisterInput = z.infer<typeof registerSchema>;
export type LoginInput = z.infer<typeof loginSchema>;
export type UpdateMeInput = z.infer<typeof updateMeSchema>;
