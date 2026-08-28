import mongoose from 'mongoose';
import { detectTransactionSupport } from '../src/config/db';

export const mongoAvailable = process.env.SAJI_NO_MONGO !== '1';

/** `describe` for suites that need a database — skipped when none is reachable. */
export const describeDb: jest.Describe = mongoAvailable ? describe : describe.skip;

beforeAll(async () => {
  if (!mongoAvailable) return;
  await mongoose.connect(process.env.SAJI_TEST_MONGO_URI!, { serverSelectionTimeoutMS: 30_000 });
  await detectTransactionSupport();
}, 120_000);

afterAll(async () => {
  if (!mongoAvailable) return;
  await mongoose.disconnect();
});

afterEach(async () => {
  if (!mongoAvailable || mongoose.connection.readyState !== 1) return;
  const { collections } = mongoose.connection;
  await Promise.all(Object.values(collections).map((c) => c.deleteMany({})));
});
