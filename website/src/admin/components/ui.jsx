import { Fragment, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { Icon } from '../../components/Icon';

// The admin's own compact kit, drawn in the site's palette. Every piece is
// built to work at phone width first: inputs stay at 16px on small screens so
// iOS never zooms on focus, dialogs become bottom sheets, and tables collapse
// into cards.

const BUTTON_BASE =
  'inline-flex min-h-[40px] items-center justify-center gap-2 rounded-xl px-4 py-2 text-sm font-bold transition disabled:cursor-not-allowed disabled:opacity-50';
const BUTTON_VARIANTS = {
  solid: 'bg-forest text-white hover:bg-forest-soft',
  outline: 'bg-white text-forest ring-1 ring-inset ring-forest/20 hover:bg-forest/5',
  danger: 'bg-tomato text-white hover:brightness-110',
  ghost: 'text-ink-soft hover:bg-ink/5',
  success: 'bg-leaf text-white hover:bg-leaf-bright',
};

export function Button({ variant = 'solid', className = '', ...props }) {
  return <button type="button" className={`${BUTTON_BASE} ${BUTTON_VARIANTS[variant]} ${className}`} {...props} />;
}

/** A router link that looks like a Button. */
export function ButtonLink({ variant = 'solid', className = '', ...props }) {
  return <Link className={`${BUTTON_BASE} ${BUTTON_VARIANTS[variant]} ${className}`} {...props} />;
}

const fieldClass =
  'w-full rounded-xl border border-ink/10 bg-white px-3 py-2.5 text-base outline-none transition focus:border-leaf focus:ring-2 focus:ring-leaf/20 sm:py-2 sm:text-sm';

export function Input({ label, error, className = '', ...props }) {
  return (
    <label className="block min-w-0">
      {label && <span className="mb-1 block text-sm font-bold text-ink-soft">{label}</span>}
      <input className={`${fieldClass} ${className}`} {...props} />
      {error && <span className="mt-1 block text-xs text-tomato">{error}</span>}
    </label>
  );
}

export function Textarea({ label, error, className = '', ...props }) {
  return (
    <label className="block min-w-0">
      {label && <span className="mb-1 block text-sm font-bold text-ink-soft">{label}</span>}
      <textarea className={`${fieldClass} ${className}`} {...props} />
      {error && <span className="mt-1 block text-xs text-tomato">{error}</span>}
    </label>
  );
}

export function Select({ label, error, className = '', children, ...props }) {
  return (
    <label className="block min-w-0">
      {label && <span className="mb-1 block text-sm font-bold text-ink-soft">{label}</span>}
      <select className={`${fieldClass} ${className}`} {...props}>
        {children}
      </select>
      {error && <span className="mt-1 block text-xs text-tomato">{error}</span>}
    </label>
  );
}

export function Checkbox({ label, className = '', ...props }) {
  return (
    <label className={`flex min-h-[40px] cursor-pointer items-center gap-2 text-sm font-bold text-ink-soft ${className}`}>
      <input type="checkbox" className="h-5 w-5 rounded border-ink/20 accent-forest" {...props} />
      {label}
    </label>
  );
}

export function Card({ className = '', children }) {
  return <div className={`rounded-2xl bg-white p-4 shadow-card sm:p-5 ${className}`}>{children}</div>;
}

export function Badge({ tone = 'neutral', children }) {
  const tones = {
    neutral: 'bg-ink/5 text-ink-soft',
    green: 'bg-leaf-tint text-forest',
    red: 'bg-red-50 text-tomato',
    yellow: 'bg-tangerine-soft text-tangerine',
    blue: 'bg-sky-100 text-sky-700',
  };
  return (
    <span className={`inline-flex items-center whitespace-nowrap rounded-full px-2.5 py-1 text-xs font-bold ${tones[tone]}`}>
      {children}
    </span>
  );
}

export function Spinner({ className = 'h-5 w-5' }) {
  return (
    <svg className={`animate-spin ${className}`} viewBox="0 0 24 24" fill="none" aria-hidden="true">
      <circle cx="12" cy="12" r="9" stroke="currentColor" strokeOpacity=".2" strokeWidth="3" />
      <path d="M21 12a9 9 0 0 0-9-9" stroke="currentColor" strokeWidth="3" strokeLinecap="round" />
    </svg>
  );
}

export function PageLoader() {
  return (
    <div className="flex h-64 items-center justify-center text-forest">
      <Spinner className="h-8 w-8" />
    </div>
  );
}

export function ErrorBanner({ message }) {
  if (!message) return null;
  return (
    <div className="my-3 rounded-xl bg-red-50 px-4 py-3 text-sm font-semibold text-tomato ring-1 ring-red-200">
      {message}
    </div>
  );
}

export function EmptyState({ children = 'لا توجد بيانات' }) {
  return <div className="py-12 text-center text-sm font-semibold text-ink-muted">{children}</div>;
}

/** Title on one side, actions on the other; the actions wrap under it on phones. */
export function PageHeader({ title, children }) {
  return (
    <div className="mb-5 flex flex-wrap items-center justify-between gap-3">
      <h1 className="font-display text-2xl font-extrabold sm:text-3xl">{title}</h1>
      {children && <div className="flex flex-wrap gap-2">{children}</div>}
    </div>
  );
}

/** Filters row: stacked full-width on phones, side by side from `sm`. */
export function Filters({ children }) {
  return <div className="mb-4 grid gap-3 sm:flex sm:flex-wrap sm:[&>*]:w-64">{children}</div>;
}

/** Cancel / submit row: full-width stacked buttons on phones. */
export function FormActions({ children, className = '' }) {
  return (
    <div className={`flex flex-col-reverse gap-2 pt-2 sm:flex-row sm:justify-end [&>button]:w-full sm:[&>button]:w-auto ${className}`}>
      {children}
    </div>
  );
}

function useLockScroll(active) {
  useEffect(() => {
    if (!active) return undefined;
    const prev = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    return () => {
      document.body.style.overflow = prev;
    };
  }, [active]);
}

/** Centered dialog from `sm`, bottom sheet on phones. */
export function Modal({ open, onClose, title, children, width = 'max-w-lg' }) {
  useLockScroll(open);
  useEffect(() => {
    if (!open) return undefined;
    const onKey = (e) => e.key === 'Escape' && onClose();
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [open, onClose]);
  if (!open) return null;
  return (
    <div
      className="fixed inset-0 z-[80] flex items-end justify-center bg-forest-deep/50 backdrop-blur-sm sm:items-center sm:p-4"
      onClick={onClose}
      dir="rtl"
    >
      <div
        role="dialog"
        aria-modal="true"
        className={`flex max-h-[92vh] w-full ${width} flex-col overflow-hidden rounded-t-3xl bg-white shadow-lift sm:max-h-[90vh] sm:rounded-3xl`}
        onClick={(e) => e.stopPropagation()}
        style={{ paddingBottom: 'env(safe-area-inset-bottom)' }}
      >
        <div className="flex items-center justify-between gap-3 border-b border-ink/5 px-4 py-3 sm:px-6 sm:py-4">
          <h3 className="truncate text-lg font-extrabold">{title}</h3>
          <button
            type="button"
            onClick={onClose}
            className="grid h-10 w-10 shrink-0 place-items-center rounded-full text-ink-muted hover:bg-ink/5"
            aria-label="إغلاق"
          >
            <Icon name="x" className="h-5 w-5" />
          </button>
        </div>
        <div className="overflow-y-auto overscroll-contain px-4 py-4 sm:px-6 sm:py-5">{children}</div>
      </div>
    </div>
  );
}

export function Pagination({ page, total, limit, onChange }) {
  const totalPages = Math.max(1, Math.ceil((total ?? 0) / (limit || 1)));
  if (totalPages <= 1) return null;
  return (
    <div className="flex items-center justify-center gap-2 border-t border-ink/5 p-3">
      <Button variant="outline" disabled={page <= 1} onClick={() => onChange(page - 1)}>
        السابق
      </Button>
      <span className="num px-2 text-sm font-bold text-ink-soft">
        {page} / {totalPages}
      </span>
      <Button variant="outline" disabled={page >= totalPages} onClick={() => onChange(page + 1)}>
        التالي
      </Button>
    </div>
  );
}

export function ConfirmModal({ open, onClose, onConfirm, title = 'تأكيد', message, loading }) {
  return (
    <Modal open={open} onClose={onClose} title={title} width="max-w-sm">
      <p className="text-sm text-ink-soft">{message}</p>
      <FormActions className="mt-5">
        <Button variant="ghost" onClick={onClose}>
          إلغاء
        </Button>
        <Button variant="danger" onClick={onConfirm} disabled={loading}>
          {loading ? <Spinner className="h-4 w-4" /> : 'تأكيد'}
        </Button>
      </FormActions>
    </Modal>
  );
}

/**
 * A table from `md` up, a stack of cards below it.
 *
 * columns: [{ key, header, cell(row), primary?, actions? }]
 * - `primary` columns form each card's heading on phones.
 * - the `actions` column sits at the bottom of each card.
 * - the rest render as label / value pairs.
 */
export function DataTable({ columns, rows, rowKey = (r) => r.id, empty = 'لا توجد بيانات' }) {
  if (!rows?.length) return <EmptyState>{empty}</EmptyState>;
  const primary = columns.filter((c) => c.primary);
  const actions = columns.find((c) => c.actions);
  const details = columns.filter((c) => !c.primary && !c.actions);
  return (
    <>
      <div className="hidden overflow-x-auto md:block">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-ink/5 text-ink-muted">
              {columns.map((c) => (
                <th key={c.key} className="whitespace-nowrap px-4 py-3 text-start font-bold">
                  {c.header}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={rowKey(row)} className="border-b border-ink/5 last:border-0 hover:bg-cream/50">
                {columns.map((c) => (
                  <td key={c.key} className={`px-4 py-3 ${c.actions ? 'text-end' : ''}`}>
                    {c.actions ? <div className="flex justify-end gap-2">{c.cell(row)}</div> : c.cell(row)}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <ul className="divide-y divide-ink/5 md:hidden">
        {rows.map((row) => (
          <li key={rowKey(row)} className="space-y-3 p-4">
            {primary.length > 0 && (
              <div className="flex flex-wrap items-center justify-between gap-2">
                {primary.map((c) => (
                  <Fragment key={c.key}>{c.cell(row)}</Fragment>
                ))}
              </div>
            )}
            {details.length > 0 && (
              <dl className="grid grid-cols-2 gap-x-3 gap-y-2 text-sm">
                {details.map((c) => (
                  <div key={c.key} className="min-w-0">
                    <dt className="text-xs font-bold text-ink-muted">{c.header}</dt>
                    <dd className="break-words text-ink-soft">{c.cell(row)}</dd>
                  </div>
                ))}
              </dl>
            )}
            {actions && <div className="flex flex-wrap gap-2 [&>*]:flex-1">{actions.cell(row)}</div>}
          </li>
        ))}
      </ul>
    </>
  );
}
