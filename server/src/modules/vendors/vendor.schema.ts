import { z } from 'zod';
import { objectId } from '../orders/order.schema';

const boolQuery = z
  .union([z.boolean(), z.enum(['true', 'false', '1', '0'])])
  .transform((v) => v === true || v === 'true' || v === '1');

export const vendorListQuerySchema = z.object({
  category: objectId.optional(),
  search: z.string().trim().min(1).max(80).optional(),
  lat: z.coerce.number().min(-90).max(90).optional(),
  lng: z.coerce.number().min(-180).max(180).optional(),
  sort: z.enum(['nearest', 'fastest', 'rating', 'featured']).default('featured'),
  openNow: boolQuery.optional(),
  hasOffer: boolQuery.optional(),
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(50).default(20),
});

export const vendorGetQuerySchema = z.object({
  lat: z.coerce.number().min(-90).max(90).optional(),
  lng: z.coerce.number().min(-180).max(180).optional(),
});

const imageSchema = z
  .object({
    url: z.string().url(),
    publicId: z.string().min(1),
    width: z.number().int().positive().optional(),
    height: z.number().int().positive().optional(),
  })
  .nullable();

const openingHourSchema = z.object({
  day: z.number().int().min(0).max(6),
  from: z.string().regex(/^\d{2}:\d{2}$/),
  to: z.string().regex(/^\d{2}:\d{2}$/),
});

export const createVendorSchema = z
  .object({
    name: z.string().trim().min(2).max(80),
    slug: z
      .string()
      .trim()
      .min(2)
      .max(80)
      .regex(/^[a-z0-9-]+$/, 'المعرّف يجب أن يحتوي حروفاً لاتينية صغيرة وأرقاماً وشرطات فقط'),
    description: z.string().trim().max(500).optional(),
    category: objectId,
    logo: imageSchema.optional(),
    cover: imageSchema.optional(),
    phone: z.string().trim().min(6).max(20),
    addressText: z.string().trim().min(3).max(200),
    lat: z.number().min(-90).max(90),
    lng: z.number().min(-180).max(180),
    prepTimeMin: z.number().int().min(0).max(240).default(15),
    prepTimeMax: z.number().int().min(0).max(240).default(30),
    deliveryFeeCentimes: z.number().int().min(0).default(15000),
    minOrderCentimes: z.number().int().min(0).default(0),
    isOpen: z.boolean().default(true),
    openingHours: z.array(openingHourSchema).max(21).default([]),
    isFeatured: z.boolean().default(false),
    sortOrder: z.number().int().default(0),
    isActive: z.boolean().default(true),
  })
  .strict();

export const updateVendorSchema = createVendorSchema.partial();

export const menuSectionSchema = z
  .object({
    name: z.string().trim().min(1).max(60),
    sortOrder: z.number().int().default(0),
  })
  .strict();
