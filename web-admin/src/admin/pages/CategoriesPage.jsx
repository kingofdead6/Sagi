import { useState } from 'react';
import { categoriesApi } from '../api/endpoints';
import { apiErrorMessage } from '../api/client';
import { useAsync } from '../lib/useAsync';
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
  Spinner,
} from '../components/ui';

const EMPTY = { nameAr: '', nameFr: '', iconKey: '', sortOrder: 0, isActive: true };

export default function CategoriesPage() {
  const { data: items, loading, error, refetch } = useAsync(() => categoriesApi.list(), []);
  const [modal, setModal] = useState(null); // { mode: 'create'|'edit', item }
  const [form, setForm] = useState(EMPTY);
  const [formError, setFormError] = useState(null);
  const [saving, setSaving] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [deleting, setDeleting] = useState(false);

  function openCreate() {
    setForm(EMPTY);
    setFormError(null);
    setModal({ mode: 'create' });
  }

  function openEdit(item) {
    setForm({
      nameAr: item.nameAr,
      nameFr: item.nameFr,
      iconKey: item.iconKey,
      sortOrder: item.sortOrder,
      isActive: item.isActive,
    });
    setFormError(null);
    setModal({ mode: 'edit', item });
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setSaving(true);
    setFormError(null);
    try {
      const body = { ...form, sortOrder: Number(form.sortOrder) || 0 };
      if (modal.mode === 'create') await categoriesApi.create(body);
      else await categoriesApi.update(modal.item.id, body);
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
      await categoriesApi.remove(deleteTarget.id);
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
        <h1 className="text-2xl font-black">الفئات</h1>
        <Button onClick={openCreate}>+ فئة جديدة</Button>
      </div>

      <ErrorBanner message={error || formError} />
      {loading && <PageLoader />}

      {items && (
        <Card className="p-0">
          {items.length === 0 ? (
            <EmptyState>لا توجد فئات بعد</EmptyState>
          ) : (
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-black/5 text-start text-ink-muted">
                  <th className="px-4 py-3 text-start font-bold">الاسم (عربي)</th>
                  <th className="px-4 py-3 text-start font-bold">الاسم (فرنسي)</th>
                  <th className="px-4 py-3 text-start font-bold">الأيقونة</th>
                  <th className="px-4 py-3 text-start font-bold">الترتيب</th>
                  <th className="px-4 py-3 text-start font-bold">الحالة</th>
                  <th className="px-4 py-3"></th>
                </tr>
              </thead>
              <tbody>
                {items.map((c) => (
                  <tr key={c.id} className="border-b border-black/5 last:border-0">
                    <td className="px-4 py-3 font-bold">{c.nameAr}</td>
                    <td className="px-4 py-3 text-ink-soft">{c.nameFr}</td>
                    <td className="px-4 py-3 text-ink-soft">{c.iconKey}</td>
                    <td className="px-4 py-3 text-ink-soft">{c.sortOrder}</td>
                    <td className="px-4 py-3">
                      <Badge tone={c.isActive ? 'green' : 'neutral'}>
                        {c.isActive ? 'مفعّلة' : 'معطّلة'}
                      </Badge>
                    </td>
                    <td className="px-4 py-3 text-end">
                      <div className="flex justify-end gap-2">
                        <Button variant="outline" onClick={() => openEdit(c)}>
                          تعديل
                        </Button>
                        <Button variant="danger" onClick={() => setDeleteTarget(c)}>
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

      <Modal open={!!modal} onClose={() => setModal(null)} title={modal?.mode === 'create' ? 'فئة جديدة' : 'تعديل الفئة'}>
        <form className="space-y-4" onSubmit={handleSubmit}>
          <Input
            label="الاسم بالعربية"
            value={form.nameAr}
            onChange={(e) => setForm((f) => ({ ...f, nameAr: e.target.value }))}
            required
          />
          <Input
            label="الاسم بالفرنسية"
            value={form.nameFr}
            onChange={(e) => setForm((f) => ({ ...f, nameFr: e.target.value }))}
            required
          />
          <Input
            label="مفتاح الأيقونة"
            value={form.iconKey}
            onChange={(e) => setForm((f) => ({ ...f, iconKey: e.target.value }))}
            required
          />
          <Input
            label="الترتيب"
            type="number"
            value={form.sortOrder}
            onChange={(e) => setForm((f) => ({ ...f, sortOrder: e.target.value }))}
          />
          <Checkbox
            label="مفعّلة"
            checked={form.isActive}
            onChange={(e) => setForm((f) => ({ ...f, isActive: e.target.checked }))}
          />
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
        title="حذف الفئة"
        message={`هل تريد حذف "${deleteTarget?.nameAr}"؟`}
      />
    </div>
  );
}
