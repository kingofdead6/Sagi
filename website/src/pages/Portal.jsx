import { useMemo, useRef, useState } from 'react';
import { AnimatePresence, Reorder, motion, useDragControls } from 'framer-motion';
import { Icon } from '../components/Icon';
import { Badge, Button, Confirm, EmptyState, ErrorState, Field, IconButton, Img, Input, Modal, Segmented, Skeleton, Spinner, Switch, Textarea } from '../components/ui';
import { useI18n } from '../state/i18n';
import { useToast } from '../state/toast';
import { useAsync } from '../lib/hooks';
import { portal, uploads } from '../lib/services';
import { errorInfo } from '../lib/api';
import { money } from '../lib/format';

const STATUS_TONE = { pending: 'tangerine', approved: 'leaf', rejected: 'tomato' };

/** Strips server-only fields so the body passes the strict product schema. */
function toBody(p) {
  return {
    name: p.name.trim(),
    description: p.description.trim() || undefined,
    priceCentimes: Math.round(Number(p.price || 0) * 100),
    section: p.section || null,
    image: p.image ? { url: p.image.url, publicId: p.image.publicId, ...(p.image.width ? { width: p.image.width } : {}), ...(p.image.height ? { height: p.image.height } : {}) } : null,
    isAvailable: p.isAvailable,
    options: p.options
      .filter((o) => o.name.trim() && o.values.some((v) => v.name.trim()))
      .map((o) => ({
        name: o.name.trim(),
        type: o.type,
        isRequired: o.isRequired,
        values: o.values.filter((v) => v.name.trim()).map((v) => ({ name: v.name.trim(), priceDeltaCentimes: Math.round(Number(v.delta || 0) * 100) })),
      })),
  };
}

function fromProduct(p) {
  return {
    name: p?.name ?? '',
    description: p?.description ?? '',
    price: p ? String((p.priceCentimes ?? 0) / 100) : '',
    section: p?.section?.id ?? p?.section ?? '',
    image: p?.image ?? null,
    isAvailable: p?.isAvailable ?? true,
    options: (p?.options ?? []).map((o) => ({
      key: Math.random(),
      name: o.name,
      type: o.type,
      isRequired: o.isRequired,
      values: o.values.map((v) => ({ key: Math.random(), name: v.name, delta: String((v.priceDeltaCentimes ?? 0) / 100) })),
    })),
  };
}

function ImagePicker({ image, onChange }) {
  const { t, errorText } = useI18n();
  const toast = useToast();
  const input = useRef(null);
  const [busy, setBusy] = useState(false);
  const [preview, setPreview] = useState(null);
  const pick = async (file) => {
    if (!file) return;
    setPreview(URL.createObjectURL(file));
    setBusy(true);
    try {
      onChange(await uploads.image(file, { folder: 'products' }));
    } catch (e) {
      toast.error(errorText(e));
      setPreview(null);
    } finally {
      setBusy(false);
    }
  };
  return (
    <div>
      <span className="label">{t('portal.image')}</span>
      <motion.button
        type="button"
        whileHover={{ scale: 1.01 }}
        onClick={() => input.current?.click()}
        onDragOver={(e) => e.preventDefault()}
        onDrop={(e) => {
          e.preventDefault();
          pick(e.dataTransfer.files?.[0]);
        }}
        className="group relative block aspect-square w-40 overflow-hidden rounded-3xl border-2 border-dashed border-leaf/40 bg-cream"
      >
        {preview && busy ? (
          <img src={preview} alt="" className="h-full w-full object-cover opacity-60" />
        ) : image ? (
          <Img image={image} ratio={1} width={320} className="h-full w-full" />
        ) : (
          <span className="flex h-full flex-col items-center justify-center gap-2 text-forest">
            <Icon name="upload" className="h-8 w-8" />
            <span className="text-sm font-bold">{t('portal.uploadImage')}</span>
          </span>
        )}
        {busy && (
          <span className="absolute inset-0 grid place-items-center bg-white/50 text-forest">
            <Spinner />
          </span>
        )}
        {image && !busy && (
          <span className="absolute inset-x-0 bottom-0 bg-forest-deep/70 py-1.5 text-center text-xs font-bold text-white opacity-0 transition group-hover:opacity-100">
            {t('portal.changeImage')}
          </span>
        )}
      </motion.button>
      <input ref={input} type="file" accept="image/*" hidden onChange={(e) => pick(e.target.files?.[0])} />
    </div>
  );
}

