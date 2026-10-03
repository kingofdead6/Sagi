import { useState } from 'react';
import { vouchersApi, apiErrorMessage, useAsync } from '../api';
import { VOUCHER_TYPES, VOUCHER_TYPE_LABELS, centimesToDa, daToCentimes } from '../constants';
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
    code: '',
    type: 'percentage',
    value: 0,
    minOrderDa: '0',
    maxUses: 0,
    perUserLimit: 1,
    startsAt: '',
    endsAt: '',
    isActive: true,
  };
}

function toForm(v) {
  return {
    code: v.code,
    type: v.type,
    value: v.value,
    minOrderDa: centimesToDa(v.minOrderCentimes),
    maxUses: v.maxUses,
    perUserLimit: v.perUserLimit,
    startsAt: v.startsAt ? v.startsAt.slice(0, 10) : '',
    endsAt: v.endsAt ? v.endsAt.slice(0, 10) : '',
    isActive: v.isActive,
  };
}

export default function VouchersPage() {
  const { data: vouchers, loading, error, refetch } = useAsync(() => vouchersApi.list(), []);
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
  function openEdit(v) {
    setForm(toForm(v));
    setFormError(null);
    setModal({ mode: 'edit', item: v });
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
        code: form.code,
        type: form.type,
        value: Number(form.value) || 0,
        minOrderCentimes: daToCentimes(form.minOrderDa),
        maxUses: Number(form.maxUses) || 0,
        perUserLimit: Number(form.perUserLimit) || 1,
        startsAt: form.startsAt ? new Date(form.startsAt) : null,
        endsAt: form.endsAt ? new Date(form.endsAt) : null,
        isActive: form.isActive,
      };
      if (modal.mode === 'create') await vouchersApi.create(body);
      else await vouchersApi.update(modal.item.id, body);
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
      await vouchersApi.remove(deleteTarget.id);
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
      <PageHeader title="القسائم">
        <Button onClick={openCreate}>+ قسيمة جديدة</Button>
      </PageHeader>

      <ErrorBanner message={error || formError} />
      {loading && !vouchers && <PageLoader />}

      {vouchers && (
        <Card className="overflow-hidden !p-0">
          <DataTable
            empty="لا توجد قسائم"
            rows={vouchers}
            columns={[
              { key: 'code', header: 'الرمز', primary: true, cell: (v) => <span className="font-mono font-bold">{v.code}</span> },
              {
                key: 'status',
                header: 'الحالة',
                primary: true,
                cell: (v) => <Badge tone={v.isActive ? 'green' : 'neutral'}>{v.isActive ? 'مفعّلة' : 'معطّلة'}</Badge>,
              },
              { key: 'type', header: 'النوع', cell: (v) => VOUCHER_TYPE_LABELS[v.type] },
              { key: 'value', header: 'القيمة', cell: (v) => <span className="num">{v.value}</span> },
              {
                key: 'uses',
                header: 'الاستخدامات',
                cell: (v) => (
                  <span className="num">
                    {v.usedCount ?? 0} / {v.maxUses || '∞'}
                  </span>
                ),
              },
              {
                key: 'actions',
                actions: true,
                cell: (v) => (
                  <>
                    <Button variant="outline" onClick={() => openEdit(v)}>
                      تعديل
                    </Button>
                    <Button variant="danger" onClick={() => setDeleteTarget(v)}>
                      حذف
                    </Button>
                  </>
                ),
              },
            ]}
          />
        </Card>
      )}

      <Modal open={!!modal} onClose={() => setModal(null)} title={modal?.mode === 'create' ? 'قسيمة جديدة' : 'تعديل القسيمة'}>
        <form className="space-y-4" onSubmit={handleSubmit}>
          <Input label="الرمز" value={form.code} onChange={(e) => set('code', e.target.value)} required />
          <div className="grid gap-4 sm:grid-cols-2">
            <Select label="النوع" value={form.type} onChange={(e) => set('type', e.target.value)}>
              {VOUCHER_TYPES.map((t) => (
                <option key={t} value={t}>
                  {VOUCHER_TYPE_LABELS[t]}
                </option>
              ))}
            </Select>
            <Input label="القيمة" type="number" value={form.value} onChange={(e) => set('value', e.target.value)} />
          </div>
          <Input
            label="أقل قيمة طلب (د.ج)"
            type="number"
            step="0.01"
            value={form.minOrderDa}
            onChange={(e) => set('minOrderDa', e.target.value)}
          />
          <div className="grid gap-4 sm:grid-cols-2">
            <Input
              label="أقصى عدد استخدام (0 = غير محدود)"
              type="number"
              value={form.maxUses}
              onChange={(e) => set('maxUses', e.target.value)}
            />
            <Input
              label="الحد لكل مستخدم"
              type="number"
              value={form.perUserLimit}
              onChange={(e) => set('perUserLimit', e.target.value)}
            />
          </div>
          <div className="grid gap-4 sm:grid-cols-2">
            <Input label="تاريخ البدء" type="date" value={form.startsAt} onChange={(e) => set('startsAt', e.target.value)} />
            <Input label="تاريخ الانتهاء" type="date" value={form.endsAt} onChange={(e) => set('endsAt', e.target.value)} />
          </div>
          <Checkbox label="مفعّلة" checked={form.isActive} onChange={(e) => set('isActive', e.target.checked)} />
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
        title="حذف القسيمة"
        message={`هل تريد حذف "${deleteTarget?.code}"؟`}
      />
    </div>
  );
}
