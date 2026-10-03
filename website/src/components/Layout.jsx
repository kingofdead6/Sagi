import { useEffect, useRef, useState } from 'react';
import { Link, NavLink, useLocation, useNavigate } from 'react-router-dom';
import { AnimatePresence, motion, useAnimationControls, useMotionValueEvent, useScroll } from 'framer-motion';
import { Icon } from './Icon';
import { useAuth } from '../state/auth';
import { useCart } from '../state/cart';
import { LANGUAGES, useI18n } from '../state/i18n';
import { FACEBOOK_URL, INSTAGRAM_URL, PHONE_DISPLAY, PHONE_TEL, PLAY_STORE_URL } from '../lib/contact';

export function Logo({ className = 'h-11' }) {
  return (
    <Link to="/" className="flex shrink-0 items-center gap-2" aria-label="Saji">
      <motion.img
        src="/brand/logo-mark.png"
        alt=""
        whileHover={{ rotate: [-2, 3, -1, 0], scale: 1.06 }}
        transition={{ duration: 0.5 }}
        className={`${className} w-auto object-contain mix-blend-multiply`}
      />
    </Link>
  );
}

/** Which links a role sees; the customer set doubles as the guest set. */
function linksFor(role, t) {
  if (role === 'agent') return [{ to: '/driver', label: t('nav.driver'), icon: 'bike' }];
  if (role === 'vendor') return [{ to: '/portal', label: t('nav.portal'), icon: 'store' }];
  if (role === 'admin') return [{ to: '/admin', label: t('nav.admin'), icon: 'shield' }];
  return [
    { to: '/', label: t('nav.home'), icon: 'home', end: true },
    { to: '/stores', label: t('nav.stores'), icon: 'store' },
    { to: '/orders', label: t('nav.orders'), icon: 'receipt' },
  ];
}

