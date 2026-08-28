import crypto from 'node:crypto';
import jwt from 'jsonwebtoken';
import { env } from '../../config/env';
import { RefreshToken } from './refreshToken.model';
import { ApiError } from '../../utils/ApiError';
import type { Role } from '../users/user.model';

export interface AccessPayload {
  sub: string;
  role: Role;
  phone: string;
}

export interface TokenPair {
  accessToken: string;
  refreshToken: string;
  expiresIn: string;
}

function hashToken(token: string): string {
  return crypto.createHash('sha256').update(token).digest('hex');
}

export function signAccessToken(payload: AccessPayload): string {
  return jwt.sign(payload, env.JWT_ACCESS_SECRET, {
    expiresIn: env.JWT_ACCESS_TTL,
  } as jwt.SignOptions);
}

export function verifyAccessToken(token: string): AccessPayload {
  try {
    return jwt.verify(token, env.JWT_ACCESS_SECRET) as AccessPayload;
  } catch {
    throw ApiError.unauthorized('انتهت صلاحية الجلسة، سجّل الدخول من جديد');
  }
}

/** Issues a refresh token and persists only its hash. */
export async function issueRefreshToken(userId: string, family?: string): Promise<string> {
  const raw = crypto.randomBytes(48).toString('hex');
  const expiresAt = new Date(Date.now() + env.JWT_REFRESH_TTL_DAYS * 24 * 60 * 60 * 1000);
  await RefreshToken.create({
    user: userId,
    tokenHash: hashToken(raw),
    family: family ?? crypto.randomUUID(),
    expiresAt,
  });
  return raw;
}

/**
 * Rotates a refresh token. If the presented token was already used (reuse
 * detection) the entire family is revoked and the caller must re-login.
 */
export async function rotateRefreshToken(
  raw: string,
): Promise<{ userId: string; refreshToken: string }> {
  const record = await RefreshToken.findOne({ tokenHash: hashToken(raw) });
  if (!record) throw ApiError.unauthorized('رمز التحديث غير صالح');

  if (record.revokedAt) {
    await RefreshToken.updateMany(
      { family: record.family, revokedAt: null },
      { $set: { revokedAt: new Date() } },
    );
    throw ApiError.unauthorized('تم اكتشاف إعادة استخدام رمز التحديث، سجّل الدخول من جديد');
  }

  if (record.expiresAt.getTime() < Date.now()) {
    throw ApiError.unauthorized('انتهت صلاحية رمز التحديث');
  }

  const next = await issueRefreshToken(String(record.user), record.family);
  record.revokedAt = new Date();
  record.replacedBy = hashToken(next);
  await record.save();

  return { userId: String(record.user), refreshToken: next };
}

export async function revokeRefreshToken(raw: string): Promise<void> {
  const record = await RefreshToken.findOne({ tokenHash: hashToken(raw) });
  if (!record) return;
  await RefreshToken.updateMany(
    { family: record.family, revokedAt: null },
    { $set: { revokedAt: new Date() } },
  );
}

export async function revokeAllForUser(userId: string): Promise<void> {
  await RefreshToken.updateMany({ user: userId, revokedAt: null }, { $set: { revokedAt: new Date() } });
}
