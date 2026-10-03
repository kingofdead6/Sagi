import { useEffect, useMemo, useRef, useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { Button, Confirm, CountUp, Img, Modal, Stepper } from './ui';
import { Icon } from './Icon';
import { flyToCart } from './Layout';
import { unitPrice, useCart } from '../state/cart';
import { useI18n } from '../state/i18n';
import { useToast } from '../state/toast';
import { dinars, imageUrl, money } from '../lib/format';

/**
 * Pick options and quantity, then add. Enforces the same rules as the server's
 * pricing core: every required option gets a value and a single-choice option
 * gets at most one, so the quote never bounces the line back.
 */
export function ProductModal({ product: incoming, vendor, onClose }) {
  const { t, lang } = useI18n();
  // Hold on to the last product so the sheet keeps its content while it
  // animates out after `incoming` becomes null.
  const [product, setProduct] = useState(incoming);
  useEffect(() => {
    if (incoming) setProduct(incoming);
  }, [incoming]);
  const cart = useCart();
  const toast = useToast();
  const [chosen, setChosen] = useState({});
  const [qty, setQty] = useState(1);
  const [missing, setMissing] = useState(null);
  const [conflict, setConflict] = useState(false);
  const addRef = useRef(null);

  useEffect(() => {
    if (!incoming) return;
    // Pre-select the first value of required single-choice options — the
    // common case is a size with an obvious default.
    const initial = {};
    for (const option of incoming.options ?? []) {
      if (option.isRequired && option.type === 'single' && option.values?.[0]) initial[option.name] = [option.values[0].id];
    }
    setChosen(initial);
    setQty(1);
    setMissing(null);
  }, [incoming]);

  const valueIds = useMemo(() => Object.values(chosen).flat(), [chosen]);
  const price = product ? unitPrice(product, valueIds) * qty : 0;

  const toggle = (option, valueId) => {
    setMissing(null);
    setChosen((current) => {
      const now = current[option.name] ?? [];
      if (option.type === 'single') {
        return { ...current, [option.name]: now[0] === valueId && !option.isRequired ? [] : [valueId] };
      }
      return { ...current, [option.name]: now.includes(valueId) ? now.filter((v) => v !== valueId) : [...now, valueId] };
    });
  };

  const commit = () => {
    cart.add(vendorSnapshot(vendor), product, valueIds, qty);
    flyToCart(addRef.current, imageUrl(product.image, 120, 1));
    toast.success(`${t('store.added')} — ${product.name}`);
    onClose();
  };

  const submit = () => {
    const unmet = (product.options ?? []).find((o) => o.isRequired && !(chosen[o.name]?.length > 0));
    if (unmet) {
      setMissing(unmet.name);
      return;
    }
    if (cart.conflictsWith(vendor.id)) {
      setConflict(true);
      return;
    }
    commit();
  };

  return (
    <>
      <Modal
        open={Boolean(incoming)}
        onClose={onClose}
        wide
        footer={
          product && (
            <div className="flex items-center gap-3">
              <Stepper value={qty} min={1} onChange={(q) => setQty(Math.max(1, q))} />
              <Button ref={addRef} size="lg" className="flex-1" onClick={submit} icon="bag">
                <span>{t('store.add')}</span>
                <span className="num rounded-xl bg-white/15 px-2 py-0.5">
                  <CountUp value={dinars(price)} /> {lang === 'ar' ? 'دج' : 'DA'}
                </span>
              </Button>
            </div>
          )
        }
      >
        {product && (
          <div>
            <div className="relative">
              <Img image={product.image} ratio={16 / 10} width={900} alt={product.name} fallback="burger" />
              <button
                type="button"
                onClick={onClose}
                aria-label={t('common.close')}
                className="absolute end-4 top-4 grid h-10 w-10 place-items-center rounded-full bg-white/90 text-forest shadow backdrop-blur transition hover:rotate-90"
              >
                <Icon name="x" />
              </button>
            </div>
            <div className="px-6 pb-4 pt-5">
              <motion.h3 initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="text-2xl font-bold">
                {product.name}
              </motion.h3>
              {product.description && <p className="mt-2 text-ink-soft">{product.description}</p>}
              <p className="num mt-3 font-display text-xl font-bold text-forest">{money(product.priceCentimes, lang)}</p>

              {(product.options ?? []).map((option, oi) => {
                const picked = chosen[option.name] ?? [];
                const isMissing = missing === option.name;
                return (
                  <motion.fieldset
                    key={option.name}
                    initial={{ opacity: 0, y: 14 }}
                    animate={isMissing ? { opacity: 1, y: 0, x: [0, -8, 8, -5, 5, 0] } : { opacity: 1, y: 0 }}
                    transition={{ delay: isMissing ? 0 : 0.08 * oi, duration: isMissing ? 0.4 : 0.35 }}
                    className={`mt-6 rounded-3xl border p-4 transition-colors ${isMissing ? 'border-tomato bg-red-50/50' : 'border-ink/5'}`}
                  >
                    <legend className="flex w-full items-center justify-between gap-2 px-1">
                      <span className="font-bold">{option.name}</span>
                      <span className={`text-xs font-bold ${option.isRequired ? 'text-tangerine' : 'text-ink-muted'}`}>
                        {option.isRequired ? t('store.required') : t('common.optional')} ·{' '}
                        {option.type === 'single' ? t('store.chooseOne') : t('store.chooseMany')}
                      </span>
                    </legend>
                    <div className="mt-2 grid gap-2 sm:grid-cols-2">
                      {(option.values ?? []).map((value) => {
                        const on = picked.includes(value.id);
                        return (
                          <motion.button
                            key={value.id}
                            type="button"
                            whileTap={{ scale: 0.97 }}
                            onClick={() => toggle(option, value.id)}
                            className={`flex items-center justify-between gap-3 rounded-2xl border-2 px-4 py-3 text-start transition-colors ${
                              on ? 'border-leaf bg-leaf-tint/60' : 'border-ink/5 hover:border-leaf/40'
                            }`}
                          >
                            <span className="flex items-center gap-3">
                              <span
                                className={`grid h-6 w-6 shrink-0 place-items-center border-2 transition-colors ${
                                  option.type === 'single' ? 'rounded-full' : 'rounded-lg'
                                } ${on ? 'border-leaf bg-leaf text-white' : 'border-ink/20'}`}
                              >
                                <AnimatePresence>
                                  {on && (
                                    <motion.span initial={{ scale: 0 }} animate={{ scale: 1 }} exit={{ scale: 0 }}>
                                      <Icon name="check" className="h-3.5 w-3.5" strokeWidth={3} />
                                    </motion.span>
                                  )}
                                </AnimatePresence>
                              </span>
                              <span className="font-bold">{value.name}</span>
                            </span>
                            {value.priceDeltaCentimes > 0 && (
                              <span className="num text-sm font-bold text-ink-muted">+{money(value.priceDeltaCentimes, lang)}</span>
                            )}
                          </motion.button>
                        );
                      })}
                    </div>
                    {isMissing && <p className="mt-2 text-sm font-bold text-tomato">{t('store.missingRequired', { name: option.name })}</p>}
                  </motion.fieldset>
                );
              })}
            </div>
          </div>
        )}
      </Modal>
      <Confirm
        open={conflict}
        title={t('store.conflictTitle')}
        text={t('store.conflictText', { vendor: cart.cart.vendor?.name ?? '' })}
        confirmLabel={t('store.conflictReplace')}
        danger
        onClose={() => setConflict(false)}
        onConfirm={() => {
          setConflict(false);
          commit();
        }}
      />
    </>
  );
}

/** What the cart keeps about the store: enough to show it and gate the minimum. */
export function vendorSnapshot(vendor) {
  return {
    id: vendor.id,
    name: vendor.name,
    logo: vendor.logo ?? null,
    minOrderCentimes: vendor.minOrderCentimes ?? 0,
    deliveryFeeCentimes: vendor.deliveryFeeCentimes ?? 0,
  };
}
