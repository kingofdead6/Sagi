import { useEffect, useState } from 'react';
import { productsApi, vendorsApi } from '../api/endpoints';
import { apiErrorMessage } from '../api/client';
import { useAsync } from '../lib/useAsync';
import { centimesToDa, daToCentimes } from '../lib/constants';
import { ImageField } from '../components/ImageField';
import {
  Badge,
  Button,
  Card,
  Checkbox,
  ConfirmModal,
  EmptyState,
  ErrorBanner,
  Input,
  Modal,
  PageLoader,
  Pagination,
  Select,
  Spinner,
  Textarea,
} from '../components/ui';

function emptyForm(vendorId) {
  return {
    vendor: vendorId || '',
    section: '',
    name: '',
    description: '',
    image: null,
    priceDa: '',
    isAvailable: true,
    sortOrder: 0,
    options: [],
  };
}

function toForm(p) {
  return {
    vendor: p.vendor,
    section: p.section ?? '',
    name: p.name,
    description: p.description ?? '',
    image: p.image ?? null,
    priceDa: centimesToDa(p.priceCentimes),
    isAvailable: p.isAvailable,
    sortOrder: p.sortOrder,
    options: p.options ?? [],
  };
}

export default function ProductsPage() {
  const [vendorFilter, setVendorFilter] = useState('');
  const [q, setQ] = useState('');
  const [page, setPage] = useState(1);
  const { data: vendorsData } = useAsync(() => vendorsApi.list({ limit: 100 }), []);
  const { data, loading, error, refetch } = useAsync(
    () => productsApi.list({ vendor: vendorFilter || undefined, q: q || undefined, page, limit: 20 }),
    [vendorFilter, q, page],
  );
  const { data: sections } = useAsync(
    () => (vendorFilter ? vendorsApi.sections(vendorFilter) : Promise.resolve([])),
    [vendorFilter],
  );

  const [modal, setModal] = useState(null);
  const [form, setForm] = useState(emptyForm());
  const [formError, setFormError] = useState(null);
  const [saving, setSaving] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [deleting, setDeleting] = useState(false);

  function openCreate() {
    setForm(emptyForm(vendorFilter));
    setFormError(null);
    setModal({ mode: 'create' });
  }
  function openEdit(p) {
    setForm(toForm(p));
    setFormError(null);
    setModal({ mode: 'edit', item: p });
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setSaving(true);
    setFormError(null);
    try {
      const body = {
        vendor: form.vendor,
        section: form.section || null,
        name: form.name,
        description: form.description || undefined,
        image: form.image,
        priceCentimes: daToCentimes(form.priceDa),
        isAvailable: form.isAvailable,
        sortOrder: Number(form.sortOrder) || 0,
        options: form.options,
      };
      if (modal.mode === 'create') await productsApi.create(body);
      else {
        const { vendor, ...rest } = body;
        await productsApi.update(modal.item.id, rest);
      }
      setModal(null);
      refetch();
    } catch (err) {
      setFormError(apiErrorMessage(err));
    } finally {
      setSaving(false);
    }
  }

  async function handleDelete() {
    setDeleting(true);
    try {
      await productsApi.remove(deleteTarget.id);
      setDeleteTarget(null);
      refetch();
    } catch (err) {
      setFormError(apiErrorMessage(err));
      setDeleteTarget(null);
    } finally {
      setDeleting(false);
    }
  }

  return (
    <div>
      <div className="mb-6 flex items-center justify-between">
        <h1 className="text-2xl font-black">المنتجات</h1>
        <Button onClick={openCreate}>+ منتج جديد</Button>
      </div>

      <div className="mb-4 flex flex-wrap gap-3">
        <Select
          value={vendorFilter}
          onChange={(e) => {
            setPage(1);
            setVendorFilter(e.target.value);
          }}
          className="max-w-xs"
        >
          <option value="">كل المتاجر</option>
          {vendorsData?.items?.map((v) => (
            <option key={v.id} value={v.id}>
              {v.name}
            </option>
          ))}
        </Select>
        <Input
          placeholder="بحث بالاسم..."
          value={q}
          onChange={(e) => {
            setPage(1);
            setQ(e.target.value);
          }}
          className="max-w-xs"
        />
      </div>

      <ErrorBanner message={error} />
      {loading && <PageLoader />}

      {data && (
        <Card className="p-0">
          {data.items.length === 0 ? (
            <EmptyState>لا توجد منتجات</EmptyState>
          ) : (
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-black/5 text-ink-muted">
                  <th className="px-4 py-3 text-start font-bold">المنتج</th>
                  <th className="px-4 py-3 text-start font-bold">السعر</th>
                  <th className="px-4 py-3 text-start font-bold">الحالة</th>
                  <th className="px-4 py-3"></th>
                </tr>
              </thead>
              <tbody>
                {data.items.map((p) => (
                  <tr key={p.id} className="border-b border-black/5 last:border-0">
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-3">
                        {p.image?.url ? (
                          <img src={p.image.url} alt="" className="h-9 w-9 rounded-lg object-cover" />
                        ) : (
                          <div className="h-9 w-9 rounded-lg bg-black/5" />
                        )}
                        <span className="font-bold">{p.name}</span>
                      </div>
                    </td>
                    <td className="px-4 py-3 text-ink-soft">{centimesToDa(p.priceCentimes)} د.ج</td>
                    <td className="px-4 py-3">
                      <Badge tone={p.isAvailable ? 'green' : 'neutral'}>
                        {p.isAvailable ? 'متاح' : 'غير متاح'}
                      </Badge>
                    </td>
                    <td className="px-4 py-3 text-end">
                      <div className="flex justify-end gap-2">
                        <Button variant="outline" onClick={() => openEdit(p)}>
                          تعديل
                        </Button>
                        <Button variant="danger" onClick={() => setDeleteTarget(p)}>
                          حذف
                        </Button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
          <Pagination page={data.page} total={data.total} limit={data.limit} onChange={setPage} />
        </Card>
      )}

      <Modal
        open={!!modal}
        onClose={() => setModal(null)}
        title={modal?.mode === 'create' ? 'منتج جديد' : 'تعديل المنتج'}
        width="max-w-2xl"
      >
        <ProductForm
          form={form}
          setForm={setForm}
          vendors={vendorsData?.items ?? []}
          sections={sections ?? []}
          isCreate={modal?.mode === 'create'}
        />
        <ErrorBanner message={formError} />
        <div className="mt-4 flex justify-end gap-2">
          <Button type="button" variant="ghost" onClick={() => setModal(null)}>
            إلغاء
          </Button>
          <Button onClick={handleSubmit} disabled={saving}>
            {saving ? <Spinner className="h-4 w-4" /> : 'حفظ'}
          </Button>
        </div>
      </Modal>

      <ConfirmModal
        open={!!deleteTarget}
        onClose={() => setDeleteTarget(null)}
        onConfirm={handleDelete}
        loading={deleting}
        title="حذف المنتج"
        message={`هل تريد حذف "${deleteTarget?.name}"؟`}
      />
    </div>
  );
}

function ProductForm({ form, setForm, vendors, sections, isCreate }) {
  const [productSections, setProductSections] = useState(sections);

  useEffect(() => {
    if (!form.vendor) {
      setProductSections([]);
      return;
    }
    if (isCreate) {
      vendorsApi.sections(form.vendor).then(setProductSections).catch(() => setProductSections([]));
    } else {
      setProductSections(sections);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [form.vendor]);

  function set(field, value) {
    setForm((f) => ({ ...f, [field]: value }));
  }

  function addOption() {
    set('options', [
      ...form.options,
      { name: '', type: 'single', isRequired: false, values: [{ name: '', priceDeltaCentimes: 0 }] },
    ]);
  }
  function updateOption(i, patch) {
    set('options', form.options.map((o, idx) => (idx === i ? { ...o, ...patch } : o)));
  }
  function removeOption(i) {
    set('options', form.options.filter((_, idx) => idx !== i));
  }
  function addValue(oi) {
    updateOption(oi, {
      values: [...form.options[oi].values, { name: '', priceDeltaCentimes: 0 }],
    });
  }
  function updateValue(oi, vi, patch) {
    updateOption(oi, {
      values: form.options[oi].values.map((v, idx) => (idx === vi ? { ...v, ...patch } : v)),
    });
  }
  function removeValue(oi, vi) {
    updateOption(oi, { values: form.options[oi].values.filter((_, idx) => idx !== vi) });
  }

  return (
    <form className="space-y-4" onSubmit={(e) => e.preventDefault()}>
      {isCreate && (
        <Select label="المتجر" value={form.vendor} onChange={(e) => set('vendor', e.target.value)} required>
          <option value="">اختر متجراً</option>
          {vendors.map((v) => (
            <option key={v.id} value={v.id}>
              {v.name}
            </option>
          ))}
        </Select>
      )}

      <Select label="القسم" value={form.section} onChange={(e) => set('section', e.target.value)}>
        <option value="">بلا قسم</option>
        {productSections?.map((s) => (
          <option key={s.id} value={s.id}>
            {s.name}
          </option>
        ))}
      </Select>

      <Input label="اسم المنتج" value={form.name} onChange={(e) => set('name', e.target.value)} required />
      <Textarea label="الوصف" value={form.description} onChange={(e) => set('description', e.target.value)} rows={2} />
      <ImageField label="الصورة" value={form.image} onChange={(v) => set('image', v)} folder="products" />

      <div className="grid grid-cols-2 gap-4">
        <Input
          label="السعر (د.ج)"
          type="number"
          step="0.01"
          value={form.priceDa}
          onChange={(e) => set('priceDa', e.target.value)}
          required
        />
        <Input label="الترتيب" type="number" value={form.sortOrder} onChange={(e) => set('sortOrder', e.target.value)} />
      </div>

      <Checkbox label="متاح" checked={form.isAvailable} onChange={(e) => set('isAvailable', e.target.checked)} />

      <div>
        <div className="mb-2 flex items-center justify-between">
          <span className="text-sm font-bold text-ink-soft">الخيارات (إضافات)</span>
          <Button type="button" variant="outline" onClick={addOption}>
            + إضافة خيار
          </Button>
        </div>
        <div className="space-y-3">
          {form.options.map((o, oi) => (
            <div key={oi} className="rounded-xl border border-black/10 p-3">
              <div className="mb-2 flex items-center gap-2">
                <Input
                  placeholder="اسم الخيار (مثال: الحجم)"
                  value={o.name}
                  onChange={(e) => updateOption(oi, { name: e.target.value })}
                  className="flex-1"
                />
                <Select value={o.type} onChange={(e) => updateOption(oi, { type: e.target.value })} className="w-32">
                  <option value="single">اختيار واحد</option>
                  <option value="multi">اختيار متعدد</option>
                </Select>
                <Checkbox
                  label="إلزامي"
                  checked={o.isRequired}
                  onChange={(e) => updateOption(oi, { isRequired: e.target.checked })}
                />
                <Button type="button" variant="danger" onClick={() => removeOption(oi)}>
                  حذف
                </Button>
              </div>
              <div className="space-y-2 ps-4">
                {o.values.map((v, vi) => (
                  <div key={vi} className="flex items-center gap-2">
                    <Input
                      placeholder="اسم القيمة"
                      value={v.name}
                      onChange={(e) => updateValue(oi, vi, { name: e.target.value })}
                      className="flex-1"
                    />
                    <Input
                      type="number"
                      placeholder="فرق السعر (سنتيم)"
                      value={v.priceDeltaCentimes}
                      onChange={(e) =>
                        updateValue(oi, vi, { priceDeltaCentimes: Number(e.target.value) || 0 })
                      }
                      className="w-40"
                    />
                    <Button type="button" variant="ghost" onClick={() => removeValue(oi, vi)}>
                      إزالة
                    </Button>
                  </div>
                ))}
                <Button type="button" variant="outline" onClick={() => addValue(oi)}>
                  + قيمة
                </Button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </form>
  );
}
