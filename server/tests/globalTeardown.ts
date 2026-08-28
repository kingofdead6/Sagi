import type { MongoMemoryReplSet } from 'mongodb-memory-server';

export default async function globalTeardown(): Promise<void> {
  const replset = (globalThis as Record<string, unknown>).__SAJI_REPLSET__ as
    | MongoMemoryReplSet
    | undefined;
  await replset?.stop();
}
