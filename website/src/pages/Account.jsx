import { useEffect, useState } from 'react';
import { NavLink, Navigate, Route, Routes, useNavigate } from 'react-router-dom';
import { AnimatePresence, motion } from 'framer-motion';
import { Icon } from '../components/Icon';
import { Badge, Button, Confirm, CountOnView, EmptyState, Field, Input, Skeleton, Switch } from '../components/ui';
import { AddressForm } from '../components/AddressForm';
import { useAuth } from '../state/auth';
import { LANGUAGES, useI18n } from '../state/i18n';
import { useToast } from '../state/toast';
import { useAsync } from '../lib/hooks';
import { addresses as addressApi, auth as authApi, vouchers } from '../lib/services';
import { dateTime, localPhone, money } from '../lib/format';
import { readPrefs, writePrefs, chime } from './OrderNotifier';
import { FACEBOOK_URL, INSTAGRAM_URL, PHONE_TEL } from '../lib/contact';

function Panel({ title, children, action }) {
  return (
    <motion.section
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -10 }}
      transition={{ duration: 0.4, ease: [0.16, 1, 0.3, 1] }}
      className="card p-6 md:p-8"
    >
      <div className="mb-6 flex items-center justify-between gap-3">
        <h2 className="text-2xl font-extrabold">{title}</h2>
        {action}
      </div>
      {children}
    </motion.section>
  );
}

function Profile() {
  const { t, errorText } = useI18n();
  const { user, setUser, role } = useAuth();
  const toast = useToast();
  const [name, setName] = useState(user?.fullName ?? '');
  const [busy, setBusy] = useState(false);
  const save = async (e) => {
    e.preventDefault();
    if (name.trim().length < 2) return;
    setBusy(true);
    try {
      const next = await authApi.updateMe({ fullName: name.trim() });
      setUser(next);
      toast.success(t('account.saved'));
    } catch (err) {
      toast.error(errorText(err));
    } finally {
      setBusy(false);
    }
  };
  return (
    <div className="space-y-6">
      {role === 'customer' && (
        <motion.div
          initial={{ opacity: 0, scale: 0.96 }}
          animate={{ opacity: 1, scale: 1 }}
          className="relative overflow-hidden rounded-4xl bg-gradient-to-br from-forest via-forest-soft to-leaf p-7 text-white shadow-lift"
        >
          <motion.div
            aria-hidden="true"
            animate={{ rotate: 360 }}
            transition={{ duration: 40, repeat: Infinity, ease: 'linear' }}
            className="absolute -end-16 -top-16 h-56 w-56 rounded-full border-[22px] border-white/10"
          />
          <motion.span
            aria-hidden="true"
            animate={{ y: [0, -10, 0], rotate: [0, 12, 0] }}
            transition={{ duration: 4, repeat: Infinity }}
            className="absolute bottom-6 end-8 text-6xl"
          >
            🪙
          </motion.span>
          <p className="relative text-sm font-bold text-white/75">{t('account.points')}</p>
          <p className="relative mt-1 font-display text-6xl font-extrabold">
            <CountOnView to={user?.points ?? 0} />
          </p>
          <p className="relative mt-2 max-w-xs text-sm text-white/80">{t('account.pointsHint')}</p>
        </motion.div>
      )}
      <Panel title={t('account.profile')}>
        <form onSubmit={save} className="grid gap-4 sm:grid-cols-2">
          <Field label={t('account.fullName')}>
            <Input value={name} onChange={(e) => setName(e.target.value)} maxLength={80} />
          </Field>
          <Field label={t('account.phone')}>
            <Input value={localPhone(user?.phone)} disabled className="num opacity-70" />
          </Field>
          <div className="sm:col-span-2">
            <Button type="submit" loading={busy} disabled={name.trim() === user?.fullName || name.trim().length < 2} icon="check">
              {t('common.save')}
            </Button>
          </div>
        </form>
      </Panel>
    </div>
  );
}

