import { Suspense, forwardRef, lazy, useCallback, useEffect, useRef, useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { Icon } from '../components/Icon';
import { Badge, Button, CountOnView, EmptyState, ErrorState, Modal, Segmented, Skeleton, Switch } from '../components/ui';
import { CountdownRing, SlideToConfirm } from '../components/Effects';
import { useI18n } from '../state/i18n';
import { useToast } from '../state/toast';
import { useAsync } from '../lib/hooks';
import { emitAgentLocation, getSocket, useSocketEvent } from '../lib/socket';
import { agent as agentApi } from '../lib/services';
import { TONE } from '../lib/orderStatus';
import { dateTime, localPhone, mapsLink, money } from '../lib/format';

const LiveMap = lazy(() => import('../components/Maps').then((m) => ({ default: m.LiveMap })));

/**
 * Shares the driver's GPS while they are online or carrying an order. The
 * socket is preferred (the server throttles it to one fix per 5s); when it is
 * down, fixes go over HTTP instead so the customer's map keeps moving.
 */
function useLocationSharing(enabled) {
  const [fix, setFix] = useState(null);
  const [denied, setDenied] = useState(false);
  const last = useRef(0);
  const latest = useRef(null);
  useEffect(() => {
    if (!enabled || !('geolocation' in navigator)) return undefined;
    const send = (point) => {
      last.current = Date.now();
      if (getSocket().connected) emitAgentLocation(point);
      else agentApi.location(point).catch(() => {});
    };
    const id = navigator.geolocation.watchPosition(
      (pos) => {
        setDenied(false);
        const point = {
          lat: pos.coords.latitude,
          lng: pos.coords.longitude,
          ...(pos.coords.heading != null && !Number.isNaN(pos.coords.heading) ? { heading: pos.coords.heading } : {}),
          ...(pos.coords.speed != null && pos.coords.speed >= 0 ? { speed: pos.coords.speed } : {}),
        };
        setFix([point.lat, point.lng]);
        latest.current = point;
        const now = Date.now();
        if (now - last.current < 5000) return;
        send(point);
      },
      () => setDenied(true),
      { enableHighAccuracy: true, maximumAge: 5000, timeout: 20_000 },
    );
    // watchPosition only fires on movement. A driver waiting at the store
    // still needs to appear on the customer's map, so repeat the last fix.
    const heartbeat = setInterval(() => {
      if (latest.current && Date.now() - last.current >= 15_000) send(latest.current);
    }, 5_000);
    return () => {
      navigator.geolocation.clearWatch(id);
      clearInterval(heartbeat);
    };
  }, [enabled]);
  return { fix, denied };
}

function Stat({ icon, label, value, suffix, tone, delay }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay }}
      className="card relative overflow-hidden p-5"
    >
      <span className={`mb-3 grid h-10 w-10 place-items-center rounded-xl ${tone}`}>
        <Icon name={icon} className="h-5 w-5" />
      </span>
      <p className="font-display text-3xl font-extrabold">
        <CountOnView to={value ?? 0} />
        {suffix && <span className="ms-1 text-base font-bold text-ink-muted">{suffix}</span>}
      </p>
      <p className="text-sm font-bold text-ink-muted">{label}</p>
    </motion.div>
  );
}

