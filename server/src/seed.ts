/* eslint-disable no-console */
import mongoose from 'mongoose';
import { connectDb, disconnectDb } from './config/db';
import { hashPassword } from './modules/auth/auth.service';
import { User } from './modules/users/user.model';
import { Address } from './modules/addresses/address.model';
import { Category } from './modules/categories/category.model';
import { MenuSection, Vendor } from './modules/vendors/vendor.model';
import { Product } from './modules/products/product.model';
import { Offer } from './modules/offers/offer.model';
import { Voucher, VoucherRedemption } from './modules/vouchers/voucher.model';
import { Order } from './modules/orders/order.model';
import { Assignment } from './modules/assignments/assignment.model';
import { AgentLocation, AgentStatus } from './modules/agents/agent.model';
import { Rating } from './modules/ratings/rating.model';
import { RefreshToken } from './modules/auth/refreshToken.model';
import { ensureDefaultSettings, getSettings } from './modules/settings/settings.service';
import { point } from './utils/geo';
import { generateOrderCode } from './utils/orderCode';
import { formatCentimes } from './utils/money';
import type { OrderStatus } from './modules/orders/order.state';

// Bir El Ater, Tébessa — the launch area (§12).
const CITY = { lat: 34.7442, lng: 8.0603 };

function near(dLat: number, dLng: number) {
  return point(CITY.lng + dLng, CITY.lat + dLat);
}

const PASSWORD = 'saji1234';

async function wipe() {
  await Promise.all(
    [
      User,
      Address,
      Category,
      Vendor,
      MenuSection,
      Product,
      Offer,
      Voucher,
      VoucherRedemption,
      Order,
      Assignment,
      AgentStatus,
      AgentLocation,
      Rating,
      RefreshToken,
    ].map((m) => (m as mongoose.Model<any>).deleteMany({})),
  );
}

