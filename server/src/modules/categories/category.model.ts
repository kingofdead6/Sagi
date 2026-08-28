import { Schema, model, type Document, type Types } from 'mongoose';
import { BASE_SCHEMA_OPTIONS } from '../common/baseOptions';

export interface CategoryDoc extends Document<Types.ObjectId> {
  nameAr: string;
  nameFr: string;
  iconKey: string;
  sortOrder: number;
  isActive: boolean;
}

const categorySchema = new Schema<CategoryDoc>(
  {
    nameAr: { type: String, required: true, trim: true },
    nameFr: { type: String, required: true, trim: true },
    iconKey: { type: String, required: true, trim: true },
    sortOrder: { type: Number, default: 0, index: true },
    isActive: { type: Boolean, default: true, index: true },
  },
  BASE_SCHEMA_OPTIONS,
);

export const Category = model<CategoryDoc>('Category', categorySchema);
