import { useState } from 'react';
import { agentsApi, apiErrorMessage, useAsync } from '../api';
import {
  Badge,
  Button,
  Card,
  Checkbox,
  DataTable,
  ErrorBanner,
  Filters,
  FormActions,
  Input,
  Modal,
  PageHeader,
  PageLoader,
  Pagination,
  Spinner,
} from '../components/ui';

export default function AgentsPage() {
  const [q, setQ] = useState('');
  const [page, setPage] = useState(1);
  const { data, loading, error, refetch } = useAsync(
    () => agentsApi.list({ q, page, limit: 20 }),
    [q, page],
  );

  const [createOpen, setCreateOpen] = useState(false);
  const [createForm, setCreateForm] = useState({ fullName: '', phone: '', password: '' });
  const [editTarget, setEditTarget] = useState(null);
  const [editForm, setEditForm] = useState({ fullName: '', isActive: true, isBlocked: false, password: '' });
  const [busy, setBusy] = useState(false);
  const [formError, setFormError] = useState(null);

  function openCreate() {
    setCreateForm({ fullName: '', phone: '', password: '' });
    setFormError(null);
    setCreateOpen(true);
  }

  function openEdit(a) {
    setEditForm({ fullName: a.fullName, isActive: a.isActive, isBlocked: a.isBlocked, password: '' });
    setFormError(null);
    setEditTarget(a);
  }

  async function handleCreate(e) {
    e.preventDefault();
    setBusy(true);
    setFormError(null);
    try {
      await agentsApi.create(createForm);
      setCreateOpen(false);
      refetch();
    } catch (err) {
      setFormError(apiErrorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  async function handleEdit(e) {
    e.preventDefault();
    setBusy(true);
    setFormError(null);
    try {
      const body = { fullName: editForm.fullName, isActive: editForm.isActive, isBlocked: editForm.isBlocked };
      if (editForm.password) body.password = editForm.password;
      await agentsApi.update(editTarget.id, body);
      setEditTarget(null);
      refetch();
    } catch (err) {
      setFormError(apiErrorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div>
      <PageHeader title="السائقون">
        <Button onClick={openCreate}>+ سائق جديد</Button>
      </PageHeader>

      <Filters>
        <Input
          type="search"
          placeholder="بحث بالاسم أو الهاتف..."
          value={q}
          onChange={(e) => {
            setPage(1);
            setQ(e.target.value);
          }}
        />
      </Filters>

      <ErrorBanner message={error} />
      {loading && !data && <PageLoader />}

      {data && (
        <Card className="overflow-hidden !p-0">
          <DataTable
            empty="لا يوجد سائقون"
            rows={data.items}
            columns={[
              { key: 'name', header: 'الاسم', primary: true, cell: (a) => <span className="font-bold">{a.fullName}</span> },
              {
                key: 'online',
                header: 'متصل؟',
                primary: true,
                cell: (a) => <Badge tone={a.isOnline ? 'green' : 'neutral'}>{a.isOnline ? 'متصل' : 'غير متصل'}</Badge>,
              },
              {
                key: 'phone',
                header: 'الهاتف',
                cell: (a) => (
                  <a href={`tel:${a.phone}`} dir="ltr" className="hover:text-forest">
                    {a.phone}
                  </a>
                ),
              },
              {
                key: 'status',
                header: 'الحالة',
                cell: (a) => (
                  <div className="flex flex-wrap gap-1">
                    <Badge tone={a.isActive ? 'green' : 'neutral'}>{a.isActive ? 'مفعّل' : 'معطّل'}</Badge>
                    {a.isBlocked && <Badge tone="red">محظور</Badge>}
                  </div>
                ),
              },
              {
                key: 'actions',
                actions: true,
                cell: (a) => (
                  <Button variant="outline" onClick={() => openEdit(a)}>
                    تعديل
                  </Button>
                ),
              },
            ]}
          />
          <Pagination page={data.page} total={data.total} limit={data.limit} onChange={setPage} />
        </Card>
      )}

      <Modal open={createOpen} onClose={() => setCreateOpen(false)} title="سائق جديد">
        <form className="space-y-4" onSubmit={handleCreate}>
          <Input
            label="الاسم الكامل"
            value={createForm.fullName}
            onChange={(e) => setCreateForm((f) => ({ ...f, fullName: e.target.value }))}
            required
          />
          <Input
            label="رقم الهاتف"
            value={createForm.phone}
            onChange={(e) => setCreateForm((f) => ({ ...f, phone: e.target.value }))}
            required
          />
          <Input
            label="كلمة المرور"
            type="password"
            value={createForm.password}
            onChange={(e) => setCreateForm((f) => ({ ...f, password: e.target.value }))}
            required
          />
          <ErrorBanner message={formError} />
          <FormActions>
            <Button type="button" variant="ghost" onClick={() => setCreateOpen(false)}>
              إلغاء
            </Button>
            <Button type="submit" disabled={busy}>
              {busy ? <Spinner className="h-4 w-4" /> : 'إنشاء'}
            </Button>
          </FormActions>
        </form>
      </Modal>

      <Modal open={!!editTarget} onClose={() => setEditTarget(null)} title="تعديل السائق">
        <form className="space-y-4" onSubmit={handleEdit}>
          <Input
            label="الاسم الكامل"
            value={editForm.fullName}
            onChange={(e) => setEditForm((f) => ({ ...f, fullName: e.target.value }))}
            required
          />
          <Input
            label="كلمة مرور جديدة (اختياري)"
            type="password"
            value={editForm.password}
            onChange={(e) => setEditForm((f) => ({ ...f, password: e.target.value }))}
          />
          <div className="flex flex-wrap gap-x-6">
            <Checkbox
              label="مفعّل"
              checked={editForm.isActive}
              onChange={(e) => setEditForm((f) => ({ ...f, isActive: e.target.checked }))}
            />
            <Checkbox
              label="محظور"
              checked={editForm.isBlocked}
              onChange={(e) => setEditForm((f) => ({ ...f, isBlocked: e.target.checked }))}
            />
          </div>
          <ErrorBanner message={formError} />
          <FormActions>
            <Button type="button" variant="ghost" onClick={() => setEditTarget(null)}>
              إلغاء
            </Button>
            <Button type="submit" disabled={busy}>
              {busy ? <Spinner className="h-4 w-4" /> : 'حفظ'}
            </Button>
          </FormActions>
        </form>
      </Modal>
    </div>
  );
}
