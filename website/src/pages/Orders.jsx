import { forwardRef, useCallback, useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { AnimatePresence, motion } from 'framer-motion';
import { Icon } from '../components/Icon';
import { Badge, Button, EmptyState, ErrorState, Img, Segmented, Skeleton } from '../components/ui';
import { vendorSnapshot } from '../components/ProductModal';
import { useI18n } from '../state/i18n';
import { lineKey, useCart } from '../state/cart';
import { useToast } from '../state/toast';
import { useSocketEvent } from '../lib/socket';
import { catalog, orders as ordersApi } from '../lib/services';
import { ACTIVE, DONE, TONE, isActive } from '../lib/orderStatus';
import { dateTime, money } from '../lib/format';

// popLayout measures its children, so the card must forward a ref.
const OrderCard = forwardRef(function OrderCard({ order, index, onReorder, reordering }, ref) {
  const { t, lang } = useI18n();
  const active = isActive(order.status);
  const count = order.items.reduce((n, i) => n + i.qty, 0);
  return (
    <motion.div
      ref={ref}
      layout
      initial={{ opacity: 0, y: 24 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, scale: 0.95 }}
      transition={{ delay: index * 0.04, duration: 0.45, ease: [0.16, 1, 0.3, 1] }}
    >
      <Link
        to={`/orders/${order.id}`}
        className="group relative block overflow-hidden rounded-4xl bg-white p-5 shadow-card transition-shadow hover:shadow-lift"
      >
        {active && (
          <motion.span
            aria-hidden="true"
            className="absolute inset-x-0 top-0 h-1 bg-gradient-to-r from-leaf via-tangerine to-leaf bg-[length:200%_100%]"
            animate={{ backgroundPositionX: ['0%', '200%'] }}
            transition={{ duration: 3, repeat: Infinity, ease: 'linear' }}
          />
        )}
        <div className="flex items-start gap-4">
          <Img image={order.vendor?.logo} ratio={1} width={128} className="h-16 w-16 shrink-0 rounded-2xl" fallback="store" />
          <div className="min-w-0 flex-1">
            <div className="flex flex-wrap items-center justify-between gap-2">
              <h3 className="truncate text-lg font-bold">{order.vendor?.name}</h3>
              <Badge tone={TONE[order.status]} pulse={active}>{t(`status.${order.status}`)}</Badge>
            </div>
            <p className="num mt-0.5 text-sm text-ink-muted">
              #{order.code} · {dateTime(order.createdAt, lang)}
            </p>
            <p className="mt-2 line-clamp-1 text-sm text-ink-soft">
              {order.items.map((i) => `${i.qty}× ${i.nameSnapshot}`).join('، ')}
            </p>
          </div>
        </div>
        <div className="mt-4 flex items-center justify-between gap-3 border-t border-dashed border-ink/10 pt-4">
          <span className="text-sm text-ink-muted">
            {t('orders.items', { n: count })}
            {order.deliveryType === 'vip' && <Badge tone="tangerine" className="ms-2">VIP</Badge>}
          </span>
          <div className="flex items-center gap-3">
            <span className="num font-display text-xl font-bold text-forest">{money(order.totalCentimes, lang)}</span>
            {order.status === 'delivered' ? (
              <Button
                size="sm"
                variant="soft"
                icon="refresh"
                loading={reordering}
                onClick={(e) => {
                  e.preventDefault();
                  onReorder(order);
                }}
              >
                {t('orders.reorder')}
              </Button>
            ) : active ? (
              <span className="flex items-center gap-1 text-sm font-bold text-leaf">
                {t('orders.track')}
                <Icon name="arrow" className="h-4 w-4 transition-transform group-hover:translate-x-1 rtl:group-hover:-translate-x-1" />
              </span>
            ) : null}
          </div>
        </div>
      </Link>
    </motion.div>
  );
});

export default function Orders() {
  const { t, errorText } = useI18n();
  const cart = useCart();
  const toast = useToast();
  const navigate = useNavigate();
  const [tab, setTab] = useState('active');
  const [state, setState] = useState({ items: [], page: 0, hasMore: false, loading: true, error: null });
  const [reordering, setReordering] = useState(null);

  const load = useCallback(
    async (page) => {
      setState((s) => ({ ...s, loading: true, error: null }));
      try {
        const res = await ordersApi.list({ status: tab === 'active' ? ACTIVE : DONE, page, limit: 15 });
        setState((s) => ({
          items: page === 1 ? res.items : [...s.items, ...res.items],
          page,
          hasMore: res.hasMore,
          loading: false,
          error: null,
        }));
      } catch (error) {
        setState((s) => ({ ...s, loading: false, error }));
      }
    },
    [tab],
  );

  useEffect(() => {
    setState({ items: [], page: 0, hasMore: false, loading: true, error: null });
    load(1);
  }, [load]);

  // A status change anywhere refreshes the list so cards move between tabs.
  useSocketEvent('order:status', () => load(1), [load]);

  /**
   * "Order again": fetch the store's live menu and rebuild the basket from the
   * delivered order, matching option values by name. Anything no longer on the
   * menu (or not approved) is dropped and the shopper is told.
   */
  const reorder = async (order) => {
    setReordering(order.id);
    try {
      const vendorId = order.vendor?.id ?? order.vendor;
      const [vendor, menu] = await Promise.all([catalog.vendor(vendorId), catalog.menu(vendorId)]);
      const products = new Map(menu.flatMap((g) => g.products).map((p) => [p.id, p]));
      let missing = false;
      const lines = [];
      for (const item of order.items) {
        const product = products.get(item.product?.id ?? item.product);
        if (!product || !product.isAvailable) {
          missing = true;
          continue;
        }
        const valueIds = [];
        for (const sel of item.selectedOptions ?? []) {
          const option = product.options.find((o) => o.name === sel.name);
          const value = option?.values.find((v) => v.name === sel.value);
          if (value) valueIds.push(value.id);
          else missing = true;
        }
        lines.push({
          key: lineKey(product.id, valueIds),
          product: { id: product.id, name: product.name, image: product.image, priceCentimes: product.priceCentimes, options: product.options },
          valueIds,
          qty: item.qty,
        });
      }
      if (!lines.length) {
        toast.error(t('orders.unavailableItems'));
        return;
      }
      cart.replace(vendorSnapshot(vendor), lines);
      toast.success(missing ? t('orders.unavailableItems') : t('orders.reordered'));
      cart.open();
    } catch (e) {
      toast.error(errorText(e));
    } finally {
      setReordering(null);
    }
  };

  return (
    <div className="container-x pb-12 pt-6">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <motion.h1 initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} className="text-4xl font-extrabold md:text-5xl">
          {t('orders.title')}
        </motion.h1>
        <Segmented
          value={tab}
          onChange={setTab}
          options={[
            { value: 'active', label: t('orders.active'), icon: 'bike' },
            { value: 'past', label: t('orders.past'), icon: 'history' },
          ]}
        />
      </div>

      <div className="mt-8">
        {state.error && state.items.length === 0 ? (
          <ErrorState error={state.error} onRetry={() => load(1)} />
        ) : !state.loading && state.items.length === 0 ? (
          <EmptyState
            icon="receipt"
            title={t('orders.empty')}
            text={t('orders.emptyText')}
            action={<Button icon="store" onClick={() => navigate('/stores')}>{t('cart.browse')}</Button>}
          />
        ) : (
          <div className="grid gap-5 md:grid-cols-2">
            <AnimatePresence mode="popLayout">
              {state.items.map((o, i) => (
                <OrderCard key={o.id} order={o} index={i} onReorder={reorder} reordering={reordering === o.id} />
              ))}
            </AnimatePresence>
            {state.loading && Array.from({ length: 4 }, (_, i) => <Skeleton key={i} className="h-48 rounded-4xl" />)}
          </div>
        )}
        {state.hasMore && !state.loading && (
          <div className="mt-8 text-center">
            <Button variant="outline" onClick={() => load(state.page + 1)}>{t('orders.loadMore')}</Button>
          </div>
        )}
      </div>
    </div>
  );
}
