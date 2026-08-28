import { Schema, model, type Document, type Types } from 'mongoose';
import { BASE_SCHEMA_OPTIONS } from '../common/baseOptions';
import { geoPointSchema } from '../users/user.model';
import type { GeoPoint } from '../../utils/geo';

export interface AddressDoc extends Document<Types.ObjectId> {
  user: Types.ObjectId;
  label: string;
  wilaya: string;
  commune: string;
  street: string;
  notes?: string;
  location: GeoPoint;
  isDefault: boolean;
}

const addressSchema = new Schema<AddressDoc>(
  {
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    label: { type: String, required: true, trim: true, default: 'المنزل' },
    wilaya: { type: String, required: true, trim: true },
    commune: { type: String, required: true, trim: true },
    street: { type: String, required: true, trim: true },
    notes: { type: String, trim: true },
    location: { type: geoPointSchema, required: true },
    isDefault: { type: Boolean, default: false },
  },
  BASE_SCHEMA_OPTIONS,
);

addressSchema.index({ location: '2dsphere' });
addressSchema.index({ user: 1, isDefault: -1 });

export const Address = model<AddressDoc>('Address', addressSchema);
