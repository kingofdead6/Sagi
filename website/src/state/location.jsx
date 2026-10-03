import { createContext, useCallback, useContext, useMemo, useState } from 'react';

/** Bir El Ater, where Saji delivers — the map's starting point, as in the app. */
export const DEFAULT_CENTER = [34.7442, 8.0603];

const LocationContext = createContext(null);
const KEY = 'saji.lastLocation';

function saved() {
  try {
    const v = JSON.parse(sessionStorage.getItem(KEY) || 'null');
    return v && typeof v.lat === 'number' ? v : null;
  } catch {
    return null;
  }
}

/**
 * The shopper's position, asked for only when a feature needs it (nearest-first
 * sorting, "use my location" on an address). Never requested on page load.
 */
export function LocationProvider({ children }) {
  const [position, setPosition] = useState(saved);
  const [status, setStatus] = useState(position ? 'ready' : 'idle');

  const request = useCallback(
    () =>
      new Promise((resolve) => {
        if (!('geolocation' in navigator)) {
          setStatus('denied');
          resolve(null);
          return;
        }
        setStatus('locating');
        navigator.geolocation.getCurrentPosition(
          (pos) => {
            const next = { lat: pos.coords.latitude, lng: pos.coords.longitude };
            setPosition(next);
            setStatus('ready');
            try {
              sessionStorage.setItem(KEY, JSON.stringify(next));
            } catch {
              /* fine */
            }
            resolve(next);
          },
          () => {
            setStatus('denied');
            resolve(null);
          },
          { enableHighAccuracy: true, timeout: 12_000, maximumAge: 60_000 },
        );
      }),
    [],
  );

  const value = useMemo(() => ({ position, status, request }), [position, status, request]);
  return <LocationContext.Provider value={value}>{children}</LocationContext.Provider>;
}

export function useLocation2() {
  return useContext(LocationContext);
}
