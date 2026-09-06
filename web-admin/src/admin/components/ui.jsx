export function Button({ variant = 'solid', className = '', ...props }) {
  const base =
    'inline-flex items-center justify-center gap-2 rounded-xl px-4 py-2 text-sm font-bold transition disabled:opacity-50 disabled:cursor-not-allowed';
  const variants = {
    solid: 'bg-brand text-white hover:bg-brand-deep',
    outline: 'bg-white text-brand-deep ring-1 ring-inset ring-brand/30 hover:bg-brand/5',
    danger: 'bg-red-600 text-white hover:bg-red-700',
    ghost: 'text-ink-soft hover:bg-black/5',
  };
  return <button className={`${base} ${variants[variant]} ${className}`} {...props} />;
}

export function Input({ label, error, className = '', ...props }) {
  return (
    <label className="block">
      {label && <span className="mb-1 block text-sm font-bold text-ink-soft">{label}</span>}
      <input
        className={`w-full rounded-xl border border-black/10 bg-white px-3 py-2 text-sm outline-none focus:border-brand focus:ring-2 focus:ring-brand/20 ${className}`}
        {...props}
      />
      {error && <span className="mt-1 block text-xs text-red-600">{error}</span>}
    </label>
  );
}

export function Textarea({ label, error, className = '', ...props }) {
  return (
    <label className="block">
      {label && <span className="mb-1 block text-sm font-bold text-ink-soft">{label}</span>}
      <textarea
        className={`w-full rounded-xl border border-black/10 bg-white px-3 py-2 text-sm outline-none focus:border-brand focus:ring-2 focus:ring-brand/20 ${className}`}
        {...props}
      />
      {error && <span className="mt-1 block text-xs text-red-600">{error}</span>}
    </label>
  );
}

export function Select({ label, error, className = '', children, ...props }) {
  return (
    <label className="block">
      {label && <span className="mb-1 block text-sm font-bold text-ink-soft">{label}</span>}
      <select
        className={`w-full rounded-xl border border-black/10 bg-white px-3 py-2 text-sm outline-none focus:border-brand focus:ring-2 focus:ring-brand/20 ${className}`}
        {...props}
      >
        {children}
      </select>
      {error && <span className="mt-1 block text-xs text-red-600">{error}</span>}
    </label>
  );
}

export function Checkbox({ label, className = '', ...props }) {
  return (
    <label className={`flex items-center gap-2 text-sm font-bold text-ink-soft ${className}`}>
      <input type="checkbox" className="h-4 w-4 rounded border-black/20 text-brand focus:ring-brand" {...props} />
      {label}
    </label>
  );
}

export function Card({ className = '', children }) {
  return (
    <div className={`rounded-2xl bg-white p-5 shadow-sm ring-1 ring-black/5 ${className}`}>
      {children}
    </div>
  );
}

export function Badge({ tone = 'neutral', children }) {
  const tones = {
    neutral: 'bg-black/5 text-ink-soft',
    green: 'bg-green-100 text-green-700',
    red: 'bg-red-100 text-red-700',
    yellow: 'bg-yellow-100 text-yellow-800',
    blue: 'bg-blue-100 text-blue-700',
  };
  return (
    <span className={`inline-flex items-center rounded-full px-2.5 py-1 text-xs font-bold ${tones[tone]}`}>
      {children}
    </span>
  );
}

export function Spinner({ className = 'h-5 w-5' }) {
  return (
    <svg className={`animate-spin text-brand ${className}`} viewBox="0 0 24 24" fill="none">
      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z" />
    </svg>
  );
}

export function PageLoader() {
  return (
    <div className="flex h-64 items-center justify-center">
      <Spinner className="h-8 w-8" />
    </div>
  );
}

export function ErrorBanner({ message }) {
  if (!message) return null;
  return (
    <div className="rounded-xl bg-red-50 px-4 py-3 text-sm font-semibold text-red-700 ring-1 ring-red-200">
      {message}
    </div>
  );
}

export function EmptyState({ children = 'لا توجد بيانات' }) {
  return <div className="py-12 text-center text-sm font-semibold text-ink-muted">{children}</div>;
}

export function Modal({ open, onClose, title, children, width = 'max-w-lg' }) {
  if (!open) return null;
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4" onClick={onClose}>
      <div
        className={`max-h-[90vh] w-full ${width} overflow-y-auto rounded-2xl bg-white p-6 shadow-xl`}
        onClick={(e) => e.stopPropagation()}
      >
        <div className="mb-4 flex items-center justify-between">
          <h3 className="text-lg font-black">{title}</h3>
          <button onClick={onClose} className="rounded-lg p-1.5 text-ink-muted hover:bg-black/5" aria-label="إغلاق">
            ✕
          </button>
        </div>
        {children}
      </div>
    </div>
  );
}

export function Pagination({ page, total, limit, onChange }) {
  const totalPages = Math.max(1, Math.ceil((total ?? 0) / (limit || 1)));
  if (totalPages <= 1) return null;
  return (
    <div className="mt-4 flex items-center justify-center gap-2">
      <Button variant="outline" disabled={page <= 1} onClick={() => onChange(page - 1)}>
        السابق
      </Button>
      <span className="px-2 text-sm font-bold text-ink-soft">
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
      <div className="mt-5 flex justify-end gap-2">
        <Button variant="ghost" onClick={onClose}>
          إلغاء
        </Button>
        <Button variant="danger" onClick={onConfirm} disabled={loading}>
          {loading ? <Spinner className="h-4 w-4" /> : 'تأكيد'}
        </Button>
      </div>
    </Modal>
  );
}
