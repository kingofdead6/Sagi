import { useEffect, useMemo, useRef, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { AnimatePresence, motion } from 'framer-motion';
import { Icon } from '../components/Icon';
import { Button, CountUp, EmptyState, Img, Input, Skeleton, Textarea } from '../components/ui';
import { AddressForm } from '../components/AddressForm';
import { optionLabel, useCart } from '../state/cart';
import { useAuth } from '../state/auth';
import { useI18n } from '../state/i18n';
import { useToast } from '../state/toast';
import { useAsync, useDebounced } from '../lib/hooks';
import { addresses as addressApi, orders, vouchers } from '../lib/services';
import { dinars, money } from '../lib/format';

function Card({ title, icon, children, delay = 0, action }) {
  return (
    <motion.section
      initial={{ opacity: 0, y: 24 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay, duration: 0.55, ease: [0.16, 1, 0.3, 1] }}
      className="card p-5 md:p-6"
    >
      <div className="mb-4 flex items-center justify-between gap-3">
        <h2 className="flex items-center gap-2.5 text-xl font-bold">
          <span className="grid h-9 w-9 place-items-center rounded-xl bg-leaf-tint text-forest">
            <Icon name={icon} className="h-5 w-5" />
          </span>
          {title}
        </h2>
        {action}
      </div>
      {children}
    </motion.section>
  );
}

function Choice({ selected, onClick, icon, title, hint, layoutId, badge }) {
  return (
    <motion.button
      type="button"
      onClick={onClick}
      whileTap={{ scale: 0.98 }}
      className={`relative flex flex-1 items-center gap-3 rounded-2xl border-2 p-4 text-start transition-colors ${selected ? 'border-transparent' : 'border-ink/5 hover:border-leaf/40'}`}
    >
      {selected && (
        <motion.span
          layoutId={layoutId}
          className="absolute inset-0 rounded-2xl border-2 border-leaf bg-leaf-tint/50"
          transition={{ type: 'spring', stiffness: 500, damping: 36 }}
        />
      )}
      <span className={`relative grid h-11 w-11 shrink-0 place-items-center rounded-xl ${selected ? 'bg-forest text-white' : 'bg-forest/5 text-forest'}`}>
        <Icon name={icon} />
      </span>
      <span className="relative min-w-0">
        <span className="flex items-center gap-2 font-bold">
          {title}
          {badge}
        </span>
        {hint && <span className="block text-sm text-ink-muted">{hint}</span>}
      </span>
    </motion.button>
  );
}

function Row({ label, value, tone = '', strong }) {
  return (
    <motion.div layout className={`flex items-center justify-between ${strong ? 'text-lg font-extrabold' : 'text-sm'} ${tone}`}>
      <span className={strong ? '' : 'text-ink-soft'}>{label}</span>
      <span className="num font-bold">{value}</span>
    </motion.div>
  );
}

export default function Checkout() {
  const { t, lang, errorText } = useI18n();
  const cart = useCart();
  const { user, refreshMe } = useAuth();
  const toast = useToast();
  const navigate = useNavigate();

  const addressList = useAsync(() => addressApi.list(), []);
  const myVouchers = useAsync(() => vouchers.mine().catch(() => []), []);
  const [addressId, setAddressId] = useState(null);
  const [formOpen, setFormOpen] = useState(false);

  const [deliveryType, setDeliveryType] = useState('normal');
  const [codeInput, setCodeInput] = useState('');
  const [voucherCode, setVoucherCode] = useState(null);
  const [points, setPoints] = useState(0);
  const [note, setNote] = useState('');

  const [quote, setQuote] = useState(null);
  const [quoting, setQuoting] = useState(false);
  const [quoteError, setQuoteError] = useState(null);
  const [placing, setPlacing] = useState(false);
  const seq = useRef(0);

  // Points balance changes on the server; fetch it fresh for the slider.
  useEffect(() => {
    refreshMe().catch(() => {});
  }, [refreshMe]);

  useEffect(() => {
    const list = addressList.data ?? [];
    if (!addressId && list.length) setAddressId((list.find((a) => a.isDefault) ?? list[0]).id);
  }, [addressList.data, addressId]);

  const debouncedPoints = useDebounced(points, 400);
  const itemsKey = JSON.stringify(cart.requestItems);

  // The server is the only source of truth for money: re-quote on any change.
  useEffect(() => {
    if (!cart.cart.vendor || cart.cart.lines.length === 0) return;
    const id = ++seq.current;
    setQuoting(true);
    setQuoteError(null);
    orders
      .quote({
        vendorId: cart.cart.vendor.id,
        items: cart.requestItems,
        deliveryType,
        paymentMethod: 'cash',
        ...(voucherCode ? { voucherCode } : {}),
        ...(debouncedPoints > 0 ? { pointsToUse: debouncedPoints } : {}),
      })
      .then((q) => id === seq.current && setQuote(q))
      .catch((e) => id === seq.current && setQuoteError(e))
      .finally(() => id === seq.current && setQuoting(false));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [itemsKey, deliveryType, voucherCode, debouncedPoints, cart.cart.vendor?.id]);

  // A rejected voucher comes back as a warning with no voucher applied.
  const voucherRejected = voucherCode && quote && !quote.voucherCode;

  const applyVoucher = (code) => {
    const clean = code.trim().toUpperCase();
    if (!clean) return;
    setCodeInput(clean);
    setVoucherCode(clean);
  };

  const place = async () => {
    if (!addressId || !quote) return;
    setPlacing(true);
    try {
      const order = await orders.create({
        vendorId: cart.cart.vendor.id,
        items: cart.requestItems,
        addressId,
        deliveryType,
        paymentMethod: 'cash',
        ...(quote.voucherCode ? { voucherCode: quote.voucherCode } : {}),
        ...(quote.pointsUsed > 0 ? { pointsToUse: quote.pointsUsed } : {}),
        ...(note.trim() ? { customerNote: note.trim().slice(0, 400) } : {}),
      });
      cart.clear();
      refreshMe().catch(() => {});
      navigate(`/orders/${order.id}/success`, { replace: true, state: { code: order.code } });
    } catch (e) {
      toast.error(errorText(e));
    } finally {
      setPlacing(false);
    }
  };

  const currency = lang === 'ar' ? 'دج' : 'DA';
  const balance = user?.points ?? 0;
  const lines = useMemo(() => cart.cart.lines, [cart.cart.lines]);

  if (cart.cart.lines.length === 0) {
    return (
      <EmptyState
        icon="bag"
        title={t('checkout.emptyCart')}
        text={t('cart.emptyText')}
        action={<Link to="/stores"><Button icon="store">{t('cart.browse')}</Button></Link>}
      />
    );
  }

  return (
    <div className="container-x pb-12 pt-6">
      <motion.h1 initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} className="text-4xl font-extrabold md:text-5xl">
        {t('checkout.title')}
      </motion.h1>

      <div className="mt-8 grid gap-6 lg:grid-cols-[1fr_400px]">
        <div className="space-y-6">
          <Card
            title={t('checkout.address')}
            icon="pin"
            action={<Button size="sm" variant="soft" icon="plus" onClick={() => setFormOpen(true)}>{t('checkout.addAddress')}</Button>}
          >
            {addressList.loading ? (
              <Skeleton className="h-20" />
            ) : (addressList.data ?? []).length === 0 ? (
              <button
                type="button"
                onClick={() => setFormOpen(true)}
                className="flex w-full items-center justify-center gap-2 rounded-2xl border-2 border-dashed border-leaf/40 p-6 font-bold text-forest transition hover:bg-leaf-tint/40"
              >
                <Icon name="plus" />
                {t('checkout.noAddress')}
              </button>
            ) : (
              <div className="grid gap-3 sm:grid-cols-2">
                {addressList.data.map((a) => (
                  <Choice
                    key={a.id}
                    layoutId="addr"
                    selected={a.id === addressId}
                    onClick={() => setAddressId(a.id)}
                    icon={a.label === t('account.labelWork') ? 'store' : 'home'}
                    title={a.label}
                    hint={[a.street, a.commune].filter(Boolean).join('، ')}
                  />
                ))}
              </div>
            )}
          </Card>

          <Card title={t('checkout.delivery')} icon="bike" delay={0.05}>
            <div className="flex flex-col gap-3 sm:flex-row">
              <Choice layoutId="dt" selected={deliveryType === 'normal'} onClick={() => setDeliveryType('normal')} icon="bike" title={t('checkout.normal')} hint={t('checkout.normalHint')} />
              <Choice
                layoutId="dt"
                selected={deliveryType === 'vip'}
                onClick={() => setDeliveryType('vip')}
                icon="crown"
                title={t('checkout.vip')}
                hint={t('checkout.vipHint')}
                badge={
                  <motion.span animate={{ rotate: [0, -12, 12, 0] }} transition={{ duration: 1.6, repeat: Infinity, repeatDelay: 1.2 }}>
                    <Icon name="sparkles" className="h-4 w-4 text-tangerine" />
                  </motion.span>
                }
              />
            </div>
          </Card>

          <Card title={t('checkout.payment')} icon="wallet" delay={0.1}>
            <Choice layoutId="pay" selected onClick={() => {}} icon="coins" title={t('checkout.cash')} hint={t('checkout.cashHint')} />
          </Card>

          <Card title={t('checkout.voucher')} icon="gift" delay={0.15}>
            <form
              onSubmit={(e) => {
                e.preventDefault();
                applyVoucher(codeInput);
              }}
              className="flex gap-2"
            >
              <Input
                value={codeInput}
                onChange={(e) => setCodeInput(e.target.value.toUpperCase())}
                placeholder={t('checkout.voucherPlaceholder')}
                className="num uppercase tracking-widest"
                maxLength={32}
                disabled={Boolean(voucherCode)}
              />
              {voucherCode ? (
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => {
                    setVoucherCode(null);
                    setCodeInput('');
                  }}
                >
                  {t('checkout.remove')}
                </Button>
              ) : (
                <Button type="submit" disabled={!codeInput.trim()}>{t('checkout.apply')}</Button>
              )}
            </form>
            <AnimatePresence>
              {quote?.voucherCode && (
                <motion.p initial={{ opacity: 0, y: -6 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0 }} className="mt-3 flex items-center gap-2 text-sm font-bold text-leaf">
                  <Icon name="check" className="h-4 w-4" /> {quote.voucherCode} · −{money(quote.voucherDiscountCentimes, lang)}
                </motion.p>
              )}
              {voucherRejected && (
                <motion.p initial={{ opacity: 0, x: -8 }} animate={{ opacity: 1, x: [0, -6, 6, 0] }} className="mt-3 flex items-center gap-2 text-sm font-bold text-tomato">
                  <Icon name="alert" className="h-4 w-4" /> {quote.warnings?.[0] ?? t('common.errorValidation')}
                </motion.p>
              )}
            </AnimatePresence>
            {!voucherCode && (myVouchers.data ?? []).length > 0 && (
              <div className="mt-4">
                <p className="mb-2 text-xs font-bold text-ink-muted">{t('checkout.myVouchers')}</p>
                <div className="flex flex-wrap gap-2">
                  {myVouchers.data.map((v) => (
                    <motion.button
                      key={v.id}
                      type="button"
                      whileHover={{ y: -2 }}
                      whileTap={{ scale: 0.95 }}
                      onClick={() => applyVoucher(v.code)}
                      className="num rounded-xl border-2 border-dashed border-tangerine/50 bg-tangerine-soft px-3 py-1.5 text-sm font-black tracking-wider text-tangerine"
                    >
                      {v.code}
                    </motion.button>
                  ))}
                </div>
              </div>
            )}
          </Card>

          {balance > 0 && (
            <Card title={t('checkout.points')} icon="coins" delay={0.2}>
              <div className="flex items-center justify-between text-sm font-bold">
                <span className="text-ink-soft">{t('checkout.pointsBalance', { n: balance })}</span>
                <span className="num text-forest">{t('checkout.pointsUse', { n: points })}</span>
              </div>
              <input
                type="range"
                min={0}
                max={balance}
                value={points}
                onChange={(e) => setPoints(Number(e.target.value))}
                className="mt-4 w-full accent-leaf"
                dir="ltr"
              />
            </Card>
          )}

          <Card title={t('checkout.note')} icon="pencil" delay={0.25}>
            <Textarea value={note} onChange={(e) => setNote(e.target.value)} maxLength={400} placeholder={t('checkout.notePlaceholder')} />
          </Card>
        </div>

        {/* summary */}
        <motion.aside
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.15, duration: 0.6 }}
          className="lg:sticky lg:top-24 lg:self-start"
        >
          <div className="overflow-hidden rounded-4xl bg-white shadow-lift">
            <div className="flex items-center gap-3 bg-forest p-5 text-white">
              <Img image={cart.cart.vendor?.logo} ratio={1} width={96} className="h-12 w-12 rounded-xl bg-white" fallback="store" />
              <div>
                <p className="text-xs text-white/70">{t('checkout.summary')}</p>
                <p className="font-display text-xl font-bold">{cart.cart.vendor?.name}</p>
              </div>
            </div>
            <ul className="max-h-64 space-y-3 overflow-y-auto p-5">
              {lines.map((l) => (
                <li key={l.key} className="flex items-start justify-between gap-3 text-sm">
                  <span className="min-w-0">
                    <span className="num me-1 font-black text-leaf">{l.qty}×</span>
                    <span className="font-bold">{l.product.name}</span>
                    {l.valueIds.length > 0 && <span className="block text-xs text-ink-muted">{optionLabel(l.product, l.valueIds)}</span>}
                  </span>
                </li>
              ))}
            </ul>
            <div className="relative space-y-2.5 border-t border-dashed border-ink/10 p-5">
              <AnimatePresence>
                {quoting && (
                  <motion.div
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    exit={{ opacity: 0 }}
                    className="absolute inset-x-0 top-0 h-0.5 overflow-hidden bg-leaf/20"
                  >
                    <motion.div className="h-full w-1/3 bg-leaf" animate={{ x: ['-100%', '300%'] }} transition={{ duration: 1, repeat: Infinity }} />
                  </motion.div>
                )}
              </AnimatePresence>
              {quoteError ? (
                <div className="rounded-2xl bg-red-50 p-3 text-sm font-bold text-tomato">{errorText(quoteError)}</div>
              ) : !quote ? (
                <div className="space-y-2">
                  {Array.from({ length: 4 }, (_, i) => <Skeleton key={i} className="h-4" />)}
                </div>
              ) : (
                <>
                  <Row label={t('checkout.subtotal')} value={money(quote.subtotalCentimes, lang)} />
                  {quote.serviceFeeCentimes > 0 && <Row label={t('checkout.serviceFee')} value={money(quote.serviceFeeCentimes, lang)} />}
                  <Row label={t('checkout.deliveryFee')} value={money(quote.deliveryFeeCentimes, lang)} />
                  {quote.voucherDiscountCentimes > 0 && <Row tone="text-leaf" label={t('checkout.voucherDiscount')} value={`−${money(quote.voucherDiscountCentimes, lang)}`} />}
                  {quote.pointsDiscountCentimes > 0 && <Row tone="text-leaf" label={t('checkout.pointsDiscount')} value={`−${money(quote.pointsDiscountCentimes, lang)}`} />}
                  {(quote.warnings ?? []).filter((w) => !voucherRejected || w !== quote.warnings[0]).map((w) => (
                    <p key={w} className="flex gap-2 rounded-xl bg-tangerine-soft p-2.5 text-xs font-bold text-tangerine">
                      <Icon name="info" className="h-4 w-4 shrink-0" /> {w}
                    </p>
                  ))}
                  <div className="border-t border-ink/5 pt-3">
                    <div className="flex items-end justify-between">
                      <span className="text-lg font-extrabold">{t('checkout.total')}</span>
                      <span className="font-display text-4xl font-extrabold text-forest">
                        <CountUp value={dinars(quote.totalCentimes)} /> <span className="text-lg">{currency}</span>
                      </span>
                    </div>
                    {quote.pointsEarned > 0 && (
                      <motion.p initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="mt-2 flex items-center gap-1.5 text-xs font-bold text-tangerine">
                        <Icon name="sparkles" className="h-4 w-4" /> {t('checkout.earn', { n: quote.pointsEarned })}
                      </motion.p>
                    )}
                  </div>
                </>
              )}
            </div>
            <div className="p-5 pt-0">
              <Button size="lg" className="w-full" loading={placing} disabled={!quote || quoting || !addressId || Boolean(quoteError)} onClick={place} iconEnd="arrow">
                {placing ? t('checkout.placing') : t('checkout.place')}
              </Button>
              <p className="mt-3 flex items-center justify-center gap-1.5 text-center text-xs text-ink-muted">
                <Icon name="phone" className="h-3.5 w-3.5" /> {t('checkout.callNotice')}
              </p>
            </div>
          </div>
        </motion.aside>
      </div>

      <AddressForm
        open={formOpen}
        onClose={() => setFormOpen(false)}
        onSaved={(a) => {
          addressList.reload();
          setAddressId(a.id);
        }}
      />
    </div>
  );
}