function OptionsEditor({ options, onChange }) {
  const { t } = useI18n();
  const update = (key, patch) => onChange(options.map((o) => (o.key === key ? { ...o, ...patch } : o)));
  return (
    <div>
      <div className="mb-2 flex items-center justify-between">
        <span className="label !mb-0">{t('portal.options')}</span>
        <Button
          type="button"
          size="sm"
          variant="soft"
          icon="plus"
          onClick={() => onChange([...options, { key: Math.random(), name: '', type: 'single', isRequired: false, values: [{ key: Math.random(), name: '', delta: '0' }] }])}
        >
          {t('portal.optionAdd')}
        </Button>
      </div>
      <AnimatePresence initial={false}>
        {options.map((o) => (
          <motion.div
            key={o.key}
            layout
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
            className="mb-3 overflow-hidden rounded-3xl border border-ink/10 bg-cream/50"
          >
            <div className="space-y-3 p-3 sm:p-4">
              <div className="flex gap-2">
                <Input value={o.name} onChange={(e) => update(o.key, { name: e.target.value })} placeholder={t('portal.optionName')} maxLength={60} />
                <IconButton icon="trash" label={t('common.delete')} variant="ghost" className="!text-tomato" onClick={() => onChange(options.filter((x) => x.key !== o.key))} />
              </div>
              <div className="flex flex-wrap items-center gap-3">
                <Segmented size="sm" value={o.type} onChange={(v) => update(o.key, { type: v })} options={[{ value: 'single', label: t('portal.single') }, { value: 'multi', label: t('portal.multi') }]} />
                <label className="flex items-center gap-2 text-sm font-bold">
                  <Switch checked={o.isRequired} onChange={(v) => update(o.key, { isRequired: v })} label={t('portal.optionRequired')} />
                  {t('portal.optionRequired')}
                </label>
              </div>
              {o.values.map((v) => (
                <div key={v.key} className="flex gap-2">
                  <Input
                    value={v.name}
                    onChange={(e) => update(o.key, { values: o.values.map((x) => (x.key === v.key ? { ...x, name: e.target.value } : x)) })}
                    placeholder={t('portal.valueName')}
                    maxLength={60}
                  />
                  <Input
                    type="number"
                    min="0"
                    value={v.delta}
                    onChange={(e) => update(o.key, { values: o.values.map((x) => (x.key === v.key ? { ...x, delta: e.target.value } : x)) })}
                    placeholder={t('portal.valueDelta')}
                    className="num w-24 shrink-0 sm:w-28"
                    dir="ltr"
                  />
                  <IconButton
                    icon="x"
                    label={t('common.delete')}
                    variant="ghost"
                    disabled={o.values.length <= 1}
                    onClick={() => update(o.key, { values: o.values.filter((x) => x.key !== v.key) })}
                  />
                </div>
              ))}
              {o.values.length < 20 && (
                <button
                  type="button"
                  onClick={() => update(o.key, { values: [...o.values, { key: Math.random(), name: '', delta: '0' }] })}
                  className="flex items-center gap-1.5 text-sm font-bold text-forest hover:underline"
                >
                  <Icon name="plus" className="h-4 w-4" /> {t('portal.valueAdd')}
                </button>
              )}
            </div>
          </motion.div>
        ))}
      </AnimatePresence>
    </div>
  );
}

