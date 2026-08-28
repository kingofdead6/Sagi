import { z } from 'zod';
import { ORDER_STATUSES } from './order.state';
import { DELIVERY_TYPES, PAYMENT_METHODS } from './order.model';

export const objectId = z.string().regex(/^[0-9a-fA-F]{24}$/, 'معرّف غير صالح');

export const idParams = z.object({ id: objectId });

export const quoteItemSchema = z.object({
  productId: objectId,
  qty: z.number().int().min(1).max(50),
  optionValueIds: z.array(objectId).max(20).default([]),
});

export const quoteSchema = z.object({
  vendorId: objectId,
  items: z.array(quoteItemSchema).min(1, 'السلة فارغة').max(50),
  voucherCode: z.string().trim().min(2).max(32).optional(),
  pointsToUse: z.number().int().min(0).max(100_000).optional(),
  deliveryType: z.enum(DELIVERY_TYPES).default('normal'),
  paymentMethod: z.enum(PAYMENT_METHODS).default('cash'),
});

export const createOrderSchema = quoteSchema.extend({
  addressId: objectId,
  customerNote: z.string().trim().max(400).optional(),
});

export const cancelOrderSchema = z.object({
  reason: z.string().trim().min(3, 'سبب الإلغاء مطلوب').max(200),
});

export const listOrdersQuerySchema = z.object({
  status: z
    .union([z.enum(ORDER_STATUSES), z.array(z.enum(ORDER_STATUSES))])
    .optional(),
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
});

export const ratingSchema = z.object({
  vendorRating: z.number().int().min(1).max(5),
  agentRating: z.number().int().min(1).max(5).optional(),
  comment: z.string().trim().max(500).optional(),
});

export const validateVoucherSchema = z.object({
  code: z.string().trim().min(2).max(32),
  subtotalCentimes: z.number().int().min(0),
  deliveryFeeCentimes: z.number().int().min(0).default(0),
});
