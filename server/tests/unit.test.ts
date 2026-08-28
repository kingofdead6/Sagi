import { formatCentimes, percentageOf, toCentimes, toDinars } from '../src/utils/money';
import { isValidAlgerianPhone, normalizePhone, toLocalPhone } from '../src/utils/phone';
import { generateOrderCode, generateUniqueOrderCode } from '../src/utils/orderCode';
import { distanceKm, etaMinutes } from '../src/utils/geo';
import { ALLOWED, actorAllowed, canTransition, isTerminal } from '../src/modules/orders/order.state';

describe('money', () => {
  it('converts dinars to centimes as integers', () => {
    expect(toCentimes(1350)).toBe(135000);
    expect(toCentimes(13.5)).toBe(1350);
    expect(Number.isInteger(toCentimes(0.005))).toBe(true);
  });

  it('formats centimes the way the design specifies', () => {
    expect(formatCentimes(135000)).toBe('1350.0 د.ج');
    expect(formatCentimes(0)).toBe('0.0 د.ج');
    expect(formatCentimes(50)).toBe('0.5 د.ج');
  });

  it('round-trips through dinars', () => {
    expect(toDinars(toCentimes(999.99))).toBeCloseTo(999.99, 2);
  });

  it('applies percentages with half-up rounding', () => {
    expect(percentageOf(100000, 20)).toBe(20000);
    expect(percentageOf(33333, 10)).toBe(3333);
  });
});

describe('phone', () => {
  it('accepts every Algerian mobile prefix', () => {
    for (const p of ['0550123456', '0660123456', '0770123456']) {
      expect(isValidAlgerianPhone(p)).toBe(true);
    }
  });

  it('rejects landlines, short numbers and other countries', () => {
    for (const p of ['0380123456', '077012345', '+33612345678', 'abc']) {
      expect(isValidAlgerianPhone(p)).toBe(false);
    }
  });

  it('normalises every accepted form to E.164', () => {
    expect(normalizePhone('0770123456')).toBe('+213770123456');
    expect(normalizePhone('+213770123456')).toBe('+213770123456');
    expect(normalizePhone('213770123456')).toBe('+213770123456');
    expect(normalizePhone('0770 12 34 56')).toBe('+213770123456');
    expect(normalizePhone('077-012-3456')).toBe('+213770123456');
  });

  it('converts back to the local form for display', () => {
    expect(toLocalPhone('+213770123456')).toBe('0770123456');
  });

  it('throws on invalid input', () => {
    expect(() => normalizePhone('123')).toThrow();
  });
});

describe('order code', () => {
  it('matches DR + 6 digits', () => {
    for (let i = 0; i < 50; i += 1) expect(generateOrderCode()).toMatch(/^DR\d{6}$/);
  });

  it('retries until the code is unique', async () => {
    let calls = 0;
    const code = await generateUniqueOrderCode(async () => {
      calls += 1;
      return calls < 3;
    });
    expect(calls).toBe(3);
    expect(code).toMatch(/^DR\d{6}$/);
  });

  it('gives up rather than looping forever', async () => {
    await expect(generateUniqueOrderCode(async () => true, 3)).rejects.toThrow();
  });
});

describe('geo', () => {
  it('measures a known short distance', () => {
    const km = distanceKm({ lat: 34.744, lng: 8.06 }, { lat: 34.754, lng: 8.06 });
    expect(km).toBeGreaterThan(1.0);
    expect(km).toBeLessThan(1.3);
  });

  it('never returns an ETA below the 5 minute floor', () => {
    expect(etaMinutes(0)).toBe(5);
    expect(etaMinutes(11)).toBe(30);
  });
});

describe('order state machine', () => {
  it('walks the whole happy path', () => {
    const path = [
      'pending',
      'confirmed',
      'sent_to_vendor',
      'preparing',
      'ready',
      'assigned',
      'accepted',
      'picked_up',
      'on_the_way',
      'delivered',
    ] as const;
    for (let i = 0; i < path.length - 1; i += 1) {
      expect(canTransition(path[i]!, path[i + 1]!)).toBe(true);
    }
  });

  it('refuses to skip steps', () => {
    expect(canTransition('pending', 'delivered')).toBe(false);
    expect(canTransition('pending', 'assigned')).toBe(false);
    expect(canTransition('ready', 'picked_up')).toBe(false);
    expect(canTransition('confirmed', 'ready')).toBe(false);
  });

  it('treats delivered and cancelled as terminal', () => {
    expect(isTerminal('delivered')).toBe(true);
    expect(isTerminal('cancelled')).toBe(true);
    expect(ALLOWED.delivered).toHaveLength(0);
    expect(ALLOWED.cancelled).toHaveLength(0);
  });

  it('lets a rejected assignment fall back to ready', () => {
    expect(canTransition('assigned', 'ready')).toBe(true);
  });

  it('allows cancellation from every non-terminal state', () => {
    for (const [status, targets] of Object.entries(ALLOWED)) {
      if (isTerminal(status as never)) continue;
      expect(targets).toContain('cancelled');
    }
  });

  it('binds each transition to the right actor', () => {
    expect(actorAllowed('pending', 'confirmed', 'admin')).toBe(true);
    expect(actorAllowed('pending', 'confirmed', 'customer')).toBe(false);
    expect(actorAllowed('pending', 'confirmed', 'agent')).toBe(false);

    expect(actorAllowed('on_the_way', 'delivered', 'agent')).toBe(true);
    expect(actorAllowed('on_the_way', 'delivered', 'admin')).toBe(false);

    expect(actorAllowed('pending', 'cancelled', 'customer')).toBe(true);
    expect(actorAllowed('preparing', 'cancelled', 'customer')).toBe(false);

    expect(actorAllowed('ready', 'assigned', 'admin')).toBe(true);
    expect(actorAllowed('ready', 'assigned', 'agent')).toBe(false);
  });
});
