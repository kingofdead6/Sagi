import { z } from 'zod';
import { objectId } from '../orders/order.schema';
import { ORDER_STATUSES } from '../orders/order.state';
import { DELIVERY_TYPES, PAYMENT_METHODS } from '../orders/order.model';
import { OFFER_TYPES } from '../offers/offer.model';
import { VOUCHER_TYPES } from '../vouchers/voucher.model';
import { phoneField, passwordField } from '../auth/auth.schema';

const image = z
  .object({
    url: z.string().url(),
    publicId: z.string().min(1),
    width: z.number().int().positive().optional(),
    height: z.number().int().positive().optional(),
  })
  .nullable();

export const adminOrdersQuerySchema = z.object({
  status: z.union([z.enum(ORDER_STATUSES), z.array(z.enum(ORDER_STATUSES))]).optional(),
  vendor: objectId.optional(),
  agent: objectId.optional(),
  from: z.coerce.date().optional(),
  to: z.coerce.date().optional(),
  payment: z.enum(PAYMENT_METHODS).optional(),
  deliveryType: z.enum(DELIVERY_TYPES).optional(),
  q: z.string().trim().max(60).optional(),
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
});

export const adminStatusSchema = z.object({
  status: z.enum(ORDER_STATUSES),
  note: z.string().trim().max(200).optional(),
});

export const assignSchema = z.object({ agentId: objectId });

export const rangeQuerySchema = z.object({
  from: z.coerce.date().optional(),
  to: z.coerce.date().optional(),
  limit: z.coerce.number().int().min(1).max(50).default(10),
});

export const availableAgentsQuerySchema = z.object({ vendorId: objectId.optional() });

// --- products ---
const optionValue = z.object({
  name: z.string().trim().min(1).max(60),
  priceDeltaCentimes: z.number().int().default(0),
});

const productOption = z.object({
  name: z.string().trim().min(1).max(60),
  type: z.enum(['single', 'multi']).default('single'),
  isRequired: z.boolean().default(false),
  values: z.array(optionValue).min(1).max(20),
});

export const createProductSchema = z
  .object({
    vendor: objectId,
    section: objectId.nullable().optional(),
    name: z.string().trim().min(1).max(80),
    description: z.string().trim().max(400).optional(),
    image: image.optional(),
    priceCentimes: z.number().int().min(0),
    isAvailable: z.boolean().default(true),
    sortOrder: z.number().int().default(0),
    options: z.array(productOption).max(10).default([]),
  })
  .strict();

export const updateProductSchema = createProductSchema.partial().omit({ vendor: true });

export const reorderSchema = z.object({
  items: z.array(z.object({ id: objectId, sortOrder: z.number().int() })).min(1).max(200),
});

export const bulkAvailabilitySchema = z.object({
  ids: z.array(objectId).min(1).max(200),
  isAvailable: z.boolean(),
});

// --- offers ---
export const createOfferSchema = z
  .object({
    vendor: objectId.nullable().optional(),
    title: z.string().trim().min(2).max(80),
    subtitle: z.string().trim().max(120).optional(),
    image: image.optional(),
    type: z.enum(OFFER_TYPES),
    value: z.number().min(0).default(0),
    productIds: z.array(objectId).max(100).default([]),
    startsAt: z.coerce.date().nullable().optional(),
    endsAt: z.coerce.date().nullable().optional(),
    isActive: z.boolean().default(true),
    showOnHome: z.boolean().default(false),
    sortOrder: z.number().int().default(0),
  })
  .strict();

export const updateOfferSchema = createOfferSchema.partial();

// --- vouchers ---
export const createVoucherSchema = z
  .object({
    code: z.string().trim().min(2).max(32).regex(/^[A-Za-z0-9_-]+$/),
    type: z.enum(VOUCHER_TYPES),
    value: z.number().min(0),
    minOrderCentimes: z.number().int().min(0).default(0),
    maxUses: z.number().int().min(0).default(0),
    perUserLimit: z.number().int().min(0).default(1),
    startsAt: z.coerce.date().nullable().optional(),
    endsAt: z.coerce.date().nullable().optional(),
    isActive: z.boolean().default(true),
  })
  .strict();

export const updateVoucherSchema = createVoucherSchema.partial();

// --- agents & customers ---
export const createAgentSchema = z
  .object({
    fullName: z.string().trim().min(2).max(80),
    phone: phoneField,
    password: passwordField,
  })
  .strict();

export const updateAgentSchema = z
  .object({
    fullName: z.string().trim().min(2).max(80).optional(),
    isActive: z.boolean().optional(),
    isBlocked: z.boolean().optional(),
    password: passwordField.optional(),
  })
  .strict();

export const updateCustomerSchema = z
  .object({
    isBlocked: z.boolean().optional(),
    points: z.number().int().min(0).optional(),
  })
  .strict();

export const listUsersQuerySchema = z.object({
  q: z.string().trim().max(60).optional(),
  isBlocked: z.enum(['true', 'false']).optional(),
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
});

export const updateSettingsSchema = z.record(z.union([z.string(), z.number(), z.boolean()]));
