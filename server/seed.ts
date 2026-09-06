import { connectDb, disconnectDb } from './src/config/db';
import { Category } from './src/modules/categories/category.model';

async function seed() {
  await connectDb();

  console.info('→ Clearing existing categories...');
  await Category.deleteMany({});

  const categories = await Category.create([
    { nameAr: 'وجبات سريعة', nameFr: 'Fast-food', iconKey: 'fastfood', sortOrder: 1 },
    { nameAr: 'فواكه', nameFr: 'Fruits', iconKey: 'fruits', sortOrder: 2 },
    { nameAr: 'لحوم', nameFr: 'Viandes', iconKey: 'meat', sortOrder: 3 },
    { nameAr: 'بقالة', nameFr: 'Épicerie', iconKey: 'grocery', sortOrder: 4 },
    { nameAr: 'المخبز', nameFr: 'Boulangerie', iconKey: 'bakery', sortOrder: 5 },
    { nameAr: 'حلويات', nameFr: 'Pâtisserie', iconKey: 'sweets', sortOrder: 6 },
  ]);

  console.info(`✓ Categories seeded: ${categories.length}`);

  categories.forEach((category) => {
    console.info(`  - ${category.nameFr} (${category.nameAr})`);
  });

  await disconnectDb();
}

seed().catch(async (err) => {
  console.error('Seed failed:', err);
  await disconnectDb();
  process.exit(1);
});