import { Schema, model, type Document, type Types } from 'mongoose';
import { BASE_SCHEMA_OPTIONS } from '../common/baseOptions';

export const VOUCHER_TYPES = ['percentage', 'fixed', 'freeDelivery'] as const;
export type VoucherType = (typeof VOUCHER_TYPES)[number];

export interface VoucherDoc extends Document<Types.ObjectId> {
  code: string;
  type: VoucherType;
  value: number;
  minOrderCentimes: number;
  maxUses: number; // 0 = unlimited
  usedCount: number;
  perUserLimit: number; // 0 = unlimited
  startsAt?: Date | null;
  endsAt?: Date | null;
  isActive: boolean;
}

const voucherSchema = new Schema<VoucherDoc>(
  {
    code: { type: String, required: true, unique: true, uppercase: true, trim: true },
    type: { type: String, enum: VOUCHER_TYPES, required: true },
    value: { type: Number, required: true, min: 0 },
    minOrderCentimes: { type: Number, default: 0, min: 0 },
    maxUses: { type: Number, default: 0, min: 0 },
    usedCount: { type: Number, default: 0, min: 0 },
    perUserLimit: { type: Number, default: 1, min: 0 },
    startsAt: { type: Date, default: null },
    endsAt: { type: Date, default: null },
    isActive: { type: Boolean, default: true },
  },
  BASE_SCHEMA_OPTIONS,
);

export const Voucher = model<VoucherDoc>('Voucher', voucherSchema);

export interface VoucherRedemptionDoc extends Document<Types.ObjectId> {
  voucher: Types.ObjectId;
  user: Types.ObjectId;
  order: Types.ObjectId;
}

const redemptionSchema = new Schema<VoucherRedemptionDoc>(
  {
    voucher: { type: Schema.Types.ObjectId, ref: 'Voucher', required: true, index: true },
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    order: { type: Schema.Types.ObjectId, ref: 'Order', required: true },
  },
  BASE_SCHEMA_OPTIONS,
);

redemptionSchema.index({ voucher: 1, user: 1 });

export const VoucherRedemption = model<VoucherRedemptionDoc>(
  'VoucherRedemption',
  redemptionSchema,
);
