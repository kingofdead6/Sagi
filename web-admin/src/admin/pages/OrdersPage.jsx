import { useState } from 'react';
import { ordersApi } from '../api/endpoints';
import { apiErrorMessage } from '../api/client';
import { useAsync } from '../lib/useAsync';
import {
  ALLOWED_TRANSITIONS,
  DELIVERY_LABELS,
  ORDER_STATUSES,
  ORDER_STATUS_LABELS,
  PAYMENT_LABELS,
  centimesToDa,
} from '../lib/constants';
import {
  Badge,
  Button,
  Card,
  EmptyState,
  ErrorBanner,
  Input,
  Modal,
  PageLoader,
  Pagination,
  Select,
  Spinner,
  Textarea,
} from '../components/ui';

const STATUS_TONE = {
  pending: 'yellow',
  confirmed: 'blue',
  sent_to_vendor: 'blue',
  preparing: 'blue',
  ready: 'blue',
  assigned: 'blue',
  accepted: 'blue',
  picked_up: 'blue',
  on_the_way: 'blue',
  delivered: 'green',
  cancelled: 'red',
};

export default function OrdersPage() {
  const [status, setStatus] = useState('');
  const [q, setQ] = useState('');
  const [page, setPage] = useState(1);
  const { data, loading, error, refetch } = useAsync(
    () => ordersApi.list({ status: status || undefined, q: q || undefined, page, limit: 20 }),
    [status, q, page],
  );
  const [detailId, setDetailId] = useState(null);

  return (
    <div>
      <div className="mb-6 flex items-center justify-between">
        <h1 className="text-2xl font-black">الطلبات</h1>
        <a href={ordersApi.exportUrl({ status: status || undefined, q: q || undefined })}>
          <Button variant="outline">تصدير CSV</Button>
        </a>
      </div>

      <div className="mb-4 flex flex-wrap gap-3">
        <Select
          value={status}
          onChange={(e) => {
            setPage(1);
            setStatus(e.target.value);
          }}
          className="max-w-xs"
        >
          <option value="">كل الحالات</option>
          {ORDER_STATUSES.map((s) => (
            <option key={s} value={s}>
              {ORDER_STATUS_LABELS[s]}
            </option>
          ))}
        </Select>
        <Input
          placeholder="بحث برمز الطلب..."
          value={q}
          onChange={(e) => {
            setPage(1);
            setQ(e.target.value);
          }}
          className="max-w-xs"
        />
      </div>

      <ErrorBanner message={error} />
      {loading && <PageLoader />}

      {data && (
        <Card className="p-0">
          {data.items.length === 0 ? (
            <EmptyState>لا توجد طلبات</EmptyState>
          ) : (
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-black/5 text-ink-muted">
                  <th className="px-4 py-3 text-start font-bold">الرمز</th>
                  <th className="px-4 py-3 text-start font-bold">العميل</th>
                  <th className="px-4 py-3 text-start font-bold">المتجر</th>
                  <th className="px-4 py-3 text-start font-bold">المجموع</th>
                  <th className="px-4 py-3 text-start font-bold">الحالة</th>
                  <th className="px-4 py-3"></th>
                </tr>
              </thead>
              <tbody>
                {data.items.map((o) => (
                  <tr key={o.id} className="border-b border-black/5 last:border-0">
                    <td className="px-4 py-3 font-mono font-bold">{o.code}</td>
                    <td className="px-4 py-3 text-ink-soft">{o.customer?.fullName}</td>
                    <td className="px-4 py-3 text-ink-soft">{o.vendor?.name}</td>
                    <td className="px-4 py-3 font-bold">{centimesToDa(o.totalCentimes)} د.ج</td>
                    <td className="px-4 py-3">
                      <Badge tone={STATUS_TONE[o.status]}>{ORDER_STATUS_LABELS[o.status]}</Badge>
                    </td>
                    <td className="px-4 py-3 text-end">
                      <Button variant="outline" onClick={() => setDetailId(o.id)}>
                        التفاصيل
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
        <OrderDetailModal orderId={detailId} onClose={() => setDetailId(null)} onChanged={refetch} />
      )}
    </div>
  );
}

function OrderDetailModal({ orderId, onClose, onChanged }) {
  const { data: order, loading, error, refetch } = useAsync(() => ordersApi.get(orderId), [orderId]);
  const { data: agents } = useAsync(
    () => (order ? ordersApi.availableAgents(order.vendor?.id) : Promise.resolve([])),
    [order?.id],
  );

  const [nextStatus, setNextStatus] = useState('');
  const [note, setNote] = useState('');
  const [agentId, setAgentId] = useState('');
  const [busy, setBusy] = useState(false);
  const [formError, setFormError] = useState(null);

  const transitions = order ? ALLOWED_TRANSITIONS[order.status] ?? [] : [];

  async function handleStatusChange(e) {
    e.preventDefault();
    if (!nextStatus) return;
    setBusy(true);
    setFormError(null);
    try {
      await ordersApi.setStatus(orderId, nextStatus, note || undefined);
      setNextStatus('');
      setNote('');
      refetch();
      onChanged();
    } catch (err) {
      setFormError(apiErrorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  async function handleAssign(e) {
    e.preventDefault();
    if (!agentId) return;
    setBusy(true);
    setFormError(null);
    try {
      await ordersApi.assign(orderId, agentId);
      setAgentId('');
      refetch();
      onChanged();
    } catch (err) {
      setFormError(apiErrorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <Modal open onClose={onClose} title="تفاصيل الطلب" width="max-w-2xl">
      {loading && <PageLoader />}
      <ErrorBanner message={error || formError} />
      {order && (
        <div className="space-y-5">
          <div className="flex items-center justify-between">
            <div>
              <p className="font-mono text-lg font-black">{order.code}</p>
              <p className="text-sm text-ink-muted">{new Date(order.createdAt).toLocaleString('ar-DZ')}</p>
            </div>
            <Badge tone={STATUS_TONE[order.status]}>{ORDER_STATUS_LABELS[order.status]}</Badge>
          </div>

          <div className="grid grid-cols-2 gap-3 text-sm">
            <div>
              <p className="font-bold text-ink-muted">العميل</p>
              <p>{order.customer?.fullName} · {order.customer?.phone}</p>
            </div>
            <div>
              <p className="font-bold text-ink-muted">المتجر</p>
              <p>{order.vendor?.name}</p>
            </div>
            <div>
              <p className="font-bold text-ink-muted">السائق</p>
              <p>{order.agent ? `${order.agent.fullName} · ${order.agent.phone}` : '—'}</p>
            </div>
            <div>
              <p className="font-bold text-ink-muted">الدفع / التوصيل</p>
              <p>
                {PAYMENT_LABELS[order.paymentMethod]} · {DELIVERY_LABELS[order.deliveryType]}
              </p>
            </div>
          </div>

          <div>
            <p className="mb-1 font-bold text-ink-muted">العنوان</p>
            <p className="text-sm">
              {[order.address?.wilaya, order.address?.commune, order.address?.street]
                .filter(Boolean)
                .join('، ') || '—'}
            </p>
            {order.address?.notes && <p className="text-xs text-ink-muted">{order.address.notes}</p>}
          </div>

          <div>
            <p className="mb-2 font-bold text-ink-muted">العناصر</p>
            <div className="space-y-1">
              {order.items?.map((it, i) => (
                <div key={i} className="flex justify-between text-sm">
                  <span>
                    {it.qty} × {it.nameSnapshot}
                  </span>
                  <span className="font-bold">{centimesToDa(it.lineTotalCentimes)} د.ج</span>
                </div>
              ))}
            </div>
            <div className="mt-2 space-y-1 border-t border-black/10 pt-2 text-sm">
              <div className="flex justify-between text-ink-soft">
                <span>المجموع الفرعي</span>
                <span>{centimesToDa(order.subtotalCentimes)} د.ج</span>
              </div>
              <div className="flex justify-between text-ink-soft">
                <span>رسوم التوصيل</span>
                <span>{centimesToDa(order.deliveryFeeCentimes)} د.ج</span>
              </div>
              <div className="flex justify-between font-black">
                <span>الإجمالي</span>
                <span>{centimesToDa(order.totalCentimes)} د.ج</span>
              </div>
            </div>
          </div>

          {order.status === 'ready' && (
            <form className="rounded-xl bg-black/5 p-3" onSubmit={handleAssign}>
              <p className="mb-2 text-sm font-bold">إسناد إلى سائق</p>
              <div className="flex gap-2">
                <Select value={agentId} onChange={(e) => setAgentId(e.target.value)} className="flex-1">
                  <option value="">اختر سائقاً متاحاً</option>
                  {agents?.map((a) => (
                    <option key={a.id} value={a.id}>
                      {a.fullName}
                    </option>
                  ))}
                </Select>
                <Button type="submit" disabled={busy || !agentId}>
                  {busy ? <Spinner className="h-4 w-4" /> : 'إسناد'}
                </Button>
              </div>
            </form>
          )}

          {transitions.length > 0 && (
            <form className="rounded-xl bg-black/5 p-3" onSubmit={handleStatusChange}>
              <p className="mb-2 text-sm font-bold">تغيير الحالة</p>
              <div className="flex flex-col gap-2">
                <Select value={nextStatus} onChange={(e) => setNextStatus(e.target.value)}>
                  <option value="">اختر الحالة الجديدة</option>
                  {transitions.map((s) => (
                    <option key={s} value={s}>
                      {ORDER_STATUS_LABELS[s]}
                    </option>
                  ))}
                </Select>
                {nextStatus === 'cancelled' && (
                  <Textarea
                    placeholder="سبب الإلغاء (مطلوب)"
                    value={note}
                    onChange={(e) => setNote(e.target.value)}
                    rows={2}
                  />
                )}
                <Button type="submit" disabled={busy || !nextStatus} className="self-end">
                  {busy ? <Spinner className="h-4 w-4" /> : 'تحديث الحالة'}
                </Button>
              </div>
            </form>
          )}
        </div>
      )}
    </Modal>
  );
}
