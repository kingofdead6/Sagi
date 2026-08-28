import rateLimit from 'express-rate-limit';
import { env } from '../config/env';

const skip = () => env.isTest;

export const generalLimiter = rateLimit({
  windowMs: 60_000,
  limit: 300,
  standardHeaders: 'draft-7',
  legacyHeaders: false,
  skip,
  message: { success: false, message: 'محاولات كثيرة، حاول لاحقاً', code: 'RATE_LIMITED' },
});

/** Auth routes are limited hard: 5 requests / minute / IP by default. */
export const authLimiter = rateLimit({
  windowMs: 60_000,
  limit: env.RATE_LIMIT_AUTH_MAX,
  standardHeaders: 'draft-7',
  legacyHeaders: false,
  skip,
  message: { success: false, message: 'محاولات كثيرة، حاول لاحقاً', code: 'RATE_LIMITED' },
});