async function seed() {
  await connectDb();
  console.info('→ Clearing existing data (seed is idempotent — it always starts fresh)');
  await wipe();
  await ensureDefaultSettings();
  const settings = await getSettings(true);

  const passwordHash = await hashPassword(PASSWORD);

  // ── categories ──────────────────────────────────────────────────────────
  const categories = await Category.create([
    { nameAr: 'وجبات سريعة', nameFr: 'Fast-food', iconKey: 'fastfood', sortOrder: 1 },
    { nameAr: 'فواكه', nameFr: 'Fruits', iconKey: 'fruits', sortOrder: 2 },
    { nameAr: 'لحوم', nameFr: 'Viandes', iconKey: 'meat', sortOrder: 3 },
    { nameAr: 'بقالة', nameFr: 'Épicerie', iconKey: 'grocery', sortOrder: 4 },
    { nameAr: 'المخبز', nameFr: 'Boulangerie', iconKey: 'bakery', sortOrder: 5 },
    { nameAr: 'حلويات', nameFr: 'Pâtisserie', iconKey: 'sweets', sortOrder: 6 },
  ]);
  const catBy = (fr: string) => categories.find((c) => c.nameFr === fr)!;

  // ── users ───────────────────────────────────────────────────────────────
  const admin = await User.create({
    phone: '+213555000001',
    passwordHash,
    fullName: 'مدير ساجي',
    role: 'admin',
  });

  const agents = await User.create([
    { phone: '+213661000001', passwordHash, fullName: 'ياسين بلعيد', role: 'agent' },
    { phone: '+213661000002', passwordHash, fullName: 'كريم زروقي', role: 'agent' },
  ]);

  const customers = await User.create([
    { phone: '+213770000001', passwordHash, fullName: 'أمين حملاوي', role: 'customer', points: 120 },
    { phone: '+213770000002', passwordHash, fullName: 'سارة بن عمر', role: 'customer', points: 40 },
    { phone: '+213770000003', passwordHash, fullName: 'رياض شويحة', role: 'customer', points: 0 },
  ]);

  await AgentStatus.create(
    agents.map((a, i) => ({
      agent: a._id,
      isOnline: i === 0,
      lastLocation: near(0.004 * (i + 1), 0.003 * (i + 1)),
      lastSeenAt: new Date(),
    })),
  );

  const addresses = await Address.create(
    customers.map((c, i) => ({
      user: c._id,
      label: i === 0 ? 'المنزل' : 'العمل',
      wilaya: 'تبسة',
      commune: 'بئر العاتر',
      street: `حي النصر، رقم ${12 + i * 7}`,
      notes: i === 0 ? 'الطابق الثاني، الباب على اليمين' : undefined,
      location: near(0.002 * (i + 1), -0.002 * (i + 1)),
      isDefault: true,
    })),
  );
  await Promise.all(
    customers.map((c, i) => User.updateOne({ _id: c._id }, { $set: { defaultAddress: addresses[i]!._id } })),
  );

  // ── vendors ─────────────────────────────────────────────────────────────
  const vendorSeeds = [
    {
      name: 'مطعم الأصالة',
      slug: 'el-assala',
      description: 'وجبات سريعة وبرغر طازج على الفحم',
      category: catBy('Fast-food')._id,
      phone: '+213770100001',
      addressText: 'شارع أول نوفمبر، بئر العاتر',
      location: near(0.005, 0.004),
      rating: 4.6,
      ratingCount: 214,
      prepTimeMin: 15,
      prepTimeMax: 25,
      deliveryFeeCentimes: 15000,
      minOrderCentimes: 50000,
      isFeatured: true,
    },
    {
      name: 'بيتزيريا نابولي',
      slug: 'napoli',
      description: 'بيتزا إيطالية بعجين يومي',
      category: catBy('Fast-food')._id,
      phone: '+213770100002',
      addressText: 'حي 5 جويلية، بئر العاتر',
      location: near(-0.006, 0.005),
      rating: 4.4,
      ratingCount: 168,
      prepTimeMin: 20,
      prepTimeMax: 35,
      deliveryFeeCentimes: 18000,
      minOrderCentimes: 60000,
      isFeatured: true,
    },
    {
      name: 'مخبزة الرحمة',
      slug: 'errahma-bakery',
      description: 'خبز تقليدي وحلويات شرقية',
      category: catBy('Boulangerie')._id,
      phone: '+213770100003',
      addressText: 'سوق المدينة، بئر العاتر',
      location: near(0.002, -0.005),
      rating: 4.8,
      ratingCount: 96,
      prepTimeMin: 10,
      prepTimeMax: 15,
      deliveryFeeCentimes: 12000,
      minOrderCentimes: 20000,
    },
    {
      name: 'ملحمة الشروق',
      slug: 'echourouk-meat',
      description: 'لحوم حمراء وبيضاء طازجة يومياً',
      category: catBy('Viandes')._id,
      phone: '+213770100004',
      addressText: 'حي بوحجار، بئر العاتر',
      location: near(-0.003, -0.004),
      rating: 4.5,
      ratingCount: 74,
      prepTimeMin: 15,
      prepTimeMax: 30,
      deliveryFeeCentimes: 20000,
      minOrderCentimes: 100000,
    },
    {
      name: 'بقالة النخيل',
      slug: 'ennakhil-market',
      description: 'كل ما يحتاجه البيت من مواد غذائية',
      category: catBy('Épicerie')._id,
      phone: '+213770100005',
      addressText: 'الطريق الوطني رقم 16، بئر العاتر',
      location: near(0.008, -0.002),
      rating: 4.2,
      ratingCount: 51,
      prepTimeMin: 20,
      prepTimeMax: 40,
      deliveryFeeCentimes: 15000,
      minOrderCentimes: 30000,
    },
  ];

  const openingHours = Array.from({ length: 7 }, (_, day) => ({ day, from: '08:00', to: '23:30' }));
  const vendors = await Vendor.create(vendorSeeds.map((v) => ({ ...v, openingHours })));
  const vendorBy = (slug: string) => vendors.find((v) => v.slug === slug)!;

  // ── menu sections + products ────────────────────────────────────────────
  interface Seed {
    name: string;
    price: number; // dinars
    description?: string;
    options?: { name: string; type: 'single' | 'multi'; isRequired: boolean; values: [string, number][] }[];
  }

  const menus: Record<string, Record<string, Seed[]>> = {
    'el-assala': {
      'البرجر': [
        {
          name: 'برجر كلاسيك',
          price: 450,
          description: 'قطعة لحم بقري، خس، طماطم وصلصة البيت',
          options: [
            { name: 'الحجم', type: 'single', isRequired: true, values: [['عادي', 0], ['مضاعف', 150]] },
            { name: 'إضافات', type: 'multi', isRequired: false, values: [['جبن', 50], ['بيض', 40], ['بصل مقلي', 30]] },
          ],
        },
        { name: 'برجر دجاج', price: 400, description: 'صدر دجاج مشوي مع صلصة الثوم' },
        { name: 'برجر مزدوج', price: 650, description: 'قطعتان من اللحم البقري' },
        { name: 'تشيز برجر', price: 500 },
      ],
      'الساندويتش': [
        {
          name: 'ساندويتش شاورما',
          price: 350,
          options: [
            { name: 'الخبز', type: 'single', isRequired: true, values: [['بغريّر', 0], ['خبز فرنسي', 20]] },
            { name: 'حار', type: 'single', isRequired: false, values: [['بدون', 0], ['حار', 0]] },
          ],
        },
        { name: 'ساندويتش كفتة', price: 380 },
        { name: 'ساندويتش تونة', price: 300 },
      ],
      'المرافقات': [
        {
          name: 'بطاطا مقلية',
          price: 150,
          options: [{ name: 'الحجم', type: 'single', isRequired: true, values: [['صغير', 0], ['كبير', 80]] }],
        },
        { name: 'حلقات البصل', price: 180 },
        { name: 'مشروب غازي', price: 100 },
        { name: 'ماء معدني', price: 50 },
      ],
    },
    napoli: {
      'بيتزا': [
        {
          name: 'بيتزا مارغريتا',
          price: 700,
          description: 'صلصة طماطم، موزاريلا وريحان',
          options: [
            { name: 'الحجم', type: 'single', isRequired: true, values: [['صغيرة', 0], ['متوسطة', 250], ['كبيرة', 500]] },
            { name: 'إضافات', type: 'multi', isRequired: false, values: [['زيتون', 60], ['فطر', 80], ['جبن إضافي', 120]] },
          ],
        },
        { name: 'بيتزا مختلطة', price: 900, description: 'دجاج، زيتون، فلفل وفطر' },
        { name: 'بيتزا تونة', price: 850 },
        { name: 'بيتزا أربعة أجبان', price: 1000 },
        { name: 'كالزوني', price: 800 },
      ],
      'المعكرونة': [
        { name: 'باستا بولونيز', price: 750 },
        { name: 'باستا ألفريدو', price: 800 },
        { name: 'لازانيا', price: 950 },
      ],
      'المشروبات': [
        { name: 'عصير برتقال طازج', price: 200 },
        { name: 'مشروب غازي', price: 100 },
      ],
    },
    'errahma-bakery': {
      'الخبز': [
        { name: 'خبز الدار', price: 40 },
        { name: 'باغيت', price: 25 },
        { name: 'مطلوع', price: 60 },
        { name: 'خبز الشعير', price: 50 },
      ],
      'الحلويات': [
        { name: 'قلب اللوز', price: 80, description: 'حلوى تقليدية باللوز والسميد' },
        { name: 'بقلاوة', price: 120 },
        { name: 'مقروط', price: 70 },
        { name: 'كعك بالعسل', price: 100 },
      ],
      'المعجنات': [
        { name: 'كرواسون', price: 90 },
        { name: 'بان أو شوكولا', price: 110 },
        { name: 'فطيرة بالجبن', price: 130 },
      ],
    },
    'echourouk-meat': {
      'لحوم حمراء': [
        {
          name: 'لحم غنم',
          price: 2200,
          description: 'السعر للكيلوغرام',
          options: [{ name: 'التقطيع', type: 'single', isRequired: true, values: [['كامل', 0], ['مقطع', 0], ['مفروم', 100]] }],
        },
        { name: 'لحم بقري', price: 1800, description: 'السعر للكيلوغرام' },
        { name: 'كفتة محضّرة', price: 1600 },
        { name: 'مرقاز', price: 1400 },
      ],
      'دواجن': [
        { name: 'دجاج كامل', price: 750 },
        { name: 'صدر دجاج', price: 1100 },
        { name: 'أفخاذ دجاج', price: 850 },
      ],
    },
    'ennakhil-market': {
      'مواد أساسية': [
        { name: 'زيت المائدة 5 لتر', price: 950 },
        { name: 'سميد 10 كغ', price: 800 },
        { name: 'سكر 1 كغ', price: 130 },
        { name: 'أرز 1 كغ', price: 180 },
        { name: 'معجون طماطم', price: 120 },
      ],
      'ألبان': [
        { name: 'حليب 1 لتر', price: 90 },
        { name: 'لبن رايب', price: 60 },
        { name: 'زبدة 250 غ', price: 320 },
        { name: 'جبن مثلثات', price: 210 },
      ],
      'فواكه وخضر': [
        { name: 'تمر دقلة نور 1 كغ', price: 900 },
        { name: 'برتقال 1 كغ', price: 220 },
        { name: 'موز 1 كغ', price: 380 },
        { name: 'طماطم 1 كغ', price: 150 },
        { name: 'بطاطا 1 كغ', price: 110 },
      ],
    },
  };

  let productCount = 0;
  const productsByVendor = new Map<string, mongoose.Types.ObjectId[]>();

  for (const [slug, sections] of Object.entries(menus)) {
    const vendor = vendorBy(slug);
    const ids: mongoose.Types.ObjectId[] = [];
    let sectionOrder = 0;

    for (const [sectionName, items] of Object.entries(sections)) {
      const section = await MenuSection.create({
        vendor: vendor._id,
        name: sectionName,
        sortOrder: sectionOrder++,
      });

      let order = 0;
      for (const item of items) {
        const doc = await Product.create({
          vendor: vendor._id,
          section: section._id,
          name: item.name,
          description: item.description,
          priceCentimes: item.price * 100,
          sortOrder: order++,
          options: (item.options ?? []).map((o) => ({
            name: o.name,
            type: o.type,
            isRequired: o.isRequired,
            values: o.values.map(([name, delta]) => ({ name, priceDeltaCentimes: delta * 100 })),
          })),
        });
        ids.push(doc._id as mongoose.Types.ObjectId);
        productCount += 1;
      }
    }
    productsByVendor.set(slug, ids);
  }

  // ── offers & vouchers ───────────────────────────────────────────────────
  const now = Date.now();
  await Offer.create([
    {
      vendor: vendorBy('el-assala')._id,
      title: 'خصم 20% على كل البرجر',
      subtitle: 'العرض ساري طيلة الأسبوع',
      type: 'percentage',
      value: 20,
      productIds: productsByVendor.get('el-assala')!.slice(0, 4),
      startsAt: new Date(now - 86400000),
      endsAt: new Date(now + 14 * 86400000),
      isActive: true,
      showOnHome: true,
      sortOrder: 1,
    },
    {
      vendor: null,
      title: 'توصيل مجاني على أول طلب',
      subtitle: 'لكل زبون جديد في بئر العاتر',
      type: 'freeDelivery',
      value: 0,
      isActive: true,
      showOnHome: true,
      sortOrder: 2,
    },
    {
      vendor: vendorBy('napoli')._id,
      title: 'بيتزا كبيرة بسعر المتوسطة',
      subtitle: 'كل يوم ثلاثاء',
      type: 'fixed',
      value: 25000,
      isActive: true,
      showOnHome: true,
      sortOrder: 3,
    },
  ]);

  await Voucher.create([
    {
      code: 'SAJI10',
      type: 'percentage',
      value: 10,
      minOrderCentimes: 50000,
      maxUses: 500,
      perUserLimit: 3,
      isActive: true,
    },
    {
      code: 'LIVRAISON',
      type: 'freeDelivery',
      value: 0,
      minOrderCentimes: 80000,
      maxUses: 0,
      perUserLimit: 1,
      isActive: true,
    },
  ]);

  // ── a few orders across the lifecycle ───────────────────────────────────
  const assala = vendorBy('el-assala');
  const burger = await Product.findOne({ vendor: assala._id, name: 'برجر كلاسيك' });
  const fries = await Product.findOne({ vendor: assala._id, name: 'بطاطا مقلية' });

  async function makeOrder(
    customerIndex: number,
    status: OrderStatus,
    agentIndex: number | null,
    minutesAgo: number,
  ) {
    const customer = customers[customerIndex]!;
    const address = addresses[customerIndex]!;
    const createdAt = new Date(now - minutesAgo * 60_000);

    const items = [
      {
        product: burger!._id,
        nameSnapshot: burger!.name,
        unitPriceCentimes: burger!.priceCentimes,
        qty: 2,
        selectedOptions: [],
        lineTotalCentimes: burger!.priceCentimes * 2,
      },
      {
        product: fries!._id,
        nameSnapshot: fries!.name,
        unitPriceCentimes: fries!.priceCentimes,
        qty: 1,
        selectedOptions: [],
        lineTotalCentimes: fries!.priceCentimes,
      },
    ];
    const subtotal = items.reduce((s, i) => s + i.lineTotalCentimes, 0);
    const total = subtotal + settings.serviceFeeCentimes + assala.deliveryFeeCentimes;

    const flow: OrderStatus[] = [
      'pending',
      'confirmed',
      'sent_to_vendor',
      'preparing',
      'ready',
      'assigned',
      'accepted',
      'picked_up',
      'on_the_way',
      'delivered',
    ];
    const upTo = status === 'cancelled' ? 1 : flow.indexOf(status) + 1;
    const events = flow.slice(0, Math.max(1, upTo)).map((s, i) => ({
      from: i === 0 ? null : flow[i - 1]!,
      to: s,
      actorRole: (i === 0 ? 'customer' : i <= 5 ? 'admin' : 'agent') as 'customer' | 'admin' | 'agent',
      at: new Date(createdAt.getTime() + i * 4 * 60_000),
    }));
    if (status === 'cancelled') {
      events.push({ from: 'pending', to: 'cancelled', actorRole: 'admin', at: new Date(createdAt.getTime() + 300_000) });
    }

    const confirmedAt = flow.indexOf(status) >= 1 ? new Date(createdAt.getTime() + 4 * 60_000) : null;

    return Order.create({
      code: generateOrderCode(),
      customer: customer._id,
      vendor: assala._id,
      status,
      deliveryType: customerIndex === 1 ? 'vip' : 'normal',
      paymentMethod: 'cash',
      address: {
        label: address.label,
        wilaya: address.wilaya,
        commune: address.commune,
        street: address.street,
        notes: address.notes,
      },
      deliveryLocation: address.location,
      customerNote: customerIndex === 0 ? 'اتصل بي عند الوصول من فضلك' : undefined,
      items,
      subtotalCentimes: subtotal,
      serviceFeeCentimes: settings.serviceFeeCentimes,
      deliveryFeeCentimes: assala.deliveryFeeCentimes,
      discountCentimes: 0,
      pointsUsed: 0,
      pointsEarned: Math.floor(subtotal / 10_000),
      totalCentimes: total,
      agent: agentIndex !== null ? agents[agentIndex]!._id : null,
      confirmedBy: confirmedAt ? admin._id : null,
      confirmedAt,
      assignedAt: agentIndex !== null ? new Date(createdAt.getTime() + 20 * 60_000) : null,
      acceptedAt: ['accepted', 'picked_up', 'on_the_way', 'delivered'].includes(status)
        ? new Date(createdAt.getTime() + 22 * 60_000)
        : null,
      pickedUpAt: ['picked_up', 'on_the_way', 'delivered'].includes(status)
        ? new Date(createdAt.getTime() + 28 * 60_000)
        : null,
      deliveredAt: status === 'delivered' ? new Date(createdAt.getTime() + 40 * 60_000) : null,
      cancelledReason: status === 'cancelled' ? 'الزبون لم يرد على الهاتف' : null,
      events,
      createdAt,
    });
  }

  await makeOrder(0, 'pending', null, 3);
  await makeOrder(1, 'pending', null, 8);
  await makeOrder(2, 'preparing', null, 25);
  await makeOrder(0, 'ready', null, 35);
  await makeOrder(1, 'on_the_way', 0, 50);
  await makeOrder(2, 'delivered', 1, 180);
  await makeOrder(0, 'delivered', 0, 1500);
  await makeOrder(1, 'cancelled', null, 2000);

  const orderCount = await Order.countDocuments();

  console.info('\n─────────────────────────────────────────────');
  console.info('  ساجي — seed complete');
  console.info('─────────────────────────────────────────────');
  console.info(`  categories : ${categories.length}`);
  console.info(`  vendors    : ${vendors.length}`);
  console.info(`  products   : ${productCount}`);
  console.info(`  orders     : ${orderCount}`);
  console.info(`  service fee: ${formatCentimes(settings.serviceFeeCentimes)}`);
  console.info('\n  Test credentials (password for everyone: ' + PASSWORD + ')');
  console.info('  ┌───────────┬────────────────┬──────────────────────┐');
  console.info('  │ role      │ phone          │ name                 │');
  console.info('  ├───────────┼────────────────┼──────────────────────┤');
  console.info(`  │ admin     │ 0555000001     │ ${admin.fullName}          │`);
  for (const a of agents) console.info(`  │ agent     │ 0${a.phone.slice(4)}     │ ${a.fullName}         │`);
  for (const c of customers) console.info(`  │ customer  │ 0${c.phone.slice(4)}     │ ${c.fullName}        │`);
  console.info('  └───────────┴────────────────┴──────────────────────┘\n');

  await disconnectDb();
}

seed().catch(async (err) => {
  console.error('Seed failed:', err);
  await disconnectDb();
  process.exit(1);
});
