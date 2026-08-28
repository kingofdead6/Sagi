import request from 'supertest';
import type { Express } from 'express';
import { createApp } from '../src/app';
import { hashPassword } from '../src/modules/auth/auth.service';
import { User } from '../src/modules/users/user.model';
import { Address } from '../src/modules/addresses/address.model';
import { Category } from '../src/modules/categories/category.model';
import { MenuSection, Vendor } from '../src/modules/vendors/vendor.model';
import { Product } from '../src/modules/products/product.model';
import { AgentStatus } from '../src/modules/agents/agent.model';
import { ensureDefaultSettings, invalidateSettingsCache } from '../src/modules/settings/settings.service';
import { signAccessToken } from '../src/modules/auth/token.service';
import { point } from '../src/utils/geo';

export const app: Express = createApp();
export const api = (path: string) => `/api/v1${path}`;

export const PASSWORD = 'saji1234';

export async function makeUser(role: 'customer' | 'agent' | 'admin', phone: string, fullName = 'مستخدم') {
  const user = await User.create({
    phone,
    passwordHash: await hashPassword(PASSWORD),
    fullName,
    role,
  });
  if (role === 'agent') await AgentStatus.create({ agent: user._id, isOnline: true });
  return user;
}

export function tokenFor(user: { _id: unknown; role: string; phone: string }) {
  return signAccessToken({ sub: String(user._id), role: user.role as never, phone: user.phone });
}

export function authed(method: 'get' | 'post' | 'patch' | 'delete', path: string, token: string) {
  return request(app)[method](api(path)).set('Authorization', `Bearer ${token}`);
}

export interface Fixture {
  admin: Awaited<ReturnType<typeof makeUser>>;
  agent: Awaited<ReturnType<typeof makeUser>>;
  customer: Awaited<ReturnType<typeof makeUser>>;
  vendor: any;
  burger: any;
  fries: any;
  address: any;
  tokens: { admin: string; agent: string; customer: string };
}

/** A complete, order-ready world: settings, vendor, menu, users, address. */
export async function seedFixture(): Promise<Fixture> {
  invalidateSettingsCache();
  await ensureDefaultSettings();

  const admin = await makeUser('admin', '+213555000001', 'مدير');
  const agent = await makeUser('agent', '+213661000001', 'سائق');
  const customer = await makeUser('customer', '+213770000001', 'زبون');

  const category = await Category.create({
    nameAr: 'وجبات سريعة',
    nameFr: 'Fast-food',
    iconKey: 'fastfood',
  });

  const vendor = await Vendor.create({
    name: 'مطعم الاختبار',
    slug: 'test-vendor',
    category: category._id,
    phone: '+213770100001',
    addressText: 'بئر العاتر',
    location: point(8.06, 34.744),
    deliveryFeeCentimes: 15000,
    minOrderCentimes: 0,
    prepTimeMin: 15,
    prepTimeMax: 25,
  });

  const section = await MenuSection.create({ vendor: vendor._id, name: 'البرجر', sortOrder: 0 });

  const burger = await Product.create({
    vendor: vendor._id,
    section: section._id,
    name: 'برجر كلاسيك',
    priceCentimes: 45000, // 450 دج
    options: [
      {
        name: 'الحجم',
        type: 'single',
        isRequired: true,
        values: [
          { name: 'عادي', priceDeltaCentimes: 0 },
          { name: 'مضاعف', priceDeltaCentimes: 15000 },
        ],
      },
      {
        name: 'إضافات',
        type: 'multi',
        isRequired: false,
        values: [
          { name: 'جبن', priceDeltaCentimes: 5000 },
          { name: 'بيض', priceDeltaCentimes: 4000 },
        ],
      },
    ],
  });

  const fries = await Product.create({
    vendor: vendor._id,
    section: section._id,
    name: 'بطاطا مقلية',
    priceCentimes: 15000,
  });

  const address = await Address.create({
    user: customer._id,
    label: 'المنزل',
    wilaya: 'تبسة',
    commune: 'بئر العاتر',
    street: 'حي النصر 12',
    location: point(8.062, 34.746),
    isDefault: true,
  });

  return {
    admin,
    agent,
    customer,
    vendor,
    burger,
    fries,
    address,
    tokens: { admin: tokenFor(admin), agent: tokenFor(agent), customer: tokenFor(customer) },
  };
}

/** The default single-burger basket: 450 + 150 (مضاعف) = 600 دج. */
export function basket(fixture: Fixture, qty = 1) {
  return {
    vendorId: String(fixture.vendor._id),
    items: [
      {
        productId: String(fixture.burger._id),
        qty,
        optionValueIds: [String(fixture.burger.options[0].values[1]._id)],
      },
    ],
    deliveryType: 'normal' as const,
    paymentMethod: 'cash' as const,
  };
}
