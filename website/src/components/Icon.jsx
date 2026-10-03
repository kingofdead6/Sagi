/**
 * A small inline icon set (24px grid, 2px strokes) so the site needs no icon
 * dependency. Directional icons are mirrored automatically in RTL.
 */
const PATHS = {
  home: 'M3 10.5 12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z',
  store: 'M3 9l1.5-5h15L21 9M3 9v11h18V9M3 9a3 3 0 0 0 6 0 3 3 0 0 0 6 0 3 3 0 0 0 6 0M9 20v-5h6v5',
  bag: 'M6 7h12l1 13H5zM9 7V6a3 3 0 0 1 6 0v1',
  receipt: 'M5 3h14v18l-3-2-2 2-2-2-2 2-2-2-3 2zM9 8h6M9 12h6M9 16h4',
  user: 'M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM4 21a8 8 0 0 1 16 0',
  search: 'M11 18a7 7 0 1 0 0-14 7 7 0 0 0 0 14zM20 20l-4-4',
  x: 'M6 6l12 12M18 6 6 18',
  plus: 'M12 5v14M5 12h14',
  minus: 'M5 12h14',
  check: 'M5 12.5l4.5 4.5L19 7.5',
  alert: 'M12 8v5M12 16.5v.01M10.3 3.9 2.6 17.3A2 2 0 0 0 4.3 20h15.4a2 2 0 0 0 1.7-2.7L13.7 3.9a2 2 0 0 0-3.4 0z',
  bell: 'M6 16V11a6 6 0 1 1 12 0v5l2 2H4zM10 20a2 2 0 0 0 4 0',
  star: 'M12 3.5l2.6 5.3 5.9.9-4.3 4.1 1 5.8L12 16.9l-5.2 2.7 1-5.8-4.3-4.1 5.9-.9z',
  clock: 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM12 7v5l3 2',
  bike: 'M5.5 18a3 3 0 1 0 0-6 3 3 0 0 0 0 6zM18.5 18a3 3 0 1 0 0-6 3 3 0 0 0 0 6zM5.5 15l4-7h5l4 7M9.5 8 8 5H5.5M14.5 8l1.5-3h2',
  pin: 'M12 21s-7-6.2-7-11.5a7 7 0 0 1 14 0C19 14.8 12 21 12 21zM12 12a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z',
  phone: 'M5 4h3.5l1.5 4.5-2 1.5a11 11 0 0 0 6 6l1.5-2L20 15.5V19a1 1 0 0 1-1 1A16 16 0 0 1 4 5a1 1 0 0 1 1-1z',
  chevron: 'M9 6l6 6-6 6',
  chevronDown: 'M6 9l6 6 6-6',
  arrow: 'M5 12h14M13 6l6 6-6 6',
  trash: 'M4 7h16M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3',
  pencil: 'M4 20h4L19 9l-4-4L4 16zM13.5 6.5l4 4',
  logout: 'M15 4h4v16h-4M10 8l-4 4 4 4M6 12h11',
  globe: 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM3 12h18M12 3a14 14 0 0 1 0 18M12 3a14 14 0 0 0 0 18',
  gift: 'M4 11h16v9H4zM3 7h18v4H3zM12 7v13M12 7S10.5 3 8 3.5 7 7 12 7zM12 7s1.5-4 4-3.5S17 7 12 7z',
  coins: 'M9 8a6 3 0 1 0 0 .01M3 8v4c0 1.7 2.7 3 6 3s6-1.3 6-3V8M9 15v1c0 1.7 2.7 3 6 3s6-1.3 6-3v-4c0-1.6-2.3-2.8-5.4-3',
  lock: 'M6 11h12v10H6zM8.5 11V7.5a3.5 3.5 0 0 1 7 0V11',
  navigation: 'M3 11l18-8-8 18-2-8z',
  package: 'M3 7.5 12 3l9 4.5v9L12 21l-9-4.5zM3 7.5l9 4.5 9-4.5M12 12v9M7.5 5.2l9 4.6',
  sparkles: 'M12 3l1.8 5.2L19 10l-5.2 1.8L12 17l-1.8-5.2L5 10l5.2-1.8zM19 16l.8 2.2L22 19l-2.2.8L19 22l-.8-2.2L16 19l2.2-.8z',
  flame: 'M12 21a6 6 0 0 0 6-6c0-4-3-6-3-9 0 0-3 1-4 5-1-1-1.5-2-1.5-2S6 11 6 15a6 6 0 0 0 6 6z',
  burger: 'M4 10a8 5 0 0 1 16 0zM3.5 13.5h17M4 17h16a0 0 0 0 1 0 0 3 3 0 0 1-3 3H7a3 3 0 0 1-3-3z',
  carrot: 'M14.5 9.5 4 20c-.5-.5 4-11 6.5-13.5a3 3 0 0 1 4 3zM15 9l4-4M14 6c0-2 1-3 1-3M18 10c2 0 3-1 3-1',
  basket: 'M3 10h18l-2 10H5zM7 10l4-7M17 10l-4-7M9 14v3M15 14v3M12 14v3',
  cake: 'M4 21h16v-8H4zM4 16c2 0 2-1.5 4-1.5s2 1.5 4 1.5 2-1.5 4-1.5 2 1.5 4 1.5M12 13V9M12 5.5v.01',
  bread: 'M5 20h14V11a4 4 0 0 0 1-2.5C20 5.5 16.5 4 12 4S4 5.5 4 8.5A4 4 0 0 0 5 11z',
  meat: 'M15.5 4.5a5.5 5.5 0 0 1 0 7.8l-3.2 3.2a5.5 5.5 0 0 1-7.8-7.8l3.2-3.2a5.5 5.5 0 0 1 7.8 0zM5 19l-1.5 1.5M7 17l-3 3',
  apple: 'M12 7c-2-2-7-1.5-7 4 0 4 2.5 9 5 9 1 0 1.5-.5 2-.5s1 .5 2 .5c2.5 0 5-5 5-9 0-5.5-5-6-7-4zM12 7c0-2 1-4 3-4',
  pill: 'M10.5 20.5a5 5 0 0 1-7-7l7-7a5 5 0 0 1 7 7zM7 10l7 7',
  image: 'M4 5h16v14H4zM4 16l5-5 4 4 3-3 4 4M15 9.5v.01',
  upload: 'M12 16V4M7 9l5-5 5 5M4 20h16',
  eye: 'M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12zM12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6z',
  eyeOff: 'M3 3l18 18M10.6 5.1A10 10 0 0 1 12 5c6.5 0 10 7 10 7a17 17 0 0 1-3.2 4M6.6 6.6A17 17 0 0 0 2 12s3.5 7 10 7a10 10 0 0 0 5.4-1.6M9.9 9.9a3 3 0 0 0 4.2 4.2',
  menu: 'M4 7h16M4 12h16M4 17h16',
  copy: 'M9 9h11v11H9zM5 15H4V4h11v1',
  power: 'M12 3v9M6.3 6.3a8 8 0 1 0 11.4 0',
  refresh: 'M20 11a8 8 0 0 0-14.6-4.5L4 8M4 4v4h4M4 13a8 8 0 0 0 14.6 4.5L20 16M20 20v-4h-4',
  grip: 'M9 6h.01M15 6h.01M9 12h.01M15 12h.01M9 18h.01M15 18h.01',
  up: 'M12 19V5M6 11l6-6 6 6',
  down: 'M12 5v14M6 13l6 6 6-6',
  download: 'M12 4v12M7 11l5 5 5-5M4 20h16',
  crown: 'M3 8l4.5 4L12 5l4.5 7L21 8l-2 11H5z',
  wallet: 'M3 7h16a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2zM3 7l12-3v3M16 13.5h.01',
  sliders: 'M4 6h10M18 6h2M4 12h4M12 12h8M4 18h12M20 18h0M16 4v4M10 10v4M18 16v4',
  target: 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM12 16a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM12 2v3M12 19v3M2 12h3M19 12h3',
  info: 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM12 11v5M12 8v.01',
  send: 'M4 12 20 4l-5 16-3-7z',
  chart: 'M4 20V10M10 20V4M16 20v-7M22 20H2',
  history: 'M3 12a9 9 0 1 0 3-6.7L3 8M3 3v5h5M12 7v5l3 2',
  tag: 'M3 12V4h8l10 10-8 8zM7.5 7.5v.01',
  shield: 'M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z',
  facebook: 'M15 3h-2.5A3.5 3.5 0 0 0 9 6.5V9H6.5v3.5H9V21h3.5v-8.5H15l.5-3.5h-3V7a1 1 0 0 1 1-1H15z',
  instagram: 'M7 3h10a4 4 0 0 1 4 4v10a4 4 0 0 1-4 4H7a4 4 0 0 1-4-4V7a4 4 0 0 1 4-4zM12 16a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM17.5 6.5v.01',
};

