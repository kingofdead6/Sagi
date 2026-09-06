import { NavLink, Outlet } from 'react-router-dom';
import { useAuth } from '../auth/AuthContext';

const NAV = [
  { to: '/', label: 'لوحة التحكم', end: true },
  { to: '/orders', label: 'الطلبات' },
  { to: '/categories', label: 'الفئات' },
  { to: '/vendors', label: 'المتاجر' },
  { to: '/products', label: 'المنتجات' },
  { to: '/offers', label: 'العروض' },
  { to: '/vouchers', label: 'القسائم' },
  { to: '/agents', label: 'السائقون' },
  { to: '/customers', label: 'العملاء' },
  { to: '/analytics', label: 'الإحصائيات' },
  { to: '/settings', label: 'الإعدادات' },
];

export default function AdminShell() {
  const { user, logout } = useAuth();

  return (
    <div className="flex min-h-screen bg-canvas">
      <aside className="flex w-64 shrink-0 flex-col border-l border-black/5 bg-white">
        <div className="flex items-center gap-2 border-b border-black/5 px-5 py-4">
          <img src="./assets/logo-mark.png" alt="" className="h-9 w-9 rounded-lg object-contain" />
          <span className="text-lg font-black">لوحة ساجي</span>
        </div>

        <nav className="flex-1 space-y-1 overflow-y-auto p-3">
          {NAV.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.end}
              className={({ isActive }) =>
                `block rounded-xl px-4 py-2.5 text-sm font-bold transition ${
                  isActive ? 'bg-brand text-white' : 'text-ink-soft hover:bg-black/5'
                }`
              }
            >
              {item.label}
            </NavLink>
          ))}
        </nav>

        <div className="border-t border-black/5 p-3">
          <div className="mb-2 truncate px-2 text-xs font-semibold text-ink-muted">
            {user?.fullName} · {user?.phone}
          </div>
          <button
            onClick={logout}
            className="w-full rounded-xl px-4 py-2.5 text-start text-sm font-bold text-red-600 hover:bg-red-50"
          >
            تسجيل الخروج
          </button>
        </div>
      </aside>

      <main className="min-w-0 flex-1 overflow-y-auto p-6">
        <Outlet />
      </main>
    </div>
  );
}
