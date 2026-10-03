import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { AnimatePresence, motion } from 'framer-motion';
import { Button, Confirm, CountUp, Drawer, EmptyState, Img, Stepper } from './ui';
import { Icon } from './Icon';
import { optionLabel, unitPrice, useCart } from '../state/cart';
import { useI18n } from '../state/i18n';
import { dinars, money } from '../lib/format';

export function CartDrawer() {
  const { cart, isOpen, close, setQty, clear, subtotal, count } = useCart();
  const { t, lang } = useI18n();
  const navigate = useNavigate();
  const [confirmClear, setConfirmClear] = useState(false);
  const vendor = cart.vendor;
  const belowMin = vendor?.minOrderCentimes > 0 && subtotal < vendor.minOrderCentimes;
  const progress = vendor?.minOrderCentimes > 0 ? Math.min(1, subtotal / vendor.minOrderCentimes) : 1;

  return (
    <>
      <Drawer
        open={isOpen}
        onClose={close}
        title={t('cart.title')}
        footer={
          cart.lines.length > 0 && (
            <div className="space-y-3">
              {belowMin && (
                <div>
                  <div className="mb-1.5 flex justify-between text-xs font-bold text-ink-soft">
                    <span>{t('cart.minOrder', { amount: money(vendor.minOrderCentimes, lang) })}</span>
                  </div>
                  <div className="h-2 overflow-hidden rounded-full bg-ink/5">
                    <motion.div
                      className="h-full rounded-full bg-gradient-to-r from-tangerine to-leaf"
                      initial={{ width: 0 }}
                      animate={{ width: `${progress * 100}%` }}
                      transition={{ type: 'spring', stiffness: 120, damping: 20 }}
                    />
                  </div>
                </div>
              )}
              <div className="flex items-end justify-between">
                <span className="text-sm font-bold text-ink-soft">{t('cart.estimate')}</span>
                <span className="font-display text-3xl font-bold text-forest">
                  <CountUp value={dinars(subtotal)} /> <span className="text-base">{lang === 'ar' ? 'دج' : 'DA'}</span>
                </span>
              </div>
              <p className="text-xs text-ink-muted">{t('cart.finalNote')}</p>
              <Button
                size="lg"
                className="w-full"
                iconEnd="arrow"
                disabled={belowMin}
                onClick={() => {
                  close();
                  navigate('/checkout');
                }}
              >
                {t('cart.checkout')}
              </Button>
            </div>
          )
        }
      >
        {cart.lines.length === 0 ? (
          <EmptyState
            icon="bag"
            title={t('cart.empty')}
            text={t('cart.emptyText')}
            action={
              <Button
                onClick={() => {
                  close();
                  navigate('/stores');
                }}
                icon="store"
              >
                {t('cart.browse')}
              </Button>
            }
          />
        ) : (
          <div className="pb-6">
            <div className="mb-4 flex items-center justify-between rounded-2xl bg-white p-3 shadow-card">
              <div className="flex items-center gap-3">
                <Img image={vendor?.logo} ratio={1} width={96} className="h-11 w-11 rounded-xl" fallback="store" />
                <div>
                  <p className="text-xs font-bold text-ink-muted">{t('cart.from', { vendor: '' }).trim()}</p>
                  <p className="font-display text-lg font-bold leading-tight">{vendor?.name}</p>
                </div>
              </div>
              <span className="num rounded-full bg-leaf-tint px-3 py-1 text-xs font-bold text-forest">
                {t('cart.items', { n: count })}
              </span>
            </div>
            <ul className="space-y-3">
              <AnimatePresence initial={false}>
                {cart.lines.map((line) => (
                  <motion.li
                    key={line.key}
                    layout
                    initial={{ opacity: 0, x: 40 }}
                    animate={{ opacity: 1, x: 0 }}
                    exit={{ opacity: 0, x: -60, height: 0, marginTop: 0, transition: { duration: 0.25 } }}
                    className="flex gap-3 rounded-2xl bg-white p-3 shadow-card"
                  >
                    <Img image={line.product.image} ratio={1} width={160} className="h-20 w-20 shrink-0 rounded-xl" fallback="burger" />
                    <div className="flex min-w-0 flex-1 flex-col">
                      <p className="truncate font-bold">{line.product.name}</p>
                      {line.valueIds.length > 0 && (
                        <p className="line-clamp-1 text-xs text-ink-muted">{optionLabel(line.product, line.valueIds)}</p>
                      )}
                      <div className="mt-auto flex items-center justify-between gap-2 pt-2">
                        <span className="num font-bold text-forest">
                          {money(unitPrice(line.product, line.valueIds) * line.qty, lang)}
                        </span>
                        <Stepper size="sm" value={line.qty} min={1} onChange={(q) => setQty(line.key, q)} />
                      </div>
                    </div>
                  </motion.li>
                ))}
              </AnimatePresence>
            </ul>
            <button
              type="button"
              onClick={() => setConfirmClear(true)}
              className="mx-auto mt-5 flex items-center gap-1.5 text-sm font-bold text-tomato/80 hover:text-tomato"
            >
              <Icon name="trash" className="h-4 w-4" />
              {t('cart.clear')}
            </button>
          </div>
        )}
      </Drawer>
      <Confirm
        open={confirmClear}
        danger
        title={t('cart.clearConfirm')}
        confirmLabel={t('cart.clear')}
        onClose={() => setConfirmClear(false)}
        onConfirm={() => {
          clear();
          setConfirmClear(false);
        }}
      />
    </>
  );
}