function ProductEditor({ open, product, sections, onClose, onSaved }) {
  const { t, errorText } = useI18n();
  const toast = useToast();
  const [form, setForm] = useState(() => fromProduct(product));
  const [busy, setBusy] = useState(false);
  const [tried, setTried] = useState(false);
  const [lastKey, setLastKey] = useState(null);

  // Re-seed whenever a different product (or "new") is opened.
  const key = open ? product?.id ?? 'new' : null;
  if (key !== lastKey) {
    setLastKey(key);
    if (open) {
      setForm(fromProduct(product));
      setTried(false);
    }
  }

  const set = (k) => (e) => setForm((f) => ({ ...f, [k]: e.target.value }));
  const invalid = !form.name.trim() || form.price === '' || Number(form.price) < 0;

  const save = async () => {
    setTried(true);
    if (invalid) {
      toast.error(t('portal.invalid'));
      return;
    }
    setBusy(true);
    try {
      const body = toBody(form);
      const saved = product ? await portal.updateProduct(product.id, body) : await portal.createProduct(body);
      toast.success(saved.status === 'pending' ? t('portal.submitted') : t('portal.saved'));
      onSaved(saved);
      onClose();
    } catch (e) {
      const info = errorInfo(e);
      toast.error(info.details?.[0]?.message ?? errorText(e));
    } finally {
      setBusy(false);
    }
  };

  return (
    <Modal
      open={open}
      onClose={onClose}
      wide
      title={product ? t('portal.productEdit') : t('portal.productNew')}
      footer={<Button size="lg" className="w-full" loading={busy} onClick={save} icon="send">{product ? t('common.save') : t('portal.submitted')}</Button>}
    >
      <div className="space-y-5 p-4 sm:p-6">
        <p className="flex items-start gap-2 rounded-2xl bg-tangerine-soft p-3 text-sm font-bold text-tangerine">
          <Icon name="info" className="h-5 w-5 shrink-0" /> {t('portal.reviewNotice')}
        </p>
        {product?.status === 'rejected' && product.rejectionReason && (
          <p className="rounded-2xl bg-red-50 p-3 text-sm font-bold text-tomato">{t('portal.rejectedWhy', { reason: product.rejectionReason })}</p>
        )}
        <div className="flex flex-col items-center gap-5 sm:flex-row sm:items-start">
          <ImagePicker image={form.image} onChange={(image) => setForm((f) => ({ ...f, image }))} />
          <div className="w-full flex-1 space-y-4">
            <Field label={t('portal.name')} error={tried && !form.name.trim() ? t('portal.invalid') : null}>
              <Input value={form.name} onChange={set('name')} maxLength={80} invalid={tried && !form.name.trim()} />
            </Field>
            <div className="grid grid-cols-2 gap-3">
              <Field label={t('portal.price')}>
                <Input type="number" min="0" value={form.price} onChange={set('price')} className="num" dir="ltr" invalid={tried && form.price === ''} />
              </Field>
              <Field label={t('portal.section')}>
                <select value={form.section} onChange={set('section')} className="field">
                  <option value="">{t('portal.noSection')}</option>
                  {sections.map((s) => <option key={s.id} value={s.id}>{s.name}</option>)}
                </select>
              </Field>
            </div>
          </div>
        </div>
        <Field label={`${t('portal.description')} (${t('common.optional')})`}>
          <Textarea value={form.description} onChange={set('description')} maxLength={400} />
        </Field>
        <label className="flex items-center justify-between rounded-2xl bg-cream px-4 py-3 font-bold">
          {t('portal.available')}
          <Switch checked={form.isAvailable} onChange={(v) => setForm((f) => ({ ...f, isAvailable: v }))} label={t('portal.available')} />
        </label>
        <OptionsEditor options={form.options} onChange={(options) => setForm((f) => ({ ...f, options }))} />
      </div>
    </Modal>
  );
}

