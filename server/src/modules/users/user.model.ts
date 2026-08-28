import { Schema, model, type Document, type Types } from 'mongoose';
import type { GeoPoint } from '../../utils/geo';

// 'vendor' is a shop or restaurant owner: they sign in to manage their own
// menu and nothing else. Created by an admin — vendors cannot self-register.
export const ROLES = ['customer', 'agent', 'admin', 'vendor'] as const;
export type Role = (typeof ROLES)[number];

export interface ImageRef {
  url: string;
  publicId: string;
  width?: number;
  height?: number;
}

export interface FcmToken {
  token: string;
  platform: 'android' | 'ios' | 'web';
  lastSeen: Date;
}

export interface UserDoc extends Document<Types.ObjectId> {
  phone: string;
  passwordHash: string;
  fullName: string;
  role: Role;
  avatar?: ImageRef | null;
  isActive: boolean;
  isBlocked: boolean;
  points: number;
  defaultAddress?: Types.ObjectId | null;
  fcmTokens: FcmToken[];
  createdAt: Date;
  updatedAt: Date;
}

export const imageRefSchema = new Schema<ImageRef>(
  {
    url: { type: String, required: true },
    publicId: { type: String, required: true },
    width: Number,
    height: Number,
  },
  { _id: false },
);

export const geoPointSchema = new Schema<GeoPoint>(
  {
    type: { type: String, enum: ['Point'], default: 'Point', required: true },
    coordinates: {
      type: [Number],
      required: true,
      validate: {
        validator: (v: number[]) => v.length === 2 && v.every(Number.isFinite),
        message: 'coordinates must be [lng, lat]',
      },
    },
  },
  { _id: false },
);

const userSchema = new Schema<UserDoc>(
  {
    phone: { type: String, required: true, unique: true, trim: true },
    passwordHash: { type: String, required: true, select: false },
    fullName: { type: String, required: true, trim: true },
    role: { type: String, enum: ROLES, default: 'customer', index: true },
    avatar: { type: imageRefSchema, default: null },
    isActive: { type: Boolean, default: true },
    isBlocked: { type: Boolean, default: false },
    points: { type: Number, default: 0, min: 0 },
    defaultAddress: { type: Schema.Types.ObjectId, ref: 'Address', default: null },
    fcmTokens: {
      type: [
        new Schema<FcmToken>(
          {
            token: { type: String, required: true },
            platform: { type: String, enum: ['android', 'ios', 'web'], default: 'android' },
            lastSeen: { type: Date, default: Date.now },
          },
          { _id: false },
        ),
      ],
      default: [],
    },
  },
  {
    timestamps: true,
    toJSON: {
      virtuals: true,
      transform(_doc, ret: Record<string, any>) {
        ret.id = String(ret._id);
        delete ret._id;
        delete ret.__v;
        delete ret.passwordHash;
        delete ret.fcmTokens;
        return ret;
      },
    },
  },
);

userSchema.index({ role: 1, isActive: 1 });

export const User = model<UserDoc>('User', userSchema);
