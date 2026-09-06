import { useState } from 'react';
import { agentsApi } from '../api/endpoints';
import { apiErrorMessage } from '../api/client';
import { useAsync } from '../lib/useAsync';
import {
  Badge,
  Button,
  Card,
  Checkbox,
  EmptyState,
  ErrorBanner,
  Input,
  Modal,
  PageLoader,
  Pagination,
  Spinner,
} from '../components/ui';

export default function AgentsPage() {
  const [q, setQ] = useState('');
  const [page, setPage] = useState(1);
  const { data, loading, error, refetch } = useAsync(
    () => agentsApi.list({ q: q || undefined, page, limit: 20 }),
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
      <div className="mb-6 flex items-center justify-between">
        <h1 className="text-2xl font-black">السائقون</h1>
        <Button onClick={openCreate}>+ سائق جديد</Button>
      </div>

      <div className="mb-4 max-w-sm">
        <Input
          placeholder="بحث بالاسم أو الهاتف..."
          value={q}
          onChange={(e) => {
            setPage(1);
            setQ(e.target.value);
          }}
        />
      </div>

      <ErrorBanner message={error} />
      {loading && <PageLoader />}

      {data && (
        <Card className="p-0">
          {data.items.length === 0 ? (
            <EmptyState>لا يوجد سائقون</EmptyState>
          ) : (
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-black/5 text-ink-muted">
                  <th className="px-4 py-3 text-start font-bold">الاسم</th>
                  <th className="px-4 py-3 text-start font-bold">الهاتف</th>
                  <th className="px-4 py-3 text-start font-bold">متصل؟</th>
                  <th className="px-4 py-3 text-start font-bold">الحالة</th>
                  <th className="px-4 py-3"></th>
                </tr>
              </thead>
              <tbody>
                {data.items.map((a) => (
                  <tr key={a.id} className="border-b border-black/5 last:border-0">
                    <td className="px-4 py-3 font-bold">{a.fullName}</td>
                    <td className="px-4 py-3 text-ink-soft">{a.phone}</td>
                    <td className="px-4 py-3">
                      <Badge tone={a.isOnline ? 'green' : 'neutral'}>{a.isOnline ? 'متصل' : 'غير متصل'}</Badge>
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex gap-1">
                        <Badge tone={a.isActive ? 'green' : 'neutral'}>{a.isActive ? 'مفعّل' : 'معطّل'}</Badge>
                        {a.isBlocked && <Badge tone="red">محظور</Badge>}
                      </div>
                    </td>
                    <td className="px-4 py-3 text-end">
                      <Button variant="outline" onClick={() => openEdit(a)}>
                        تعديل
                      </Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
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
          <div className="flex justify-end gap-2">
            <Button type="button" variant="ghost" onClick={() => setCreateOpen(false)}>
              إلغاء
            </Button>
            <Button type="submit" disabled={busy}>
              {busy ? <Spinner className="h-4 w-4" /> : 'إنشاء'}
            </Button>
          </div>
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
          <div className="flex gap-4">
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
          <div className="flex justify-end gap-2">
            <Button type="button" variant="ghost" onClick={() => setEditTarget(null)}>
              إلغاء
            </Button>
            <Button type="submit" disabled={busy}>
              {busy ? <Spinner className="h-4 w-4" /> : 'حفظ'}
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  );
}
