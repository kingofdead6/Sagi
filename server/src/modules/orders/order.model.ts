import { Schema, model, type Document, type Types } from 'mongoose';
import { BASE_SCHEMA_OPTIONS } from '../common/baseOptions';
import { geoPointSchema } from '../users/user.model';
import type { GeoPoint } from '../../utils/geo';
import { ORDER_STATUSES, type OrderStatus } from './order.state';
import type { Role } from '../users/user.model';

export const DELIVERY_TYPES = ['normal', 'vip'] as const;
export type DeliveryType = (typeof DELIVERY_TYPES)[number];

export const PAYMENT_METHODS = ['cash', 'electronic'] as const;
export type PaymentMethod = (typeof PAYMENT_METHODS)[number];

export interface OrderSelectedOption {
  name: string;
  value: string;
  priceDeltaCentimes: number;
}

export interface OrderItem {
  product: Types.ObjectId;
  nameSnapshot: string;
  unitPriceCentimes: number;
  qty: number;
  selectedOptions: OrderSelectedOption[];
  lineTotalCentimes: number;
}

export interface OrderAddressSnapshot {
  label: string;
  wilaya: string;
  commune: string;
  street: string;
  notes?: string;
}

export interface OrderEvent {
  from: OrderStatus | null;
  to: OrderStatus;
  actor?: Types.ObjectId | null;
  actorRole: Role | 'system';
  note?: string;
  at: Date;
}

export interface OrderDoc extends Document<Types.ObjectId> {
  code: string;
  customer: Types.ObjectId;
  vendor: Types.ObjectId;
  status: OrderStatus;
  deliveryType: DeliveryType;
  paymentMethod: PaymentMethod;
  address: OrderAddressSnapshot;
  deliveryLocation: GeoPoint;
  customerNote?: string;
  items: OrderItem[];
  subtotalCentimes: number;
  serviceFeeCentimes: number;
  deliveryFeeCentimes: number;
  discountCentimes: number;
  pointsUsed: number;
  pointsEarned: number;
  totalCentimes: number;
  voucher?: Types.ObjectId | null;
  agent?: Types.ObjectId | null;
  confirmedBy?: Types.ObjectId | null;
  confirmedAt?: Date | null;
  assignedAt?: Date | null;
  acceptedAt?: Date | null;
  pickedUpAt?: Date | null;
  deliveredAt?: Date | null;
  cancelledReason?: string | null;
  events: OrderEvent[];
  createdAt: Date;
  updatedAt: Date;
  isLate: boolean;
}

const selectedOptionSchema = new Schema<OrderSelectedOption>(
  {
    name: { type: String, required: true },
    value: { type: String, required: true },
    priceDeltaCentimes: { type: Number, default: 0 },
  },
  { _id: false },
);

const orderItemSchema = new Schema<OrderItem>(
  {
    product: { type: Schema.Types.ObjectId, ref: 'Product', required: true },
    nameSnapshot: { type: String, required: true },
    unitPriceCentimes: { type: Number, required: true, min: 0 },
    qty: { type: Number, required: true, min: 1 },
    selectedOptions: { type: [selectedOptionSchema], default: [] },
    lineTotalCentimes: { type: Number, required: true, min: 0 },
  },
  { _id: false },
);

const eventSchema = new Schema<OrderEvent>(
  {
    from: { type: String, enum: [...ORDER_STATUSES, null], default: null },
    to: { type: String, enum: ORDER_STATUSES, required: true },
    actor: { type: Schema.Types.ObjectId, ref: 'User', default: null },
    actorRole: { type: String, enum: ['customer', 'agent', 'admin', 'system'], required: true },
    note: { type: String },
    at: { type: Date, default: Date.now },
  },
  { _id: false },
);

const orderSchema = new Schema<OrderDoc>(
  {
    code: { type: String, required: true, unique: true, uppercase: true, trim: true },
    customer: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    vendor: { type: Schema.Types.ObjectId, ref: 'Vendor', required: true, index: true },
    status: { type: String, enum: ORDER_STATUSES, default: 'pending' },
    deliveryType: { type: String, enum: DELIVERY_TYPES, default: 'normal' },
    paymentMethod: { type: String, enum: PAYMENT_METHODS, default: 'cash' },
    address: {
      label: { type: String, required: true },
      wilaya: { type: String, required: true },
      commune: { type: String, required: true },
      street: { type: String, required: true },
      notes: { type: String },
    },
    deliveryLocation: { type: geoPointSchema, required: true },
    customerNote: { type: String, trim: true },
    items: { type: [orderItemSchema], required: true },
    subtotalCentimes: { type: Number, required: true, min: 0 },
    serviceFeeCentimes: { type: Number, required: true, min: 0 },
    deliveryFeeCentimes: { type: Number, required: true, min: 0 },
    discountCentimes: { type: Number, default: 0, min: 0 },
    pointsUsed: { type: Number, default: 0, min: 0 },
    pointsEarned: { type: Number, default: 0, min: 0 },
    totalCentimes: { type: Number, required: true, min: 0 },
    voucher: { type: Schema.Types.ObjectId, ref: 'Voucher', default: null },
    agent: { type: Schema.Types.ObjectId, ref: 'User', default: null },
    confirmedBy: { type: Schema.Types.ObjectId, ref: 'User', default: null },
    confirmedAt: { type: Date, default: null },
    assignedAt: { type: Date, default: null },
    acceptedAt: { type: Date, default: null },
    pickedUpAt: { type: Date, default: null },
    deliveredAt: { type: Date, default: null },
    cancelledReason: { type: String, default: null },
    events: { type: [eventSchema], default: [] },
  },
  BASE_SCHEMA_OPTIONS,
);

orderSchema.index({ status: 1, createdAt: -1 });
orderSchema.index({ agent: 1, status: 1 });
orderSchema.index({ customer: 1, createdAt: -1 });
orderSchema.index({ deliveryLocation: '2dsphere' });

/**
 * Late = still in a non-terminal state more than `lateThresholdMin` after
 * confirmation. The threshold is injected at read time by the order service so
 * the virtual stays free of a database round-trip.
 */
let lateThresholdMin = 45;

orderSchema.virtual('isLate').get(function (this: OrderDoc) {
  const threshold = lateThresholdMin;
  if (!this.confirmedAt) return false;
  if (['delivered', 'cancelled'].includes(this.status)) return false;
  return Date.now() - this.confirmedAt.getTime() > threshold * 60_000;
});

export const Order = model<OrderDoc>('Order', orderSchema);

/** Updates the threshold used by the `isLate` virtual (called on settings load). */
export function setLateThreshold(minutes: number): void {
  lateThresholdMin = minutes;
}

export function getLateThreshold(): number {
  return lateThresholdMin;
}
