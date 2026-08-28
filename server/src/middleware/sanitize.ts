import type { NextFunction, Request, Response } from 'express';

const FORBIDDEN_KEY = /^\$|\./;

function scrub(value: unknown, depth = 0): unknown {
  if (depth > 8 || value === null || typeof value !== 'object') return value;
  if (Array.isArray(value)) return value.map((v) => scrub(v, depth + 1));
  const out: Record<string, unknown> = {};
  for (const [k, v] of Object.entries(value as Record<string, unknown>)) {
    if (FORBIDDEN_KEY.test(k)) continue;
    out[k] = scrub(v, depth + 1);
  }
  return out;
}

/** Strips Mongo operator keys ($gt, dotted paths) from user input. */
export function mongoSanitize(req: Request, _res: Response, next: NextFunction) {
  if (req.body) req.body = scrub(req.body);
  if (req.params) req.params = scrub(req.params) as typeof req.params;
  if (req.query && Object.keys(req.query).length) {
    Object.defineProperty(req, 'query', {
      value: scrub(req.query),
      writable: true,
      configurable: true,
    });
  }
  next();
}