function Addresses() {
  const { t, errorText } = useI18n();
  const toast = useToast();
  const list = useAsync(() => addressApi.list(), []);
  const [editing, setEditing] = useState(undefined);
  const [deleting, setDeleting] = useState(null);
  const [busy, setBusy] = useState(false);

  const makeDefault = async (a) => {
    try {
      await addressApi.setDefault(a.id);
      list.reload();
    } catch (e) {
      toast.error(errorText(e));
    }
  };

  return (
    <Panel title={t('account.addresses')} action={<Button size="sm" icon="plus" onClick={() => setEditing(null)}>{t('account.addressNew')}</Button>}>
      {list.loading ? (
        <div className="space-y-3">{[0, 1].map((i) => <Skeleton key={i} className="h-24 rounded-3xl" />)}</div>
      ) : (list.data ?? []).length === 0 ? (
        <EmptyState icon="pin" title={t('account.noAddresses')} action={<Button icon="plus" onClick={() => setEditing(null)}>{t('account.addressNew')}</Button>} />
      ) : (
        <motion.ul layout className="grid gap-3 sm:grid-cols-2">
          <AnimatePresence>
            {list.data.map((a, i) => (
              <motion.li
                key={a.id}
                layout
                initial={{ opacity: 0, y: 16 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, scale: 0.9 }}
                transition={{ delay: i * 0.05 }}
                className={`relative rounded-3xl border-2 p-5 ${a.isDefault ? 'border-leaf bg-leaf-tint/40' : 'border-ink/5'}`}
              >
                <div className="flex items-start justify-between gap-2">
                  <p className="flex items-center gap-2 text-lg font-bold">
                    <Icon name={a.label === t('account.labelWork') ? 'store' : 'home'} className="h-5 w-5 text-leaf" />
                    {a.label}
                  </p>
                  {a.isDefault && <Badge tone="forest">{t('account.default')}</Badge>}
                </div>
                <p className="mt-1 text-sm text-ink-soft">{[a.street, a.commune, a.wilaya].filter(Boolean).join('، ')}</p>
                {a.notes && <p className="text-xs text-ink-muted">{a.notes}</p>}
                <div className="mt-4 flex flex-wrap gap-2">
                  <Button size="sm" variant="soft" icon="pencil" onClick={() => setEditing(a)}>{t('common.edit')}</Button>
                  {!a.isDefault && <Button size="sm" variant="ghost" icon="check" onClick={() => makeDefault(a)}>{t('account.setDefault')}</Button>}
                  <Button size="sm" variant="ghost" className="!text-tomato" icon="trash" onClick={() => setDeleting(a)}>{t('common.delete')}</Button>
                </div>
              </motion.li>
            ))}
          </AnimatePresence>
        </motion.ul>
      )}
      <AddressForm open={editing !== undefined} address={editing} onClose={() => setEditing(undefined)} onSaved={() => list.reload()} />
      <Confirm
        open={Boolean(deleting)}
        danger
        loading={busy}
        title={t('account.deleteConfirm')}
        text={deleting?.label}
        confirmLabel={t('common.delete')}
        onClose={() => setDeleting(null)}
        onConfirm={async () => {
          setBusy(true);
          try {
            await addressApi.remove(deleting.id);
            setDeleting(null);
            list.reload();
          } catch (e) {
            toast.error(errorText(e));
          } finally {
            setBusy(false);
          }
        }}
      />
    </Panel>
  );
}

function Vouchers() {
  const { t, lang } = useI18n();
  const toast = useToast();
  const list = useAsync(() => vouchers.mine(), []);
  const label = (v) =>
    v.type === 'percentage'
      ? t('account.voucherPercent', { n: v.value })
      : v.type === 'fixed'
        ? t('account.voucherFixed', { amount: money(v.value, lang) })
        : t('account.voucherFree');
  return (
    <Panel title={t('account.vouchers')}>
      {list.loading ? (
        <Skeleton className="h-32 rounded-3xl" />
      ) : (list.data ?? []).length === 0 ? (
        <EmptyState icon="gift" title={t('account.vouchersEmpty')} />
      ) : (
        <div className="grid gap-4 sm:grid-cols-2">
          {list.data.map((v, i) => (
            <motion.button
              key={v.id}
              type="button"
              initial={{ opacity: 0, rotate: -3, y: 20 }}
              animate={{ opacity: 1, rotate: 0, y: 0 }}
              transition={{ delay: i * 0.07, type: 'spring', stiffness: 200, damping: 16 }}
              whileHover={{ y: -4, rotate: i % 2 ? 1 : -1 }}
              onClick={async () => {
                try {
                  await navigator.clipboard.writeText(v.code);
                  toast.success(`${t('account.copied')} — ${v.code}`);
                } catch {
                  /* clipboard blocked */
                }
              }}
              className="group relative flex overflow-hidden rounded-3xl bg-gradient-to-br from-tangerine to-[#F5A524] text-start text-white shadow-lift"
            >
              <div className="flex-1 p-5">
                <p className="font-display text-3xl font-extrabold">{label(v)}</p>
                {v.minOrderCentimes > 0 && <p className="mt-1 text-sm text-white/85">{t('account.voucherMin', { amount: money(v.minOrderCentimes, lang) })}</p>}
                {v.endsAt && <p className="text-xs text-white/75">{t('account.voucherEnds', { date: dateTime(v.endsAt, lang) })}</p>}
              </div>
              <div className="relative flex w-28 flex-col items-center justify-center border-s-2 border-dashed border-white/50 bg-white/10 p-3">
                <span className="absolute -top-3 start-[-0.75rem] h-6 w-6 rounded-full bg-white" />
                <span className="absolute -bottom-3 start-[-0.75rem] h-6 w-6 rounded-full bg-white" />
                <span className="num break-all text-center font-black tracking-wider">{v.code}</span>
                <span className="mt-1 flex items-center gap-1 text-xs opacity-80"><Icon name="copy" className="h-3.5 w-3.5" />{t('account.copy')}</span>
              </div>
            </motion.button>
          ))}
        </div>
      )}
    </Panel>
  );
}

