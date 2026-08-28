/**
 * Shared schema options: timestamps on, and a toJSON transform that maps
 * _id -> id and strips __v plus any password hash.
 */
export function baseSchemaOptions() {
  return {
    timestamps: true,
    toJSON: {
      virtuals: true,
      transform(_doc: unknown, ret: Record<string, any>) {
        ret.id = String(ret._id);
        delete ret._id;
        delete ret.__v;
        delete ret.passwordHash;
        return ret;
      },
    },
    toObject: { virtuals: true },
  } as const as any;
}

export const BASE_SCHEMA_OPTIONS = baseSchemaOptions();
