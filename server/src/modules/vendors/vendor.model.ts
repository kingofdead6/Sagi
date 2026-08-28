import { Schema, model, type Document, type Types } from 'mongoose';
import { BASE_SCHEMA_OPTIONS } from '../common/baseOptions';
import { geoPointSchema, imageRefSchema, type ImageRef } from '../users/user.model';
import type { GeoPoint } from '../../utils/geo';

export interface OpeningHour {
  day: number; // 0 = Sunday
  from: string; // "08:00"
  to: string; // "23:00"
}

export interface VendorDoc extends Document<Types.ObjectId> {
  name: string;
  slug: string;
  description?: string;
  category: Types.ObjectId;
  logo?: ImageRef | null;
  cover?: ImageRef | null;
  phone: string;
  addressText: string;
  location: GeoPoint;
  rating: number;
  ratingCount: number;
  prepTimeMin: number;
  prepTimeMax: number;
  deliveryFeeCentimes: number;
  minOrderCentimes: number;
  isOpen: boolean;
  openingHours: OpeningHour[];
  isFeatured: boolean;
  sortOrder: number;
  isActive: boolean;
}

const openingHourSchema = new Schema<OpeningHour>(
  {
    day: { type: Number, min: 0, max: 6, required: true },
    from: { type: String, required: true },
    to: { type: String, required: true },
  },
  { _id: false },
);

const vendorSchema = new Schema<VendorDoc>(
  {
    name: { type: String, required: true, trim: true },
    slug: { type: String, required: true, unique: true, lowercase: true, trim: true },
    description: { type: String, trim: true },
    category: { type: Schema.Types.ObjectId, ref: 'Category', required: true, index: true },
    logo: { type: imageRefSchema, default: null },
    cover: { type: imageRefSchema, default: null },
    phone: { type: String, required: true, trim: true },
    addressText: { type: String, required: true, trim: true },
    location: { type: geoPointSchema, required: true },
    rating: { type: Number, default: 0, min: 0, max: 5 },
    ratingCount: { type: Number, default: 0, min: 0 },
    prepTimeMin: { type: Number, default: 15, min: 0 },
    prepTimeMax: { type: Number, default: 30, min: 0 },
    deliveryFeeCentimes: { type: Number, default: 15000, min: 0 },
    minOrderCentimes: { type: Number, default: 0, min: 0 },
    isOpen: { type: Boolean, default: true },
    openingHours: { type: [openingHourSchema], default: [] },
    isFeatured: { type: Boolean, default: false, index: true },
    sortOrder: { type: Number, default: 0 },
    isActive: { type: Boolean, default: true, index: true },
  },
  BASE_SCHEMA_OPTIONS,
);

vendorSchema.index({ location: '2dsphere' });
vendorSchema.index({ name: 'text', description: 'text' }, { weights: { name: 5, description: 1 } });
vendorSchema.index({ category: 1, isActive: 1, isFeatured: -1 });

export const Vendor = model<VendorDoc>('Vendor', vendorSchema);

export interface MenuSectionDoc extends Document<Types.ObjectId> {
  vendor: Types.ObjectId;
  name: string;
  sortOrder: number;
}

const menuSectionSchema = new Schema<MenuSectionDoc>(
  {
    vendor: { type: Schema.Types.ObjectId, ref: 'Vendor', required: true, index: true },
    name: { type: String, required: true, trim: true },
    sortOrder: { type: Number, default: 0 },
  },
  BASE_SCHEMA_OPTIONS,
);

menuSectionSchema.index({ vendor: 1, sortOrder: 1 });

export const MenuSection = model<MenuSectionDoc>('MenuSection', menuSectionSchema);