// popLayout measures its children, so the card must forward a ref.
const OfferCard = forwardRef(function OfferCard({ offer, onAccept, onReject, busy }, ref) {
  const { t, lang } = useI18n();
  const [expired, setExpired] = useState(false);
  return (
    <motion.div
      ref={ref}
      layout
      initial={{ opacity: 0, scale: 0.9, y: 30 }}
      animate={{ opacity: 1, scale: 1, y: 0 }}
      exit={{ opacity: 0, x: 120, transition: { duration: 0.25 } }}
      transition={{ type: 'spring', stiffness: 260, damping: 22 }}
      className={`relative overflow-hidden rounded-4xl bg-white p-5 shadow-lift ring-2 ${expired ? 'opacity-50 ring-ink/10' : 'ring-leaf'}`}
    >
      <motion.div
        aria-hidden="true"
        className="absolute inset-x-0 top-0 h-1 bg-gradient-to-r from-leaf to-tangerine"
        animate={{ opacity: [1, 0.4, 1] }}
        transition={{ duration: 1.4, repeat: Infinity }}
      />
      <div className="flex items-start justify-between gap-4">
        <div>
          <Badge tone="tangerine"><Icon name="sparkles" className="h-3.5 w-3.5" />{t('driver.newOffer')}</Badge>
          <p className="num mt-2 text-sm text-ink-muted">#{offer.order?.code}</p>
          {offer.order?.deliveryType === 'vip' && <Badge tone="forest" className="mt-1">VIP</Badge>}
        </div>
        <div className="flex items-center gap-2">
          <span className="text-xs font-bold text-ink-muted">{t('driver.expires')}</span>
          <CountdownRing expiresAt={offer.expiresAt} totalSec={offer.timeoutSec} onExpire={() => setExpired(true)} />
        </div>
      </div>
      <div className="relative mt-4 space-y-3 ps-6">
        <span aria-hidden="true" className="absolute start-[7px] top-2 h-[calc(100%-1.25rem)] border-s-2 border-dashed border-leaf/40" />
        <div className="relative">
          <span className="absolute -start-6 top-1 h-4 w-4 rounded-full bg-tangerine ring-4 ring-tangerine-soft" />
          <p className="text-xs font-bold text-ink-muted">{t('driver.pickup')}</p>
          <p className="font-bold">{offer.pickup?.name}</p>
          <p className="text-sm text-ink-soft">{offer.pickup?.address}</p>
        </div>
        <div className="relative">
          <span className="absolute -start-6 top-1 h-4 w-4 rounded-full bg-forest ring-4 ring-leaf-tint" />
          <p className="text-xs font-bold text-ink-muted">{t('driver.dropoff')}</p>
          <p className="font-bold">{[offer.dropoff?.address?.street, offer.dropoff?.address?.commune].filter(Boolean).join('، ')}</p>
        </div>
      </div>
      <div className="mt-4 grid grid-cols-2 gap-3">
        <div className="rounded-2xl bg-cream p-3">
          <p className="text-xs font-bold text-ink-muted">{t('driver.distance')}</p>
          <p className="num font-display text-xl font-bold">{offer.distanceKm ?? '—'} {t('common.km')}</p>
        </div>
        <div className="rounded-2xl bg-leaf-tint p-3">
          <p className="text-xs font-bold text-forest/70">{t('driver.payout')}</p>
          <p className="num font-display text-xl font-bold text-forest">{money(offer.payoutCentimes, lang)}</p>
        </div>
      </div>
      {expired ? (
        <p className="mt-4 text-center font-bold text-ink-muted">{t('driver.expired')}</p>
      ) : (
        <div className="mt-4 flex gap-3">
          <Button variant="outline" className="flex-1 !text-tomato" onClick={() => onReject(offer)} disabled={busy}>{t('driver.reject')}</Button>
          <Button variant="leaf" className="flex-[2]" size="lg" icon="check" loading={busy} onClick={() => onAccept(offer)}>{t('driver.accept')}</Button>
        </div>
      )}
    </motion.div>
  );
});