function Sections({ sections, onChanged }) {
  const { t, errorText } = useI18n();
  const toast = useToast();
  const [name, setName] = useState('');
  const [editing, setEditing] = useState(null);
  const [deleting, setDeleting] = useState(null);
  const [busy, setBusy] = useState(false);

  const add = async (e) => {
    e.preventDefault();
    if (!name.trim()) return;
    setBusy(true);
    try {
      await portal.createSection({ name: name.trim(), sortOrder: sections.length });
      setName('');
      onChanged();
    } catch (err) {
      toast.error(errorText(err));
    } finally {
      setBusy(false);
    }
  };

  const move = async (index, dir) => {
    const other = sections[index + dir];
    const self = sections[index];
    if (!other) return;
    try {
      await Promise.all([
        portal.updateSection(self.id, { sortOrder: index + dir }),
        portal.updateSection(other.id, { sortOrder: index }),
      ]);
      onChanged();
    } catch (err) {
      toast.error(errorText(err));
    }
  };

  const rename = async () => {
    if (!editing?.name.trim()) return;
    try {
      await portal.updateSection(editing.id, { name: editing.name.trim() });
      setEditing(null);
      onChanged();
    } catch (err) {
      toast.error(errorText(err));
    }
  };

  return (
    <section className="card p-4 sm:p-5">
      <h2 className="mb-4 text-xl font-bold">{t('portal.sections')}</h2>
      <form onSubmit={add} className="mb-4 flex gap-2">
        <Input value={name} onChange={(e) => setName(e.target.value)} placeholder={t('portal.sectionName')} maxLength={60} />
        <Button type="submit" icon="plus" loading={busy} disabled={!name.trim()} aria-label={t('portal.sectionNew')} />
      </form>
      <ul className="space-y-2">
        <AnimatePresence initial={false}>
          {sections.map((s, i) => (
            <motion.li key={s.id} layout initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }} className="flex items-center gap-1 rounded-2xl bg-cream p-2">
              {editing?.id === s.id ? (
                <form
                  className="flex flex-1 gap-1"
                  onSubmit={(e) => {
                    e.preventDefault();
                    rename();
                  }}
                >
                  <input autoFocus value={editing.name} onChange={(e) => setEditing({ ...editing, name: e.target.value })} maxLength={60} className="field !py-2" />
                  <IconButton icon="check" label={t('common.save')} variant="primary" type="submit" />
                </form>
              ) : (
                <>
                  <span className="flex-1 truncate px-2 font-bold">{s.name}</span>
                  <IconButton icon="up" label={t('portal.moveUp')} variant="ghost" size="h-8 w-8" disabled={i === 0} onClick={() => move(i, -1)} />
                  <IconButton icon="down" label={t('portal.moveDown')} variant="ghost" size="h-8 w-8" disabled={i === sections.length - 1} onClick={() => move(i, 1)} />
                  <IconButton icon="pencil" label={t('common.edit')} variant="ghost" size="h-8 w-8" onClick={() => setEditing({ id: s.id, name: s.name })} />
                  <IconButton icon="trash" label={t('common.delete')} variant="ghost" size="h-8 w-8" className="!text-tomato" onClick={() => setDeleting(s)} />
                </>
              )}
            </motion.li>
          ))}
        </AnimatePresence>
      </ul>
      <Confirm
        open={Boolean(deleting)}
        danger
        title={t('portal.sectionDeleteConfirm')}
        text={deleting?.name}
        confirmLabel={t('common.delete')}
        onClose={() => setDeleting(null)}
        onConfirm={async () => {
          try {
            await portal.deleteSection(deleting.id);
            setDeleting(null);
            onChanged();
          } catch (err) {
            toast.error(errorText(err));
          }
        }}
      />
    </section>
  );
}

