import { ApiError } from '../../utils/ApiError';
import { percentageOf } from '../../utils/money';
import type { PlatformSettings } from '../settings/settings.service';
import type { DeliveryType, OrderSelectedOption } from './order.model';
import type { VoucherType } from '../vouchers/voucher.model';

/**
 * Pure pricing core — no database, no Express. Everything the engine needs is
 * passed in, which makes the whole pricing matrix directly testable.
 */

export interface PricingOptionValue {
  id: string;
  name: string;
  priceDeltaCentimes: number;
}

export interface PricingOption {
  name: string;
  type: 'single' | 'multi';
  isRequired: boolean;
  values: PricingOptionValue[];
}

export interface PricingProduct {
  id: string;
  name: string;
  priceCentimes: number;
  isAvailable: boolean;
  options: PricingOption[];
}

export interface PricingVendor {
  id: string;
  deliveryFeeCentimes: number;
  minOrderCentimes: number;
}

export interface PricingVoucher {
  code: string;
  type: VoucherType;
  value: number;
}

export interface PricingLine {
  productId: string;
  qty: number;
  optionValueIds: string[];
}

export interface PricingRequest {
  lines: PricingLine[];
  deliveryType: DeliveryType;
  voucher?: PricingVoucher | null;
  voucherDiscountCentimes?: number;
  pointsToUse?: number;
  pointsBalance?: number;
}

export interface PricedLine {
  productId: string;
  nameSnapshot: string;
  unitPriceCentimes: number;
  qty: number;
  selectedOptions: OrderSelectedOption[];
  lineTotalCentimes: number;
}

export interface PricingResult {
  items: PricedLine[];
  subtotalCentimes: number;
  serviceFeeCentimes: number;
  deliveryFeeCentimes: number;
  voucherDiscountCentimes: number;
  pointsUsed: number;
  pointsDiscountCentimes: number;
  discountCentimes: number;
  pointsEarned: number;
  totalCentimes: number;
  warnings: string[];
}

export function resolveOptions(
  product: PricingProduct,
  optionValueIds: string[],
): { selectedOptions: OrderSelectedOption[]; deltaCentimes: number } {
  const wanted = new Set(optionValueIds.map(String));
  const selectedOptions: OrderSelectedOption[] = [];
  let deltaCentimes = 0;

  for (const option of product.options) {
    const chosen = option.values.filter((v) => wanted.has(v.id));

    if (option.isRequired && chosen.length === 0) {
      throw ApiError.badRequest(`يجب اختيار "${option.name}" للمنتج ${product.name}`);
    }
    if (option.type === 'single' && chosen.length > 1) {
      throw ApiError.badRequest(`لا يمكن اختيار أكثر من قيمة واحدة في "${option.name}"`);
    }

    for (const value of chosen) {
      selectedOptions.push({
        name: option.name,
        value: value.name,
        priceDeltaCentimes: value.priceDeltaCentimes,
      });
      deltaCentimes += value.priceDeltaCentimes;
      wanted.delete(value.id);
    }
  }

  if (wanted.size > 0) {
    throw ApiError.badRequest('أحد الخيارات المُرسلة لا ينتمي إلى هذا المنتج');
  }

  return { selectedOptions, deltaCentimes };
}

export function voucherDiscount(
  voucher: PricingVoucher,
  subtotalCentimes: number,
  deliveryFeeCentimes: number,
): number {
  switch (voucher.type) {
    case 'percentage':
      return percentageOf(subtotalCentimes, voucher.value);
    case 'fixed':
      return Math.min(Math.round(voucher.value), subtotalCentimes);
    case 'freeDelivery':
      return deliveryFeeCentimes;
    default:
      return 0;
  }
}

export function computePricing(
  vendor: PricingVendor,
  productsById: Map<string, PricingProduct>,
  request: PricingRequest,
  settings: PlatformSettings,
): PricingResult {
  const warnings: string[] = [];
  if (!request.lines.length) throw ApiError.badRequest('السلة فارغة');

  const items: PricedLine[] = [];
  let subtotalCentimes = 0;

  for (const line of request.lines) {
    const product = productsById.get(line.productId);
    if (!product) throw ApiError.badRequest('أحد المنتجات لم يعد متوفراً في هذا المتجر');
    if (!product.isAvailable) throw ApiError.conflict(`${product.name} غير متوفر حالياً`);
    if (!Number.isInteger(line.qty) || line.qty < 1) throw ApiError.badRequest('الكمية غير صالحة');

    const { selectedOptions, deltaCentimes } = resolveOptions(product, line.optionValueIds);
    const unitPriceCentimes = product.priceCentimes + deltaCentimes;
    const lineTotalCentimes = unitPriceCentimes * line.qty;

    items.push({
      productId: product.id,
      nameSnapshot: product.name,
      unitPriceCentimes,
      qty: line.qty,
      selectedOptions,
      lineTotalCentimes,
    });
    subtotalCentimes += lineTotalCentimes;
  }

  if (vendor.minOrderCentimes > 0 && subtotalCentimes < vendor.minOrderCentimes) {
    throw ApiError.badRequest('قيمة الطلب أقل من الحد الأدنى لهذا المتجر');
  }

  const serviceFeeCentimes = settings.serviceFeeCentimes;
  let deliveryFeeCentimes = vendor.deliveryFeeCentimes;
  if (request.deliveryType === 'vip') deliveryFeeCentimes += settings.vipSurchargeCentimes;

  const voucherDiscountCentimes = request.voucher
    ? (request.voucherDiscountCentimes ??
      voucherDiscount(request.voucher, subtotalCentimes, deliveryFeeCentimes))
    : 0;

  // Points: 1 point = pointValueCentimes, capped at a share of the subtotal.
  let pointsUsed = 0;
  const requested = Math.max(0, Math.floor(request.pointsToUse ?? 0));
  if (requested > 0) {
    const balance = request.pointsBalance ?? 0;
    const capCentimes = percentageOf(subtotalCentimes, settings.maxPointsPercentOfSubtotal);
    const maxByCap = Math.floor(capCentimes / settings.pointValueCentimes);
    pointsUsed = Math.max(0, Math.min(requested, balance, maxByCap));
    if (pointsUsed < requested) warnings.push('تم تعديل عدد النقاط المستعملة إلى الحد المسموح');
  }
  const pointsDiscountCentimes = pointsUsed * settings.pointValueCentimes;

  const discountCentimes = Math.min(
    voucherDiscountCentimes + pointsDiscountCentimes,
    subtotalCentimes + deliveryFeeCentimes,
  );

  const totalCentimes = Math.max(
    0,
    subtotalCentimes + serviceFeeCentimes + deliveryFeeCentimes - discountCentimes,
  );

  // 1 point per 100 دج of subtotal, awarded on delivery.
  const pointsEarned = Math.floor((subtotalCentimes / 10_000) * settings.pointsPerHundredDinars);

  return {
    items,
    subtotalCentimes,
    serviceFeeCentimes,
    deliveryFeeCentimes,
    voucherDiscountCentimes,
    pointsUsed,
    pointsDiscountCentimes,
    discountCentimes,
    pointsEarned,
    totalCentimes,
    warnings,
  };
}
