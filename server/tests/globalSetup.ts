import { MongoMemoryReplSet } from 'mongodb-memory-server';

/**
 * Integration tests need a real MongoDB. mongodb-memory-server downloads one on
 * first run; where the network blocks that download the suite degrades to the
 * pure unit tests instead of failing (see README → Running the tests).
 */
export default async function globalSetup(): Promise<void> {
  try {
    const replset = await MongoMemoryReplSet.create({
      replSet: { count: 1, storageEngine: 'wiredTiger' },
    });
    process.env.SAJI_TEST_MONGO_URI = replset.getUri();
    (globalThis as Record<string, unknown>).__SAJI_REPLSET__ = replset;
  } catch (err) {
    process.env.SAJI_NO_MONGO = '1';
    // eslint-disable-next-line no-console
    console.warn(
      `\n⚠️  MongoDB unavailable — integration tests will be skipped.\n   ${(err as Error).message.split('\n')[0]}\n`,
    );
  }
}
