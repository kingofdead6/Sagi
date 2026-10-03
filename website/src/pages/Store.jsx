import { Suspense, lazy, useEffect, useMemo, useRef, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { AnimatePresence, motion, useScroll, useTransform } from 'framer-motion';
import { Icon } from '../components/Icon';
import { Badge, Button, EmptyState, ErrorState, Img, Skeleton } from '../components/ui';
import { ProductCard } from '../components/Catalog';
import { ProductModal } from '../components/ProductModal';
import { useI18n } from '../state/i18n';
import { useCart } from '../state/cart';
import { useLocation2 } from '../state/location';
import { useAsync, useSlow } from '../lib/hooks';
import { catalog } from '../lib/services';
import { localPhone, money, openNow, toLatLng } from '../lib/format';

const LiveMap = lazy(() => import('../components/Maps').then((m) => ({ default: m.LiveMap })));

function Hours({ vendor }) {
  const { t } = useI18n();
  const today = new Date().getDay();
  if (!vendor.openingHours?.length) return <p className="text-sm text-ink-soft">{t('store.allDay')}</p>;
  return (
    <ul className="space-y-1.5 text-sm">
      {t('days').map((day, d) => {
        const slots = vendor.openingHours.filter((h) => h.day === d);
        return (
          <li key={d} className={`flex justify-between rounded-xl px-3 py-1.5 ${d === today ? 'bg-leaf-tint font-bold text-forest' : 'text-ink-soft'}`}>
            <span>{day}</span>
            <span className="num">{slots.length ? slots.map((s) => `${s.from}–${s.to}`).join(' · ') : t('store.closedToday')}</span>
          </li>
        );
      })}
    </ul>
  );
}

export default function Store() {
  const { id } = useParams();
  const { t, lang } = useI18n();
  const { position } = useLocation2();
  const cart = useCart();
  const vendor = useAsync(() => catalog.vendor(id, position), [id]);
  const menu = useAsync(() => catalog.menu(id), [id]);
  const slow = useSlow(vendor.loading);
  const [selected, setSelected] = useState(null);
  const [query, setQuery] = useState('');
  const [active, setActive] = useState(null);

  const heroRef = useRef(null);
  const { scrollYProgress } = useScroll({ target: heroRef, offset: ['start start', 'end start'] });
  const coverY = useTransform(scrollYProgress, [0, 1], ['0%', '30%']);
  const coverScale = useTransform(scrollYProgress, [0, 1], [1, 1.15]);

  const groups = useMemo(() => {
    const q = query.trim().toLowerCase();
    return (menu.data ?? [])
      .map((g) => ({
        id: g.section?.id ?? 'other',
        name: g.section?.name ?? '',
        products: (g.products ?? []).filter(
          (p) => !q || p.name.toLowerCase().includes(q) || (p.description ?? '').toLowerCase().includes(q),
        ),
      }))
      .filter((g) => g.products.length > 0);
  }, [menu.data, query]);

  // Scroll-spy: the section nearest the top of the viewport lights its tab.
  useEffect(() => {
    if (!groups.length) return undefined;
    const io = new IntersectionObserver(
      (entries) => {
        const visible = entries.filter((e) => e.isIntersecting).sort((a, b) => a.boundingClientRect.top - b.boundingClientRect.top);
        if (visible[0]) setActive(visible[0].target.dataset.section);
      },
      { rootMargin: '-140px 0px -60% 0px' },
    );
    groups.forEach((g) => {
      const el = document.getElementById(`sec-${g.id}`);
      if (el) io.observe(el);
    });
    return () => io.disconnect();
  }, [groups]);

  const jump = (sid) => {
    const el = document.getElementById(`sec-${sid}`);
    if (el) window.scrollTo({ top: el.getBoundingClientRect().top + window.scrollY - 130, behavior: 'smooth' });
  };

  if (vendor.error) {
    const notFound = vendor.error?.response?.status === 404;
    return notFound ? (
      <EmptyState icon="store" title={t('store.notFound')} action={<Link to="/stores"><Button>{t('cart.browse')}</Button></Link>} />
    ) : (
      <ErrorState error={vendor.error} onRetry={vendor.reload} />
    );
  }

  const v = vendor.data;
  const isOpen = v ? openNow(v) : true;
  const storePoint = v ? toLatLng(v.location) : null;
  const inCart = cart.cart.vendor?.id === id ? cart.count : 0;

  return (
    <div className="pb-10">
      <div ref={heroRef} className="container-x pt-2">
        <div className="relative h-64 overflow-hidden rounded-[2.5rem] md:h-80">
          {v ? (
            <motion.div style={{ y: coverY, scale: coverScale }} className="absolute inset-0">
              <Img image={v.cover ?? v.logo} ratio={21 / 9} width={1600} className="h-full w-full" fallback="store" />
            </motion.div>
          ) : (
            <Skeleton className="absolute inset-0 rounded-none" />
          )}
          <div className="absolute inset-0 bg-gradient-to-t from-forest-deep/80 via-forest-deep/20 to-transparent" />
          <Link
            to="/stores"
            className="absolute start-4 top-4 grid h-11 w-11 place-items-center rounded-full bg-white/90 text-forest shadow backdrop-blur transition hover:scale-105"
            aria-label={t('common.back')}
          >
            <Icon name="chevron" className="h-5 w-5 rotate-180" />
          </Link>
        </div>

        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, ease: [0.16, 1, 0.3, 1] }}
          className="relative -mt-20 mx-3 rounded-4xl bg-white p-5 shadow-lift md:mx-8 md:p-7"
        >
          {!v ? (
            <div className="space-y-3">
              <Skeleton className="h-8 w-1/2" />
              <Skeleton className="h-4 w-1/3" />
              {slow && <p className="text-sm font-bold text-ink-muted">{t('common.waking')}</p>}
            </div>
          ) : (
            <div className="flex flex-col gap-5 md:flex-row md:items-center">
              <motion.div
                initial={{ scale: 0, rotate: -20 }}
                animate={{ scale: 1, rotate: 0 }}
                transition={{ type: 'spring', stiffness: 200, damping: 14, delay: 0.2 }}
                className="-mt-16 h-24 w-24 shrink-0 overflow-hidden rounded-3xl bg-white p-1.5 shadow-lift ring-4 ring-white md:mt-0"
              >
                <Img image={v.logo} ratio={1} width={200} className="h-full w-full rounded-2xl" fallback="store" />
              </motion.div>
              <div className="min-w-0 flex-1">
                <div className="flex flex-wrap items-center gap-2">
                  <h1 className="text-3xl font-extrabold md:text-4xl">{v.name}</h1>
                  <Badge tone={isOpen ? 'leaf' : 'tomato'} pulse={isOpen}>{isOpen ? t('stores.open') : t('stores.closed')}</Badge>
                </div>
                {v.description && <p className="mt-1 text-ink-soft">{v.description}</p>}
                <div className="mt-3 flex flex-wrap gap-2">
                  {v.ratingCount > 0 && (
                    <span className="chip num cursor-default">
                      <Icon name="star" filled className="h-4 w-4 text-tangerine" />
                      {Number(v.rating).toFixed(1)} <span className="text-ink-muted">({t('stores.reviews', { n: v.ratingCount })})</span>
                    </span>
                  )}
                  <span className="chip num cursor-default">
                    <Icon name="clock" className="h-4 w-4 text-leaf" />
                    {t('stores.prep', { min: v.prepTimeMin, max: v.prepTimeMax })}
                  </span>
                  <span className="chip num cursor-default">
                    <Icon name="bike" className="h-4 w-4 text-leaf" />
                    {t('stores.deliveryFee', { amount: money(v.deliveryFeeCentimes, lang) })}
                  </span>
                  {v.minOrderCentimes > 0 && (
                    <span className="chip num cursor-default">
                      <Icon name="bag" className="h-4 w-4 text-leaf" />
                      {t('stores.minOrder', { amount: money(v.minOrderCentimes, lang) })}
                    </span>
                  )}
                </div>
              </div>
            </div>
          )}
        </motion.div>
        <AnimatePresence>
          {v && !isOpen && (
            <motion.div
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              className="mx-3 mt-4 flex items-center gap-3 rounded-2xl bg-tangerine-soft px-4 py-3 font-bold text-tangerine md:mx-8"
            >
              <Icon name="clock" />
              {t('store.closedBanner')}
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      <div className="container-x mt-8 grid gap-8 lg:grid-cols-[1fr_340px]">
        <div className="min-w-0">
          <div className="sticky top-[68px] z-20 -mx-4 bg-cream/90 px-4 py-3 backdrop-blur-xl">
            <label className="mb-3 flex items-center gap-3 rounded-2xl bg-white px-4 shadow-card focus-within:ring-4 focus-within:ring-leaf/20">
              <Icon name="search" className="h-5 w-5 text-ink-muted" />
              <input
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                placeholder={t('store.searchMenu')}
                className="h-12 flex-1 bg-transparent outline-none placeholder:text-ink-muted"
              />
            </label>
            <div className="scrollbar-none flex gap-1 overflow-x-auto">
              {groups.map((g) => (
                <button
                  key={g.id}
                  type="button"
                  onClick={() => jump(g.id)}
                  className={`relative shrink-0 rounded-full px-4 py-2 text-sm font-bold transition-colors ${active === g.id ? 'text-white' : 'text-ink-soft hover:text-forest'}`}
                >
                  {active === g.id && (
                    <motion.span layoutId="menu-tab" className="absolute inset-0 rounded-full bg-forest" transition={{ type: 'spring', stiffness: 500, damping: 36 }} />
                  )}
                  <span className="relative">{g.name}</span>
                </button>
              ))}
            </div>
          </div>

          {menu.loading ? (
            <div className="mt-4 grid gap-4 md:grid-cols-2">
              {Array.from({ length: 6 }, (_, i) => <Skeleton key={i} className="h-36 rounded-3xl" />)}
            </div>
          ) : menu.error ? (
            <ErrorState error={menu.error} onRetry={menu.reload} />
          ) : groups.length === 0 ? (
            <EmptyState icon="burger" title={query ? t('stores.noResults') : t('store.emptyMenu')} />
          ) : (
            groups.map((g) => (
              <section key={g.id} id={`sec-${g.id}`} data-section={g.id} className="scroll-mt-40 pt-8">
                <motion.h2
                  initial={{ opacity: 0, x: 20 }}
                  whileInView={{ opacity: 1, x: 0 }}
                  viewport={{ once: true }}
                  className="mb-4 flex items-center gap-3 text-2xl font-extrabold"
                >
                  <span className="h-8 w-1.5 rounded-full bg-leaf" />
                  {g.name}
                  <span className="num text-base font-bold text-ink-muted">{g.products.length}</span>
                </motion.h2>
                <div className="grid gap-4 md:grid-cols-2">
                  {g.products.map((p) => (
                    <ProductCard key={p.id} product={p} onOpen={setSelected} />
                  ))}
                </div>
              </section>
            ))
          )}
        </div>

        <aside className="space-y-4 lg:sticky lg:top-24 lg:self-start">
          {v && (
            <>
              <div className="card p-5">
                <h3 className="mb-3 text-lg font-bold">{t('store.info')}</h3>
                <p className="flex gap-2 text-sm text-ink-soft">
                  <Icon name="pin" className="h-5 w-5 shrink-0 text-leaf" />
                  {v.addressText}
                </p>
                {v.phone && (
                  <a href={`tel:${v.phone}`} className="num mt-3 flex items-center gap-2 text-sm font-bold text-forest hover:underline">
                    <Icon name="phone" className="h-5 w-5 text-leaf" />
                    {localPhone(v.phone)}
                  </a>
                )}
                {storePoint && (
                  <div className="mt-4">
                    <Suspense fallback={<Skeleton className="h-44 rounded-4xl" />}>
                      <LiveMap store={storePoint} className="h-44" />
                    </Suspense>
                  </div>
                )}
              </div>
              <div className="card p-5">
                <h3 className="mb-3 text-lg font-bold">{t('store.hours')}</h3>
                <Hours vendor={v} />
              </div>
            </>
          )}
        </aside>
      </div>

      {/* A floating "view cart" pill while this store's items are in the cart. */}
      <AnimatePresence>
        {inCart > 0 && (
          <motion.button
            type="button"
            onClick={cart.open}
            initial={{ y: 120, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            exit={{ y: 120, opacity: 0 }}
            transition={{ type: 'spring', stiffness: 300, damping: 26 }}
            className="fixed inset-x-4 bottom-24 z-30 mx-auto flex max-w-md items-center justify-between rounded-3xl bg-forest px-5 py-4 text-white shadow-lift md:bottom-8"
          >
            <span className="flex items-center gap-3 font-bold">
              <span className="num grid h-8 w-8 place-items-center rounded-full bg-white/15">{inCart}</span>
              {t('cart.checkout')}
            </span>
            <span className="num font-display text-lg font-bold">{money(cart.subtotal, lang)}</span>
          </motion.button>
        )}
      </AnimatePresence>

      {v && <ProductModal product={selected} vendor={v} onClose={() => setSelected(null)} />}
    </div>
  );
}