function Security() {
  const { t, errorText } = useI18n();
  const { logout } = useAuth();
  const toast = useToast();
  const navigate = useNavigate();
  const [current, setCurrent] = useState('');
  const [next, setNext] = useState('');
  const [busy, setBusy] = useState(false);
  const submit = async (e) => {
    e.preventDefault();
    if (next.length < 6) return;
    setBusy(true);
    try {
      await authApi.changePassword(current, next);
      // The server revokes every session on a password change.
      toast.success(t('account.passwordChanged'));
      await logout();
      navigate('/login');
    } catch (err) {
      toast.error(errorText(err));
    } finally {
      setBusy(false);
    }
  };
  return (
    <Panel title={t('account.security')}>
      <form onSubmit={submit} className="grid max-w-md gap-4">
        <Field label={t('account.currentPassword')}>
          <Input type="password" value={current} onChange={(e) => setCurrent(e.target.value)} autoComplete="current-password" />
        </Field>
        <Field label={t('account.newPassword')} error={next && next.length < 6 ? t('auth.shortPassword') : null}>
          <Input type="password" value={next} onChange={(e) => setNext(e.target.value)} autoComplete="new-password" />
        </Field>
        <Button type="submit" loading={busy} disabled={!current || next.length < 6} icon="lock">{t('account.changePassword')}</Button>
      </form>
    </Panel>
  );
}

function Settings() {
  const { t, lang, setLang } = useI18n();
  const [prefs, setPrefs] = useState(readPrefs);
  const [permission, setPermission] = useState(() => ('Notification' in window ? Notification.permission : 'unsupported'));
  useEffect(() => writePrefs(prefs), [prefs]);
  const ask = async () => {
    if (!('Notification' in window)) return;
    const result = await Notification.requestPermission();
    setPermission(result);
  };
  return (
    <div className="space-y-6">
      <Panel title={t('account.notifications')}>
        <p className="mb-5 text-ink-soft">{t('account.notifText')}</p>
        <div className="mb-5">
          {permission === 'granted' ? (
            <Badge tone="leaf" className="!text-sm"><Icon name="check" className="h-4 w-4" />{t('account.notifEnabled')}</Badge>
          ) : permission === 'denied' ? (
            <Badge tone="tomato" className="!text-sm">{t('account.notifBlocked')}</Badge>
          ) : permission === 'unsupported' ? (
            <Badge tone="ink" className="!text-sm">{t('account.notifUnsupported')}</Badge>
          ) : (
            <Button icon="bell" onClick={ask}>{t('account.notifEnable')}</Button>
          )}
        </div>
        <div className="divide-y divide-ink/5 rounded-3xl border border-ink/5">
          <label className="flex items-center justify-between gap-4 p-4">
            <span className="flex items-center gap-3 font-bold"><Icon name="receipt" className="h-5 w-5 text-leaf" />{t('account.notifOrders')}</span>
            <Switch checked={prefs.orders} onChange={(v) => setPrefs((p) => ({ ...p, orders: v }))} label={t('account.notifOrders')} />
          </label>
          <label className="flex items-center justify-between gap-4 p-4">
            <span className="flex items-center gap-3 font-bold"><Icon name="bell" className="h-5 w-5 text-leaf" />{t('account.notifSound')}</span>
            <Switch
              checked={prefs.sound}
              onChange={(v) => {
                setPrefs((p) => ({ ...p, sound: v }));
                if (v) chime();
              }}
              label={t('account.notifSound')}
            />
          </label>
        </div>
      </Panel>
      <Panel title={t('account.language')}>
        <div className="grid gap-3 sm:grid-cols-3">
          {LANGUAGES.map((l) => (
            <motion.button
              key={l.code}
              type="button"
              whileTap={{ scale: 0.97 }}
              onClick={() => setLang(l.code)}
              className={`relative rounded-2xl border-2 p-4 text-center font-bold transition-colors ${lang === l.code ? 'border-transparent text-forest' : 'border-ink/5 text-ink-soft hover:border-leaf/40'}`}
            >
              {lang === l.code && <motion.span layoutId="lang" className="absolute inset-0 rounded-2xl border-2 border-leaf bg-leaf-tint/50" />}
              <span className="relative">{l.label}</span>
            </motion.button>
          ))}
        </div>
      </Panel>
      <Panel title={t('account.support')}>
        <div className="flex flex-wrap gap-3">
          <a href={PHONE_TEL}><Button variant="leaf" icon="phone">{t('account.supportText')}</Button></a>
          <a href={FACEBOOK_URL} target="_blank" rel="noreferrer"><Button variant="outline" icon="facebook">Facebook</Button></a>
          <a href={INSTAGRAM_URL} target="_blank" rel="noreferrer"><Button variant="outline" icon="instagram">Instagram</Button></a>
        </div>
      </Panel>
    </div>
  );
}