function LanguageMenu() {
  const { lang, setLang } = useI18n();
  const [open, setOpen] = useState(false);
  const ref = useRef(null);
  useEffect(() => {
    if (!open) return undefined;
    const close = (e) => !ref.current?.contains(e.target) && setOpen(false);
    document.addEventListener('mousedown', close);
    return () => document.removeEventListener('mousedown', close);
  }, [open]);
  return (
    <div className="relative" ref={ref}>
      <button
        type="button"
        onClick={() => setOpen((o) => !o)}
        className="flex h-10 items-center gap-1.5 rounded-full px-3 text-sm font-bold text-ink-soft transition hover:bg-forest/5 hover:text-forest"
        aria-haspopup="menu"
        aria-expanded={open}
      >
        <Icon name="globe" className="h-[18px] w-[18px]" />
        <span className="uppercase">{lang}</span>
      </button>
      <AnimatePresence>
        {open && (
          <motion.div
            role="menu"
            initial={{ opacity: 0, y: -8, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: -6, scale: 0.97 }}
            transition={{ type: 'spring', stiffness: 500, damping: 34 }}
            className="absolute end-0 top-12 z-50 w-40 origin-top overflow-hidden rounded-2xl bg-white p-1.5 shadow-lift"
          >
            {LANGUAGES.map((l) => (
              <button
                key={l.code}
                type="button"
                role="menuitem"
                onClick={() => {
                  setLang(l.code);
                  setOpen(false);
                }}
                className={`flex w-full items-center justify-between rounded-xl px-3 py-2.5 text-start text-sm font-bold transition hover:bg-forest/5 ${
                  lang === l.code ? 'text-forest' : 'text-ink-soft'
                }`}
              >
                {l.label}
                {lang === l.code && <Icon name="check" className="h-4 w-4 text-leaf" />}
              </button>
            ))}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}

function CartButton() {
  const { count, open, bump } = useCart();
  const { t } = useI18n();
  const controls = useAnimationControls();
  const first = useRef(true);
  useEffect(() => {
    if (first.current) {
      first.current = false;
      return;
    }
    controls.start({ scale: [1, 1.3, 0.9, 1.08, 1], rotate: [0, -12, 10, -4, 0], transition: { duration: 0.6 } });
  }, [bump, controls]);
  return (
    <motion.button
      id="cart-target"
      type="button"
      onClick={open}
      animate={controls}
      whileTap={{ scale: 0.9 }}
      aria-label={t('nav.cart')}
      className="relative grid h-11 w-11 place-items-center rounded-full bg-forest text-white shadow-[0_8px_20px_-8px_rgba(14,77,43,.8)]"
    >
      <Icon name="bag" />
      <AnimatePresence>
        {count > 0 && (
          <motion.span
            key={count}
            initial={{ scale: 0, y: 6 }}
            animate={{ scale: 1, y: 0 }}
            exit={{ scale: 0 }}
            transition={{ type: 'spring', stiffness: 600, damping: 18 }}
            className="num absolute -end-1 -top-1 grid h-5 min-w-5 place-items-center rounded-full bg-tangerine px-1 text-[11px] font-black ring-2 ring-cream"
          >
            {count}
          </motion.span>
        )}
      </AnimatePresence>
    </motion.button>
  );
}

function AccountButton() {
  const { isAuthed, user } = useAuth();
  const { t } = useI18n();
  if (!isAuthed) {
    return (
      <Link
        to="/login"
        className="flex h-11 items-center gap-2 rounded-full bg-white px-4 text-sm font-bold text-forest shadow-card transition hover:shadow-lift"
      >
        <Icon name="user" className="h-[18px] w-[18px]" />
        <span className="hidden sm:inline">{t('nav.login')}</span>
      </Link>
    );
  }
  const initial = (user?.fullName || '?').trim().charAt(0);
  return (
    <Link
      to="/account"
      aria-label={t('nav.account')}
      className="grid h-11 w-11 place-items-center rounded-full bg-gradient-to-br from-leaf to-forest font-display text-lg font-bold text-white shadow-card ring-2 ring-white transition hover:scale-105"
    >
      {initial}
    </Link>
  );
}

export function Navbar() {
  const { role } = useAuth();
  const { t } = useI18n();
  const { scrollY } = useScroll();
  const [compact, setCompact] = useState(false);
  useMotionValueEvent(scrollY, 'change', (y) => setCompact(y > 24));
  const links = linksFor(role, t);
  const isCustomer = !role || role === 'customer';

  return (
    <motion.header
      initial={{ y: -80 }}
      animate={{ y: 0 }}
      transition={{ type: 'spring', stiffness: 200, damping: 26 }}
      className="sticky top-0 z-40"
    >
      <div
        className={`transition-all duration-300 ${
          compact ? 'bg-cream/80 py-2 shadow-[0_8px_30px_-20px_rgba(14,77,43,.45)] backdrop-blur-xl' : 'bg-transparent py-4'
        }`}
      >
        <div className="container-x flex items-center gap-4">
          <Logo className={compact ? 'h-10' : 'h-12'} />
          <nav className="ms-4 hidden items-center gap-1 md:flex">
            {links.map((l) => (
              <NavLink key={l.to} to={l.to} end={l.end} className="relative px-4 py-2 text-[15px] font-bold">
                {({ isActive }) => (
                  <>
                    {isActive && (
                      <motion.span
                        layoutId="nav-pill"
                        className="absolute inset-0 rounded-full bg-forest/[.07]"
                        transition={{ type: 'spring', stiffness: 500, damping: 36 }}
                      />
                    )}
                    <span className={`relative transition-colors ${isActive ? 'text-forest' : 'text-ink-soft hover:text-forest'}`}>
                      {l.label}
                    </span>
                  </>
                )}
              </NavLink>
            ))}
          </nav>
          <div className="ms-auto flex items-center gap-2">
            <LanguageMenu />
            {isCustomer && <CartButton />}
            <AccountButton />
          </div>
        </div>
      </div>
    </motion.header>
  );
}

/** Thumb-reach navigation for customers on phones. */
export function TabBar() {
  const { role } = useAuth();
  const { t } = useI18n();
  const { count, open } = useCart();
  if (role && role !== 'customer') return null;
  const tabs = [
    { to: '/', label: t('nav.home'), icon: 'home', end: true },
    { to: '/stores', label: t('nav.stores'), icon: 'store' },
    { cart: true, label: t('nav.cart'), icon: 'bag' },
    { to: '/orders', label: t('nav.orders'), icon: 'receipt' },
    { to: '/account', label: t('nav.account'), icon: 'user' },
  ];
  return (
    <nav className="fixed inset-x-3 bottom-3 z-40 md:hidden" style={{ marginBottom: 'env(safe-area-inset-bottom)' }}>
      <div className="flex items-center justify-around rounded-3xl bg-forest-deep/95 px-2 py-2 shadow-lift backdrop-blur-xl">
        {tabs.map((tab) =>
          tab.cart ? (
            <button
              key="cart"
              type="button"
              onClick={open}
              className="relative -mt-8 grid h-14 w-14 place-items-center rounded-full bg-tangerine text-white shadow-[0_10px_24px_-6px_rgba(242,122,26,.9)] ring-4 ring-cream"
              aria-label={tab.label}
            >
              <Icon name="bag" className="h-6 w-6" />
              {count > 0 && (
                <span className="num absolute -end-1 -top-1 grid h-5 min-w-5 place-items-center rounded-full bg-white px-1 text-[11px] font-black text-tangerine">
                  {count}
                </span>
              )}
            </button>
          ) : (
            <NavLink key={tab.to} to={tab.to} end={tab.end} className="relative flex flex-1 flex-col items-center gap-0.5 py-1.5">
              {({ isActive }) => (
                <>
                  {isActive && (
                    <motion.span layoutId="tab-dot" className="absolute -top-0.5 h-1 w-6 rounded-full bg-leaf-bright" />
                  )}
                  <Icon name={tab.icon} className={`h-[22px] w-[22px] transition ${isActive ? 'text-white' : 'text-white/50'}`} />
                  <span className={`text-[10px] font-bold ${isActive ? 'text-white' : 'text-white/50'}`}>{tab.label}</span>
                </>
              )}
            </NavLink>
          ),
        )}
      </div>
    </nav>
  );
}

/** "Get it on Google Play" — the app's only store. */
export function PlayStoreBadge({ className = '' }) {
  const { t } = useI18n();
  return (
    <motion.a
      href={PLAY_STORE_URL}
      target="_blank"
      rel="noreferrer"
      whileHover={{ y: -3 }}
      whileTap={{ scale: 0.97 }}
      className={`inline-flex items-center gap-3 rounded-2xl bg-black px-5 py-2.5 text-white ring-1 ring-white/20 transition-shadow hover:shadow-lift ${className}`}
    >
      <svg viewBox="0 0 24 24" className="h-7 w-7" aria-hidden="true">
        <path fill="#34A853" d="M3.6 2.3 13.4 12l-9.8 9.7a1.7 1.7 0 0 1-.6-1.3V3.6c0-.5.2-1 .6-1.3z" />
        <path fill="#FBBC04" d="m16.7 15.3-3.3-3.3 3.3-3.3 3.9 2.2c1.1.6 1.1 1.6 0 2.2z" />
        <path fill="#EA4335" d="M13.4 12 3.6 21.7c.4.4 1.1.4 1.8 0l11.3-6.4z" />
        <path fill="#4285F4" d="M13.4 12 16.7 8.7 5.4 2.3c-.7-.4-1.4-.4-1.8 0z" />
      </svg>
      <span className="text-start leading-tight">
        <span className="block text-[11px] text-white/70">{t('footer.getItOn')}</span>
        <span className="block font-display text-lg font-bold">Google Play</span>
      </span>
    </motion.a>
  );
}

export function Footer() {
  const { t } = useI18n();
  return (
    <footer className="relative mt-24 overflow-hidden bg-forest-deep pb-28 pt-16 text-white/80 md:pb-12">
      <div aria-hidden="true" className="pointer-events-none absolute -top-24 start-1/2 h-64 w-[120%] -translate-x-1/2 rounded-[50%] bg-forest/60 blur-3xl" />
      <div className="container-x relative grid gap-10 md:grid-cols-[1.4fr_1fr_1fr]">
        <div>
          <div className="inline-block rounded-3xl bg-cream p-3">
            <img src="/brand/logo-mark.png" alt="Saji" className="h-16 mix-blend-multiply" />
          </div>
          <p className="mt-4 max-w-sm font-display text-2xl font-bold text-white">{t('common.tagline')}</p>
          <p className="mt-2 text-sm">{t('footer.made')}</p>
          <PlayStoreBadge className="mt-6" />
        </div>
        <div>
          <h4 className="mb-3 font-display text-lg font-bold text-white">{t('footer.links')}</h4>
          <ul className="space-y-2 text-sm">
            <li><Link className="hover:text-leaf-bright" to="/stores">{t('nav.stores')}</Link></li>
            <li><Link className="hover:text-leaf-bright" to="/orders">{t('nav.orders')}</Link></li>
            <li><Link className="hover:text-leaf-bright" to="/account">{t('nav.account')}</Link></li>
          </ul>
        </div>
        <div>
          <h4 className="mb-3 font-display text-lg font-bold text-white">{t('footer.contact')}</h4>
          <a href={PHONE_TEL} className="num inline-flex items-center gap-2 text-sm hover:text-leaf-bright">
            <Icon name="phone" className="h-4 w-4" />
            {/* Spaced digit groups would reverse order in RTL; a phone always reads left-to-right. */}
            <span dir="ltr">{PHONE_DISPLAY}</span>
          </a>
          <div className="mt-4 flex gap-2">
            <a href={FACEBOOK_URL} target="_blank" rel="noreferrer" aria-label="Facebook"
              className="grid h-10 w-10 place-items-center rounded-full bg-white/10 transition hover:-translate-y-1 hover:bg-leaf">
              <Icon name="facebook" className="h-5 w-5" />
            </a>
            <a href={INSTAGRAM_URL} target="_blank" rel="noreferrer" aria-label="Instagram"
              className="grid h-10 w-10 place-items-center rounded-full bg-white/10 transition hover:-translate-y-1 hover:bg-tangerine">
              <Icon name="instagram" className="h-5 w-5" />
            </a>
          </div>
        </div>
      </div>
      <div className="container-x relative mt-12 border-t border-white/10 pt-6 text-xs">
        © {new Date().getFullYear()} Saji — {t('footer.rights')}
      </div>
    </footer>
  );
}

/**
 * Animates a product image from where it was added into the cart button —
 * fired with `flyToCart(element, src)` from anywhere.
 */
export function flyToCart(fromEl, src) {
  const rect = fromEl?.getBoundingClientRect?.();
  if (!rect) return;
  window.dispatchEvent(new CustomEvent('saji:fly', { detail: { rect, src } }));
}

export function FlyLayer() {
  const [flights, setFlights] = useState([]);
  useEffect(() => {
    const onFly = (e) => {
      const target = document.getElementById('cart-target') ?? document.querySelector('[aria-label][data-cart-tab]');
      const to = target?.getBoundingClientRect();
      if (!to) return;
      const id = Math.random();
      setFlights((f) => [...f, { id, from: e.detail.rect, to, src: e.detail.src }]);
      setTimeout(() => setFlights((f) => f.filter((x) => x.id !== id)), 900);
    };
    window.addEventListener('saji:fly', onFly);
    return () => window.removeEventListener('saji:fly', onFly);
  }, []);
  return (
    <div className="pointer-events-none fixed inset-0 z-[90]">
      {flights.map(({ id, from, to, src }) => {
        const size = 56;
        const sx = from.left + from.width / 2 - size / 2;
        const sy = from.top + from.height / 2 - size / 2;
        const ex = to.left + to.width / 2 - size / 2;
        const ey = to.top + to.height / 2 - size / 2;
        return (
          <motion.div
            key={id}
            initial={{ x: sx, y: sy, scale: 1, opacity: 1 }}
            animate={{ x: [sx, (sx + ex) / 2, ex], y: [sy, Math.min(sy, ey) - 120, ey], scale: [1, 0.8, 0.25], opacity: [1, 1, 0.4] }}
            transition={{ duration: 0.85, ease: [0.5, 0, 0.2, 1] }}
            className="absolute left-0 top-0 h-14 w-14 overflow-hidden rounded-full bg-leaf shadow-lift ring-4 ring-white"
          >
            {src ? <img src={src} alt="" className="h-full w-full object-cover" /> : <Icon name="bag" className="m-auto mt-4 h-6 w-6 text-white" />}
          </motion.div>
        );
      })}
    </div>
  );
}

/** Scroll to top on navigation, except when only the hash changes. */
export function ScrollToTop() {
  const { pathname } = useLocation();
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'instant' });
  }, [pathname]);
  return null;
}

export function useGo() {
  return useNavigate();
}

