import { Schema, model, type Document, type Types } from 'mongoose';
import { BASE_SCHEMA_OPTIONS } from '../common/baseOptions';

export const ASSIGNMENT_STATES = ['offered', 'accepted', 'rejected', 'expired'] as const;
export type AssignmentState = (typeof ASSIGNMENT_STATES)[number];

export interface AssignmentDoc extends Document<Types.ObjectId> {
  order: Types.ObjectId;
  agent: Types.ObjectId;
  state: AssignmentState;
  offeredAt: Date;
  expiresAt: Date;
  respondedAt?: Date | null;
  rejectReason?: string | null;
}

const assignmentSchema = new Schema<AssignmentDoc>(
  {
    order: { type: Schema.Types.ObjectId, ref: 'Order', required: true, index: true },
    agent: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    state: { type: String, enum: ASSIGNMENT_STATES, default: 'offered', index: true },
    offeredAt: { type: Date, default: Date.now },
    expiresAt: { type: Date, required: true },
    respondedAt: { type: Date, default: null },
    rejectReason: { type: String, default: null },
  },
  BASE_SCHEMA_OPTIONS,
);

assignmentSchema.index({ agent: 1, state: 1 });
assignmentSchema.index({ order: 1, state: 1 });

export const Assignment = model<AssignmentDoc>('Assignment', assignmentSchema);
