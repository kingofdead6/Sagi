import type { NextFunction, Request, Response } from 'express';
import { verifyAccessToken, type AccessPayload } from '../modules/auth/token.service';
import { ApiError } from '../utils/ApiError';
import { User } from '../modules/users/user.model';
import type { Role } from '../modules/users/user.model';

declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace Express {
    interface Request {
      user?: AccessPayload;
    }
  }
}

function extractToken(req: Request): string | null {
  const header = req.headers.authorization;
  if (header?.startsWith('Bearer ')) return header.slice(7).trim();
  return null;
}

export async function requireAuth(req: Request, _res: Response, next: NextFunction) {
  try {
    const token = extractToken(req);
    if (!token) throw ApiError.unauthorized();
    const payload = verifyAccessToken(token);

    const user = await User.findById(payload.sub).select('_id role isActive isBlocked phone').lean();
    if (!user) throw ApiError.unauthorized('الحساب غير موجود');
    if (user.isBlocked) throw ApiError.forbidden('تم حظر هذا الحساب');
    if (!user.isActive) throw ApiError.forbidden('الحساب غير مفعّل');

    // The role always comes from the database, never from the client.
    req.user = { sub: String(user._id), role: user.role as Role, phone: user.phone };
    next();
  } catch (err) {
    next(err);
  }
}

/** Attaches req.user when a valid token is present, but never rejects. */
export async function optionalAuth(req: Request, _res: Response, next: NextFunction) {
  const token = extractToken(req);
  if (!token) return next();
  try {
    const payload = verifyAccessToken(token);
    const user = await User.findById(payload.sub).select('_id role isBlocked phone').lean();
    if (user && !user.isBlocked) {
      req.user = { sub: String(user._id), role: user.role as Role, phone: user.phone };
    }
  } catch {
    // ignore — this route works unauthenticated
  }
  next();
}

export function requireRole(...roles: Role[]) {
  return (req: Request, _res: Response, next: NextFunction) => {
    if (!req.user) return next(ApiError.unauthorized());
    if (!roles.includes(req.user.role)) return next(ApiError.forbidden());
    next();
  };
}

/** Throws unless the request comes from `ownerId` or an admin. */
export function assertOwnerOrAdmin(user: AccessPayload | undefined, ownerId: string): void {
  if (!user) throw ApiError.unauthorized();
  if (user.role === 'admin') return;
  if (String(ownerId) !== user.sub) throw ApiError.forbidden();
}