function ActiveDelivery({ active, myFix, onChanged }) {
  const { t, lang, errorText } = useI18n();
  const toast = useToast();
  const [cashOk, setCashOk] = useState(false);
  const o = active.order;
  const pickup = active.pickup && typeof active.pickup.lat === 'number' ? [active.pickup.lat, active.pickup.lng] : null;
  const dropoff = active.dropoff && typeof active.dropoff.lat === 'number' ? [active.dropoff.lat, active.dropoff.lng] : null;
  const cash = o.paymentMethod === 'cash';

  const next = {
    accepted: { status: 'picked_up', label: t('driver.swipePickup'), target: pickup },
    picked_up: { status: 'on_the_way', label: t('driver.swipeOnTheWay'), target: dropoff },
    on_the_way: { status: 'delivered', label: t('driver.swipeDeliver'), target: dropoff },
  }[o.status];

  const advance = async () => {
    if (!next) return;
    try {
      await agentApi.setStatus(o.id, next.status, next.status === 'delivered' && cash ? { cashCollected: true } : {});
      if (next.status === 'delivered') toast.success(t('driver.deliveredDone'));
      onChanged();
    } catch (e) {
      toast.error(errorText(e));
      throw e;
    }
  };

  const steps = ['accepted', 'picked_up', 'on_the_way'];
  const at = steps.indexOf(o.status);

  return (
    <motion.section initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="overflow-hidden rounded-4xl bg-white shadow-lift">
      <div className="flex items-center justify-between bg-forest p-5 text-white">
        <div>
          <p className="text-xs text-white/70">{t('driver.active')}</p>
          <p className="num font-display text-2xl font-bold">#{o.code}</p>
        </div>
        <Badge tone="white" pulse>{t(`status.${o.status}`)}</Badge>
      </div>
      <div className="flex gap-1 px-5 pt-4">
        {steps.map((s, i) => (
          <motion.span key={s} className="h-1.5 flex-1 rounded-full bg-ink/10" animate={{ backgroundColor: i <= at ? '#5BB22F' : 'rgba(21,34,24,.1)' }} />
        ))}
      </div>
      <div className="p-5">
        <Suspense fallback={<Skeleton className="h-64 rounded-4xl" />}>
          <LiveMap store={pickup} home={dropoff} driver={myFix} className="h-64" />
        </Suspense>
        <div className="mt-5 grid gap-3 sm:grid-cols-2">
          <div className={`rounded-3xl p-4 ${o.status === 'accepted' ? 'bg-tangerine-soft ring-2 ring-tangerine/40' : 'bg-cream'}`}>
            <p className="text-xs font-bold text-ink-muted">{t('driver.pickup')}</p>
            <p className="font-bold">{active.pickup?.name}</p>
            <p className="text-sm text-ink-soft">{active.pickup?.address}</p>
            <div className="mt-3 flex gap-2">
              {pickup && <a href={mapsLink(...pickup)} target="_blank" rel="noreferrer"><Button size="sm" variant="white" icon="navigation">{t('driver.navigate')}</Button></a>}
              {active.pickup?.phone && <a href={`tel:${active.pickup.phone}`}><Button size="sm" variant="white" icon="phone">{t('common.call')}</Button></a>}
            </div>
          </div>
          <div className={`rounded-3xl p-4 ${o.status !== 'accepted' ? 'bg-leaf-tint ring-2 ring-leaf/40' : 'bg-cream'}`}>
            <p className="text-xs font-bold text-ink-muted">{t('driver.customer')} · {o.customer?.fullName}</p>
            <p className="font-bold">{o.address?.label}</p>
            <p className="text-sm text-ink-soft">{[o.address?.street, o.address?.commune].filter(Boolean).join('، ')}</p>
            {o.address?.notes && <p className="text-xs text-ink-muted">{o.address.notes}</p>}
            <div className="mt-3 flex gap-2">
              {dropoff && <a href={mapsLink(...dropoff)} target="_blank" rel="noreferrer"><Button size="sm" variant="white" icon="navigation">{t('driver.navigate')}</Button></a>}
              {o.customer?.phone && <a href={`tel:${o.customer.phone}`}><Button size="sm" variant="white" icon="phone">{localPhone(o.customer.phone)}</Button></a>}
            </div>
          </div>
        </div>
        {o.customerNote && <p className="mt-3 rounded-2xl bg-cream p-3 text-sm"><span className="font-bold">{t('driver.note')}:</span> {o.customerNote}</p>}

        <details className="mt-3 rounded-2xl bg-cream p-3 text-sm">
          <summary className="cursor-pointer font-bold">{t('orders.itemsTitle')} ({o.items.reduce((n, i) => n + i.qty, 0)})</summary>
          <ul className="mt-2 space-y-1">
            {o.items.map((item, i) => (
              <li key={i}><span className="num font-black text-leaf">{item.qty}×</span> {item.nameSnapshot}{item.selectedOptions?.length ? ` (${item.selectedOptions.map((s) => s.value).join('، ')})` : ''}</li>
            ))}
          </ul>
        </details>

        {next?.status === 'delivered' && cash && (
          <motion.label initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="mt-5 flex items-center justify-between gap-4 rounded-3xl bg-tangerine-soft p-4">
            <span>
              <span className="block font-display text-2xl font-extrabold text-tangerine">{t('driver.cashCollect', { amount: money(o.totalCentimes, lang) })}</span>
              <span className="text-sm font-bold text-ink-soft">{t('driver.cashConfirm')}</span>
            </span>
            <Switch checked={cashOk} onChange={setCashOk} label={t('driver.cashConfirm')} size="lg" />
          </motion.label>
        )}
        {next && (
          <div className="mt-5">
            <SlideToConfirm
              key={o.status}
              label={next.label}
              tone={next.status === 'delivered' ? 'accent' : 'forest'}
              disabled={next.status === 'delivered' && cash && !cashOk}
              onConfirm={advance}
            />
          </div>
        )}
      </div>
    </motion.section>
  );
}