function ProductRow({ product, section, onEdit, onDelete, onToggle, onGrip }) {
  const { t, lang } = useI18n();
  const actions = (
    <>
      <IconButton icon="pencil" label={t('common.edit')} variant="ghost" onClick={() => onEdit(product)} />
      <IconButton icon="trash" label={t('common.delete')} variant="ghost" className="!text-tomato" onClick={() => onDelete(product)} />
    </>
  );
  return (
    <div className="rounded-3xl bg-white p-3 shadow-card">
      <div className="flex items-center gap-3">
        {onGrip && (
          // Only the grip starts a drag, so a finger on the rest of the card
          // still scrolls the page on phones.
          <span
            onPointerDown={onGrip}
            className="-ms-1 grid cursor-grab touch-none select-none place-items-center self-stretch px-1 text-ink/30 active:cursor-grabbing"
            aria-hidden="true"
          >
            <Icon name="grip" className="h-5 w-5" strokeWidth={3} />
          </span>
        )}
        <Img image={product.image} ratio={1} width={140} className="h-16 w-16 shrink-0 rounded-2xl" fallback="burger" />
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-center gap-x-2 gap-y-1">
            <p className="line-clamp-2 break-words font-bold sm:truncate">{product.name}</p>
            <Badge tone={STATUS_TONE[product.status] ?? 'ink'} pulse={product.status === 'pending'}>{t(`portal.${product.status ?? 'approved'}`)}</Badge>
          </div>
          <p className="num text-sm text-ink-muted">
            {money(product.priceCentimes, lang)}
            {section && ` · ${section.name}`}
            {product.options?.length > 0 && ` · ${product.options.length} ${t('portal.options')}`}
          </p>
          {product.status === 'rejected' && product.rejectionReason && (
            <p className="line-clamp-2 text-xs font-bold text-tomato sm:line-clamp-1">{t('portal.rejectedWhy', { reason: product.rejectionReason })}</p>
          )}
          {product.status === 'pending' && <p className="text-xs text-ink-muted">{t('portal.pendingHint')}</p>}
        </div>
        <div className="hidden shrink-0 items-center gap-1 sm:flex">
          <Switch checked={product.isAvailable} onChange={() => onToggle(product)} label={t('portal.available')} />
          {actions}
        </div>
      </div>
      <div className="mt-2 flex items-center justify-between border-t border-ink/5 pt-2 sm:hidden">
        <label className="flex items-center gap-2 text-sm font-bold text-ink-soft">
          <Switch checked={product.isAvailable} onChange={() => onToggle(product)} label={t('portal.available')} />
          {product.isAvailable ? t('portal.available') : t('portal.unavailable')}
        </label>
        <div className="flex items-center gap-1">{actions}</div>
      </div>
    </div>
  );
}

/** A reorderable row whose drag starts from the grip only. */
function DraggableProduct({ product, onDrop, ...rowProps }) {
  const controls = useDragControls();
  return (
    <Reorder.Item
      value={product}
      dragListener={false}
      dragControls={controls}
      onDragEnd={onDrop}
      whileDrag={{ scale: 1.03, boxShadow: '0 24px 48px -16px rgba(14,77,43,.35)' }}
      className="list-none rounded-3xl"
    >
      <ProductRow product={product} onGrip={(e) => controls.start(e)} {...rowProps} />
    </Reorder.Item>
  );
}

