import {
  computePricing,
  resolveOptions,
  voucherDiscount,
  type PricingProduct,
  type PricingVendor,
} from '../src/modules/orders/pricing.core';
import { DEFAULT_SETTINGS } from '../src/modules/settings/settings.service';
import { ApiError } from '../src/utils/ApiError';

const settings = { ...DEFAULT_SETTINGS }; // serviceFee 5000, vip 10000, point = 100

const burger: PricingProduct = {
  id: 'p1',
  name: 'برجر كلاسيك',
  priceCentimes: 45000, // 450 دج
  isAvailable: true,
  options: [
    {
      name: 'الحجم',
      type: 'single',
      isRequired: true,
      values: [
        { id: 'size-normal', name: 'عادي', priceDeltaCentimes: 0 },
        { id: 'size-double', name: 'مضاعف', priceDeltaCentimes: 15000 },
      ],
    },
    {
      name: 'إضافات',
      type: 'multi',
      isRequired: false,
      values: [
        { id: 'add-cheese', name: 'جبن', priceDeltaCentimes: 5000 },
        { id: 'add-egg', name: 'بيض', priceDeltaCentimes: 4000 },
      ],
    },
  ],
};

const fries: PricingProduct = {
  id: 'p2',
  name: 'بطاطا مقلية',
  priceCentimes: 15000,
  isAvailable: true,
  options: [],
};

const soldOut: PricingProduct = { ...fries, id: 'p3', name: 'نفدت الكمية', isAvailable: false };

const vendor: PricingVendor = { id: 'v1', deliveryFeeCentimes: 15000, minOrderCentimes: 0 };
const products = new Map([burger, fries, soldOut].map((p) => [p.id, p]));

const line = (productId: string, qty = 1, optionValueIds: string[] = []) => ({
  productId,
  qty,
  optionValueIds,
});

describe('option resolution', () => {
  it('adds a single-choice delta to the unit price', () => {
    const { deltaCentimes, selectedOptions } = resolveOptions(burger, ['size-double']);
    expect(deltaCentimes).toBe(15000);
    expect(selectedOptions).toEqual([
      { name: 'الحجم', value: 'مضاعف', priceDeltaCentimes: 15000 },
    ]);
  });

  it('sums several multi-choice deltas', () => {
    const { deltaCentimes } = resolveOptions(burger, ['size-normal', 'add-cheese', 'add-egg']);
    expect(deltaCentimes).toBe(9000);
  });

  it('rejects a missing required option', () => {
    expect(() => resolveOptions(burger, [])).toThrow(ApiError);
  });

  it('rejects two values for a single-choice option', () => {
    expect(() => resolveOptions(burger, ['size-normal', 'size-double'])).toThrow(ApiError);
  });

  it('rejects an option value from a different product', () => {
    expect(() => resolveOptions(burger, ['size-normal', 'not-mine'])).toThrow(ApiError);
  });
});

describe('voucher discount', () => {
  it('takes a percentage of the subtotal only', () => {
    expect(voucherDiscount({ code: 'X', type: 'percentage', value: 10 }, 100000, 15000)).toBe(10000);
  });

  it('caps a fixed voucher at the subtotal', () => {
    expect(voucherDiscount({ code: 'X', type: 'fixed', value: 200000 }, 60000, 15000)).toBe(60000);
  });

  it('waives exactly the delivery fee', () => {
    expect(voucherDiscount({ code: 'X', type: 'freeDelivery', value: 0 }, 100000, 18000)).toBe(18000);
  });
});

