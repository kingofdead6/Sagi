import { forwardRef, useEffect, useId, useRef, useState } from 'react';
import { AnimatePresence, animate, motion, useInView, useMotionValue, useTransform } from 'framer-motion';
import { Icon } from './Icon';
import { blurUrl, groupNumber, imageUrl } from '../lib/format';
import { useI18n } from '../state/i18n';

const spring = { type: 'spring', stiffness: 500, damping: 32 };

// ── buttons ────────────────────────────────────────────────────────────────

const VARIANTS = {
  primary: 'bg-forest text-white hover:bg-forest-soft shadow-[0_10px_24px_-10px_rgba(14,77,43,.7)]',
  leaf: 'bg-leaf text-white hover:bg-leaf-bright shadow-[0_10px_24px_-10px_rgba(91,178,47,.8)]',
  accent: 'bg-tangerine text-white hover:brightness-110 shadow-[0_10px_24px_-10px_rgba(242,122,26,.8)]',
  ghost: 'bg-transparent text-forest hover:bg-forest/5',
  soft: 'bg-forest/5 text-forest hover:bg-forest/10',
  outline: 'bg-white text-forest ring-1 ring-inset ring-forest/15 hover:ring-forest/40',
  danger: 'bg-tomato text-white hover:brightness-110',
  white: 'bg-white text-forest hover:bg-cream shadow-card',
};
const SIZES = {
  sm: 'h-9 px-3.5 text-sm gap-1.5 rounded-xl',
  md: 'h-11 px-5 text-[15px] gap-2 rounded-2xl',
  lg: 'h-14 px-7 text-base gap-2.5 rounded-2xl',
};

export const Button = forwardRef(function Button(
  { variant = 'primary', size = 'md', loading = false, icon, iconEnd, className = '', children, disabled, ...rest },
  ref,
) {
  return (
    <motion.button
      ref={ref}
      whileTap={disabled || loading ? undefined : { scale: 0.96 }}
      whileHover={disabled || loading ? undefined : { y: -1 }}
      transition={spring}
      disabled={disabled || loading}
      className={`relative inline-flex select-none items-center justify-center font-bold transition-colors disabled:cursor-not-allowed disabled:opacity-50 ${VARIANTS[variant]} ${SIZES[size]} ${className}`}
      {...rest}
    >
      <span className={`inline-flex items-center gap-[inherit] ${loading ? 'invisible' : ''}`}>
        {icon && <Icon name={icon} className="h-[1.15em] w-[1.15em]" />}
        {children}
        {iconEnd && <Icon name={iconEnd} className="h-[1.15em] w-[1.15em]" />}
      </span>
      {loading && (
        <span className="absolute inset-0 grid place-items-center">
          <Spinner className="h-5 w-5" />
        </span>
      )}
    </motion.button>
  );
});

export function IconButton({ icon, label, className = '', variant = 'soft', size = 'h-10 w-10', ...rest }) {
  return (
    <motion.button
      type="button"
      aria-label={label}
      title={label}
      whileTap={{ scale: 0.9 }}
      transition={spring}
      className={`grid shrink-0 place-items-center rounded-full transition-colors ${VARIANTS[variant]} ${size} ${className}`}
      {...rest}
    >
      <Icon name={icon} className="h-5 w-5" />
    </motion.button>
  );
}

export function Spinner({ className = 'h-6 w-6' }) {
  return (
    <svg className={`animate-spin ${className}`} viewBox="0 0 24 24" fill="none" aria-hidden="true">
      <circle cx="12" cy="12" r="9" stroke="currentColor" strokeOpacity=".2" strokeWidth="3" />
      <path d="M21 12a9 9 0 0 0-9-9" stroke="currentColor" strokeWidth="3" strokeLinecap="round" />
    </svg>
  );
}

// ── form ───────────────────────────────────────────────────────────────────

export function Field({ label, error, hint, children, className = '' }) {
  return (
    <label className={`block ${className}`}>
      {label && <span className="label">{label}</span>}
      {children}
      <AnimatePresence initial={false}>
        {error ? (
          <motion.span
            key="e"
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
            className="mt-1.5 block text-sm font-bold text-tomato"
          >
            {error}
          </motion.span>
        ) : hint ? (
          <span className="mt-1.5 block text-sm text-ink-muted">{hint}</span>
        ) : null}
      </AnimatePresence>
    </label>
  );
}

export const Input = forwardRef(function Input({ className = '', invalid, ...rest }, ref) {
  return (
    <input
      ref={ref}
      className={`field ${invalid ? 'border-tomato focus:border-tomato focus:ring-tomato/15' : ''} ${className}`}
      {...rest}
    />
  );
});

export function Textarea({ className = '', ...rest }) {
  return <textarea className={`field min-h-[96px] resize-y ${className}`} {...rest} />;
}