function History() {
  const { t, lang } = useI18n();
  const [filter, setFilter] = useState('all');
  const [state, setState] = useState({ items: [], page: 0, hasMore: false, loading: true, error: null });
  const load = useCallback(async (page) => {
    setState((s) => ({ ...s, loading: true, error: null }));
    try {
      const res = await agentApi.history({ status: filter === 'all' ? undefined : filter, page, limit: 20 });
      setState((s) => ({ items: page === 1 ? res.items : [...s.items, ...res.items], page, hasMore: res.hasMore, loading: false, error: null }));
    } catch (error) {
      setState((s) => ({ ...s, loading: false, error }));
    }
  }, [filter]);
  useEffect(() => {
    load(1);
  }, [load]);
  return (
    <div>
      <Segmented
        size="sm"
        value={filter}
        onChange={setFilter}
        options={[
          { value: 'all', label: t('driver.all') },
          { value: 'delivered', label: t('driver.delivered') },
          { value: 'cancelled', label: t('driver.cancelled') },
        ]}
      />
      <div className="mt-5 space-y-3">
        {state.error && !state.items.length ? (
          <ErrorState error={state.error} onRetry={() => load(1)} />
        ) : !state.loading && !state.items.length ? (
          <EmptyState icon="history" title={t('orders.empty')} />
        ) : (
          state.items.map((o, i) => (
            <motion.div
              key={o.id}
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: (i % 20) * 0.03 }}
              className="card flex items-center gap-4 p-4"
            >
              <span className={`grid h-11 w-11 place-items-center rounded-2xl ${o.status === 'delivered' ? 'bg-leaf-tint text-forest' : 'bg-red-50 text-tomato'}`}>
                <Icon name={o.status === 'delivered' ? 'check' : 'x'} />
              </span>
              <div className="min-w-0 flex-1">
                <p className="truncate font-bold">{o.vendor?.name} → {o.address?.commune}</p>
                <p className="num text-xs text-ink-muted">#{o.code} · {dateTime(o.deliveredAt ?? o.updatedAt, lang)}</p>
              </div>
              <div className="text-end">
                <p className="num font-display text-lg font-bold text-forest">+{money(o.deliveryFeeCentimes, lang)}</p>
                <Badge tone={TONE[o.status]}>{t(`status.${o.status}`)}</Badge>
              </div>
            </motion.div>
          ))
        )}
        {state.loading && Array.from({ length: 3 }, (_, i) => <Skeleton key={i} className="h-20 rounded-3xl" />)}
        {state.hasMore && !state.loading && (
          <div className="text-center"><Button variant="outline" onClick={() => load(state.page + 1)}>{t('orders.loadMore')}</Button></div>
        )}
      </div>
    </div>
  );
}

