import { Schema, model, type Document, type Types } from 'mongoose';
import { BASE_SCHEMA_OPTIONS } from '../common/baseOptions';

export interface SettingDoc extends Document<Types.ObjectId> {
  key: string;
  value: unknown;
  description?: string;
}

const settingSchema = new Schema<SettingDoc>(
  {
    key: { type: String, required: true, unique: true, trim: true },
    value: { type: Schema.Types.Mixed, required: true },
    description: { type: String, trim: true },
  },
  BASE_SCHEMA_OPTIONS,
);

export const Setting = model<SettingDoc>('Setting', settingSchema);
