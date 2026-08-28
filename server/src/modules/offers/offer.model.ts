import { Schema, model, type Document, type Types } from 'mongoose';
import { BASE_SCHEMA_OPTIONS } from '../common/baseOptions';
import { imageRefSchema, type ImageRef } from '../users/user.model';

export const OFFER_TYPES = ['percentage', 'fixed', 'freeDelivery', 'bundle'] as const;
export type OfferType = (typeof OFFER_TYPES)[number];

export interface OfferDoc extends Document<Types.ObjectId> {
  vendor?: Types.ObjectId | null; // null = platform-wide
  title: string;
  subtitle?: string;
  image?: ImageRef | null;
  type: OfferType;
  value: number; // percent for `percentage`, centimes for `fixed`
  productIds: Types.ObjectId[];
  startsAt?: Date | null;
  endsAt?: Date | null;
  isActive: boolean;
  showOnHome: boolean;
  sortOrder: number;
}

const offerSchema = new Schema<OfferDoc>(
  {
    vendor: { type: Schema.Types.ObjectId, ref: 'Vendor', default: null, index: true },
    title: { type: String, required: true, trim: true },
    subtitle: { type: String, trim: true },
    image: { type: imageRefSchema, default: null },
    type: { type: String, enum: OFFER_TYPES, required: true },
    value: { type: Number, default: 0, min: 0 },
    productIds: { type: [{ type: Schema.Types.ObjectId, ref: 'Product' }], default: [] },
    startsAt: { type: Date, default: null },
    endsAt: { type: Date, default: null },
    isActive: { type: Boolean, default: true, index: true },
    showOnHome: { type: Boolean, default: false, index: true },
    sortOrder: { type: Number, default: 0 },
  },
  BASE_SCHEMA_OPTIONS,
);

export const Offer = model<OfferDoc>('Offer', offerSchema);