export default function Portal() {
  const { t, errorText } = useI18n();
  const toast = useToast();
  const shop = useAsync(() => portal.me(), []);
  const sections = useAsync(() => portal.sections(), []);
  const products = useAsync(() => portal.products(), []);
  const [filter, setFilter] = useState('all');
  // Phones show one pane at a time; from `lg` both sit side by side.
  const [pane, setPane] = useState('products');
  const [editing, setEditing] = useState(undefined);
  const [deleting, setDeleting] = useState(null);
  const [togglingShop, setTogglingShop] = useState(false);
  const orderRef = useRef(null);

  const sectionById = useMemo(() => new Map((sections.data ?? []).map((s) => [s.id, s])), [sections.data]);
  const all = products.data ?? [];
  const counts = useMemo(() => all.reduce((c, p) => ({ ...c, [p.status ?? 'approved']: (c[p.status ?? 'approved'] ?? 0) + 1 }), {}), [all]);
  const shown = filter === 'all' ? all : all.filter((p) => (p.status ?? 'approved') === filter);

  if (shop.error) {
    const forbidden = shop.error?.response?.status === 403;
    return forbidden ? <EmptyState icon="store" title={t('portal.notLinked')} /> : <ErrorState error={shop.error} onRetry={shop.reload} />;
  }

  const toggleShop = async (isOpen) => {
    setTogglingShop(true);
    try {
      shop.setData(await portal.setOpen(isOpen));
    } catch (e) {
      toast.error(errorText(e));
    } finally {
      setTogglingShop(false);
    }
  };

  // Availability alone never re-enters review on the server — it's stock, not content.
  const toggleProduct = async (p) => {
    products.setData((list) => list.map((x) => (x.id === p.id ? { ...x, isAvailable: !x.isAvailable } : x)));
    try {
      await portal.updateProduct(p.id, { isAvailable: !p.isAvailable });
    } catch (e) {
      toast.error(errorText(e));
      products.reload();
    }
  };

  // Drag-to-reorder is only meaningful on the full list, where order = menu order.
  // The ref holds the latest order so the drop saves exactly what is on screen.
  const reorder = (next) => {
    orderRef.current = next;
    products.setData(next);
  };
  const persistOrder = async () => {
    const list = orderRef.current;
    if (!list) return;
    orderRef.current = null;
    try {
      await portal.reorderProducts(list.map((p, i) => ({ id: p.id, sortOrder: i })));
    } catch (e) {
      toast.error(errorText(e));
      products.reload();
    }
  };

  const s = shop.data;
  return (
    <div className="container-x pb-28 pt-4 sm:pt-6 lg:pb-12">
      <motion.div
        layout
        className={`relative overflow-hidden rounded-[2rem] p-5 text-white sm:rounded-[2.5rem] sm:p-6 shadow-lift transition-colors duration-700 md:p-8 ${s?.isOpen ? 'bg-forest' : 'bg-ink-soft'}`}
      >
        {!s ? (
          <Skeleton className="h-20 bg-white/10" />
        ) : (
          <div className="relative flex flex-wrap items-center gap-4 sm:gap-5">
            <motion.div initial={{ scale: 0, rotate: -20 }} animate={{ scale: 1, rotate: 0 }} transition={{ type: 'spring', stiffness: 200, damping: 14 }} className="h-16 w-16 shrink-0 overflow-hidden rounded-3xl bg-white p-1.5 sm:h-20 sm:w-20">
              <Img image={s.logo} ratio={1} width={160} className="h-full w-full rounded-2xl" fallback="store" />
            </motion.div>
            <div className="min-w-0 flex-1">
              <p className="text-sm font-bold text-white/70">{t('portal.title')}</p>
              <h1 className="truncate text-2xl font-extrabold sm:text-3xl md:text-4xl">{s.name}</h1>
              <p className="text-sm text-white/80">{s.isOpen ? t('portal.openHint') : t('portal.closedHint')}</p>
            </div>
            <div className="flex w-full items-center justify-between gap-3 rounded-full bg-white/10 py-2 pe-2 ps-5 backdrop-blur sm:w-auto sm:justify-start">
              <span className="font-bold">{s.isOpen ? t('portal.open') : t('portal.closed')}</span>
              <Switch checked={s.isOpen} onChange={toggleShop} disabled={togglingShop} size="lg" label={t('portal.open')} />
            </div>
          </div>
        )}
      </motion.div>

      <Segmented
        className="mt-5 flex w-full lg:hidden"
        value={pane}
        onChange={setPane}
        options={[
          { value: 'products', label: t('portal.products'), icon: 'burger', badge: all.length },
          { value: 'sections', label: t('portal.sections'), icon: 'menu', badge: sections.data?.length ?? 0 },
        ]}
      />

      <div className="mt-5 grid gap-6 lg:mt-8 lg:grid-cols-[1fr_320px]">
        <section className={`min-w-0 ${pane === 'products' ? '' : 'hidden lg:block'}`}>
          <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
            <h2 className="text-xl font-extrabold sm:text-2xl">{t('portal.products')} <span className="num text-base text-ink-muted">({all.length})</span></h2>
            <Button icon="plus" className="hidden sm:inline-flex" onClick={() => setEditing(null)}>{t('portal.productNew')}</Button>
          </div>
          <div className="scrollbar-none -mx-4 mb-4 overflow-x-auto px-4">
            <Segmented
              size="sm"
              value={filter}
              onChange={setFilter}
              options={[
                { value: 'all', label: t('portal.filterAll'), badge: all.length },
                { value: 'pending', label: t('portal.pending'), badge: counts.pending ?? 0 },
                { value: 'approved', label: t('portal.approved'), badge: counts.approved ?? 0 },
                { value: 'rejected', label: t('portal.rejected'), badge: counts.rejected ?? 0 },
              ]}
            />
          </div>
          {products.loading ? (
            <div className="space-y-3">{Array.from({ length: 4 }, (_, i) => <Skeleton key={i} className="h-24 rounded-3xl" />)}</div>
          ) : products.error ? (
            <ErrorState error={products.error} onRetry={products.reload} />
          ) : shown.length === 0 ? (
            <div className="card"><EmptyState icon="burger" title={t('portal.empty')} action={<Button icon="plus" onClick={() => setEditing(null)}>{t('portal.productNew')}</Button>} /></div>
          ) : filter === 'all' ? (
            <Reorder.Group axis="y" values={all} onReorder={reorder} className="space-y-3">
              {all.map((p) => (
                <DraggableProduct key={p.id} product={p} onDrop={persistOrder} section={sectionById.get(p.section?.id ?? p.section)} onEdit={setEditing} onDelete={setDeleting} onToggle={toggleProduct} />
              ))}
            </Reorder.Group>
          ) : (
            <div className="space-y-3">
              {shown.map((p) => (
                <motion.div key={p.id} layout initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }}>
                  <ProductRow product={p} section={sectionById.get(p.section?.id ?? p.section)} onEdit={setEditing} onDelete={setDeleting} onToggle={toggleProduct} />
                </motion.div>
              ))}
            </div>
          )}
        </section>
        <aside className={`min-w-0 lg:sticky lg:top-24 lg:block lg:self-start ${pane === 'sections' ? '' : 'hidden'}`}>
          {sections.loading ? <Skeleton className="h-64 rounded-3xl" /> : <Sections sections={sections.data ?? []} onChanged={() => { sections.reload(); products.reload(); }} />}
        </aside>
      </div>

      {/* Thumb-reach "new product" on phones, where the header button is hidden. */}
      <AnimatePresence>
        {pane === 'products' && editing === undefined && (
          <motion.button
            type="button"
            initial={{ scale: 0, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0, opacity: 0 }}
            whileTap={{ scale: 0.9 }}
            onClick={() => setEditing(null)}
            aria-label={t('portal.productNew')}
            className="fixed bottom-5 end-5 z-30 flex h-14 items-center gap-2 rounded-full bg-forest pe-5 ps-4 font-bold text-white shadow-lift sm:hidden"
            style={{ marginBottom: 'env(safe-area-inset-bottom)' }}
          >
            <Icon name="plus" className="h-6 w-6" />
            {t('portal.productNew')}
          </motion.button>
        )}
      </AnimatePresence>

      <ProductEditor
        open={editing !== undefined}
        product={editing ?? null}
        sections={sections.data ?? []}
        onClose={() => setEditing(undefined)}
        onSaved={() => products.reload()}
      />
      <Confirm
        open={Boolean(deleting)}
        danger
        title={t('portal.deleteConfirm', { name: deleting?.name ?? '' })}
        confirmLabel={t('common.delete')}
        onClose={() => setDeleting(null)}
        onConfirm={async () => {
          try {
            await portal.deleteProduct(deleting.id);
            products.setData((list) => list.filter((x) => x.id !== deleting.id));
            setDeleting(null);
          } catch (e) {
            toast.error(errorText(e));
          }
        }}
      />
    </div>
  );
}
