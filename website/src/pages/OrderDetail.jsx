import { Suspense, lazy, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { AnimatePresence, motion } from 'framer-motion';
import { Icon } from '../components/Icon';
import { Badge, Button, ErrorState, Img, Modal, Skeleton, Stars, Textarea } from '../components/ui';
import { StatusStepper } from '../components/Effects';
import { useI18n } from '../state/i18n';
import { useToast } from '../state/toast';
import { useAsync } from '../lib/hooks';
import { useOrderRoom, useSocketEvent } from '../lib/socket';
import { orders as ordersApi } from '../lib/services';
import { TONE, isActive } from '../lib/orderStatus';
import { dateTime, localPhone, money, timeOnly, toLatLng } from '../lib/format';

const LiveMap = lazy(() => import('../components/Maps').then((m) => ({ default: m.LiveMap })));
const RATED_KEY = 'saji.rated';
const EN_ROUTE = ['accepted', 'picked_up', 'on_the_way'];

function ratedSet() {
  try {
    return new Set(JSON.parse(localStorage.getItem(RATED_KEY) || '[]'));
  } catch {
    return new Set();
  }
}
function markRated(id) {
  try {
    localStorage.setItem(RATED_KEY, JSON.stringify([...ratedSet(), id].slice(-200)));
  } catch {
    /* fine */
  }
}

function CancelSheet({ open, onClose, order, onDone }) {
  const { t, errorText } = useI18n();
  const toast = useToast();
  const [reason, setReason] = useState('');
  const [busy, setBusy] = useState(false);
  const submit = async () => {
    if (reason.trim().length < 3) return;
    setBusy(true);
    try {
      await ordersApi.cancel(order.id, reason.trim());
      toast.success(t('orders.cancelled'));
      onDone();
      onClose();
    } catch (e) {
      toast.error(errorText(e));
    } finally {
      setBusy(false);
    }
  };
  return (
    <Modal
      open={open}
      onClose={onClose}
      title={t('orders.cancelTitle')}
      footer={<Button variant="danger" size="lg" className="w-full" loading={busy} disabled={reason.trim().length < 3} onClick={submit}>{t('orders.cancel')}</Button>}
    >
      <div className="space-y-3 p-6">
        <div className="flex flex-wrap gap-2">
          {t('orders.reasons').map((r) => (
            <button key={r} type="button" onClick={() => setReason(r)} className={`chip ${reason === r ? 'chip-on' : ''}`}>{r}</button>
          ))}
        </div>
        <Textarea value={reason} onChange={(e) => setReason(e.target.value)} maxLength={200} placeholder={t('orders.cancelReason')} />
      </div>
    </Modal>
  );
}

function RateSheet({ open, onClose, order, onDone }) {
  const { t, errorText } = useI18n();
  const toast = useToast();
  const [vendorRating, setVendorRating] = useState(0);
  const [agentRating, setAgentRating] = useState(0);
  const [comment, setComment] = useState('');
  const [busy, setBusy] = useState(false);
  const submit = async () => {
    setBusy(true);
    try {
      await ordersApi.rate(order.id, {
        vendorRating,
        ...(agentRating ? { agentRating } : {}),
        ...(comment.trim() ? { comment: comment.trim() } : {}),
      });
      toast.success(t('orders.rated'));
      onDone();
      onClose();
    } catch (e) {
      // Already rated (from the app, say): remember it and stop offering.
      if (e?.response?.status === 409) onDone();
      toast.error(errorText(e));
    } finally {
      setBusy(false);
    }
  };
  return (
    <Modal
      open={open}
      onClose={onClose}
      title={t('orders.rateTitle')}
      footer={<Button size="lg" className="w-full" loading={busy} disabled={!vendorRating} onClick={submit} icon="send">{t('orders.rateSubmit')}</Button>}
    >
      <div className="space-y-6 p-6">
        <div className="text-center">
          <p className="mb-2 font-bold">{t('orders.rateVendor')} · {order.vendor?.name}</p>
          <Stars value={vendorRating} onChange={setVendorRating} size="h-10 w-10" />
        </div>
        {order.agent && (
          <div className="text-center">
            <p className="mb-2 font-bold">{t('orders.rateAgent')} · {order.agent.fullName}</p>
            <Stars value={agentRating} onChange={setAgentRating} size="h-10 w-10" />
          </div>
        )}
        <Textarea value={comment} onChange={(e) => setComment(e.target.value)} maxLength={500} placeholder={t('orders.rateComment')} />
      </div>
    </Modal>
  );
}

export default function OrderDetail() {
  const { id } = useParams();
  const { t, lang } = useI18n();
  const order = useAsync(() => ordersApi.get(id), [id]);
  const [driver, setDriver] = useState(null);
  const [cancelOpen, setCancelOpen] = useState(false);
  const [rateOpen, setRateOpen] = useState(false);
  const [rated, setRated] = useState(() => ratedSet().has(id));

  useOrderRoom(id);
  useSocketEvent('order:status', (p) => p?.orderId === id && order.reload(), [id]);
  useSocketEvent('agent:location', (p) => {
    if (p?.orderId === id && typeof p.lat === 'number') setDriver([p.lat, p.lng]);
  }, [id]);

  if (order.error) return <ErrorState error={order.error} onRetry={order.reload} />;
  const o = order.data;
  if (!o) {
    return (
      <div className="container-x space-y-4 pt-6">
        <Skeleton className="h-10 w-1/3" />
        <Skeleton className="h-40 rounded-4xl" />
        <Skeleton className="h-72 rounded-4xl" />
      </div>
    );
  }

  const active = isActive(o.status);
  const store = toLatLng(o.vendor?.location);
  const home = toLatLng(o.deliveryLocation);
  const enRoute = EN_ROUTE.includes(o.status);
  const lastCancel = o.status === 'cancelled' ? [...(o.events ?? [])].reverse().find((e) => e.to === 'cancelled') : null;

  return (
    <div className="container-x pb-12 pt-6">
      <Link to="/orders" className="inline-flex items-center gap-1.5 text-sm font-bold text-ink-soft hover:text-forest">
        <Icon name="chevron" className="h-4 w-4 rotate-180" /> {t('orders.title')}
      </Link>
      <div className="mt-3 flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="num text-3xl font-extrabold md:text-4xl">{t('orders.code', { code: o.code })}</h1>
          <p className="mt-1 text-sm text-ink-muted">{t('orders.placedAt', { date: dateTime(o.createdAt, lang) })}</p>
        </div>
        <div className="flex items-center gap-2">
          {o.deliveryType === 'vip' && <Badge tone="tangerine"><Icon name="crown" className="h-3.5 w-3.5" /> VIP</Badge>}
          <Badge tone={TONE[o.status]} pulse={active}>{t(`status.${o.status}`)}</Badge>
          {active && <Badge tone="forest" pulse>{t('orders.liveBadge')}</Badge>}
        </div>
      </div>

      <div className="mt-6 grid gap-6 lg:grid-cols-[1fr_380px]">
        <div className="space-y-6">
          <motion.section initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="card overflow-hidden p-5 md:p-6">
            {o.status === 'cancelled' ? (
              <div className="flex items-center gap-4 rounded-3xl bg-red-50 p-5 text-tomato">
                <Icon name="x" className="h-8 w-8" />
                <div>
                  <p className="text-lg font-bold">{t('status.cancelled')}</p>
                  {lastCancel?.note && <p className="text-sm">{t('orders.cancelledReason', { reason: lastCancel.note })}</p>}
                </div>
              </div>
            ) : (
              <StatusStepper status={o.status} />
            )}
          </motion.section>

          <motion.section initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.08 }} className="space-y-3">
            <AnimatePresence>
              {enRoute && (
                <motion.div initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: 'auto' }} className="flex items-center gap-2 font-bold text-forest">
                  <span className="relative flex h-3 w-3">
                    <span className="absolute h-full w-full animate-ping2 rounded-full bg-leaf" />
                    <span className="relative h-3 w-3 rounded-full bg-leaf" />
                  </span>
                  {t('orders.liveMap')}
                </motion.div>
              )}
              {o.status === 'assigned' && (
                <motion.p initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="flex items-center gap-2 font-bold text-ink-soft">
                  <motion.span animate={{ rotate: 360 }} transition={{ repeat: Infinity, duration: 2, ease: 'linear' }}>
                    <Icon name="refresh" className="h-4 w-4" />
                  </motion.span>
                  {t('orders.waitingAgent')}
                </motion.p>
              )}
            </AnimatePresence>
            <Suspense fallback={<Skeleton className="h-80 rounded-4xl" />}>
              <LiveMap store={store} home={home} driver={enRoute ? driver : null} className="h-80" />
            </Suspense>
          </motion.section>

          {o.agent && (
            <motion.section initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} className="card flex items-center gap-4 p-5">
              <div className="grid h-14 w-14 place-items-center rounded-full bg-gradient-to-br from-leaf to-forest text-2xl">🛵</div>
              <div className="flex-1">
                <p className="text-xs font-bold text-ink-muted">{t('orders.agent')}</p>
                <p className="text-lg font-bold">{o.agent.fullName}</p>
              </div>
              {o.agent.phone && (
                <a href={`tel:${o.agent.phone}`}>
                  <Button variant="leaf" icon="phone">{t('common.call')}</Button>
                </a>
              )}
            </motion.section>
          )}

          <section className="card p-5 md:p-6">
            <h2 className="mb-4 text-xl font-bold">{t('orders.timeline')}</h2>
            <ol className="relative space-y-4 border-s-2 border-dashed border-leaf/30 ps-6">
              {(o.events ?? []).map((e, i) => (
                <motion.li
                  key={`${e.to}-${e.at}`}
                  initial={{ opacity: 0, x: 20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: i * 0.06 }}
                  className="relative"
                >
                  <span className={`absolute -start-[33px] top-0.5 h-4 w-4 rounded-full ring-4 ring-white ${i === o.events.length - 1 ? 'bg-leaf' : 'bg-forest/40'}`} />
                  <p className="font-bold">{t(`status.${e.to}`)}</p>
                  <p className="num text-xs text-ink-muted">{timeOnly(e.at, lang)}</p>
                  {e.note && e.to !== 'cancelled' && <p className="mt-0.5 text-sm text-ink-soft">{e.note}</p>}
                </motion.li>
              ))}
            </ol>
          </section>
        </div>

        <aside className="space-y-6 lg:sticky lg:top-24 lg:self-start">
          <section className="overflow-hidden rounded-4xl bg-white shadow-lift">
            {/* The call button sits beside the store link, not inside it: an <a> in an <a> is invalid. */}
            <div className="flex items-center gap-3 bg-forest p-5 text-white">
              <Link to={`/stores/${o.vendor?.id}`} className="flex min-w-0 flex-1 items-center gap-3">
                <Img image={o.vendor?.logo} ratio={1} width={96} className="h-12 w-12 shrink-0 rounded-xl bg-white" fallback="store" />
                <div className="min-w-0">
                  <p className="text-xs text-white/70">{t('orders.vendor')}</p>
                  <p className="truncate font-display text-xl font-bold">{o.vendor?.name}</p>
                </div>
              </Link>
              {o.vendor?.phone && (
                <a href={`tel:${o.vendor.phone}`} aria-label={t('common.call')} className="grid h-10 w-10 shrink-0 place-items-center rounded-full bg-white/15 hover:bg-white/25">
                  <Icon name="phone" className="h-5 w-5" />
                </a>
              )}
            </div>
            <div className="p-5">
              <p className="mb-3 text-sm font-bold text-ink-muted">{t('orders.itemsTitle')}</p>
              <ul className="space-y-3">
                {o.items.map((item, i) => (
                  <li key={i} className="flex justify-between gap-3 text-sm">
                    <span>
                      <span className="num me-1 font-black text-leaf">{item.qty}×</span>
                      <span className="font-bold">{item.nameSnapshot}</span>
                      {item.selectedOptions?.length > 0 && (
                        <span className="block text-xs text-ink-muted">{item.selectedOptions.map((s) => s.value).join('، ')}</span>
                      )}
                    </span>
                    <span className="num shrink-0 font-bold">{money(item.lineTotalCentimes, lang)}</span>
                  </li>
                ))}
              </ul>
              <div className="mt-4 space-y-2 border-t border-dashed border-ink/10 pt-4 text-sm">
                <div className="flex justify-between"><span className="text-ink-soft">{t('checkout.subtotal')}</span><span className="num font-bold">{money(o.subtotalCentimes, lang)}</span></div>
                {o.serviceFeeCentimes > 0 && <div className="flex justify-between"><span className="text-ink-soft">{t('checkout.serviceFee')}</span><span className="num font-bold">{money(o.serviceFeeCentimes, lang)}</span></div>}
                <div className="flex justify-between"><span className="text-ink-soft">{t('checkout.deliveryFee')}</span><span className="num font-bold">{money(o.deliveryFeeCentimes, lang)}</span></div>
                {o.discountCentimes > 0 && <div className="flex justify-between text-leaf"><span>−</span><span className="num font-bold">−{money(o.discountCentimes, lang)}</span></div>}
                <div className="flex items-end justify-between pt-2">
                  <span className="text-lg font-extrabold">{t('checkout.total')}</span>
                  <span className="num font-display text-3xl font-extrabold text-forest">{money(o.totalCentimes, lang)}</span>
                </div>
                <p className="flex items-center gap-1.5 pt-1 text-xs text-ink-muted"><Icon name="coins" className="h-4 w-4" />{t('orders.paymentCash')}</p>
              </div>
            </div>
          </section>

          <section className="card p-5">
            <p className="mb-2 text-sm font-bold text-ink-muted">{t('orders.deliveryAddress')}</p>
            <p className="flex gap-2 font-bold">
              <Icon name="pin" className="h-5 w-5 shrink-0 text-leaf" />
              <span>
                {o.address?.label} — {[o.address?.street, o.address?.commune, o.address?.wilaya].filter(Boolean).join('، ')}
                {o.address?.notes && <span className="block text-sm font-normal text-ink-muted">{o.address.notes}</span>}
              </span>
            </p>
            {o.customerNote && <p className="mt-3 rounded-2xl bg-cream p-3 text-sm text-ink-soft">“{o.customerNote}”</p>}
          </section>

          {o.status === 'pending' && (
            <div>
              <Button variant="outline" className="w-full !text-tomato" icon="x" onClick={() => setCancelOpen(true)}>{t('orders.cancel')}</Button>
              <p className="mt-2 text-center text-xs text-ink-muted">{t('orders.cancelOnlyPending')}</p>
            </div>
          )}
          {o.status === 'delivered' && !rated && (
            <motion.div initial={{ scale: 0.9, opacity: 0 }} animate={{ scale: 1, opacity: 1 }}>
              <Button variant="accent" size="lg" className="w-full" icon="star" onClick={() => setRateOpen(true)}>{t('orders.rate')}</Button>
            </motion.div>
          )}
          {o.vendor?.phone && active && (
            <p className="num text-center text-xs text-ink-muted">{t('orders.vendor')}: {localPhone(o.vendor.phone)}</p>
          )}
        </aside>
      </div>

      <CancelSheet open={cancelOpen} onClose={() => setCancelOpen(false)} order={o} onDone={order.reload} />
      <RateSheet
        open={rateOpen}
        onClose={() => setRateOpen(false)}
        order={o}
        onDone={() => {
          markRated(o.id);
          setRated(true);
        }}
      />
    </div>
  );
}
