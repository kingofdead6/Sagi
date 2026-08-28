/**
 * Money is always an integer number of centimes (1 دج = 100 centimes).
 * Never use floating point for amounts anywhere in this codebase.
 */

export const CENTIMES_PER_DINAR = 100;

export function toCentimes(dinars: number): number {
  return Math.round(dinars * CENTIMES_PER_DINAR);
}

export function toDinars(centimes: number): number {
  return centimes / CENTIMES_PER_DINAR;
}

/** Formats centimes for display, e.g. 135000 -> "1350.0 د.ج" */
export function formatCentimes(centimes: number): string {
  const dinars = toDinars(centimes);
  const rounded = Math.round(dinars * 10) / 10;
  return `${rounded.toFixed(1)} د.ج`;
}

/** Applies a percentage (0-100) to an amount, rounding half-up to whole centimes. */
export function percentageOf(centimes: number, percent: number): number {
  return Math.round((centimes * percent) / 100);
}

export function clampCentimes(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, Math.round(value)));
}

export function assertCentimes(value: number, field = 'amount'): number {
  if (!Number.isInteger(value) || value < 0) {
    throw new Error(`${field} must be a non-negative integer number of centimes`);
  }
  return value;
}
