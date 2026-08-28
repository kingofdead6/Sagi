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
  },
  BASE_SCHEMA_OPTIONS,
);

productSchema.index({ vendor: 1, isAvailable: 1 });
productSchema.index({ name: 'text' });

export const Product = model<ProductDoc>('Product', productSchema);
