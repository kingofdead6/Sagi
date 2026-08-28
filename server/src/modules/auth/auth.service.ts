import bcrypt from 'bcrypt';
import { User, type Role, type UserDoc } from '../users/user.model';
import { ApiError } from '../../utils/ApiError';
import { env } from '../../config/env';
import {
  issueRefreshToken,
  revokeAllForUser,
  revokeRefreshToken,
  rotateRefreshToken,
  signAccessToken,
} from './token.service';
import type { RegisterInput, LoginInput, UpdateMeInput } from './auth.schema';

const BCRYPT_ROUNDS = 12;

export async function hashPassword(plain: string): Promise<string> {
  return bcrypt.hash(plain, BCRYPT_ROUNDS);
}

function session(user: UserDoc, accessToken: string, refreshToken: string) {
  return {
    user: user.toJSON(),
    accessToken,
    refreshToken,
    expiresIn: env.JWT_ACCESS_TTL,
  };
}

async function issuePair(user: UserDoc) {
  const accessToken = signAccessToken({
    sub: String(user._id),
    role: user.role,
    phone: user.phone,
  });
  const refreshToken = await issueRefreshToken(String(user._id));
  return session(user, accessToken, refreshToken);
}

export async function register(input: RegisterInput) {
  const existing = await User.findOne({ phone: input.phone }).lean();
  if (existing) throw ApiError.conflict('رقم الهاتف مسجّل من قبل');

  const user = await User.create({
    phone: input.phone,
    passwordHash: await hashPassword(input.password),
    fullName: input.fullName,
    role: 'customer' as Role,
  });

  return issuePair(user);
}

export async function login(input: LoginInput) {
  const user = await User.findOne({ phone: input.phone }).select('+passwordHash');
  if (!user) throw ApiError.unauthorized('رقم الهاتف أو كلمة المرور غير صحيحة');

  const matches = await bcrypt.compare(input.password, user.passwordHash);
  if (!matches) throw ApiError.unauthorized('رقم الهاتف أو كلمة المرور غير صحيحة');
  if (user.isBlocked) throw ApiError.forbidden('تم حظر هذا الحساب');
  if (!user.isActive) throw ApiError.forbidden('الحساب غير مفعّل');

  return issuePair(user);
}

export async function refresh(rawRefreshToken: string) {
  const { userId, refreshToken } = await rotateRefreshToken(rawRefreshToken);
  const user = await User.findById(userId);
  if (!user || user.isBlocked || !user.isActive) {
    throw ApiError.unauthorized('الحساب غير متاح');
  }
  const accessToken = signAccessToken({
    sub: String(user._id),
    role: user.role,
    phone: user.phone,
  });
  return session(user, accessToken, refreshToken);
}

export async function logout(rawRefreshToken?: string, userId?: string) {
  if (rawRefreshToken) await revokeRefreshToken(rawRefreshToken);
  else if (userId) await revokeAllForUser(userId);
}

export async function me(userId: string) {
  const user = await User.findById(userId).populate('defaultAddress');
  if (!user) throw ApiError.notFound('الحساب غير موجود');
  return user.toJSON();
}

/** Only whitelisted fields are ever written — never raw req.body. */
export async function updateMe(userId: string, input: UpdateMeInput) {
  const update: Record<string, unknown> = {};
  if (input.fullName !== undefined) update.fullName = input.fullName;
  if (input.avatar !== undefined) update.avatar = input.avatar;
  if (input.defaultAddress !== undefined) update.defaultAddress = input.defaultAddress;

  const user = await User.findByIdAndUpdate(userId, { $set: update }, { new: true }).populate(
    'defaultAddress',
  );
  if (!user) throw ApiError.notFound('الحساب غير موجود');
  return user.toJSON();
}

export async function changePassword(userId: string, current: string, next: string) {
  const user = await User.findById(userId).select('+passwordHash');
  if (!user) throw ApiError.notFound('الحساب غير موجود');
  const matches = await bcrypt.compare(current, user.passwordHash);
  if (!matches) throw ApiError.badRequest('كلمة المرور الحالية غير صحيحة');
  user.passwordHash = await hashPassword(next);
  await user.save();
  await revokeAllForUser(userId);
}

export async function saveFcmToken(userId: string, token: string, platform: 'android' | 'ios' | 'web') {
  await User.updateOne({ _id: userId }, { $pull: { fcmTokens: { token } } });
  await User.updateOne(
    { _id: userId },
    { $push: { fcmTokens: { token, platform, lastSeen: new Date() } } },
  );
}

export async function removeFcmToken(userId: string, token: string) {
  await User.updateOne({ _id: userId }, { $pull: { fcmTokens: { token } } });
}
