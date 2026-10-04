import { useState } from 'react';
import { offersApi, vendorsApi, apiErrorMessage, useAsync } from '../api';
import { OFFER_TYPES, OFFER_TYPE_LABELS } from '../constants';
import { ImageField } from '../components/ImageField';
import {
  Badge,
  Button,
  Card,
  Checkbox,
  ConfirmModal,
  DataTable,
  ErrorBanner,
  FormActions,
  Input,
  Modal,
  PageHeader,
  PageLoader,
  Select,
  Spinner,
} from '../components/ui';

function emptyForm() {
  return {
    vendor: '',
    title: '',
    subtitle: '',
    image: null,
    type: 'percentage',
    value: 0,
    startsAt: '',
    endsAt: '',
    isActive: true,
    showOnHome: false,
    sortOrder: 0,
  };
}

function toForm(o) {
  return {
    vendor: o.vendor?.id ?? o.vendor ?? '',
    title: o.title,
    subtitle: o.subtitle ?? '',
    image: o.image ?? null,
    type: o.type,
    value: o.value,
    startsAt: o.startsAt ? o.startsAt.slice(0, 10) : '',
    endsAt: o.endsAt ? o.endsAt.slice(0, 10) : '',
    isActive: o.isActive,
    showOnHome: o.showOnHome,
    sortOrder: o.sortOrder,
  };
}

export default function OffersPage() {
  const { data: offers, loading, error, refetch } = useAsync(() => offersApi.list(), []);
  const { data: vendorsData } = useAsync(() => vendorsApi.list({ limit: 100 }), []);
  const [modal, setModal] = useState(null);
  const [form, setForm] = useState(emptyForm());
  const [formError, setFormError] = useState(null);
  const [saving, setSaving] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [deleting, setDeleting] = useState(false);

  function openCreate() {
    setForm(emptyForm());
    setFormError(null);
    setModal({ mode: 'create' });
  }
  function openEdit(o) {
    setForm(toForm(o));
    setFormError(null);
    setModal({ mode: 'edit', item: o });
  }
  function set(field, value) {
    setForm((f) => ({ ...f, [field]: value }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setSaving(true);
    setFormError(null);
    try {
      const body = {
        vendor: form.vendor || null,
        title: form.title,
        subtitle: form.subtitle || undefined,
        image: form.image,
        type: form.type,
        value: Number(form.value) || 0,
        startsAt: form.startsAt ? new Date(form.startsAt) : null,
        endsAt: form.endsAt ? new Date(form.endsAt) : null,
        isActive: form.isActive,
        showOnHome: form.showOnHome,
        sortOrder: Number(form.sortOrder) || 0,
      };
      if (modal.mode === 'create') await offersApi.create(body);
      else await offersApi.update(modal.item.id, body);
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
      await offersApi.remove(deleteTarget.id);
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
      <PageHeader title="العروض">
        <Button onClick={openCreate}>+ عرض جديد</Button>
      </PageHeader>

      <ErrorBanner message={error || formError} />
      {loading && !offers && <PageLoader />}

      {offers && (
        <Card className="overflow-hidden !p-0">
          <DataTable
            empty="لا توجد عروض"
            rows={offers}
            columns={[
              {
                key: 'title',
                header: 'العرض',
                primary: true,
                cell: (o) => (
                  <div className="flex min-w-0 items-center gap-3">
                    {o.image?.url ? (
                      <img src={o.image.url} alt="" className="h-10 w-10 shrink-0 rounded-xl object-cover" />
                    ) : (
                      <div className="h-10 w-10 shrink-0 rounded-xl bg-ink/5" />
                    )}
                    <span className="font-bold">{o.title}</span>
                  </div>
                ),
              },
              { key: 'type', header: 'النوع', cell: (o) => OFFER_TYPE_LABELS[o.type] },
              { key: 'value', header: 'القيمة', cell: (o) => <span className="num">{o.value}</span> },
              { key: 'vendor', header: 'المتجر', cell: (o) => o.vendor?.name ?? 'عام' },
              {
                key: 'status',
                header: 'الحالة',
                cell: (o) => (
                  <div className="flex flex-wrap gap-1">
                    <Badge tone={o.isActive ? 'green' : 'neutral'}>{o.isActive ? 'مفعّل' : 'معطّل'}</Badge>
                    {o.showOnHome && <Badge tone="blue">الرئيسية</Badge>}
                  </div>
                ),
              },
              {
                key: 'actions',
                actions: true,
                cell: (o) => (
                  <>
                    <Button variant="outline" onClick={() => openEdit(o)}>
                      تعديل
                    </Button>
                    <Button variant="danger" onClick={() => setDeleteTarget(o)}>
                      حذف
                    </Button>
                  </>
                ),
              },
            ]}
          />
        </Card>
      )}

      <Modal open={!!modal} onClose={() => setModal(null)} title={modal?.mode === 'create' ? 'عرض جديد' : 'تعديل العرض'}>
        <form className="space-y-4" onSubmit={handleSubmit}>
          <Select label="المتجر (اختياري)" value={form.vendor} onChange={(e) => set('vendor', e.target.value)}>
            <option value="">عرض عام</option>
            {vendorsData?.items?.map((v) => (
              <option key={v.id} value={v.id}>
                {v.name}
              </option>
            ))}
          </Select>
          <Input label="العنوان" value={form.title} onChange={(e) => set('title', e.target.value)} required />
          <Input label="العنوان الفرعي" value={form.subtitle} onChange={(e) => set('subtitle', e.target.value)} />
          <ImageField label="الصورة" value={form.image} onChange={(v) => set('image', v)} folder="offers" />
          <div className="grid gap-4 sm:grid-cols-2">
            <Select label="النوع" value={form.type} onChange={(e) => set('type', e.target.value)}>
              {OFFER_TYPES.map((t) => (
                <option key={t} value={t}>
                  {OFFER_TYPE_LABELS[t]}
                </option>
              ))}
            </Select>
            <Input label="القيمة" type="number" value={form.value} onChange={(e) => set('value', e.target.value)} />
          </div>
          <div className="grid gap-4 sm:grid-cols-2">
            <Input label="تاريخ البدء" type="date" value={form.startsAt} onChange={(e) => set('startsAt', e.target.value)} />
            <Input label="تاريخ الانتهاء" type="date" value={form.endsAt} onChange={(e) => set('endsAt', e.target.value)} />
          </div>
          <div className="flex flex-wrap gap-x-6">
            <Checkbox label="مفعّل" checked={form.isActive} onChange={(e) => set('isActive', e.target.checked)} />
            <Checkbox
              label="إظهار في الرئيسية"
              checked={form.showOnHome}
              onChange={(e) => set('showOnHome', e.target.checked)}
            />
          </div>
          <Input label="الترتيب" type="number" value={form.sortOrder} onChange={(e) => set('sortOrder', e.target.value)} />
          <ErrorBanner message={formError} />
          <FormActions>
            <Button type="button" variant="ghost" onClick={() => setModal(null)}>
              إلغاء
            </Button>
            <Button type="submit" disabled={saving}>
              {saving ? <Spinner className="h-4 w-4" /> : 'حفظ'}
            </Button>
          </FormActions>
        </form>
      </Modal>

      <ConfirmModal
        open={!!deleteTarget}
        onClose={() => setDeleteTarget(null)}
        onConfirm={handleDelete}
        loading={deleting}
        title="حذف العرض"
        message={`هل تريد حذف "${deleteTarget?.title}"؟`}
      />
    </div>
  );
}
