import { Schema, model, type Document, type Types } from 'mongoose';
import { BASE_SCHEMA_OPTIONS } from '../common/baseOptions';
import { imageRefSchema, type ImageRef } from '../users/user.model';

export interface OptionValue {
  _id: Types.ObjectId;
  name: string;
  priceDeltaCentimes: number;
}

export interface ProductOption {
  name: string;
  type: 'single' | 'multi';
  isRequired: boolean;
  values: OptionValue[];
}

/**
 * Where a product sits in the review pipeline.
 *
 * `pending`  — submitted by a shop, waiting on an admin. Invisible publicly.
 * `approved` — cleared by an admin. The only status that reaches customers.
 * `rejected` — turned down, with a reason the shop can read and act on.
 */
export type ProductStatus = 'pending' | 'approved' | 'rejected';

export const PRODUCT_STATUSES: ProductStatus[] = ['pending', 'approved', 'rejected'];

export interface ProductDoc extends Document<Types.ObjectId> {
  vendor: Types.ObjectId;
  section?: Types.ObjectId | null;
  name: string;
  description?: string;
  image?: ImageRef | null;
  priceCentimes: number;
  isAvailable: boolean;
  sortOrder: number;
  options: ProductOption[];
  status: ProductStatus;
  /** Why an admin rejected it — shown to the shop so they can fix and resubmit. */
  rejectionReason?: string | null;
  reviewedBy?: Types.ObjectId | null;
  reviewedAt?: Date | null;
  submittedAt?: Date | null;
}

const optionValueSchema = new Schema<OptionValue>({
  name: { type: String, required: true, trim: true },
  priceDeltaCentimes: { type: Number, default: 0 },
});

const productOptionSchema = new Schema<ProductOption>(
  {
    name: { type: String, required: true, trim: true },
    type: { type: String, enum: ['single', 'multi'], default: 'single' },
    isRequired: { type: Boolean, default: false },
    values: { type: [optionValueSchema], default: [] },
  },
  { _id: false },
);

const productSchema = new Schema<ProductDoc>(
  {
    vendor: { type: Schema.Types.ObjectId, ref: 'Vendor', required: true, index: true },
    section: { type: Schema.Types.ObjectId, ref: 'MenuSection', default: null, index: true },
    name: { type: String, required: true, trim: true },
    description: { type: String, trim: true },
    image: { type: imageRefSchema, default: null },
    priceCentimes: { type: Number, required: true, min: 0 },
    isAvailable: { type: Boolean, default: true },
    sortOrder: { type: Number, default: 0 },
    options: { type: [productOptionSchema], default: [] },
    // New products wait for review. Admin-created ones are approved outright
    // by the route that makes them — the admin is the reviewer.
    status: { type: String, enum: PRODUCT_STATUSES, default: 'pending', index: true },
    rejectionReason: { type: String, trim: true, default: null },
    reviewedBy: { type: Schema.Types.ObjectId, ref: 'User', default: null },
    reviewedAt: { type: Date, default: null },
    submittedAt: { type: Date, default: Date.now },
  },
  BASE_SCHEMA_OPTIONS,
);

productSchema.index({ vendor: 1, isAvailable: 1 });
// The public menu filters on status; the admin queue sorts by submission time.
productSchema.index({ vendor: 1, status: 1 });
productSchema.index({ status: 1, submittedAt: -1 });
productSchema.index({ name: 'text' });

export const Product = model<ProductDoc>('Product', productSchema);
