import { useRef } from 'react';
import { Link } from 'react-router-dom';
import { motion, useMotionValue, useSpring, useTransform } from 'framer-motion';
import { Icon, categoryVisual } from './Icon';
import { Badge, Img, Skeleton } from './ui';
import { categoryName, useI18n } from '../state/i18n';
import { money, openNow } from '../lib/format';

/** Follows the pointer with a gentle 3D tilt; flat for touch and reduced motion. */
function useTilt(strength = 8) {
  const ref = useRef(null);
  const px = useMotionValue(0.5);
  const py = useMotionValue(0.5);
  const rx = useSpring(useTransform(py, [0, 1], [strength, -strength]), { stiffness: 220, damping: 20 });
  const ry = useSpring(useTransform(px, [0, 1], [-strength, strength]), { stiffness: 220, damping: 20 });
  const glareX = useTransform(px, [0, 1], ['0%', '100%']);
  const onMove = (e) => {
    if (e.pointerType !== 'mouse') return;
    const r = ref.current.getBoundingClientRect();
    px.set((e.clientX - r.left) / r.width);
    py.set((e.clientY - r.top) / r.height);
  };
  const onLeave = () => {
    px.set(0.5);
    py.set(0.5);
  };
  return { ref, style: { rotateX: rx, rotateY: ry, transformPerspective: 900 }, glareX, onMove, onLeave };
}

export function VendorCard({ vendor, index = 0 }) {
  const { t, lang } = useI18n();
  const tilt = useTilt();
  const open = openNow(vendor);
  return (
    <motion.div
      initial={{ opacity: 0, y: 30 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: '-40px' }}
      transition={{ duration: 0.6, delay: (index % 6) * 0.06, ease: [0.16, 1, 0.3, 1] }}
    >
      <motion.div
        ref={tilt.ref}
        style={tilt.style}
        onPointerMove={tilt.onMove}
        onPointerLeave={tilt.onLeave}
        whileHover={{ y: -6 }}
        transition={{ type: 'spring', stiffness: 300, damping: 22 }}
        className="group relative"
      >
        <Link to={`/stores/${vendor.id}`} className="block overflow-hidden rounded-4xl bg-white shadow-card transition-shadow group-hover:shadow-lift">
          <div className="relative">
            <Img
              image={vendor.cover ?? vendor.logo}
              ratio={16 / 9}
              width={720}
              alt={vendor.name}
              fallback="store"
              imgClassName="transition-transform duration-700 ease-out group-hover:scale-110"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-forest-deep/50 via-transparent to-transparent" />
            <motion.div
              aria-hidden="true"
              style={{ left: tilt.glareX }}
              className="pointer-events-none absolute -top-1/2 h-[200%] w-24 -translate-x-1/2 rotate-12 bg-white/20 opacity-0 blur-xl transition-opacity group-hover:opacity-100"
            />
            <div className="absolute start-3 top-3 flex flex-wrap gap-1.5">
              {vendor.isFeatured && (
                <Badge tone="white">
                  <Icon name="sparkles" className="h-3.5 w-3.5 text-tangerine" />
                  {t('stores.sortFeatured')}
                </Badge>
              )}
            </div>
            <div className="absolute end-3 top-3">
              <Badge tone={open ? 'white' : 'tomato'} pulse={open}>
                <span className={open ? 'text-leaf' : ''}>{open ? t('stores.open') : t('stores.closed')}</span>
              </Badge>
            </div>
            {!open && <div className="absolute inset-0 bg-white/40 backdrop-grayscale" />}
          </div>
          <div className="relative px-5 pb-5 pt-9">
            <div className="absolute -top-8 start-5 h-16 w-16 overflow-hidden rounded-2xl bg-white p-1 shadow-card ring-4 ring-white transition-transform duration-500 group-hover:-rotate-6 group-hover:scale-105">
              <Img image={vendor.logo} ratio={1} width={128} className="h-full w-full rounded-xl" fallback="store" />
            </div>
            <div className="flex items-start justify-between gap-3">
              <h3 className="line-clamp-1 text-xl font-bold">{vendor.name}</h3>
              {vendor.ratingCount > 0 && (
                <span className="num flex shrink-0 items-center gap-1 rounded-full bg-tangerine-soft px-2 py-0.5 text-sm font-bold text-tangerine">
                  <Icon name="star" filled className="h-3.5 w-3.5" />
                  {Number(vendor.rating).toFixed(1)}
                </span>
              )}
            </div>
            {vendor.description && <p className="mt-1 line-clamp-1 text-sm text-ink-muted">{vendor.description}</p>}
            <div className="mt-3 flex flex-wrap items-center gap-x-4 gap-y-1 text-sm font-bold text-ink-soft">
              <span className="flex items-center gap-1.5">
                <Icon name="clock" className="h-4 w-4 text-leaf" />
                <span className="num">{t('stores.prep', { min: vendor.etaMinutes ?? vendor.prepTimeMin, max: (vendor.etaMinutes ?? vendor.prepTimeMin) + Math.max(0, (vendor.prepTimeMax ?? 0) - (vendor.prepTimeMin ?? 0)) })}</span>
              </span>
              <span className="flex items-center gap-1.5">
                <Icon name="bike" className="h-4 w-4 text-leaf" />
                <span className="num">{money(vendor.deliveryFeeCentimes, lang)}</span>
              </span>
              {typeof vendor.distanceKm === 'number' && (
                <span className="flex items-center gap-1.5">
                  <Icon name="pin" className="h-4 w-4 text-leaf" />
                  <span className="num">{vendor.distanceKm} {t('common.km')}</span>
                </span>
              )}
            </div>
          </div>
        </Link>
      </motion.div>
    </motion.div>
  );
}