const MIRRORED = new Set(['chevron', 'arrow', 'navigation', 'send']);

export function Icon({ name, className = 'h-5 w-5', strokeWidth = 2, filled = false, ...rest }) {
  const d = PATHS[name] ?? PATHS.info;
  return (
    <svg
      viewBox="0 0 24 24"
      fill={filled ? 'currentColor' : 'none'}
      stroke="currentColor"
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
      className={`${className} ${MIRRORED.has(name) ? 'rtl:-scale-x-100' : ''}`}
      {...rest}
    >
      <path d={d} />
    </svg>
  );
}

/** The server's category iconKey → an icon and a brand colour, as in the app. */
const CATEGORY = {
  fastfood: { icon: 'burger', tone: 'bg-tangerine-soft text-tangerine' },
  fruits: { icon: 'apple', tone: 'bg-leaf-tint text-leaf' },
  vegetables: { icon: 'carrot', tone: 'bg-leaf-tint text-leaf' },
  meat: { icon: 'meat', tone: 'bg-red-50 text-tomato' },
  grocery: { icon: 'basket', tone: 'bg-amber-50 text-amber-600' },
  bakery: { icon: 'bread', tone: 'bg-orange-50 text-orange-600' },
  sweets: { icon: 'cake', tone: 'bg-pink-50 text-pink-600' },
  pharmacy: { icon: 'pill', tone: 'bg-sky-50 text-sky-600' },
};

export function categoryVisual(iconKey) {
  return CATEGORY[iconKey] ?? { icon: 'package', tone: 'bg-forest/5 text-forest' };
}
