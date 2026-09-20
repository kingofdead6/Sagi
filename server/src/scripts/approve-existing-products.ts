/**
 * One-off migration: grandfather every pre-existing product as approved.
 *
 * The review pipeline defaults new products to `pending`. Without this, the
 * products already live before the upgrade would inherit that default and
 * vanish from every public menu at once. Run it exactly once, right after
 * deploying the schema change:
 *
 *   npx tsx src/scripts/approve-existing-products.ts
 *
 * It only touches documents that have no status yet, so running it twice is
 * harmless — the second pass matches nothing.
 */
import { connectDb, disconnectDb } from '../config/db';
import { logger } from '../config/logger';
import { Product } from '../modules/products/product.model';

async function main() {
  await connectDb();

  const result = await Product.updateMany(
    { $or: [{ status: { $exists: false } }, { status: null }] },
    { $set: { status: 'approved', submittedAt: new Date() } },
  );

  logger.info({ approved: result.modifiedCount }, 'existing products grandfathered as approved');
  await disconnectDb();
}

main().catch((error) => {
  logger.error({ error }, 'migration failed');
  process.exitCode = 1;
});