export function VendorCardSkeleton() {
  return (
    <div className="overflow-hidden rounded-4xl bg-white shadow-card">
      <Skeleton className="aspect-video rounded-none" />
      <div className="space-y-3 p-5">
        <Skeleton className="h-6 w-2/3" />
        <Skeleton className="h-4 w-1/2" />
      </div>
    </div>
  );
}

export function CategoryTile({ category, active, onClick, index = 0 }) {
  const { lang } = useI18n();
  const visual = categoryVisual(category?.iconKey);
  return (
    <motion.button
      type="button"
      onClick={onClick}
      initial={{ opacity: 0, scale: 0.8, y: 20 }}
      whileInView={{ opacity: 1, scale: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ type: 'spring', stiffness: 260, damping: 20, delay: index * 0.05 }}
      whileHover={{ y: -6 }}
      whileTap={{ scale: 0.94 }}
      className="group flex w-24 shrink-0 flex-col items-center gap-2 sm:w-28"
    >
      <span
        className={`relative grid h-20 w-20 place-items-center rounded-[1.75rem] transition-all duration-300 sm:h-24 sm:w-24 ${visual.tone} ${
          active ? 'shadow-glow ring-2 ring-leaf' : 'group-hover:shadow-card'
        }`}
      >
        <motion.span
          className="grid place-items-center"
          whileHover={{ rotate: [0, -12, 10, -6, 0], scale: 1.12 }}
          transition={{ duration: 0.6 }}
        >
          <Icon name={visual.icon} className="h-9 w-9 sm:h-10 sm:w-10" strokeWidth={1.8} />
        </motion.span>
      </span>
      <span className={`text-center text-sm font-bold leading-tight ${active ? 'text-forest' : 'text-ink-soft'}`}>
        {categoryName(category, lang)}
      </span>
    </motion.button>
  );
}

export function offerHeadline(offer, t, lang) {
  if (offer.type === 'percentage') return t('home.offerOff', { n: offer.value });
  if (offer.type === 'fixed') return t('home.offerFixed', { amount: money(offer.value, lang) });
  if (offer.type === 'freeDelivery') return t('home.offerFree');
  return t('home.offerBundle');
}

const OFFER_SKINS = [
  'from-forest to-forest-soft',
  'from-tangerine to-[#F5A524]',
  'from-leaf to-forest-soft',
  'from-tomato to-tangerine',
];

