import { useEffect, useState } from 'react';
import { productsApi, vendorsApi, apiErrorMessage, useAsync } from '../api';
import { centimesToDa, daToCentimes } from '../constants';
import { ImageField } from '../components/ImageField';
import {
  Badge,
  Button,
  Card,
  Checkbox,
  ConfirmModal,
  DataTable,
  ErrorBanner,
  Filters,
  FormActions,
  Input,
  Modal,
  PageHeader,
  PageLoader,
  Pagination,
  Select,
  Spinner,
  Textarea,
} from '../components/ui';

const REVIEW_LABELS = { pending: 'بانتظار المراجعة', approved: 'منشور', rejected: 'مرفوض' };
const REVIEW_TONE = { pending: 'yellow', approved: 'green', rejected: 'red' };

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
    vendor: p.vendor?.id ?? p.vendor,
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
  const [statusFilter, setStatusFilter] = useState('');
  const [q, setQ] = useState('');
  const [page, setPage] = useState(1);
  const { data: vendorsData } = useAsync(() => vendorsApi.list({ limit: 100 }), []);
  const { data, loading, error, refetch } = useAsync(
    () => productsApi.list({ vendor: vendorFilter, status: statusFilter, q, page, limit: 20 }),
    [vendorFilter, statusFilter, q, page],
  );

  const [modal, setModal] = useState(null);
  const [form, setForm] = useState(emptyForm());
  const [formError, setFormError] = useState(null);
  const [saving, setSaving] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [deleting, setDeleting] = useState(false);
  const [rejectTarget, setRejectTarget] = useState(null);
  const [rejectReason, setRejectReason] = useState('');
  const [reviewing, setReviewing] = useState(null);
  const [listError, setListError] = useState(null);

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

  async function handleApprove(p) {
    setReviewing(p.id);
    setListError(null);
    try {
      await productsApi.approve(p.id);
      refetch();
    } catch (err) {
      setListError(apiErrorMessage(err));
    } finally {
      setReviewing(null);
    }
  }

  function openReject(p) {
    setRejectReason('');
    setListError(null);
    setRejectTarget(p);
  }

  async function handleReject(e) {
    e.preventDefault();
    if (!rejectReason.trim()) return;
    setReviewing(rejectTarget.id);
    try {
      await productsApi.reject(rejectTarget.id, rejectReason.trim());
      setRejectTarget(null);
      refetch();
    } catch (err) {
      setListError(apiErrorMessage(err));
      setRejectTarget(null);
    } finally {
      setReviewing(null);
    }
  }

  const columns = [
    {
      key: 'name',
      header: 'المنتج',
      primary: true,
      cell: (p) => (
        <div className="flex min-w-0 items-center gap-3">
          {p.image?.url ? (
            <img src={p.image.url} alt="" className="h-11 w-11 shrink-0 rounded-xl object-cover" />
          ) : (
            <div className="h-11 w-11 shrink-0 rounded-xl bg-ink/5" />
          )}
          <div className="min-w-0">
            <p className="font-bold">{p.name}</p>
            {p.status === 'rejected' && p.rejectionReason && (
              <p className="line-clamp-2 text-xs text-tomato">سبب الرفض: {p.rejectionReason}</p>
            )}
          </div>
        </div>
      ),
    },
    {
      key: 'review',
      header: 'المراجعة',
      primary: true,
      cell: (p) => (
        <Badge tone={REVIEW_TONE[p.status] ?? 'green'}>{REVIEW_LABELS[p.status] ?? REVIEW_LABELS.approved}</Badge>
      ),
    },
    { key: 'vendor', header: 'المتجر', cell: (p) => p.vendor?.name ?? '—' },
    { key: 'price', header: 'السعر', cell: (p) => <span className="num whitespace-nowrap">{centimesToDa(p.priceCentimes)} د.ج</span> },
    {
      key: 'available',
      header: 'التوفر',
      cell: (p) => <Badge tone={p.isAvailable ? 'green' : 'neutral'}>{p.isAvailable ? 'متاح' : 'غير متاح'}</Badge>,
    },
    {
      key: 'actions',
      actions: true,
      cell: (p) => (
        <>
          {p.status !== 'approved' && (
            <Button variant="success" onClick={() => handleApprove(p)} disabled={reviewing === p.id}>
              {reviewing === p.id ? <Spinner className="h-4 w-4" /> : 'قبول'}
            </Button>
          )}
          {p.status === 'pending' && (
            <Button variant="outline" onClick={() => openReject(p)} disabled={reviewing === p.id}>
              رفض
            </Button>
          )}
          <Button variant="outline" onClick={() => openEdit(p)}>
            تعديل
          </Button>
          <Button variant="danger" onClick={() => setDeleteTarget(p)}>
            حذف
          </Button>
        </>
      ),
    },
  ];

  return (
    <div>
      <PageHeader title="المنتجات">
        <Button onClick={openCreate}>+ منتج جديد</Button>
      </PageHeader>

      <Filters>
        <Select
          value={statusFilter}
          onChange={(e) => {
            setPage(1);
            setStatusFilter(e.target.value);
          }}
        >
          <option value="">كل حالات المراجعة</option>
          <option value="pending">{REVIEW_LABELS.pending}</option>
          <option value="approved">{REVIEW_LABELS.approved}</option>
          <option value="rejected">{REVIEW_LABELS.rejected}</option>
        </Select>
        <Select
          value={vendorFilter}
          onChange={(e) => {
            setPage(1);
            setVendorFilter(e.target.value);
          }}
        >
          <option value="">كل المتاجر</option>
          {vendorsData?.items?.map((v) => (
            <option key={v.id} value={v.id}>
              {v.name}
            </option>
          ))}
        </Select>
        <Input
          type="search"
          placeholder="بحث بالاسم..."
          value={q}
          onChange={(e) => {
            setPage(1);
            setQ(e.target.value);
          }}
        />
      </Filters>

      <ErrorBanner message={error || listError} />
      {loading && !data && <PageLoader />}

      {data && (
        <Card className="overflow-hidden !p-0">
          <DataTable columns={columns} rows={data.items} empty="لا توجد منتجات" />
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
          isCreate={modal?.mode === 'create'}
        />
        <ErrorBanner message={formError} />
        <FormActions>
          <Button type="button" variant="ghost" onClick={() => setModal(null)}>
            إلغاء
          </Button>
          <Button onClick={handleSubmit} disabled={saving}>
            {saving ? <Spinner className="h-4 w-4" /> : 'حفظ'}
          </Button>
        </FormActions>
      </Modal>

      <Modal open={!!rejectTarget} onClose={() => setRejectTarget(null)} title="رفض المنتج" width="max-w-md">
        <form className="space-y-4" onSubmit={handleReject}>
          <p className="text-sm text-ink-soft">
            سيبقى "{rejectTarget?.name}" مخفيًا عن العملاء، ويظهر السبب لصاحب المتجر ليعدّله.
          </p>
          <Textarea
            label="سبب الرفض"
            value={rejectReason}
            onChange={(e) => setRejectReason(e.target.value)}
            rows={3}
            maxLength={400}
            required
            autoFocus
          />
          <FormActions>
            <Button type="button" variant="ghost" onClick={() => setRejectTarget(null)}>
              إلغاء
            </Button>
            <Button type="submit" variant="danger" disabled={!rejectReason.trim() || reviewing === rejectTarget?.id}>
              {reviewing === rejectTarget?.id ? <Spinner className="h-4 w-4" /> : 'رفض'}
            </Button>
          </FormActions>
        </form>
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

function ProductForm({ form, setForm, vendors, isCreate }) {
  const [productSections, setProductSections] = useState([]);

  useEffect(() => {
    if (!form.vendor) {
      setProductSections([]);
      return undefined;
    }
    let live = true;
    vendorsApi
      .sections(form.vendor)
      .then((list) => live && setProductSections(list))
      .catch(() => live && setProductSections([]));
    return () => {
      live = false;
    };
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

      <div className="grid gap-4 sm:grid-cols-2">
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
            <div key={oi} className="rounded-xl border border-ink/10 p-3">
              <div className="mb-2 grid grid-cols-2 items-center gap-2 sm:flex">
                <div className="col-span-2 sm:flex-1">
                  <Input
                    placeholder="اسم الخيار (مثال: الحجم)"
                    value={o.name}
                    onChange={(e) => updateOption(oi, { name: e.target.value })}
                  />
                </div>
                <Select value={o.type} onChange={(e) => updateOption(oi, { type: e.target.value })} className="sm:w-36">
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
              <div className="space-y-2 sm:ps-4">
                {o.values.map((v, vi) => (
                  <div key={vi} className="flex flex-wrap items-center gap-2 sm:flex-nowrap">
                    <div className="w-full sm:flex-1">
                      <Input
                        placeholder="اسم القيمة"
                        value={v.name}
                        onChange={(e) => updateValue(oi, vi, { name: e.target.value })}
                      />
                    </div>
                    <div className="flex-1 sm:flex-none">
                      <Input
                        type="number"
                        placeholder="فرق السعر (سنتيم)"
                        value={v.priceDeltaCentimes}
                        onChange={(e) =>
                          updateValue(oi, vi, { priceDeltaCentimes: Number(e.target.value) || 0 })
                        }
                        className="sm:w-40"
                      />
                    </div>
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