export default function Account() {
  const { t } = useI18n();
  const { user, role, logout } = useAuth();
  const navigate = useNavigate();
  const [confirmOut, setConfirmOut] = useState(false);
  const isCustomer = role === 'customer';
  const tabs = [
    { to: '/account', label: t('account.profile'), icon: 'user', end: true },
    ...(isCustomer
      ? [
          { to: '/account/addresses', label: t('account.addresses'), icon: 'pin' },
          { to: '/account/vouchers', label: t('account.vouchers'), icon: 'gift' },
        ]
      : []),
    { to: '/account/security', label: t('account.security'), icon: 'lock' },
    { to: '/account/settings', label: t('account.notifications'), icon: 'bell' },
  ];
  return (
    <div className="container-x pb-12 pt-6">
      <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="flex items-center gap-4">
        <motion.div
          initial={{ scale: 0, rotate: -30 }}
          animate={{ scale: 1, rotate: 0 }}
          transition={{ type: 'spring', stiffness: 200, damping: 12 }}
          className="grid h-16 w-16 place-items-center rounded-3xl bg-gradient-to-br from-leaf to-forest font-display text-3xl font-bold text-white shadow-lift"
        >
          {(user?.fullName || '?').charAt(0)}
        </motion.div>
        <div>
          <h1 className="text-3xl font-extrabold md:text-4xl">{t('account.hello', { name: user?.fullName?.split(' ')[0] ?? '' })}</h1>
          <p className="num text-sm text-ink-muted">{localPhone(user?.phone)}</p>
        </div>
      </motion.div>

      <div className="mt-8 grid gap-6 lg:grid-cols-[260px_1fr]">
        <nav className="scrollbar-none -mx-4 flex gap-1 overflow-x-auto px-4 lg:mx-0 lg:flex-col lg:px-0">
          {tabs.map((tab) => (
            <NavLink key={tab.to} to={tab.to} end={tab.end} className="relative shrink-0 rounded-2xl px-4 py-3 font-bold">
              {({ isActive }) => (
                <>
                  {isActive && <motion.span layoutId="acct-tab" className="absolute inset-0 rounded-2xl bg-white shadow-card" transition={{ type: 'spring', stiffness: 500, damping: 36 }} />}
                  <span className={`relative flex items-center gap-3 ${isActive ? 'text-forest' : 'text-ink-soft'}`}>
                    <Icon name={tab.icon} className="h-5 w-5" />
                    {tab.label}
                  </span>
                </>
              )}
            </NavLink>
          ))}
          <button type="button" onClick={() => setConfirmOut(true)} className="flex shrink-0 items-center gap-3 rounded-2xl px-4 py-3 font-bold text-tomato hover:bg-red-50 lg:mt-4">
            <Icon name="logout" className="h-5 w-5" />
            {t('account.logout')}
          </button>
        </nav>
        <div className="min-w-0">
          <AnimatePresence mode="wait">
            <Routes>
              <Route index element={<Profile />} />
              {isCustomer && <Route path="addresses" element={<Addresses />} />}
              {isCustomer && <Route path="vouchers" element={<Vouchers />} />}
              <Route path="security" element={<Security />} />
              <Route path="settings" element={<Settings />} />
              <Route path="*" element={<Navigate to="/account" replace />} />
            </Routes>
          </AnimatePresence>
        </div>
      </div>

      <Confirm
        open={confirmOut}
        title={t('account.logoutConfirm')}
        confirmLabel={t('account.logout')}
        danger
        onClose={() => setConfirmOut(false)}
        onConfirm={async () => {
          await logout();
          navigate('/');
        }}
      />
    </div>
  );
}
