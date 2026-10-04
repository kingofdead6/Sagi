import { useState } from 'react';
import { customersApi, apiErrorMessage, useAsync } from '../api';
import { ORDER_STATUS_LABELS, centimesToDa } from '../constants';
import {
  Badge,
  Button,
  Card,
  ConfirmModal,
  EmptyState,
  DataTable,
  ErrorBanner,
  Filters,
  Input,
  Modal,
  PageHeader,
  PageLoader,
  Pagination,
} from '../components/ui';

export default function CustomersPage() {
  const [q, setQ] = useState('');
  const [page, setPage] = useState(1);
  const { data, loading, error, refetch } = useAsync(
    () => customersApi.list({ q, page, limit: 20 }),
    [q, page],
  );
  const [detailId, setDetailId] = useState(null);

  return (
    <div>
      <PageHeader title="العملاء" />

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
            empty="لا يوجد عملاء"
            rows={data.items}
            columns={[
              { key: 'name', header: 'الاسم', primary: true, cell: (c) => <span className="font-bold">{c.fullName}</span> },
              {
                key: 'status',
                header: 'الحالة',
                primary: true,
                cell: (c) => <Badge tone={c.isBlocked ? 'red' : 'green'}>{c.isBlocked ? 'محظور' : 'نشط'}</Badge>,
              },
              { key: 'phone', header: 'الهاتف', cell: (c) => <span dir="ltr">{c.phone}</span> },
              { key: 'points', header: 'النقاط', cell: (c) => <span className="num">{c.points}</span> },
              {
                key: 'actions',
                actions: true,
                cell: (c) => (
                  <Button variant="outline" onClick={() => setDetailId(c.id)}>
                    عرض
                  </Button>
                ),
              },
            ]}
          />
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
          <div className="flex flex-wrap items-center justify-between gap-3">
            <div className="min-w-0">
              <p className="text-lg font-black">{data.customer.fullName}</p>
              <a href={`tel:${data.customer.phone}`} dir="ltr" className="text-sm text-ink-muted hover:text-forest">
                {data.customer.phone}
              </a>
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
                <div key={o.id} className="flex flex-wrap items-center justify-between gap-x-3 gap-y-1 rounded-xl bg-cream px-3 py-2 text-sm">
                  <span className="font-mono font-bold">{o.code}</span>
                  <span className="text-ink-soft">{ORDER_STATUS_LABELS[o.status] ?? o.status}</span>
                  <span className="num font-bold">{centimesToDa(o.totalCentimes)} د.ج</span>
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
    <div className="rounded-xl bg-cream px-3 py-2 text-center">
      <p className="text-xs font-bold text-ink-muted">{label}</p>
      <p className="num break-words text-lg font-black">{value}</p>
    </div>
  );
}
