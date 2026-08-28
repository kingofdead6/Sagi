import type { FilterQuery, PipelineStage } from 'mongoose';
import { Vendor, MenuSection, type VendorDoc } from './vendor.model';
import { Product } from '../products/product.model';
import { Offer } from '../offers/offer.model';
import { ApiError } from '../../utils/ApiError';
import { buildPage, skipFor, type Page } from '../../utils/pagination';
import { distanceKm, etaMinutes, fromGeoPoint } from '../../utils/geo';

export type VendorSort = 'nearest' | 'fastest' | 'rating' | 'featured';

export interface VendorQuery {
  category?: string;
  search?: string;
  lat?: number;
  lng?: number;
  sort?: VendorSort;
  openNow?: boolean;
  hasOffer?: boolean;
  page?: number;
  limit?: number;
}

function decorate(vendor: VendorDoc, origin?: { lat: number; lng: number } | null) {
  const json = vendor.toJSON() as Record<string, unknown>;
  const vendorPoint = fromGeoPoint(vendor.location);
  if (origin && vendorPoint) {
    const km = distanceKm(origin, vendorPoint);
    json.distanceKm = Math.round(km * 10) / 10;
    json.etaMinutes = etaMinutes(km) + vendor.prepTimeMin;
  } else {
    json.distanceKm = null;
    json.etaMinutes = vendor.prepTimeMin;
  }
  return json;
}

/** True when the vendor is flagged open AND inside today's opening hours. */
export function isOpenNow(vendor: VendorDoc, now = new Date()): boolean {
  if (!vendor.isOpen) return false;
  if (!vendor.openingHours.length) return true;
  const today = vendor.openingHours.filter((h) => h.day === now.getDay());
  if (!today.length) return false;
  const minutes = now.getHours() * 60 + now.getMinutes();
  return today.some((h) => {
    const [fh = 0, fm = 0] = h.from.split(':').map(Number);
    const [th = 0, tm = 0] = h.to.split(':').map(Number);
    const start = fh * 60 + fm;
    const end = th * 60 + tm;
    return end > start ? minutes >= start && minutes <= end : minutes >= start || minutes <= end;
  });
}

export async function listVendors(query: VendorQuery): Promise<Page<unknown>> {
  const page = Math.max(1, query.page ?? 1);
  const limit = Math.min(50, Math.max(1, query.limit ?? 20));
  const origin =
    query.lat !== undefined && query.lng !== undefined ? { lat: query.lat, lng: query.lng } : null;

  const filter: FilterQuery<VendorDoc> = { isActive: true };
  if (query.category) filter.category = query.category;
  if (query.search) {
    const escaped = query.search.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    filter.name = new RegExp(escaped, 'i');
  }
  if (query.hasOffer) {
    const now = new Date();
    const vendorIds = await Offer.distinct('vendor', {
      isActive: true,
      vendor: { $ne: null },
      $and: [
        { $or: [{ startsAt: null }, { startsAt: { $lte: now } }] },
        { $or: [{ endsAt: null }, { endsAt: { $gte: now } }] },
      ],
    });
    filter._id = { $in: vendorIds };
  }

  // Nearest-first needs a geo stage, so it runs through the aggregation path.
  if (query.sort === 'nearest' && origin) {
    const pipeline: PipelineStage[] = [
      {
        $geoNear: {
          near: { type: 'Point', coordinates: [origin.lng, origin.lat] },
          distanceField: 'distanceMeters',
          spherical: true,
          query: filter as Record<string, unknown>,
        },
      },
      { $skip: skipFor(page, limit) },
      { $limit: limit },
    ];
    const [rows, total] = await Promise.all([
      Vendor.aggregate(pipeline),
      Vendor.countDocuments(filter),
    ]);
    const items = rows.map((row) => {
      const km = (row.distanceMeters as number) / 1000;
      return {
        ...row,
        id: String(row._id),
        _id: undefined,
        distanceKm: Math.round(km * 10) / 10,
        etaMinutes: etaMinutes(km) + (row.prepTimeMin ?? 0),
        isOpenNow: Boolean(row.isOpen),
      };
    });
    const filtered = query.openNow ? items.filter((i) => i.isOpenNow) : items;
    return buildPage(filtered, page, limit, total);
  }

  const sortSpec: Record<string, 1 | -1> =
    query.sort === 'rating'
      ? { rating: -1, ratingCount: -1 }
      : query.sort === 'fastest'
        ? { prepTimeMin: 1 }
        : { isFeatured: -1, sortOrder: 1, rating: -1 };

  const [docs, total] = await Promise.all([
    Vendor.find(filter).sort(sortSpec).skip(skipFor(page, limit)).limit(limit),
    Vendor.countDocuments(filter),
  ]);

  let items = docs.map((v) => ({ ...decorate(v, origin), isOpenNow: isOpenNow(v) }));
  if (query.openNow) items = items.filter((i) => i.isOpenNow);

  return buildPage(items, page, limit, total);
}

export async function getVendor(id: string, origin?: { lat: number; lng: number } | null) {
  const vendor = await Vendor.findOne({ _id: id, isActive: true }).populate('category');
  if (!vendor) throw ApiError.notFound('المتجر غير موجود');
  return { ...decorate(vendor, origin), isOpenNow: isOpenNow(vendor) };
}

/** Menu grouped by section, in the order the vendor arranged them. */
export async function getMenu(vendorId: string) {
  const vendor = await Vendor.findOne({ _id: vendorId, isActive: true }).lean();
  if (!vendor) throw ApiError.notFound('المتجر غير موجود');

  const [sections, products] = await Promise.all([
    MenuSection.find({ vendor: vendorId }).sort({ sortOrder: 1 }),
    Product.find({ vendor: vendorId }).sort({ sortOrder: 1, name: 1 }),
  ]);

  const grouped = sections.map((section) => ({
    section: section.toJSON(),
    products: products
      .filter((p) => String(p.section) === String(section._id))
      .map((p) => p.toJSON()),
  }));

  const orphans = products.filter((p) => !p.section).map((p) => p.toJSON());
  if (orphans.length) {
    grouped.push({
      section: { id: 'other', name: 'أخرى', sortOrder: 999, vendor: vendorId } as never,
      products: orphans,
    });
  }

  return grouped;
}
