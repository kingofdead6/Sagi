import { useState } from 'react';
import { vouchersApi } from '../api/endpoints';
import { apiErrorMessage } from '../api/client';
import { useAsync } from '../lib/useAsync';
import { VOUCHER_TYPES, VOUCHER_TYPE_LABELS, centimesToDa, daToCentimes } from '../lib/constants';
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
      <div className="mb-6 flex items-center justify-between">
        <h1 className="text-2xl font-black">القسائم</h1>
        <Button onClick={openCreate}>+ قسيمة جديدة</Button>
      </div>

      <ErrorBanner message={error} />
      {loading && <PageLoader />}

      {vouchers && (
        <Card className="p-0">
          {vouchers.length === 0 ? (
            <EmptyState>لا توجد قسائم</EmptyState>
          ) : (
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-black/5 text-ink-muted">
                  <th className="px-4 py-3 text-start font-bold">الرمز</th>
                  <th className="px-4 py-3 text-start font-bold">النوع</th>
                  <th className="px-4 py-3 text-start font-bold">القيمة</th>
                  <th className="px-4 py-3 text-start font-bold">الاستخدامات</th>
                  <th className="px-4 py-3 text-start font-bold">الحالة</th>
                  <th className="px-4 py-3"></th>
                </tr>
              </thead>
              <tbody>
                {vouchers.map((v) => (
                  <tr key={v.id} className="border-b border-black/5 last:border-0">
                    <td className="px-4 py-3 font-mono font-bold">{v.code}</td>
                    <td className="px-4 py-3 text-ink-soft">{VOUCHER_TYPE_LABELS[v.type]}</td>
                    <td className="px-4 py-3 text-ink-soft">{v.value}</td>
                    <td className="px-4 py-3 text-ink-soft">
                      {v.usedCount ?? 0} / {v.maxUses || '∞'}
                    </td>
                    <td className="px-4 py-3">
                      <Badge tone={v.isActive ? 'green' : 'neutral'}>{v.isActive ? 'مفعّلة' : 'معطّلة'}</Badge>
                    </td>
                    <td className="px-4 py-3 text-end">
                      <div className="flex justify-end gap-2">
                        <Button variant="outline" onClick={() => openEdit(v)}>
                          تعديل
                        </Button>
                        <Button variant="danger" onClick={() => setDeleteTarget(v)}>
                          حذف
                        </Button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </Card>
      )}

      <Modal open={!!modal} onClose={() => setModal(null)} title={modal?.mode === 'create' ? 'قسيمة جديدة' : 'تعديل القسيمة'}>
        <form className="space-y-4" onSubmit={handleSubmit}>
          <Input label="الرمز" value={form.code} onChange={(e) => set('code', e.target.value)} required />
          <div className="grid grid-cols-2 gap-4">
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
          <div className="grid grid-cols-2 gap-4">
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
          <div className="grid grid-cols-2 gap-4">
            <Input label="تاريخ البدء" type="date" value={form.startsAt} onChange={(e) => set('startsAt', e.target.value)} />
            <Input label="تاريخ الانتهاء" type="date" value={form.endsAt} onChange={(e) => set('endsAt', e.target.value)} />
          </div>
          <Checkbox label="مفعّلة" checked={form.isActive} onChange={(e) => set('isActive', e.target.checked)} />
          <ErrorBanner message={formError} />
          <div className="flex justify-end gap-2 pt-2">
            <Button type="button" variant="ghost" onClick={() => setModal(null)}>
              إلغاء
            </Button>
            <Button type="submit" disabled={saving}>
              {saving ? <Spinner className="h-4 w-4" /> : 'حفظ'}
            </Button>
          </div>
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
