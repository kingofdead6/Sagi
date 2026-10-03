import { useEffect, useState } from 'react';
import { Link, NavLink, Outlet, useLocation } from 'react-router-dom';
import { AnimatePresence, motion } from 'framer-motion';
import { Icon } from '../../components/Icon';
import { useAuth } from '../../state/auth';

export const NAV = [
  { to: '/admin', label: 'لوحة التحكم', icon: 'home', end: true },
  { to: '/admin/orders', label: 'الطلبات', icon: 'receipt' },
  { to: '/admin/categories', label: 'الفئات', icon: 'basket' },
  { to: '/admin/vendors', label: 'المتاجر', icon: 'store' },
  { to: '/admin/products', label: 'المنتجات', icon: 'package' },
  { to: '/admin/offers', label: 'العروض', icon: 'gift' },
  { to: '/admin/vouchers', label: 'القسائم', icon: 'tag' },
  { to: '/admin/agents', label: 'السائقون', icon: 'bike' },
  { to: '/admin/customers', label: 'العملاء', icon: 'user' },
  { to: '/admin/analytics', label: 'الإحصائيات', icon: 'chart' },
  { to: '/admin/settings', label: 'الإعدادات', icon: 'sliders' },
];

function currentLabel(pathname) {
  const match = [...NAV]
    .sort((a, b) => b.to.length - a.to.length)
    .find((n) => (n.end ? pathname === n.to || pathname === `${n.to}/` : pathname.startsWith(n.to)));
  return match?.label ?? 'لوحة الإدارة';
}

function Brand() {
  return (
    <Link to="/admin" className="flex items-center gap-2">
      <img src="/brand/logo-mark.png" alt="" className="h-9 w-9 rounded-xl object-contain mix-blend-multiply" />
      <span className="font-display text-lg font-extrabold text-forest">لوحة ساجي</span>
    </Link>
  );
}

function NavList({ onNavigate }) {
  return (
    <nav className="flex-1 space-y-1 overflow-y-auto p-3">
      {NAV.map((item) => (
        <NavLink
          key={item.to}
          to={item.to}
          end={item.end}
          onClick={onNavigate}
          className={({ isActive }) =>
            `flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-bold transition lg:py-2.5 ${
              isActive ? 'bg-forest text-white' : 'text-ink-soft hover:bg-forest/5 hover:text-forest'
            }`
          }
        >
          <Icon name={item.icon} className="h-5 w-5 shrink-0" />
          {item.label}
        </NavLink>
      ))}
    </nav>
  );
}

function UserBox() {
  const { user, logout } = useAuth();
  return (
    <div className="border-t border-ink/5 p-3">
      <div className="mb-2 truncate px-2 text-xs font-semibold text-ink-muted">
        {user?.fullName} · <span dir="ltr">{user?.phone}</span>
      </div>
      <Link
        to="/"
        className="flex items-center gap-3 rounded-xl px-4 py-2.5 text-sm font-bold text-ink-soft hover:bg-forest/5"
      >
        <Icon name="globe" className="h-5 w-5" />
        الموقع
      </Link>
      <button
        type="button"
        onClick={logout}
        className="flex w-full items-center gap-3 rounded-xl px-4 py-2.5 text-start text-sm font-bold text-tomato hover:bg-red-50"
      >
        <Icon name="logout" className="h-5 w-5" />
        تسجيل الخروج
      </button>
    </div>
  );
}

/**
 * The admin panel's frame. A fixed sidebar from `lg`; below that a sticky
 * top bar whose menu button slides the same navigation in as a drawer.
 * The panel is Arabic-only, so it pins its own direction whatever the
 * site language is.
 */
export default function AdminShell() {
  const { pathname } = useLocation();
  const [open, setOpen] = useState(false);

  // Close the drawer on navigation and lock the page behind it while open.
  useEffect(() => setOpen(false), [pathname]);
  useEffect(() => {
    if (!open) return undefined;
    const prev = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    const onKey = (e) => e.key === 'Escape' && setOpen(false);
    window.addEventListener('keydown', onKey);
    return () => {
      document.body.style.overflow = prev;
      window.removeEventListener('keydown', onKey);
    };
  }, [open]);

  return (
    <div dir="rtl" lang="ar" className="min-h-screen bg-cream lg:flex">
      <aside className="sticky top-0 hidden h-screen w-64 shrink-0 flex-col border-e border-ink/5 bg-white lg:flex">
        <div className="border-b border-ink/5 px-5 py-4">
          <Brand />
        </div>
        <NavList />
        <UserBox />
      </aside>

      <header
        className="sticky top-0 z-40 flex items-center gap-3 border-b border-ink/5 bg-white/90 px-4 py-2.5 backdrop-blur-xl lg:hidden"
        style={{ paddingTop: 'max(0.625rem, env(safe-area-inset-top))' }}
      >
        <button
          type="button"
          onClick={() => setOpen(true)}
          className="grid h-11 w-11 shrink-0 place-items-center rounded-xl bg-forest/5 text-forest"
          aria-label="القائمة"
          aria-expanded={open}
        >
          <Icon name="menu" className="h-6 w-6" />
        </button>
        <p className="min-w-0 flex-1 truncate font-display text-lg font-extrabold">{currentLabel(pathname)}</p>
        <Link to="/admin" aria-label="لوحة ساجي">
          <img src="/brand/logo-mark.png" alt="" className="h-9 w-9 object-contain mix-blend-multiply" />
        </Link>
      </header>

      <AnimatePresence>
        {open && (
          <div className="fixed inset-0 z-[60] lg:hidden">
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="absolute inset-0 bg-forest-deep/40 backdrop-blur-sm"
              onClick={() => setOpen(false)}
            />
            <motion.aside
              role="dialog"
              aria-modal="true"
              initial={{ x: '100%' }}
              animate={{ x: 0 }}
              exit={{ x: '100%' }}
              transition={{ type: 'spring', stiffness: 340, damping: 36 }}
              className="absolute inset-y-0 right-0 flex w-[82%] max-w-xs flex-col bg-white shadow-lift"
              style={{ paddingTop: 'env(safe-area-inset-top)', paddingBottom: 'env(safe-area-inset-bottom)' }}
            >
              <div className="flex items-center justify-between border-b border-ink/5 px-4 py-3">
                <Brand />
                <button
                  type="button"
                  onClick={() => setOpen(false)}
                  className="grid h-10 w-10 place-items-center rounded-full text-ink-muted hover:bg-ink/5"
                  aria-label="إغلاق"
                >
                  <Icon name="x" className="h-5 w-5" />
                </button>
              </div>
              <NavList onNavigate={() => setOpen(false)} />
              <UserBox />
            </motion.aside>
          </div>
        )}
      </AnimatePresence>

      <main className="min-w-0 flex-1 px-4 pb-10 pt-5 sm:px-6 lg:p-8">
        <Outlet />
      </main>
    </div>
  );
}
