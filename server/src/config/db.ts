import mongoose from 'mongoose';
import { env } from './env';
import { logger } from './logger';

let replicaSetSupported: boolean | null = null;

/** True when the connected server can run multi-document transactions. */
export function supportsTransactions(): boolean {
  return replicaSetSupported === true;
}

export async function detectTransactionSupport(): Promise<boolean> {
  try {
    const admin = mongoose.connection.db?.admin();
    if (!admin) return false;
    const info = (await admin.command({ hello: 1 })) as Record<string, unknown>;
    replicaSetSupported = Boolean(info.setName) || info.msg === 'isdbgrid';
  } catch {
    replicaSetSupported = false;
  }
  if (!replicaSetSupported) {
    logger.warn(
      'MongoDB is running standalone — transactions are unavailable. ' +
        'Order creation falls back to a compensating-write path (see DECISIONS.md).',
    );
  }
  return replicaSetSupported;
}

export async function connectDb(uri = env.MONGO_URI): Promise<typeof mongoose> {
  mongoose.set('strictQuery', true);
  await mongoose.connect(uri, { serverSelectionTimeoutMS: 10_000 });
  await detectTransactionSupport();
  logger.info({ transactions: replicaSetSupported }, 'MongoDB connected');
  return mongoose;
}

export async function disconnectDb(): Promise<void> {
  await mongoose.disconnect();
}