export function Switch({ checked, onChange, label, disabled, size = 'md' }) {
  const dims = size === 'lg' ? { w: 'w-16 h-9', k: 'h-7 w-7', x: 28 } : { w: 'w-12 h-7', k: 'h-5 w-5', x: 20 };
  const { isRtl } = useI18n();
  return (
    <button
      type="button"
      role="switch"
      aria-checked={checked}
      aria-label={label}
      disabled={disabled}
      onClick={() => onChange(!checked)}
      className={`relative inline-flex shrink-0 items-center rounded-full p-1 transition-colors disabled:opacity-50 ${dims.w} ${checked ? 'bg-leaf' : 'bg-ink/15'}`}
    >
      <motion.span
        transition={spring}
        animate={{ x: checked ? (isRtl ? -dims.x : dims.x) : 0 }}
        className={`block rounded-full bg-white shadow ${dims.k}`}
      />
    </button>
  );
}

/** Pill selector whose highlight slides between options. */
export function Segmented({ options, value, onChange, className = '', size = 'md' }) {
  const id = useId();
  return (
    <div className={`inline-flex rounded-2xl bg-forest/5 p-1 ${className}`} role="tablist">
      {options.map((o) => {
        const active = o.value === value;
        return (
          <button
            key={o.value}
            type="button"
            role="tab"
            aria-selected={active}
            onClick={() => onChange(o.value)}
            className={`relative flex-1 whitespace-nowrap rounded-xl font-bold transition-colors ${
              size === 'sm' ? 'px-3 py-1.5 text-sm' : 'px-4 py-2.5 text-[15px]'
            } ${active ? 'text-white' : 'text-ink-soft hover:text-forest'}`}
          >
            {active && (
              <motion.span layoutId={`seg-${id}`} transition={spring} className="absolute inset-0 rounded-xl bg-forest shadow" />
            )}
            <span className="relative inline-flex items-center gap-1.5">
              {o.icon && <Icon name={o.icon} className="h-4 w-4" />}
              {o.label}
              {o.badge != null && (
                <span className={`num rounded-full px-1.5 text-xs ${active ? 'bg-white/20' : 'bg-forest/10'}`}>{o.badge}</span>
              )}
            </span>
          </button>
        );
      })}
    </div>
  );
}