export default function Driver() {
  const { t, lang, errorText } = useI18n();
  const toast = useToast();
  const [tab, setTab] = useState('live');
  const status = useAsync(() => agentApi.status(), []);
  const stats = useAsync(() => agentApi.stats(), []);
  const active = useAsync(() => agentApi.active(), []);
  const [offers, setOffers] = useState([]);
  const [toggling, setToggling] = useState(false);
  const [busyOffer, setBusyOffer] = useState(null);
  const [rejecting, setRejecting] = useState(null);
  const [reason, setReason] = useState('');

  const online = Boolean(status.data?.isOnline);
  const hasActive = Boolean(active.data?.order);
  const { fix, denied } = useLocationSharing(online || hasActive);

  const loadOffers = useCallback(async () => {
    try {
      setOffers(await agentApi.offers());
    } catch {
      /* the next poll retries */
    }
  }, []);

  // Offers are pushed over the socket; polling covers a dropped connection.
  useEffect(() => {
    if (!online || hasActive) {
      setOffers([]);
      return undefined;
    }
    loadOffers();
    const id = setInterval(loadOffers, 12_000);
    return () => clearInterval(id);
  }, [online, hasActive, loadOffers]);

  useSocketEvent('order:assigned', () => loadOffers());
  useSocketEvent('order:status', () => {
    active.reload();
    stats.reload();
  });

  const toggle = async (value) => {
    setToggling(true);
    try {
      const next = await agentApi.setOnline(value);
      status.setData(next);
    } catch (e) {
      toast.error(errorText(e));
    } finally {
      setToggling(false);
    }
  };

  const accept = async (offer) => {
    setBusyOffer(offer.order.id);
    try {
      await agentApi.accept(offer.order.id);
      setOffers([]);
      active.reload();
    } catch (e) {
      toast.error(errorText(e));
      loadOffers();
    } finally {
      setBusyOffer(null);
    }
  };

  const reject = async () => {
    if (reason.trim().length < 2) return;
    const offer = rejecting;
    setBusyOffer(offer.order.id);
    try {
      await agentApi.reject(offer.order.id, reason.trim());
      setOffers((all) => all.filter((o) => o.order.id !== offer.order.id));
      setRejecting(null);
      setReason('');
      stats.reload();
    } catch (e) {
      toast.error(errorText(e));
    } finally {
      setBusyOffer(null);
    }
  };

  const s = stats.data;
  return (
    <div className="container-x pb-12 pt-6">
      <div className="flex flex-wrap items-center justify-between gap-4">
        <motion.h1 initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} className="text-4xl font-extrabold md:text-5xl">{t('driver.title')}</motion.h1>
        <Segmented value={tab} onChange={setTab} options={[{ value: 'live', label: t('driver.today'), icon: 'bike' }, { value: 'history', label: t('driver.history'), icon: 'history' }]} />
      </div>

      {tab === 'history' ? (
        <div className="mt-8"><History /></div>
      ) : (
        <>
          <motion.div
            layout
            className={`relative mt-8 overflow-hidden rounded-[2.5rem] p-6 text-white shadow-lift transition-colors duration-700 md:p-8 ${online ? 'bg-forest' : 'bg-ink-soft'}`}
          >
            <AnimatePresence>
              {online && (
                <motion.div key="waves" initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} aria-hidden="true" className="absolute end-10 top-1/2 -translate-y-1/2">
                  {[0, 1, 2].map((i) => (
                    <motion.span
                      key={i}
                      className="absolute -translate-x-1/2 -translate-y-1/2 rounded-full border-2 border-leaf-bright"
                      initial={{ width: 40, height: 40, opacity: 0.8 }}
                      animate={{ width: 260, height: 260, opacity: 0 }}
                      transition={{ duration: 2.4, repeat: Infinity, delay: i * 0.8, ease: 'easeOut' }}
                    />
                  ))}
                </motion.div>
              )}
            </AnimatePresence>
            <div className="relative flex flex-wrap items-center justify-between gap-6">
              <div>
                <p className="flex items-center gap-2 text-sm font-bold text-white/70">
                  <span className={`h-2.5 w-2.5 rounded-full ${online ? 'bg-leaf-bright' : 'bg-white/40'}`} />
                  {online ? t('driver.online') : t('driver.offline')}
                </p>
                <p className="mt-1 font-display text-3xl font-extrabold md:text-4xl">{online ? t('driver.noOffersHint') : t('driver.offlineHint')}</p>
                {(online || hasActive) && (
                  <p className="mt-2 flex items-center gap-2 text-sm text-white/80">
                    <Icon name={denied ? 'alert' : 'target'} className="h-4 w-4" />
                    {denied ? t('driver.locationOff') : t('driver.sharing')}
                  </p>
                )}
              </div>
              {status.loading ? (
                <Skeleton className="h-9 w-16 rounded-full" />
              ) : (
                <div className="flex items-center gap-3 rounded-full bg-white/10 py-2 pe-2 ps-5 backdrop-blur">
                  <span className="font-bold">{online ? t('driver.goOffline') : t('driver.goOnline')}</span>
                  <Switch checked={online} onChange={toggle} disabled={toggling} size="lg" label={t('driver.goOnline')} />
                </div>
              )}
            </div>
          </motion.div>

          <div className="mt-6 grid grid-cols-2 gap-4 md:grid-cols-4">
            <Stat icon="bike" label={t('driver.today')} value={s?.todayDeliveries} tone="bg-leaf-tint text-forest" delay={0} />
            <Stat icon="package" label={t('driver.deliveries')} value={s?.deliveries} tone="bg-tangerine-soft text-tangerine" delay={0.05} />
            <Stat icon="coins" label={t('driver.earnings')} value={s ? Math.round(s.earningsCentimes / 100) : 0} suffix={lang === 'ar' ? 'دج' : 'DA'} tone="bg-forest/10 text-forest" delay={0.1} />
            <Stat icon="clock" label={t('driver.avgTime')} value={s?.avgMinutes} suffix={t('common.minutes')} tone="bg-sky-50 text-sky-600" delay={0.15} />
          </div>

          <div className="mt-8">
            {active.loading ? (
              <Skeleton className="h-96 rounded-4xl" />
            ) : hasActive ? (
              <ActiveDelivery active={active.data} myFix={fix} onChanged={() => { active.reload(); stats.reload(); }} />
            ) : (
              <section>
                <h2 className="mb-4 flex items-center gap-3 text-2xl font-extrabold">
                  {t('driver.offers')}
                  {offers.length > 0 && <span className="num grid h-7 min-w-7 place-items-center rounded-full bg-tangerine px-2 text-sm text-white">{offers.length}</span>}
                </h2>
                {offers.length === 0 ? (
                  <div className="card">
                    <EmptyState icon={online ? 'bell' : 'power'} title={online ? t('driver.noOffers') : t('driver.offline')} text={online ? t('driver.noOffersHint') : t('driver.offlineHint')} />
                  </div>
                ) : (
                  <div className="grid gap-5 md:grid-cols-2">
                    <AnimatePresence mode="popLayout">
                      {offers.map((offer) => (
                        <OfferCard key={offer.assignmentId} offer={offer} busy={busyOffer === offer.order?.id} onAccept={accept} onReject={setRejecting} />
                      ))}
                    </AnimatePresence>
                  </div>
                )}
              </section>
            )}
          </div>
        </>
      )}

      <Modal
        open={Boolean(rejecting)}
        onClose={() => setRejecting(null)}
        title={t('driver.rejectReason')}
        footer={<Button variant="danger" size="lg" className="w-full" disabled={reason.trim().length < 2} loading={Boolean(busyOffer)} onClick={reject}>{t('driver.reject')}</Button>}
      >
        <div className="space-y-3 p-6">
          <div className="flex flex-wrap gap-2">
            {t('driver.rejectReasons').map((r) => (
              <button key={r} type="button" onClick={() => setReason(r)} className={`chip ${reason === r ? 'chip-on' : ''}`}>{r}</button>
            ))}
          </div>
          <input value={reason} onChange={(e) => setReason(e.target.value)} maxLength={160} className="field" placeholder={t('driver.rejectReason')} />
        </div>
      </Modal>
    </div>
  );
}
