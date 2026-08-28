export interface GeoPoint {
  type: 'Point';
  coordinates: [number, number]; // [lng, lat]
}

export function point(lng: number, lat: number): GeoPoint {
  return { type: 'Point', coordinates: [lng, lat] };
}

const EARTH_RADIUS_KM = 6371;

function toRad(deg: number): number {
  return (deg * Math.PI) / 180;
}

/** Great-circle distance in kilometres. */
export function distanceKm(
  a: { lat: number; lng: number },
  b: { lat: number; lng: number },
): number {
  const dLat = toRad(b.lat - a.lat);
  const dLng = toRad(b.lng - a.lng);
  const lat1 = toRad(a.lat);
  const lat2 = toRad(b.lat);
  const h =
    Math.sin(dLat / 2) ** 2 + Math.sin(dLng / 2) ** 2 * Math.cos(lat1) * Math.cos(lat2);
  return 2 * EARTH_RADIUS_KM * Math.asin(Math.sqrt(h));
}

export function fromGeoPoint(p?: GeoPoint | null): { lat: number; lng: number } | null {
  if (!p || !Array.isArray(p.coordinates) || p.coordinates.length !== 2) return null;
  return { lng: p.coordinates[0], lat: p.coordinates[1] };
}

/** Rough ETA in minutes for a city delivery at ~22 km/h average. */
export function etaMinutes(km: number): number {
  return Math.max(5, Math.round((km / 22) * 60));
}