export function Stepper({ value, onChange, min = 1, max = 50, size = 'md' }) {
  const h = size === 'sm' ? 'h-8 w-8' : 'h-10 w-10';
  return (
    <div className="inline-flex items-center gap-1 rounded-full bg-forest/5 p-1">
      <IconButton icon={value <= min ? 'trash' : 'minus'} label="-" size={h} variant="white" onClick={() => onChange(value - 1)} />
      <AnimatePresence mode="popLayout" initial={false}>
        <motion.span
          key={value}
          initial={{ y: -12, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          exit={{ y: 12, opacity: 0 }}
          className="num min-w-[2ch] text-center font-display text-lg font-bold"
        >
          {value}
        </motion.span>
      </AnimatePresence>
      <IconButton icon="plus" label="+" size={h} variant="primary" disabled={value >= max} onClick={() => onChange(value + 1)} />
    </div>
  );
}

// ── overlays ───────────────────────────────────────────────────────────────

function useLockScroll(locked) {
  useEffect(() => {
    if (!locked) return undefined;
    const prev = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    return () => {
      document.body.style.overflow = prev;
    };
  }, [locked]);
}

function useEscape(open, onClose) {
  useEffect(() => {
    if (!open) return undefined;
    const onKey = (e) => e.key === 'Escape' && onClose?.();
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [open, onClose]);
}

/** Centered dialog on desktop, bottom sheet on phones. */
export function Modal({ open, onClose, title, children, footer, wide = false }) {
  useLockScroll(open);
  useEscape(open, onClose);
  return (
    <AnimatePresence>
      {open && (
        <motion.div className="fixed inset-0 z-[70] flex items-end justify-center sm:items-center sm:p-6" initial="hidden" animate="show" exit="hidden">
          <motion.div
            variants={{ hidden: { opacity: 0 }, show: { opacity: 1 } }}
            className="absolute inset-0 bg-forest-deep/50 backdrop-blur-sm"
            onClick={onClose}
          />
          <motion.div
            role="dialog"
            aria-modal="true"
            aria-label={typeof title === 'string' ? title : undefined}
            variants={{
              hidden: { opacity: 0, y: 60, scale: 0.97 },
              show: { opacity: 1, y: 0, scale: 1, transition: { type: 'spring', stiffness: 380, damping: 32 } },
            }}
            className={`relative flex max-h-[92vh] w-full flex-col overflow-hidden rounded-t-4xl bg-white shadow-lift sm:rounded-4xl ${wide ? 'sm:max-w-2xl' : 'sm:max-w-md'}`}
          >
            {title && (
              <div className="flex items-center justify-between gap-3 border-b border-ink/5 px-6 py-4">
                <h3 className="text-xl font-bold">{title}</h3>
                <IconButton icon="x" label="close" onClick={onClose} />
              </div>
            )}
            <div className="overflow-y-auto">{children}</div>
            {footer && <div className="border-t border-ink/5 bg-cream/60 px-6 py-4">{footer}</div>}
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}

/** Side sheet that slides in from the inline-end edge (left in RTL). */
export function Drawer({ open, onClose, title, children, footer }) {
  const { isRtl } = useI18n();
  useLockScroll(open);
  useEscape(open, onClose);
  const from = isRtl ? '-100%' : '100%';
  return (
    <AnimatePresence>
      {open && (
        <div className="fixed inset-0 z-[70]">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="absolute inset-0 bg-forest-deep/40 backdrop-blur-sm"
            onClick={onClose}
          />
          <motion.aside
            role="dialog"
            aria-modal="true"
            initial={{ x: from }}
            animate={{ x: 0 }}
            exit={{ x: from }}
            transition={{ type: 'spring', stiffness: 340, damping: 36 }}
            className="absolute inset-y-0 end-0 flex w-full max-w-md flex-col bg-cream shadow-lift"
          >
            <div className="flex items-center justify-between gap-3 px-6 py-5">
              <h3 className="text-2xl font-bold">{title}</h3>
              <IconButton icon="x" label="close" onClick={onClose} variant="white" />
            </div>
            <div className="flex-1 overflow-y-auto px-6">{children}</div>
            {footer && <div className="border-t border-ink/5 bg-white px-6 py-5">{footer}</div>}
          </motion.aside>
        </div>
      )}
    </AnimatePresence>
  );
}

export function Confirm({ open, title, text, confirmLabel, danger, onConfirm, onClose, loading }) {
  const { t } = useI18n();
  return (
    <Modal
      open={open}
      onClose={onClose}
      footer={
        <div className="flex gap-3">
          <Button variant="outline" className="flex-1" onClick={onClose}>
            {t('common.cancel')}
          </Button>
          <Button variant={danger ? 'danger' : 'primary'} className="flex-1" loading={loading} onClick={onConfirm}>
            {confirmLabel ?? t('common.confirm')}
          </Button>
        </div>
      }
    >
      <div className="px-6 pb-2 pt-7 text-center">
        <motion.div
          initial={{ scale: 0, rotate: -20 }}
          animate={{ scale: 1, rotate: 0 }}
          transition={{ type: 'spring', stiffness: 300, damping: 14, delay: 0.1 }}
          className={`mx-auto mb-4 grid h-16 w-16 place-items-center rounded-full ${danger ? 'bg-red-50 text-tomato' : 'bg-leaf-tint text-forest'}`}
        >
          <Icon name={danger ? 'alert' : 'info'} className="h-8 w-8" />
        </motion.div>
        <h3 className="text-xl font-bold">{title}</h3>
        {text && <p className="mt-2 text-ink-soft">{text}</p>}
      </div>
    </Modal>
  );
}

// ── display ────────────────────────────────────────────────────────────────

export function Skeleton({ className = '' }) {
  return <div className={`skeleton ${className}`} />;
}

export function Badge({ tone = 'leaf', children, className = '', pulse = false }) {
  const tones = {
    leaf: 'bg-leaf-tint text-forest',
    forest: 'bg-forest text-white',
    tangerine: 'bg-tangerine-soft text-tangerine',
    tomato: 'bg-red-50 text-tomato',
    ink: 'bg-ink/5 text-ink-soft',
    white: 'bg-white/90 text-forest backdrop-blur',
  };
  return (
    <span className={`inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs font-bold ${tones[tone]} ${className}`}>
      {pulse && (
        <span className="relative flex h-2 w-2">
          <span className="absolute inline-flex h-full w-full animate-ping2 rounded-full bg-current opacity-60" />
          <span className="relative inline-flex h-2 w-2 rounded-full bg-current" />
        </span>
      )}
      {children}
    </span>
  );
}

export function Stars({ value = 0, size = 'h-4 w-4', onChange, className = '' }) {
  const [hover, setHover] = useState(0);
  const shown = hover || value;
  return (
    <div className={`inline-flex items-center gap-1 ${className}`} dir="ltr" onMouseLeave={() => setHover(0)}>
      {[1, 2, 3, 4, 5].map((n) => {
        const on = n <= Math.round(shown);
        const star = (
          <Icon name="star" filled={on} className={`${size} ${on ? 'text-tangerine' : 'text-ink/15'}`} strokeWidth={1.5} />
        );
        return onChange ? (
          <motion.button
            key={n}
            type="button"
            aria-label={`${n}`}
            whileHover={{ scale: 1.2, rotate: -8 }}
            whileTap={{ scale: 0.8 }}
            animate={on ? { scale: [1, 1.25, 1] } : { scale: 1 }}
            transition={{ duration: 0.25 }}
            onMouseEnter={() => setHover(n)}
            onClick={() => onChange(n)}
          >
            {star}
          </motion.button>
        ) : (
          <span key={n}>{star}</span>
        );
      })}
    </div>
  );
}

export function EmptyState({ icon = 'package', title, text, action }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 16 }}
      animate={{ opacity: 1, y: 0 }}
      className="mx-auto flex max-w-sm flex-col items-center px-6 py-16 text-center"
    >
      <motion.div
        animate={{ y: [0, -10, 0], rotate: [0, -6, 6, 0] }}
        transition={{ duration: 4, repeat: Infinity, ease: 'easeInOut' }}
        className="mb-5 grid h-24 w-24 place-items-center rounded-full bg-leaf-tint text-forest"
      >
        <Icon name={icon} className="h-11 w-11" strokeWidth={1.6} />
      </motion.div>
      <h3 className="text-2xl font-bold">{title}</h3>
      {text && <p className="mt-2 text-ink-soft">{text}</p>}
      {action && <div className="mt-6">{action}</div>}
    </motion.div>
  );
}

export function ErrorState({ error, onRetry }) {
  const { t, errorText } = useI18n();
  return (
    <EmptyState
      icon="alert"
      title={t('common.errorGeneric')}
      text={errorText(error)}
      action={onRetry && <Button icon="refresh" onClick={onRetry}>{t('common.retry')}</Button>}
    />
  );
}

/** Tweens to a new number instead of jumping — used on every price total. */
export function CountUp({ value, format = groupNumber, className = '' }) {
  const mv = useMotionValue(value);
  const text = useTransform(mv, (v) => format(v));
  const first = useRef(true);
  useEffect(() => {
    if (first.current) {
      first.current = false;
      mv.set(value);
      return undefined;
    }
    const controls = animate(mv, value, { duration: 0.6, ease: [0.22, 1, 0.36, 1] });
    return controls.stop;
  }, [value, mv]);
  return <motion.span className={`num ${className}`}>{text}</motion.span>;
}

/** Counts up from zero the first time it scrolls into view. */
export function CountOnView({ to, suffix = '', className = '' }) {
  const ref = useRef(null);
  const inView = useInView(ref, { once: true, margin: '-40px' });
  const mv = useMotionValue(0);
  const text = useTransform(mv, (v) => `${Math.round(v)}${suffix}`);
  useEffect(() => {
    if (inView) animate(mv, to, { duration: 1.6, ease: [0.16, 1, 0.3, 1] });
  }, [inView, to, mv]);
  return (
    <motion.span ref={ref} className={`num ${className}`}>
      {text}
    </motion.span>
  );
}

/** Fades and lifts children into place as they scroll into view. */
export function Reveal({ children, delay = 0, y = 28, className = '', as = 'div' }) {
  const Tag = motion[as];
  return (
    <Tag
      initial={{ opacity: 0, y }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: '-60px' }}
      transition={{ duration: 0.7, delay, ease: [0.16, 1, 0.3, 1] }}
      className={className}
    >
      {children}
    </Tag>
  );
}

export const stagger = {
  hidden: {},
  show: { transition: { staggerChildren: 0.06 } },
};
export const rise = {
  hidden: { opacity: 0, y: 24 },
  show: { opacity: 1, y: 0, transition: { duration: 0.55, ease: [0.16, 1, 0.3, 1] } },
};

/**
 * A remote image cropped to an exact aspect ratio by Cloudinary, with the
 * blurred micro-version underneath until the real one fades in.
 */
export function Img({ image, ratio = 1, width = 600, alt = '', className = '', fallback = 'image', imgClassName = '' }) {
  const [loaded, setLoaded] = useState(false);
  const src = imageUrl(image, width, ratio);
  const blur = blurUrl(image);
  return (
    <div className={`relative overflow-hidden bg-cream-deep ${className}`} style={{ aspectRatio: ratio }}>
      {src ? (
        <>
          {blur && !loaded && <img src={blur} alt="" aria-hidden="true" className="absolute inset-0 h-full w-full scale-110 object-cover blur-md" />}
          <img
            src={src}
            alt={alt}
            loading="lazy"
            decoding="async"
            onLoad={() => setLoaded(true)}
            className={`absolute inset-0 h-full w-full object-cover transition-opacity duration-500 ${loaded ? 'opacity-100' : 'opacity-0'} ${imgClassName}`}
          />
        </>
      ) : (
        <div className="absolute inset-0 grid place-items-center text-ink/20">
          <Icon name={fallback} className="h-1/3 w-1/3" strokeWidth={1.4} />
        </div>
      )}
    </div>
  );
}
