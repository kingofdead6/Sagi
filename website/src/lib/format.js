/** Money arrives in centimes; the UI speaks whole dinars. */
export function dinars(centimes) {
  return Math.round((centimes ?? 0) / 100);
}

/** Thousands grouped the same way in every language and every component. */
export function groupNumber(n) {
  return Math.round(n).toLocaleString('fr-DZ', { numberingSystem: 'latn' });
}

export function money(centimes, lang = 'ar') {
  const value = groupNumber(dinars(centimes));
  return lang === 'ar' ? `${value} دج` : `${value} DA`;
}

/** Mirrors server/src/utils/phone.ts so a bad number is caught before the request. */
const LOCAL_RE = /^0[5-7]\d{8}$/;
const E164_RE = /^\+213[5-7]\d{8}$/;
const strip = (s) => (s ?? '').replace(/[\s\-().]/g, '');

export function isValidPhone(input) {
  const c = strip(input);
  return LOCAL_RE.test(c) || E164_RE.test(c) || /^213[5-7]\d{8}$/.test(c);
}

export function localPhone(e164) {
  return E164_RE.test(e164 ?? '') ? `0${e164.slice(4)}` : e164 ?? '';
}

/**
 * Cloudinary delivery URL cropped to an exact box — the same `c_fill,g_auto`
 * transform the app uses, so every product photo arrives at one shape and the
 * crop window follows the subject instead of cutting it in half.
 */
export function imageUrl(image, width = 600, ratio) {
  if (!image?.url) return null;
  if (!image.url.includes('/upload/')) return image.url;
  const t = ratio
    ? `c_fill,g_auto,f_auto,q_auto,w_${width},h_${Math.round(width / ratio)}`
    : `f_auto,q_auto,w_${width}`;
  return image.url.replace('/upload/', `/upload/${t}/`);
}

export function blurUrl(image) {
  if (!image?.url?.includes('/upload/')) return null;
  return image.url.replace('/upload/', '/upload/e_blur:1000,f_auto,q_auto,w_24/');
}

/** GeoJSON stores [lng, lat]; Leaflet wants [lat, lng]. */
export function toLatLng(point) {
  if (!point) return null;
  if (Array.isArray(point.coordinates)) return [point.coordinates[1], point.coordinates[0]];
  if (typeof point.lat === 'number') return [point.lat, point.lng];
  return null;
}

export function distanceKm(a, b) {
  const R = 6371;
  const dLat = ((b[0] - a[0]) * Math.PI) / 180;
  const dLng = ((b[1] - a[1]) * Math.PI) / 180;
  const h =
    Math.sin(dLat / 2) ** 2 +
    Math.cos((a[0] * Math.PI) / 180) * Math.cos((b[0] * Math.PI) / 180) * Math.sin(dLng / 2) ** 2;
  return 2 * R * Math.asin(Math.sqrt(h));
}

export function dateTime(value, lang = 'ar') {
  if (!value) return '';
  return new Date(value).toLocaleString(lang === 'ar' ? 'ar-DZ' : lang === 'fr' ? 'fr-DZ' : 'en-GB', {
    numberingSystem: 'latn',
    dateStyle: 'medium',
    timeStyle: 'short',
  });
}

export function timeOnly(value, lang = 'ar') {
  if (!value) return '';
  return new Date(value).toLocaleTimeString(lang === 'ar' ? 'ar-DZ' : 'fr-DZ', {
    numberingSystem: 'latn',
    hour: '2-digit',
    minute: '2-digit',
  });
}

/** Opening state the way the server computes it, for the vendor page. */
export function openNow(vendor) {
  if (typeof vendor?.isOpenNow === 'boolean') return vendor.isOpenNow;
  return Boolean(vendor?.isOpen);
}

export function mapsLink(lat, lng) {
  return `https://www.google.com/maps/dir/?api=1&destination=${lat},${lng}`;
}
