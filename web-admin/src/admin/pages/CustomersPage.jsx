import { useState } from 'react';
import { customersApi } from '../api/endpoints';
import { apiErrorMessage } from '../api/client';
import { useAsync } from '../lib/useAsync';
import { ORDER_STATUS_LABELS, centimesToDa } from '../lib/constants';
import {
  Badge,
  Button,
  Card,
  ConfirmModal,
  EmptyState,
  ErrorBanner,
  Input,
  Modal,
  PageLoader,
  Pagination,
  Spinner,
} from '../components/ui';

export default function CustomersPage() {
  const [q, setQ] = useState('');
  const [page, setPage] = useState(1);
  const { data, loading, error, refetch } = useAsync(
    () => customersApi.list({ q: q || undefined, page, limit: 20 }),
    [q, page],
  );
  const [detailId, setDetailId] = useState(null);

  return (
    <div>
      <h1 className="mb-6 text-2xl font-black">العملاء</h1>

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
            <EmptyState>لا يوجد عملاء</EmptyState>
          ) : (
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-black/5 text-ink-muted">
                  <th className="px-4 py-3 text-start font-bold">الاسم</th>
                  <th className="px-4 py-3 text-start font-bold">الهاتف</th>
                  <th className="px-4 py-3 text-start font-bold">النقاط</th>
                  <th className="px-4 py-3 text-start font-bold">الحالة</th>
                  <th className="px-4 py-3"></th>
                </tr>
              </thead>
              <tbody>
                {data.items.map((c) => (
                  <tr key={c.id} className="border-b border-black/5 last:border-0">
                    <td className="px-4 py-3 font-bold">{c.fullName}</td>
                    <td className="px-4 py-3 text-ink-soft">{c.phone}</td>
                    <td className="px-4 py-3 text-ink-soft">{c.points}</td>
                    <td className="px-4 py-3">
                      <Badge tone={c.isBlocked ? 'red' : 'green'}>{c.isBlocked ? 'محظور' : 'نشط'}</Badge>
                    </td>
                    <td className="px-4 py-3 text-end">
                      <Button variant="outline" onClick={() => setDetailId(c.id)}>
                        عرض
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

      {detailId && (
        <CustomerDetailModal customerId={detailId} onClose={() => setDetailId(null)} onChanged={refetch} />
      )}
    </div>
  );
}

function CustomerDetailModal({ customerId, onClose, onChanged }) {
  const { data, loading, error, refetch } = useAsync(() => customersApi.get(customerId), [customerId]);
  const [busy, setBusy] = useState(false);
  const [formError, setFormError] = useState(null);
  const [confirmBlock, setConfirmBlock] = useState(false);

  async function toggleBlock() {
    setBusy(true);
    setFormError(null);
    try {
      await customersApi.update(customerId, { isBlocked: !data.customer.isBlocked });
      setConfirmBlock(false);
      refetch();
      onChanged();
    } catch (err) {
      setFormError(apiErrorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <Modal open onClose={onClose} title="ملف العميل" width="max-w-2xl">
      {loading && <PageLoader />}
      <ErrorBanner message={error || formError} />
      {data && (
        <div className="space-y-5">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-lg font-black">{data.customer.fullName}</p>
              <p className="text-sm text-ink-muted">{data.customer.phone}</p>
            </div>
            <Button variant={data.customer.isBlocked ? 'outline' : 'danger'} onClick={() => setConfirmBlock(true)}>
              {data.customer.isBlocked ? 'إلغاء الحظر' : 'حظر العميل'}
            </Button>
          </div>

          <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
            <Stat label="الطلبات" value={data.summary.orders} />
            <Stat label="تم التوصيل" value={data.summary.delivered} />
            <Stat label="ملغاة" value={data.summary.cancelled} />
            <Stat label="الإنفاق" value={`${centimesToDa(data.summary.spentCentimes)} د.ج`} />
          </div>

          <div>
            <h3 className="mb-2 font-bold">آخر الطلبات</h3>
            <div className="max-h-64 space-y-2 overflow-y-auto">
              {data.orders.length === 0 && <EmptyState>لا توجد طلبات</EmptyState>}
              {data.orders.map((o) => (
                <div key={o.id} className="flex items-center justify-between rounded-xl bg-black/5 px-3 py-2 text-sm">
                  <span className="font-mono font-bold">{o.code}</span>
                  <span className="text-ink-soft">{ORDER_STATUS_LABELS[o.status] ?? o.status}</span>
                  <span className="font-bold">{centimesToDa(o.totalCentimes)} د.ج</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      <ConfirmModal
        open={confirmBlock}
        onClose={() => setConfirmBlock(false)}
        onConfirm={toggleBlock}
        loading={busy}
        title={data?.customer.isBlocked ? 'إلغاء الحظر' : 'حظر العميل'}
        message={
          data?.customer.isBlocked ? 'هل تريد إلغاء حظر هذا العميل؟' : 'هل تريد حظر هذا العميل من الطلب؟'
        }
      />
    </Modal>
  );
}

function Stat({ label, value }) {
  return (
    <div className="rounded-xl bg-black/5 px-3 py-2 text-center">
      <p className="text-xs font-bold text-ink-muted">{label}</p>
      <p className="text-lg font-black">{value}</p>
    </div>
  );
}
