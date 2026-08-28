import request from 'supertest';
import { app, api } from './helpers';
import { ALLOWED, ACTOR, ORDER_STATUSES, type OrderStatus } from '../src/modules/orders/order.state';
import { DEFAULT_SETTINGS } from '../src/modules/settings/settings.service';

/**
 * Wiring checks that need no database — these run everywhere, including CI
 * boxes that cannot download a MongoDB binary.
 */
describe('app wiring', () => {
  it('serves a health check', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ success: true, data: expect.objectContaining({ status: 'ok' }) });
  });

  it('returns the error envelope for an unknown route', async () => {
    const res = await request(app).get('/api/v1/nope');
    expect(res.status).toBe(404);
    expect(res.body).toEqual({ success: false, message: expect.any(String), code: 'NOT_FOUND' });
  });

  it('rejects an unauthenticated request to a protected route with 401', async () => {
    for (const path of ['/auth/me', '/orders', '/agent/offers', '/admin/stats', '/addresses']) {
      const res = await request(app).get(api(path));
      expect(res.status).toBe(401);
      expect(res.body.code).toBe('UNAUTHORIZED');
    }
  });

  it('validates the request body before touching the database', async () => {
    const res = await request(app).post(api('/auth/login')).send({ phone: 'nope' });
    expect(res.status).toBe(400);
    expect(res.body.code).toBe('VALIDATION_ERROR');
    expect(res.body.details).toEqual(
      expect.arrayContaining([expect.objectContaining({ path: 'phone' })]),
    );
  });

  it('strips Mongo operator keys from input', async () => {
    const res = await request(app)
      .post(api('/auth/login'))
      .send({ phone: { $gt: '' }, password: { $ne: null } });
    // The sanitiser removes the operators, so zod rejects what is left.
    expect(res.status).toBe(400);
    expect(res.body.code).toBe('VALIDATION_ERROR');
  });

  it('sets the security headers helmet provides', async () => {
    const res = await request(app).get('/health');
    expect(res.headers['x-content-type-options']).toBe('nosniff');
    expect(res.headers['x-dns-prefetch-control']).toBeDefined();
  });
});

describe('state machine integrity', () => {
  it('every status is reachable from pending except cancelled', () => {
    const seen = new Set<OrderStatus>(['pending']);
    const queue: OrderStatus[] = ['pending'];

    while (queue.length) {
      const current = queue.shift()!;
      for (const next of ALLOWED[current]) {
        if (!seen.has(next)) {
          seen.add(next);
          queue.push(next);
        }
      }
    }

    for (const status of ORDER_STATUSES) {
      expect(seen.has(status)).toBe(true);
    }
  });

  it('every allowed transition names at least one actor', () => {
    for (const [from, targets] of Object.entries(ALLOWED)) {
      for (const to of targets) {
        const roles = ACTOR[`${from}->${to}` as keyof typeof ACTOR];
        expect(Array.isArray(roles)).toBe(true);
        expect(roles.length).toBeGreaterThan(0);
      }
    }
  });

  it('the actor table declares no transition the machine forbids', () => {
    for (const transition of Object.keys(ACTOR)) {
      const [from, to] = transition.split('->') as [OrderStatus, OrderStatus];
      expect(ALLOWED[from]).toContain(to);
    }
  });
});

describe('default settings', () => {
  it('match the values §12 specifies', () => {
    expect(DEFAULT_SETTINGS.serviceFeeCentimes).toBe(5000); // 50 دج
    expect(DEFAULT_SETTINGS.vipSurchargeCentimes).toBe(10000); // 100 دج
    expect(DEFAULT_SETTINGS.assignTimeoutSec).toBe(60);
    expect(DEFAULT_SETTINGS.lateThresholdMin).toBe(45);
    expect(DEFAULT_SETTINGS.deliveryRadiusKm).toBe(15);
    expect(DEFAULT_SETTINGS.pointsPerHundredDinars).toBe(1);
    expect(DEFAULT_SETTINGS.pointValueCentimes).toBe(100);
    expect(DEFAULT_SETTINGS.maxPointsPercentOfSubtotal).toBe(50);
    // Cash only at v1.
    expect(DEFAULT_SETTINGS.electronicPaymentEnabled).toBe(false);
  });
});
