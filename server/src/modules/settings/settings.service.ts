import { Setting } from './setting.model';
import { setLateThreshold } from '../orders/order.model';

export interface PlatformSettings {
  serviceFeeCentimes: number;
  vipSurchargeCentimes: number;
  assignTimeoutSec: number;
  lateThresholdMin: number;
  supportPhone: string;
  deliveryRadiusKm: number;
  pointsPerHundredDinars: number;
  pointValueCentimes: number;
  maxPointsPercentOfSubtotal: number;
  electronicPaymentEnabled: boolean;
  /** Ceiling on the delivery fee a shop may set for itself, in centimes. */
  maxVendorDeliveryFeeCentimes: number;
  /** Floor on the same, so a shop cannot undercut the agent's payout. */
  minVendorDeliveryFeeCentimes: number;
}

export const DEFAULT_SETTINGS: PlatformSettings = {
  serviceFeeCentimes: 5000, // 50 د.ج
  vipSurchargeCentimes: 10000, // 100 د.ج
  assignTimeoutSec: 60,
  lateThresholdMin: 45,
  supportPhone: '+213770000000',
  deliveryRadiusKm: 15,
  pointsPerHundredDinars: 1,
  pointValueCentimes: 100, // 1 point = 1 د.ج
  maxPointsPercentOfSubtotal: 50,
  electronicPaymentEnabled: false,
  maxVendorDeliveryFeeCentimes: 60000, // 600 د.ج
  minVendorDeliveryFeeCentimes: 5000, // 50 د.ج
};

const CACHE_TTL_MS = 30_000;
let cache: { value: PlatformSettings; at: number } | null = null;

export function invalidateSettingsCache(): void {
  cache = null;
}

export async function getSettings(force = false): Promise<PlatformSettings> {
  if (!force && cache && Date.now() - cache.at < CACHE_TTL_MS) return cache.value;

  const rows = await Setting.find().lean();
  const merged = { ...DEFAULT_SETTINGS };
  for (const row of rows) {
    if (row.key in merged) {
      (merged as Record<string, unknown>)[row.key] = row.value;
    }
  }
  setLateThreshold(merged.lateThresholdMin);
  cache = { value: merged, at: Date.now() };
  return merged;
}

export async function listSettings() {
  const current = await getSettings(true);
  return Object.entries(current).map(([key, value]) => ({ key, value }));
}

export async function updateSettings(patch: Partial<PlatformSettings>) {
  const keys = Object.keys(DEFAULT_SETTINGS) as (keyof PlatformSettings)[];
  const ops = Object.entries(patch)
    .filter(([key]) => keys.includes(key as keyof PlatformSettings))
    .map(([key, value]) => ({
      updateOne: {
        filter: { key },
        update: { $set: { key, value } },
        upsert: true,
      },
    }));
  if (ops.length) await Setting.bulkWrite(ops);
  invalidateSettingsCache();
  return getSettings(true);
}

/** Writes the default rows once, without clobbering existing values. */
export async function ensureDefaultSettings(): Promise<void> {
  const ops = Object.entries(DEFAULT_SETTINGS).map(([key, value]) => ({
    updateOne: {
      filter: { key },
      update: { $setOnInsert: { key, value } },
      upsert: true,
    },
  }));
  await Setting.bulkWrite(ops);
  invalidateSettingsCache();
}
