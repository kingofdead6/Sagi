import { Schema, model, type Document, type Types } from 'mongoose';
import { BASE_SCHEMA_OPTIONS } from '../common/baseOptions';
import { geoPointSchema } from '../users/user.model';
import type { GeoPoint } from '../../utils/geo';

export interface AgentStatusDoc extends Document<Types.ObjectId> {
  agent: Types.ObjectId;
  isOnline: boolean;
  currentOrder?: Types.ObjectId | null;
  lastSeenAt: Date;
  lastLocation?: GeoPoint | null;
}

const agentStatusSchema = new Schema<AgentStatusDoc>(
  {
    agent: { type: Schema.Types.ObjectId, ref: 'User', required: true, unique: true },
    isOnline: { type: Boolean, default: false, index: true },
    currentOrder: { type: Schema.Types.ObjectId, ref: 'Order', default: null },
    lastSeenAt: { type: Date, default: Date.now },
    lastLocation: { type: geoPointSchema, default: null },
  },
  BASE_SCHEMA_OPTIONS,
);

agentStatusSchema.index({ lastLocation: '2dsphere' });

export const AgentStatus = model<AgentStatusDoc>('AgentStatus', agentStatusSchema);

export interface AgentLocationDoc extends Document<Types.ObjectId> {
  agent: Types.ObjectId;
  order?: Types.ObjectId | null;
  location: GeoPoint;
  heading?: number;
  speed?: number;
  battery?: number;
  recordedAt: Date;
}

const agentLocationSchema = new Schema<AgentLocationDoc>(
  {
    agent: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    order: { type: Schema.Types.ObjectId, ref: 'Order', default: null },
    location: { type: geoPointSchema, required: true },
    heading: { type: Number },
    speed: { type: Number },
    battery: { type: Number },
    recordedAt: { type: Date, default: Date.now },
  },
  { timestamps: { createdAt: true, updatedAt: false } },
);

agentLocationSchema.index({ agent: 1, recordedAt: -1 });
// Append-only breadcrumb trail; kept for 7 days.
agentLocationSchema.index({ recordedAt: 1 }, { expireAfterSeconds: 7 * 24 * 60 * 60 });
agentLocationSchema.index({ location: '2dsphere' });

export const AgentLocation = model<AgentLocationDoc>('AgentLocation', agentLocationSchema);
