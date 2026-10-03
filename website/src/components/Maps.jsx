import { useEffect, useMemo, useRef, useState } from 'react';
import { MapContainer, Marker, Polyline, TileLayer, useMap, useMapEvents } from 'react-leaflet';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import { motion } from 'framer-motion';
import { Icon } from './Icon';
import { Button } from './ui';
import { DEFAULT_CENTER, useLocation2 } from '../state/location';
import { useI18n } from '../state/i18n';

const TILES = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const ATTRIBUTION = '&copy; OpenStreetMap';

/** Branded HTML markers; the classes are plain Tailwind, scanned at build time. */
function pinIcon(kind) {
  const skins = {
    store: { bg: 'bg-tangerine', glyph: '🏪' },
    home: { bg: 'bg-forest', glyph: '🏠' },
    driver: { bg: 'bg-leaf', glyph: '🛵' },
  };
  const s = skins[kind];
  return L.divIcon({
    className: '',
    iconSize: [44, 44],
    iconAnchor: [22, 22],
    html: `<div class="relative grid h-11 w-11 place-items-center">
      ${kind === 'driver' ? '<span class="absolute inset-0 animate-ping2 rounded-full bg-leaf/40"></span>' : ''}
      <span class="relative grid h-11 w-11 place-items-center rounded-full ${s.bg} text-xl shadow-lg ring-4 ring-white">${s.glyph}</span>
    </div>`,
  });
}

function FitBounds({ points }) {
  const map = useMap();
  const key = points.map((p) => p.join(',')).join('|');
  useEffect(() => {
    const valid = points.filter(Boolean);
    if (valid.length === 1) map.setView(valid[0], 15, { animate: true });
    else if (valid.length > 1) map.fitBounds(valid, { padding: [48, 48], maxZoom: 16, animate: true });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [key, map]);
  return null;
}

/**
 * The driver marker eases between fixes. GPS arrives every few seconds; a raw
 * marker would teleport, so each new point is tweened over ~1.2s.
 */
function GlidingMarker({ position, icon }) {
  const [shown, setShown] = useState(position);
  const from = useRef(position);
  useEffect(() => {
    if (!position) return undefined;
    const start = from.current ?? position;
    const t0 = performance.now();
    let raf;
    const step = (now) => {
      const k = Math.min(1, (now - t0) / 1200);
      const e = 1 - (1 - k) ** 3;
      const next = [start[0] + (position[0] - start[0]) * e, start[1] + (position[1] - start[1]) * e];
      setShown(next);
      from.current = next;
      if (k < 1) raf = requestAnimationFrame(step);
    };
    raf = requestAnimationFrame(step);
    return () => cancelAnimationFrame(raf);
  }, [position?.[0], position?.[1]]); // eslint-disable-line react-hooks/exhaustive-deps
  return shown ? <Marker position={shown} icon={icon} /> : null;
}

/** Store → driver → customer, live. Points are [lat, lng]. */
export function LiveMap({ store, home, driver, className = 'h-72' }) {
  const icons = useMemo(() => ({ store: pinIcon('store'), home: pinIcon('home'), driver: pinIcon('driver') }), []);
  const center = driver ?? home ?? store ?? DEFAULT_CENTER;
  const route = [store, driver, home].filter(Boolean);
  return (
    <div className={`relative isolate overflow-hidden rounded-4xl shadow-card ${className}`}>
      <MapContainer center={center} zoom={14} scrollWheelZoom={false} className="h-full w-full" attributionControl>
        <TileLayer url={TILES} attribution={ATTRIBUTION} />
        {route.length > 1 && (
          <Polyline positions={route} pathOptions={{ color: '#5BB22F', weight: 5, dashArray: '2 12', lineCap: 'round' }} />
        )}
        {store && <Marker position={store} icon={icons.store} />}
        {home && <Marker position={home} icon={icons.home} />}
        {driver && <GlidingMarker position={driver} icon={icons.driver} />}
        <FitBounds points={[store, home, driver].filter(Boolean)} />
      </MapContainer>
    </div>
  );
}

function CenterWatcher({ onMove, onMoving }) {
  useMapEvents({
    movestart: () => onMoving(true),
    moveend: (e) => {
      onMoving(false);
      const c = e.target.getCenter();
      onMove([c.lat, c.lng]);
    },
  });
  return null;
}

function Recenter({ to }) {
  const map = useMap();
  useEffect(() => {
    if (to) map.flyTo(to, 17, { duration: 1.1 });
  }, [to, map]);
  return null;
}

/**
 * Drag the map under a fixed centre pin, like the app's location screen. The
 * pin lifts while the map moves and drops when it settles; the settled centre
 * is reverse-geocoded through Nominatim to prefill the street fields.
 */
export function MapPicker({ value, onChange, onAddress, className = 'h-72' }) {
  const { t, lang } = useI18n();
  const { request, status } = useLocation2();
  const [moving, setMoving] = useState(false);
  const [flyTo, setFlyTo] = useState(null);
  const start = useRef(value ?? DEFAULT_CENTER);

  const settle = async (point) => {
    onChange(point);
    if (!onAddress) return;
    try {
      const url = `https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${point[0]}&lon=${point[1]}&accept-language=${lang}`;
      const res = await fetch(url, { headers: { Accept: 'application/json' } });
      if (!res.ok) return;
      const data = await res.json();
      const a = data.address ?? {};
      onAddress({
        wilaya: a.state ?? a.province ?? '',
        commune: a.city ?? a.town ?? a.village ?? a.municipality ?? '',
        street: [a.road, a.neighbourhood ?? a.suburb].filter(Boolean).join('، '),
      });
    } catch {
      /* geocoding is a convenience; the shopper can type the address */
    }
  };

  const locate = async () => {
    const pos = await request();
    if (pos) setFlyTo([pos.lat, pos.lng]);
  };

  return (
    <div className={`relative isolate overflow-hidden rounded-4xl shadow-card ${className}`}>
      <MapContainer center={start.current} zoom={16} className="h-full w-full">
        <TileLayer url={TILES} attribution={ATTRIBUTION} />
        <CenterWatcher onMove={settle} onMoving={setMoving} />
        <Recenter to={flyTo} />
      </MapContainer>
      <div className="pointer-events-none absolute inset-0 z-[400] grid place-items-center">
        <div className="relative -mt-12 flex flex-col items-center">
          <motion.div animate={{ y: moving ? -16 : 0 }} transition={{ type: 'spring', stiffness: 500, damping: 18 }}>
            <div className="grid h-12 w-12 place-items-center rounded-full bg-forest text-white shadow-lift ring-4 ring-white">
              <Icon name="home" className="h-6 w-6" />
            </div>
            <div className="mx-auto h-4 w-1 rounded-b bg-forest" />
          </motion.div>
          <motion.span
            animate={{ scale: moving ? 0.5 : 1, opacity: moving ? 0.3 : 0.6 }}
            className="h-2 w-6 rounded-full bg-forest-deep blur-[2px]"
          />
        </div>
      </div>
      <div className="absolute inset-x-3 top-3 z-[400] flex items-center justify-between gap-2">
        <span className="rounded-full bg-white/90 px-3 py-1.5 text-xs font-bold text-forest shadow backdrop-blur">{t('account.pickOnMap')}</span>
        <Button size="sm" variant="white" icon="target" type="button" onClick={locate} loading={status === 'locating'}>
          {t('account.useMyLocation')}
        </Button>
      </div>
    </div>
  );
}
