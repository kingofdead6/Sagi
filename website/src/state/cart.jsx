import { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';

const KEY = 'saji.cart';
const CartContext = createContext(null);
const EMPTY = { vendor: null, lines: [] };

function load() {
  try {
    const raw = JSON.parse(localStorage.getItem(KEY) || 'null');
    return raw && Array.isArray(raw.lines) ? raw : EMPTY;
  } catch {
    return EMPTY;
  }
}

/** Same identity rule as the app: one line per product + set of chosen values. */
export function lineKey(productId, valueIds) {
  return `${productId}::${[...valueIds].sort().join(',')}`;
}

/** Unit price including the deltas of every chosen option value. */
export function unitPrice(product, valueIds) {
  const chosen = new Set(valueIds);
  let price = product.priceCentimes ?? 0;
  for (const option of product.options ?? []) {
    for (const value of option.values ?? []) {
      if (chosen.has(value.id)) price += value.priceDeltaCentimes ?? 0;
    }
  }
  return price;
}

export function optionLabel(product, valueIds) {
  const chosen = new Set(valueIds);
  return (product.options ?? [])
    .flatMap((o) => (o.values ?? []).filter((v) => chosen.has(v.id)).map((v) => v.name))
    .join('، ');
}

/**
 * The basket is single-vendor, as in the app: adding from another store asks
 * the shopper first, because one order goes to exactly one shop.
 */
export function CartProvider({ children }) {
  const [cart, setCart] = useState(load);
  const [isOpen, setOpen] = useState(false);
  const [bump, setBump] = useState(0);

  useEffect(() => {
    try {
      localStorage.setItem(KEY, JSON.stringify(cart));
    } catch {
      /* storage unavailable: the cart lasts for this tab */
    }
  }, [cart]);

  // Keep carts in sync across tabs.
  useEffect(() => {
    const onStorage = (e) => {
      if (e.key === KEY) setCart(load());
    };
    window.addEventListener('storage', onStorage);
    return () => window.removeEventListener('storage', onStorage);
  }, []);

  const conflictsWith = useCallback(
    (vendorId) => cart.lines.length > 0 && cart.vendor && cart.vendor.id !== vendorId,
    [cart],
  );

  /** `vendor` is a snapshot: { id, name, logo, minOrderCentimes, deliveryFeeCentimes }. */
  const add = useCallback((vendor, product, valueIds = [], qty = 1) => {
    setCart((current) => {
      const base = current.vendor && current.vendor.id !== vendor.id ? EMPTY : current;
      const key = lineKey(product.id, valueIds);
      const existing = base.lines.find((l) => l.key === key);
      const lines = existing
        ? base.lines.map((l) => (l.key === key ? { ...l, qty: Math.min(50, l.qty + qty) } : l))
        : [...base.lines, { key, product: slim(product), valueIds: [...valueIds], qty }];
      return { vendor, lines };
    });
    setBump((n) => n + 1);
  }, []);

  const setQty = useCallback((key, qty) => {
    setCart((current) => {
      const lines =
        qty <= 0
          ? current.lines.filter((l) => l.key !== key)
          : current.lines.map((l) => (l.key === key ? { ...l, qty: Math.min(50, qty) } : l));
      return lines.length ? { ...current, lines } : EMPTY;
    });
  }, []);

  const clear = useCallback(() => setCart(EMPTY), []);

  /** Replaces the whole basket — used by "order again". */
  const replace = useCallback((vendor, lines) => {
    setCart(lines.length ? { vendor, lines } : EMPTY);
    setBump((n) => n + 1);
  }, []);

  const value = useMemo(() => {
    const count = cart.lines.reduce((n, l) => n + l.qty, 0);
    const subtotal = cart.lines.reduce((n, l) => n + unitPrice(l.product, l.valueIds) * l.qty, 0);
    return {
      cart,
      count,
      subtotal,
      isOpen,
      open: () => setOpen(true),
      close: () => setOpen(false),
      bump,
      add,
      setQty,
      clear,
      replace,
      conflictsWith,
      /** The body the quote and order endpoints expect. */
      requestItems: cart.lines.map((l) => ({ productId: l.product.id, qty: l.qty, optionValueIds: l.valueIds })),
    };
  }, [cart, isOpen, bump, add, setQty, clear, replace, conflictsWith]);

  return <CartContext.Provider value={value}>{children}</CartContext.Provider>;
}

/** Only what the cart needs to render and price a line. */
function slim(product) {
  return {
    id: product.id,
    name: product.name,
    image: product.image ?? null,
    priceCentimes: product.priceCentimes,
    options: product.options ?? [],
  };
}

export function useCart() {
  return useContext(CartContext);
}
