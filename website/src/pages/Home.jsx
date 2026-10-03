import { useRef, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { motion, useMotionValue, useScroll, useSpring, useTransform } from 'framer-motion';
import { Icon } from '../components/Icon';
import { Button, CountOnView, Reveal, Skeleton, rise, stagger } from '../components/ui';
import { CategoryTile, OfferCard, VendorCard, VendorCardSkeleton } from '../components/Catalog';
import { useI18n } from '../state/i18n';
import { useAsync, useSlow } from '../lib/hooks';
import { catalog } from '../lib/services';
import { PHONE_TEL } from '../lib/contact';
import { PlayStoreBadge } from '../components/Layout';


function Headline() {
  const { t } = useI18n();
  const words = [
    { text: t('hero.title1'), className: 'text-forest' },
    { text: t('hero.title2'), className: 'text-leaf' },
    { text: t('hero.title3'), className: 'text-forest' },
  ];
  return (
    <h1 className="font-display text-[clamp(2.75rem,8vw,6rem)] font-extrabold leading-[0.95] tracking-tight">
      {words.map((w, i) => (
        <span key={i} className="inline-block overflow-hidden pb-2 align-bottom">
          <motion.span
            className={`inline-block ${w.className}`}
            initial={{ y: '110%', rotate: 6 }}
            animate={{ y: 0, rotate: 0 }}
            transition={{ delay: 0.15 + i * 0.12, duration: 0.9, ease: [0.16, 1, 0.3, 1] }}
          >
            {w.text}
            {i === 1 && (
              <motion.svg viewBox="0 0 200 20" className="-mt-2 block h-4 w-full text-tangerine" initial="h" animate="s">
                <motion.path
                  d="M3 14 C 50 4, 120 4, 197 12"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="5"
                  strokeLinecap="round"
                  variants={{ h: { pathLength: 0 }, s: { pathLength: 1, transition: { delay: 0.9, duration: 0.8 } } }}
                />
              </motion.svg>
            )}
          </motion.span>
          {i < words.length - 1 && <span>&nbsp;</span>}
        </span>
      ))}
    </h1>
  );
}

/**
 * The hero visual: the logo inside a slowly turning dashed ring, with the four
 * things Saji delivers (the logo's own icons) orbiting and drifting with the
 * pointer, and a scooter riding speed lines underneath.
 */
function HeroOrb() {
  const { t } = useI18n();
  const mx = useMotionValue(0);
  const my = useMotionValue(0);
  const sx = useSpring(mx, { stiffness: 80, damping: 18 });
  const sy = useSpring(my, { stiffness: 80, damping: 18 });
  const near = { x: useTransform(sx, (v) => v * 28), y: useTransform(sy, (v) => v * 28) };
  const far = { x: useTransform(sx, (v) => v * -14), y: useTransform(sy, (v) => v * -14) };
  const orbit = [
    { icon: 'burger', label: t('hero.floatFood'), tone: 'bg-tangerine text-white', pos: 'top-[6%] start-[2%]', delay: 0 },
    { icon: 'basket', label: t('hero.floatFruits'), tone: 'bg-leaf text-white', pos: 'top-[12%] end-[0%]', delay: 0.8 },
    { icon: 'store', label: t('hero.floatShops'), tone: 'bg-white text-forest', pos: 'bottom-[22%] start-0', delay: 1.6 },
    { icon: 'package', label: t('hero.floatAny'), tone: 'bg-forest text-white', pos: 'bottom-[16%] end-0', delay: 2.4 },
  ];
  return (
    <div
      className="relative mx-auto aspect-square w-full max-w-[520px]"
      onPointerMove={(e) => {
        const r = e.currentTarget.getBoundingClientRect();
        mx.set((e.clientX - r.left) / r.width - 0.5);
        my.set((e.clientY - r.top) / r.height - 0.5);
      }}
      onPointerLeave={() => {
        mx.set(0);
        my.set(0);
      }}
    >
      <motion.div style={far} className="absolute inset-[6%] rounded-full bg-gradient-to-br from-leaf-tint via-white to-tangerine-soft" />
      <motion.svg
        viewBox="0 0 100 100"
        className="absolute inset-[2%] animate-spin-slow text-leaf"
        initial={{ opacity: 0, scale: 0.8 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 1.2 }}
      >
        <circle cx="50" cy="50" r="48" fill="none" stroke="currentColor" strokeWidth=".8" strokeDasharray="1 3" strokeLinecap="round" />
      </motion.svg>
      <motion.svg viewBox="0 0 100 100" className="absolute inset-[10%] text-leaf" initial="h" animate="s">
        <motion.circle
          cx="50" cy="50" r="46" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"
          strokeDasharray="230 60"
          variants={{ h: { pathLength: 0, rotate: -90 }, s: { pathLength: 1, rotate: 200, transition: { duration: 2, ease: [0.16, 1, 0.3, 1] } } }}
          style={{ originX: '50%', originY: '50%' }}
        />
      </motion.svg>
      <motion.div
        style={near}
        initial={{ scale: 0.6, opacity: 0, rotate: -12 }}
        animate={{ scale: 1, opacity: 1, rotate: 0 }}
        transition={{ type: 'spring', stiffness: 120, damping: 14, delay: 0.3 }}
        className="absolute inset-[22%] grid place-items-center rounded-full bg-cream shadow-lift"
      >
        <motion.img
          src="/brand/logo-mark.png"
          alt="ساجي"
          className="w-[82%] mix-blend-multiply"
          animate={{ y: [0, -8, 0] }}
          transition={{ duration: 4, repeat: Infinity, ease: 'easeInOut' }}
        />
      </motion.div>
      {orbit.map((o, i) => (
        <motion.div
          key={o.icon}
          style={i % 2 ? far : near}
          className={`absolute ${o.pos}`}
          initial={{ opacity: 0, scale: 0 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ type: 'spring', stiffness: 220, damping: 14, delay: 0.7 + i * 0.12 }}
        >
          <motion.div
            animate={{ y: [0, -14, 0], rotate: [0, i % 2 ? 4 : -4, 0] }}
            transition={{ duration: 5 + i, repeat: Infinity, ease: 'easeInOut', delay: o.delay }}
            className={`flex items-center gap-2 rounded-2xl px-3.5 py-2.5 shadow-lift ${o.tone}`}
          >
            <Icon name={o.icon} className="h-6 w-6" />
            <span className="whitespace-nowrap text-sm font-bold">{o.label}</span>
          </motion.div>
        </motion.div>
      ))}
      <div className="absolute inset-x-0 bottom-[2%] flex justify-center">
        <motion.div
          className="relative flex items-center"
          initial={{ x: -260, opacity: 0 }}
          animate={{ x: 0, opacity: 1 }}
          transition={{ delay: 1.2, type: 'spring', stiffness: 60, damping: 12 }}
        >
          <div className="me-2 flex flex-col gap-1.5" aria-hidden="true">
            {[28, 40, 22].map((w, i) => (
              <span key={i} className="block h-1.5 animate-speed rounded-full bg-leaf" style={{ width: w, animationDelay: `${i * 0.18}s` }} />
            ))}
          </div>
          <motion.span
            className="block text-6xl drop-shadow-lg"
            animate={{ y: [0, -4, 0], rotate: [0, -2, 0] }}
            transition={{ duration: 0.5, repeat: Infinity }}
          >
            🛵
          </motion.span>
        </motion.div>
      </div>
    </div>
  );
}

/** Live figures from the API — never hard-coded marketing numbers. */
function HeroStats() {
  const { t } = useI18n();
  const stores = useAsync(() => catalog.vendors({ limit: 1 }), []);
  const cats = useAsync(() => catalog.categories(), []);
  const stats = [
    { value: stores.data?.total, label: t('hero.statStores') },
    { value: cats.data?.length, label: t('hero.statCategories') },
  ];
  return (
    <motion.div variants={stagger} initial="hidden" animate="show" className="mt-10 grid max-w-xl grid-cols-3 gap-4">
      {stats.map((s) => (
        <motion.div key={s.label} variants={rise} className="rounded-3xl bg-white/70 p-4 shadow-card backdrop-blur">
          {typeof s.value === 'number' ? (
            <CountOnView to={s.value} className="font-display text-3xl font-extrabold text-forest md:text-4xl" />
          ) : (
            <Skeleton className="h-9 w-12" />
          )}
          <p className="mt-1 text-xs font-bold leading-tight text-ink-soft md:text-sm">{s.label}</p>
        </motion.div>
      ))}
      <motion.div variants={rise} className="rounded-3xl bg-forest p-4 text-white shadow-card">
        <span className="relative flex h-9 w-9 items-center justify-center">
          <span className="absolute inline-flex h-full w-full animate-ping2 rounded-full bg-leaf/50" />
          <Icon name="pin" className="relative h-7 w-7 text-leaf-bright" />
        </span>
        <p className="mt-1 text-xs font-bold leading-tight md:text-sm">{t('hero.statLive')}</p>
      </motion.div>
    </motion.div>
  );
}

function Hero() {
  const { t } = useI18n();
  const navigate = useNavigate();
  const [q, setQ] = useState('');
  const ref = useRef(null);
  const { scrollYProgress } = useScroll({ target: ref, offset: ['start start', 'end start'] });
  const y = useTransform(scrollYProgress, [0, 1], [0, 120]);
  const fade = useTransform(scrollYProgress, [0, 0.8], [1, 0]);
  return (
    <section ref={ref} className="relative overflow-hidden pb-16 pt-6 md:pb-24">
      <div aria-hidden="true" className="pointer-events-none absolute inset-0">
        <motion.div
          animate={{ x: [0, 40, 0], y: [0, 30, 0] }}
          transition={{ duration: 18, repeat: Infinity, ease: 'easeInOut' }}
          className="absolute -top-32 start-[-10%] h-[28rem] w-[28rem] rounded-full bg-leaf/20 blur-3xl"
        />
        <motion.div
          animate={{ x: [0, -30, 0], y: [0, 40, 0] }}
          transition={{ duration: 22, repeat: Infinity, ease: 'easeInOut' }}
          className="absolute end-[-8%] top-20 h-[24rem] w-[24rem] rounded-full bg-tangerine/15 blur-3xl"
        />
      </div>
      <motion.div style={{ y, opacity: fade }} className="container-x relative grid grid-cols-1 items-center gap-12 lg:grid-cols-[1.1fr_1fr]">
        {/* min-w-0: a grid item otherwise grows to its widest child and overflows on phones. */}
        <div className="min-w-0">
          <motion.span
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            className="inline-flex items-center gap-2 rounded-full bg-white px-4 py-2 text-sm font-bold text-forest shadow-card"
          >
            <span className="relative flex h-2.5 w-2.5">
              <span className="absolute inline-flex h-full w-full animate-ping2 rounded-full bg-leaf" />
              <span className="relative inline-flex h-2.5 w-2.5 rounded-full bg-leaf" />
            </span>
            {t('hero.badge')}
          </motion.span>
          <div className="mt-6">
            <Headline />
          </div>
          <motion.p
            initial={{ opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.55, duration: 0.7 }}
            className="mt-6 max-w-xl text-lg leading-relaxed text-ink-soft md:text-xl"
          >
            {t('hero.subtitle')}
          </motion.p>
          <motion.form
            initial={{ opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.7, duration: 0.7 }}
            onSubmit={(e) => {
              e.preventDefault();
              navigate(q.trim() ? `/stores?search=${encodeURIComponent(q.trim())}` : '/stores');
            }}
            className="group mt-8 flex max-w-xl items-center gap-2 rounded-3xl bg-white p-2 shadow-lift ring-1 ring-forest/5 transition focus-within:ring-4 focus-within:ring-leaf/20"
          >
            <Icon name="search" className="ms-3 h-6 w-6 shrink-0 text-ink-muted transition group-focus-within:text-leaf" />
            <input
              value={q}
              onChange={(e) => setQ(e.target.value)}
              placeholder={t('hero.searchPlaceholder')}
              className="min-w-0 flex-1 bg-transparent px-2 py-3 text-lg outline-none placeholder:text-ink-muted"
            />
            <Button type="submit" size="lg" iconEnd="arrow">{t('hero.cta')}</Button>
          </motion.form>
          <HeroStats />
        </div>
        <HeroOrb />
      </motion.div>
    </section>
  );
}

function Marquee() {
  const { t } = useI18n();
  const items = t('home.marquee').split('·').map((s) => s.trim());
  const row = [...items, ...items, ...items, ...items];
  return (
    <div className="relative -rotate-2 overflow-hidden bg-forest py-5 text-white shadow-lift" dir="ltr">
      <div className="flex w-max animate-marquee gap-10 whitespace-nowrap">
        {row.map((item, i) => (
          <span key={i} className="flex items-center gap-10 font-display text-2xl font-bold md:text-3xl">
            {item}
            <Icon name="sparkles" className="h-6 w-6 text-leaf-bright" />
          </span>
        ))}
      </div>
    </div>
  );
}

function SectionHead({ title, sub, to, cta }) {
  return (
    <div className="mb-8 flex items-end justify-between gap-4">
      <div>
        <Reveal as="h2" className="text-3xl font-extrabold md:text-5xl">{title}</Reveal>
        {sub && <Reveal delay={0.08} className="mt-2 text-ink-soft">{sub}</Reveal>}
      </div>
      {to && (
        <Link to={to} className="group flex shrink-0 items-center gap-1.5 font-bold text-forest">
          {cta}
          <Icon name="arrow" className="h-4 w-4 transition-transform group-hover:translate-x-1 rtl:group-hover:-translate-x-1" />
        </Link>
      )}
    </div>
  );
}

function Categories() {
  const { t } = useI18n();
  const navigate = useNavigate();
  const { data, loading } = useAsync(() => catalog.categories(), []);
  return (
    <section className="container-x pt-24">
      <SectionHead title={t('home.categories')} />
      <div className="scrollbar-none -mx-4 flex gap-3 overflow-x-auto px-4 pb-4 sm:flex-wrap sm:justify-start">
        {loading
          ? Array.from({ length: 6 }, (_, i) => <Skeleton key={i} className="h-28 w-24 shrink-0 rounded-[1.75rem]" />)
          : (data ?? []).map((c, i) => (
              <CategoryTile key={c.id} category={c} index={i} onClick={() => navigate(`/stores?category=${c.id}`)} />
            ))}
      </div>
    </section>
  );
}

function Offers() {
  const { t } = useI18n();
  const { data, loading } = useAsync(() => catalog.homeOffers(), []);
  const rail = useRef(null);
  if (!loading && !(data ?? []).length) return null;
  const scrollBy = (d) => rail.current?.scrollBy({ left: d * rail.current.clientWidth * 0.8, behavior: 'smooth' });
  return (
    <section className="pt-24">
      <div className="container-x">
        <div className="mb-8 flex items-end justify-between gap-4">
          <Reveal as="h2" className="text-3xl font-extrabold md:text-5xl">{t('home.offers')}</Reveal>
          <div className="hidden gap-2 sm:flex" dir="ltr">
            <button type="button" onClick={() => scrollBy(-1)} aria-label="previous" className="grid h-11 w-11 place-items-center rounded-full bg-white shadow-card transition hover:-translate-x-0.5">
              <Icon name="chevron" className="h-5 w-5 rotate-180" />
            </button>
            <button type="button" onClick={() => scrollBy(1)} aria-label="next" className="grid h-11 w-11 place-items-center rounded-full bg-white shadow-card transition hover:translate-x-0.5">
              <Icon name="chevron" className="h-5 w-5" />
            </button>
          </div>
        </div>
      </div>
      <div ref={rail} className="scrollbar-none flex snap-x snap-mandatory gap-5 overflow-x-auto px-4 pb-6 sm:px-[max(1.5rem,calc((100vw-80rem)/2+1.5rem))]">
        {loading
          ? Array.from({ length: 3 }, (_, i) => <Skeleton key={i} className="h-[190px] w-[85vw] shrink-0 rounded-4xl sm:w-[440px]" />)
          : data.map((offer, i) => (
              <motion.div
                key={offer.id}
                initial={{ opacity: 0, x: 60 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.08, duration: 0.6, ease: [0.16, 1, 0.3, 1] }}
                className="w-[85vw] shrink-0 snap-start sm:w-[440px]"
              >
                <OfferCard offer={offer} index={i} />
              </motion.div>
            ))}
      </div>
    </section>
  );
}

function VendorGrid({ title, sort, to }) {
  const { t } = useI18n();
  const { data, loading, error, reload } = useAsync(() => catalog.vendors({ sort, limit: 6 }), [sort]);
  const slow = useSlow(loading);
  const items = data?.items ?? [];
  if (!loading && !error && items.length === 0) return null;
  return (
    <section className="container-x pt-24">
      <SectionHead title={title} to={to} cta={t('common.seeAll')} />
      {slow && <p className="mb-4 text-center text-sm font-bold text-ink-muted">{t('common.waking')}</p>}
      {error ? (
        <div className="text-center">
          <Button variant="outline" icon="refresh" onClick={reload}>{t('common.retry')}</Button>
        </div>
      ) : (
        <div className="grid gap-x-6 gap-y-10 sm:grid-cols-2 lg:grid-cols-3">
          {loading
            ? Array.from({ length: 3 }, (_, i) => <VendorCardSkeleton key={i} />)
            : items.map((v, i) => <VendorCard key={v.id} vendor={v} index={i} />)}
        </div>
      )}
    </section>
  );
}

/** Three steps joined by a dashed road that draws itself as the section scrolls by. */
function HowItWorks() {
  const { t } = useI18n();
  const ref = useRef(null);
  const { scrollYProgress } = useScroll({ target: ref, offset: ['start 80%', 'end 60%'] });
  const draw = useSpring(scrollYProgress, { stiffness: 80, damping: 20 });
  const steps = [
    { icon: 'store', title: t('home.how1'), text: t('home.how1Text'), tone: 'bg-tangerine' },
    { icon: 'phone', title: t('home.how2'), text: t('home.how2Text'), tone: 'bg-leaf' },
    { icon: 'bike', title: t('home.how3'), text: t('home.how3Text'), tone: 'bg-forest' },
  ];
  return (
    <section ref={ref} className="container-x pt-28">
      <div className="text-center">
        <Reveal as="h2" className="text-3xl font-extrabold md:text-5xl">{t('home.howTitle')}</Reveal>
        <Reveal delay={0.08} className="mt-3 text-lg text-ink-soft">{t('home.howSub')}</Reveal>
      </div>
      <div className="relative mt-16">
        <svg viewBox="0 0 1000 120" preserveAspectRatio="none" className="absolute inset-x-[8%] top-6 hidden h-28 w-[84%] md:block" aria-hidden="true">
          <motion.path
            d="M0 60 C 160 -10, 330 130, 500 60 S 840 -10, 1000 60"
            fill="none" stroke="#5BB22F" strokeWidth="4" strokeDasharray="10 14" strokeLinecap="round"
            style={{ pathLength: draw }}
          />
        </svg>
        <div className="relative grid gap-8 md:grid-cols-3">
          {steps.map((s, i) => (
            <Reveal key={s.title} delay={i * 0.15} className="flex flex-col items-center text-center">
              <motion.div
                whileHover={{ rotate: [0, -10, 10, 0], scale: 1.08 }}
                className={`relative grid h-24 w-24 place-items-center rounded-[2rem] text-white shadow-lift ${s.tone}`}
              >
                <Icon name={s.icon} className="h-10 w-10" strokeWidth={1.8} />
                <span className="num absolute -end-2 -top-2 grid h-9 w-9 place-items-center rounded-full bg-white font-display text-lg font-extrabold text-forest shadow-card">
                  {i + 1}
                </span>
              </motion.div>
              <h3 className="mt-6 text-2xl font-extrabold">{s.title}</h3>
              <p className="mt-2 max-w-xs text-ink-soft">{s.text}</p>
            </Reveal>
          ))}
        </div>
      </div>
    </section>
  );
}

function AppBand() {
  const { t } = useI18n();
  return (
    <section className="container-x pt-28">
      <Reveal className="relative overflow-hidden rounded-[2.5rem] bg-forest px-6 py-14 text-white md:px-14">
        <div aria-hidden="true" className="absolute inset-0 opacity-[.07] speed-lines text-white" />
        <motion.div
          aria-hidden="true"
          animate={{ rotate: 360 }}
          transition={{ duration: 60, repeat: Infinity, ease: 'linear' }}
          className="absolute -end-24 -top-24 h-80 w-80 rounded-full border-[28px] border-leaf/30"
        />
        <div className="relative grid items-center gap-10 md:grid-cols-[1.3fr_1fr]">
          <div>
            <h2 className="text-4xl font-extrabold md:text-5xl">{t('home.appTitle')}</h2>
            <p className="mt-4 max-w-lg text-lg text-white/80">{t('home.appText')}</p>
            <div className="mt-8 flex flex-wrap gap-3">
              <PlayStoreBadge />
            </div>
            <div className="mt-10 rounded-3xl bg-white/10 p-5 backdrop-blur">
              <p className="font-display text-xl font-bold">{t('home.joinTitle')}</p>
              <p className="mt-1 text-sm text-white/75">{t('home.joinText')}</p>
              <a href={PHONE_TEL} className="mt-3 inline-flex items-center gap-2 font-bold text-leaf-bright hover:underline">
                <Icon name="phone" className="h-4 w-4" />
                {t('home.joinBtn')}
              </a>
            </div>
          </div>
          <motion.div
            initial={{ rotate: 8, y: 40, opacity: 0 }}
            whileInView={{ rotate: -4, y: 0, opacity: 1 }}
            viewport={{ once: true }}
            transition={{ type: 'spring', stiffness: 60, damping: 14 }}
            className="mx-auto w-56 rounded-[2.5rem] border-[10px] border-forest-deep bg-cream p-4 shadow-2xl md:w-64"
          >
            <div className="mx-auto mb-4 h-1.5 w-16 rounded-full bg-forest-deep/20" />
            <img src="/brand/logo-mark.png" alt="" className="mx-auto w-3/4 mix-blend-multiply" />
            <div className="mt-4 space-y-2">
              {['bg-tangerine', 'bg-leaf', 'bg-forest'].map((c, i) => (
                <motion.div
                  key={c}
                  animate={{ x: [0, 4, 0] }}
                  transition={{ duration: 2, repeat: Infinity, delay: i * 0.3 }}
                  className="flex items-center gap-2 rounded-2xl bg-white p-2 shadow-card"
                >
                  <span className={`h-8 w-8 rounded-xl ${c}`} />
                  <span className="h-2 flex-1 rounded-full bg-ink/10" />
                </motion.div>
              ))}
            </div>
          </motion.div>
        </div>
      </Reveal>
    </section>
  );
}

export default function Home() {
  const { t } = useI18n();
  return (
    <>
      <Hero />
      <Marquee />
      <Categories />
      <Offers />
      <VendorGrid title={t('home.featured')} sort="featured" to="/stores" />
      <HowItWorks />
      <VendorGrid title={t('home.topRated')} sort="rating" to="/stores?sort=rating" />
      <VendorGrid title={t('home.fastest')} sort="fastest" to="/stores?sort=fastest" />
      <AppBand />
    </>
  );
}
