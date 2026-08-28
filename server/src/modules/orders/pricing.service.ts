import type { Types } from 'mongoose';
import { Product, type ProductDoc } from '../products/product.model';
import { Vendor, type VendorDoc } from '../vendors/vendor.model';
import { Voucher, VoucherRedemption, type VoucherDoc } from '../vouchers/voucher.model';
import { User } from '../users/user.model';
import { getSettings, type PlatformSettings } from '../settings/settings.service';
import { ApiError } from '../../utils/ApiError';
import type { DeliveryType, OrderItem, PaymentMethod } from './order.model';
import {
  computePricing,
  voucherDiscount,
  type PricingProduct,
  type PricingResult,
} from './pricing.core';

export interface QuoteItemInput {
  productId: string;
  qty: number;
  optionValueIds?: string[];
}

export interface QuoteInput {
  vendorId: string;
  items: QuoteItemInput[];
  voucherCode?: string;
  pointsToUse?: number;
  deliveryType: DeliveryType;
  paymentMethod?: PaymentMethod;
}

export interface PricedQuote extends PricingResult {
  vendor: VendorDoc;
  orderItems: OrderItem[];
  voucher: VoucherDoc | null;
  settings: PlatformSettings;
}

/** Maps a Mongoose product onto the pure core's shape. */
function toPricingProduct(doc: ProductDoc): PricingProduct {
  return {
    id: String(doc._id),
    name: doc.name,
    priceCentimes: doc.priceCentimes,
    isAvailable: doc.isAvailable,
    options: doc.options.map((o) => ({
      name: o.name,
      type: o.type,
      isRequired: o.isRequired,
      values: o.values.map((v) => ({
        id: String(v._id),
        name: v.name,
        priceDeltaCentimes: v.priceDeltaCentimes,
      })),
    })),
  };
}

/**
 * Re-prices a basket from the database. The client only ever supplies ids and
 * quantities — any price it sends is ignored.
 */
export async function priceOrder(customerId: string, input: QuoteInput): Promise<PricedQuote> {
  const settings = await getSettings();

  if (!input.items.length) throw ApiError.badRequest('السلة فارغة');

  const vendor = await Vendor.findById(input.vendorId);
  if (!vendor || !vendor.isActive) throw ApiError.notFound('المتجر غير متوفر');

  const products = await Product.find({
    _id: { $in: input.items.map((i) => i.productId) },
    vendor: vendor._id,
  });
  const productsById = new Map(products.map((p) => [String(p._id), toPricingProduct(p)]));
  const docsById = new Map(products.map((p) => [String(p._id), p]));

  const warnings: string[] = [];

  // Voucher eligibility needs the database; the discount maths lives in the core.
  let voucher: VoucherDoc | null = null;
  if (input.voucherCode) {
    const evaluation = await evaluateVoucher(input.voucherCode, customerId);
    if (evaluation.error) warnings.push(evaluation.error);
    else voucher = evaluation.voucher;
  }

  let pointsBalance = 0;
  if ((input.pointsToUse ?? 0) > 0) {
    const user = await User.findById(customerId).select('points').lean();
    pointsBalance = user?.points ?? 0;
  }

  const result = computePricing(
    {
      id: String(vendor._id),
      deliveryFeeCentimes: vendor.deliveryFeeCentimes,
      minOrderCentimes: vendor.minOrderCentimes,
    },
    productsById,
    {
      lines: input.items.map((i) => ({
        productId: i.productId,
        qty: i.qty,
        optionValueIds: i.optionValueIds ?? [],
      })),
      deliveryType: input.deliveryType,
      voucher: voucher ? { code: voucher.code, type: voucher.type, value: voucher.value } : null,
      pointsToUse: input.pointsToUse,
      pointsBalance,
    },
    settings,
  );

  // A voucher with a minimum the basket misses is reported, not silently applied.
  if (voucher && result.subtotalCentimes < voucher.minOrderCentimes) {
    warnings.push('قيمة الطلب أقل من الحد الأدنى للقسيمة');
    return {
      ...(await priceOrder(customerId, { ...input, voucherCode: undefined })),
      warnings: [...warnings],
    };
  }

  const orderItems: OrderItem[] = result.items.map((i) => ({
    product: docsById.get(i.productId)!._id as Types.ObjectId,
    nameSnapshot: i.nameSnapshot,
    unitPriceCentimes: i.unitPriceCentimes,
    qty: i.qty,
    selectedOptions: i.selectedOptions,
    lineTotalCentimes: i.lineTotalCentimes,
  }));

  return {
    ...result,
    warnings: [...warnings, ...result.warnings],
    vendor,
    orderItems,
    voucher,
    settings,
  };
}

export interface VoucherEvaluation {
  voucher: VoucherDoc | null;
  error?: string;
}

/** Database-side voucher eligibility: window, quota, per-user limit. */
export async function evaluateVoucher(
  code: string,
  customerId: string,
): Promise<VoucherEvaluation> {
  const voucher = await Voucher.findOne({ code: code.trim().toUpperCase() });
  if (!voucher || !voucher.isActive) return { voucher: null, error: 'القسيمة غير صالحة' };

  const now = Date.now();
  if (voucher.startsAt && voucher.startsAt.getTime() > now) {
    return { voucher: null, error: 'القسيمة لم تبدأ بعد' };
  }
  if (voucher.endsAt && voucher.endsAt.getTime() < now) {
    return { voucher: null, error: 'انتهت صلاحية القسيمة' };
  }
  if (voucher.maxUses > 0 && voucher.usedCount >= voucher.maxUses) {
    return { voucher: null, error: 'استُهلكت هذه القسيمة بالكامل' };
  }
  if (voucher.perUserLimit > 0) {
    const used = await VoucherRedemption.countDocuments({ voucher: voucher._id, user: customerId });
    if (used >= voucher.perUserLimit) {
      return { voucher: null, error: 'لقد استعملت هذه القسيمة من قبل' };
    }
  }
  return { voucher };
}

/** Used by POST /vouchers/validate — eligibility plus the resulting discount. */
export async function validateVoucherForBasket(
  code: string,
  customerId: string,
  subtotalCentimes: number,
  deliveryFeeCentimes: number,
) {
  const { voucher, error } = await evaluateVoucher(code, customerId);
  if (error || !voucher) return { voucher: null, discountCentimes: 0, error };
  if (subtotalCentimes < voucher.minOrderCentimes) {
    return { voucher: null, discountCentimes: 0, error: 'قيمة الطلب أقل من الحد الأدنى للقسيمة' };
  }
  return {
    voucher,
    discountCentimes: voucherDiscount(
      { code: voucher.code, type: voucher.type, value: voucher.value },
      subtotalCentimes,
      deliveryFeeCentimes,
    ),
  };
}
