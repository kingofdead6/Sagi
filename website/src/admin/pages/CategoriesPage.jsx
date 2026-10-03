import { useState } from 'react';
import { categoriesApi, apiErrorMessage, useAsync } from '../api';
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
      <PageHeader title="الفئات">
        <Button onClick={openCreate}>+ فئة جديدة</Button>
      </PageHeader>

      <ErrorBanner message={error || formError} />
      {loading && !items && <PageLoader />}

      {items && (
        <Card className="overflow-hidden !p-0">
          <DataTable
            empty="لا توجد فئات بعد"
            rows={items}
            columns={[
              { key: 'nameAr', header: 'الاسم (عربي)', primary: true, cell: (c) => <span className="font-bold">{c.nameAr}</span> },
              {
                key: 'status',
                header: 'الحالة',
                primary: true,
                cell: (c) => <Badge tone={c.isActive ? 'green' : 'neutral'}>{c.isActive ? 'مفعّلة' : 'معطّلة'}</Badge>,
              },
              { key: 'nameFr', header: 'الاسم (فرنسي)', cell: (c) => c.nameFr },
              { key: 'icon', header: 'الأيقونة', cell: (c) => c.iconKey },
              { key: 'sort', header: 'الترتيب', cell: (c) => <span className="num">{c.sortOrder}</span> },
              {
                key: 'actions',
                actions: true,
                cell: (c) => (
                  <>
                    <Button variant="outline" onClick={() => openEdit(c)}>
                      تعديل
                    </Button>
                    <Button variant="danger" onClick={() => setDeleteTarget(c)}>
                      حذف
                    </Button>
                  </>
                ),
              },
            ]}
          />
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
        title="حذف الفئة"
        message={`هل تريد حذف "${deleteTarget?.nameAr}"؟`}
      />
    </div>
  );
}