describe('pricing matrix', () => {
  it('prices a plain single-item basket', () => {
    const r = computePricing(vendor, products, { lines: [line('p2')], deliveryType: 'normal' }, settings);
    expect(r.subtotalCentimes).toBe(15000);
    expect(r.serviceFeeCentimes).toBe(5000);
    expect(r.deliveryFeeCentimes).toBe(15000);
    expect(r.totalCentimes).toBe(35000);
  });

  it('multiplies options into every unit of the line', () => {
    const r = computePricing(
      vendor,
      products,
      { lines: [line('p1', 3, ['size-double', 'add-cheese'])], deliveryType: 'normal' },
      settings,
    );
    // (450 + 150 + 50) * 3 = 1950 دج
    expect(r.items[0]!.unitPriceCentimes).toBe(65000);
    expect(r.subtotalCentimes).toBe(195000);
    expect(r.totalCentimes).toBe(215000);
  });

  it('sums multiple lines', () => {
    const r = computePricing(
      vendor,
      products,
      { lines: [line('p1', 2, ['size-normal']), line('p2', 3)], deliveryType: 'normal' },
      settings,
    );
    expect(r.subtotalCentimes).toBe(45000 * 2 + 15000 * 3);
    expect(r.items).toHaveLength(2);
  });

  it('adds the VIP surcharge on top of the vendor delivery fee', () => {
    const r = computePricing(vendor, products, { lines: [line('p2')], deliveryType: 'vip' }, settings);
    expect(r.deliveryFeeCentimes).toBe(25000);
    expect(r.totalCentimes).toBe(45000);
  });

  it('applies a percentage voucher to the subtotal', () => {
    const r = computePricing(
      vendor,
      products,
      {
        lines: [line('p1', 1, ['size-normal'])],
        deliveryType: 'normal',
        voucher: { code: 'SAJI10', type: 'percentage', value: 10 },
      },
      settings,
    );
    expect(r.voucherDiscountCentimes).toBe(4500);
    expect(r.totalCentimes).toBe(45000 + 5000 + 15000 - 4500);
  });

  it('applies a free-delivery voucher', () => {
    const r = computePricing(
      vendor,
      products,
      {
        lines: [line('p2')],
        deliveryType: 'normal',
        voucher: { code: 'LIVRAISON', type: 'freeDelivery', value: 0 },
      },
      settings,
    );
    expect(r.discountCentimes).toBe(15000);
    expect(r.totalCentimes).toBe(20000);
  });

  it('spends points at 1 point = 1 دج', () => {
    const r = computePricing(
      vendor,
      products,
      { lines: [line('p2', 4)], deliveryType: 'normal', pointsToUse: 20, pointsBalance: 100 },
      settings,
    );
    expect(r.pointsUsed).toBe(20);
    expect(r.pointsDiscountCentimes).toBe(2000);
    expect(r.totalCentimes).toBe(60000 + 5000 + 15000 - 2000);
  });

  it('never spends more points than the customer holds', () => {
    const r = computePricing(
      vendor,
      products,
      { lines: [line('p2', 4)], deliveryType: 'normal', pointsToUse: 500, pointsBalance: 7 },
      settings,
    );
    expect(r.pointsUsed).toBe(7);
    expect(r.warnings.length).toBeGreaterThan(0);
  });

  it('caps points at 50% of the subtotal', () => {
    // subtotal 150 دج -> cap 75 دج -> 75 points
    const r = computePricing(
      vendor,
      products,
      { lines: [line('p2')], deliveryType: 'normal', pointsToUse: 1000, pointsBalance: 1000 },
      settings,
    );
    expect(r.pointsUsed).toBe(75);
    expect(r.pointsDiscountCentimes).toBe(7500);
  });

  it('combines a voucher and points', () => {
    const r = computePricing(
      vendor,
      products,
      {
        lines: [line('p1', 2, ['size-normal'])], // 900 دج
        deliveryType: 'normal',
        voucher: { code: 'SAJI10', type: 'percentage', value: 10 },
        pointsToUse: 50,
        pointsBalance: 200,
      },
      settings,
    );
    expect(r.voucherDiscountCentimes).toBe(9000);
    expect(r.pointsDiscountCentimes).toBe(5000);
    expect(r.discountCentimes).toBe(14000);
    expect(r.totalCentimes).toBe(90000 + 5000 + 15000 - 14000);
  });

  it('never lets the total go below zero', () => {
    const r = computePricing(
      vendor,
      products,
      {
        lines: [line('p2')],
        deliveryType: 'normal',
        voucher: { code: 'BIG', type: 'fixed', value: 999999 },
        pointsToUse: 1000,
        pointsBalance: 1000,
      },
      settings,
    );
    expect(r.totalCentimes).toBeGreaterThanOrEqual(0);
  });

  it('earns 1 point per 100 دج of subtotal', () => {
    const r = computePricing(vendor, products, { lines: [line('p2', 10)], deliveryType: 'normal' }, settings);
    expect(r.subtotalCentimes).toBe(150000); // 1500 دج
    expect(r.pointsEarned).toBe(15);
  });

  it('keeps every amount an integer number of centimes', () => {
    const r = computePricing(
      vendor,
      products,
      {
        lines: [line('p1', 3, ['size-double', 'add-egg'])],
        deliveryType: 'vip',
        voucher: { code: 'ODD', type: 'percentage', value: 7 },
        pointsToUse: 13,
        pointsBalance: 500,
      },
      settings,
    );
    for (const value of [
      r.subtotalCentimes,
      r.serviceFeeCentimes,
      r.deliveryFeeCentimes,
      r.discountCentimes,
      r.totalCentimes,
      r.pointsDiscountCentimes,
    ]) {
      expect(Number.isInteger(value)).toBe(true);
    }
  });

  it('rejects an unavailable product', () => {
    expect(() =>
      computePricing(vendor, products, { lines: [line('p3')], deliveryType: 'normal' }, settings),
    ).toThrow(ApiError);
  });

  it('rejects a product that is not on this vendor menu', () => {
    expect(() =>
      computePricing(vendor, products, { lines: [line('ghost')], deliveryType: 'normal' }, settings),
    ).toThrow(ApiError);
  });

  it('rejects an empty basket', () => {
    expect(() => computePricing(vendor, products, { lines: [], deliveryType: 'normal' }, settings)).toThrow(
      ApiError,
    );
  });

  it('rejects a zero or fractional quantity', () => {
    for (const qty of [0, -1, 1.5]) {
      expect(() =>
        computePricing(vendor, products, { lines: [line('p2', qty)], deliveryType: 'normal' }, settings),
      ).toThrow(ApiError);
    }
  });

  it('enforces the vendor minimum order', () => {
    const strict: PricingVendor = { ...vendor, minOrderCentimes: 100000 };
    expect(() =>
      computePricing(strict, products, { lines: [line('p2')], deliveryType: 'normal' }, settings),
    ).toThrow(ApiError);
  });
});