export function OfferCard({ offer, index = 0 }) {
  const { t, lang } = useI18n();
  const vendorId = offer.vendor?.id ?? (typeof offer.vendor === 'string' ? offer.vendor : null);
  const body = (
    <motion.div
      whileHover={{ y: -6, rotate: index % 2 ? 0.6 : -0.6 }}
      transition={{ type: 'spring', stiffness: 300, damping: 18 }}
      className={`group relative flex h-full min-h-[190px] overflow-hidden rounded-4xl bg-gradient-to-br p-6 text-white shadow-lift ${OFFER_SKINS[index % OFFER_SKINS.length]}`}
    >
      <div aria-hidden="true" className="absolute -end-10 -top-10 h-40 w-40 rounded-full bg-white/10 transition-transform duration-700 group-hover:scale-150" />
      <div aria-hidden="true" className="absolute -bottom-16 end-16 h-32 w-32 rounded-full bg-white/10 transition-transform duration-700 group-hover:-translate-y-4" />
      <div className="relative z-10 flex max-w-[60%] flex-col">
        <span className="font-display text-3xl font-extrabold leading-none drop-shadow">{offerHeadline(offer, t, lang)}</span>
        <h3 className="mt-3 text-lg font-bold leading-snug">{offer.title}</h3>
        {offer.subtitle && <p className="mt-1 line-clamp-2 text-sm text-white/80">{offer.subtitle}</p>}
        {offer.vendor?.name && (
          <span className="mt-auto inline-flex items-center gap-1.5 pt-4 text-sm font-bold">
            {offer.vendor.name}
            <Icon name="arrow" className="h-4 w-4 transition-transform group-hover:translate-x-1 rtl:group-hover:-translate-x-1" />
          </span>
        )}
      </div>
      {offer.image && (
        <div className="absolute inset-y-0 end-0 w-[45%]">
          <Img image={offer.image} ratio={0.85} width={420} className="h-full w-full [mask-image:linear-gradient(to_left,black_60%,transparent)] rtl:[mask-image:linear-gradient(to_right,black_60%,transparent)]" imgClassName="transition-transform duration-700 group-hover:scale-110" />
        </div>
      )}
    </motion.div>
  );
  return vendorId ? <Link to={`/stores/${vendorId}`} className="block h-full">{body}</Link> : body;
}

export function ProductCard({ product, onOpen, disabled }) {
  const { t, lang } = useI18n();
  const unavailable = !product.isAvailable;
  return (
    <motion.button
      type="button"
      layout
      onClick={() => !unavailable && onOpen(product)}
      disabled={disabled}
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: '-30px' }}
      transition={{ duration: 0.5, ease: [0.16, 1, 0.3, 1] }}
      whileHover={unavailable ? undefined : { y: -4 }}
      className={`group flex w-full items-stretch gap-4 rounded-3xl bg-white p-3 text-start shadow-card transition-shadow hover:shadow-lift ${unavailable ? 'cursor-not-allowed opacity-60' : ''}`}
    >
      <div className="flex min-w-0 flex-1 flex-col py-1 ps-1">
        <h4 className="line-clamp-1 text-lg font-bold">{product.name}</h4>
        {product.description && <p className="mt-1 line-clamp-2 text-sm text-ink-muted">{product.description}</p>}
        <div className="mt-auto flex items-center gap-2 pt-3">
          <span className="num font-display text-lg font-bold text-forest">{money(product.priceCentimes, lang)}</span>
          {unavailable && <Badge tone="tomato">{t('store.unavailable')}</Badge>}
        </div>
      </div>
      <div className="relative">
        {/* Square, server-cropped thumbnail: every menu row lines up. */}
        <Img image={product.image} ratio={1} width={260} alt={product.name} fallback="burger" className="h-28 w-28 rounded-2xl sm:h-32 sm:w-32" imgClassName="transition-transform duration-500 group-hover:scale-110" />
        {!unavailable && (
          <span className="absolute -bottom-2 -end-2 grid h-10 w-10 place-items-center rounded-full bg-forest text-white shadow-lift ring-4 ring-white transition-transform group-hover:rotate-90 group-hover:scale-110">
            <Icon name="plus" className="h-5 w-5" />
          </span>
        )}
      </div>
    </motion.button>
  );
}
