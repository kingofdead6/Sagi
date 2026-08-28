import { Schema, model, type Document, type Types } from 'mongoose';
import { BASE_SCHEMA_OPTIONS } from '../common/baseOptions';

export interface RatingDoc extends Document<Types.ObjectId> {
  order: Types.ObjectId;
  customer: Types.ObjectId;
  vendor: Types.ObjectId;
  agent?: Types.ObjectId | null;
  vendorRating: number;
  agentRating?: number | null;
  comment?: string;
}

const ratingSchema = new Schema<RatingDoc>(
  {
    order: { type: Schema.Types.ObjectId, ref: 'Order', required: true, unique: true },
    customer: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    vendor: { type: Schema.Types.ObjectId, ref: 'Vendor', required: true, index: true },
    agent: { type: Schema.Types.ObjectId, ref: 'User', default: null },
    vendorRating: { type: Number, required: true, min: 1, max: 5 },
    agentRating: { type: Number, min: 1, max: 5, default: null },
    comment: { type: String, trim: true, maxlength: 500 },
  },
  BASE_SCHEMA_OPTIONS,
);

export const Rating = model<RatingDoc>('Rating', ratingSchema);
