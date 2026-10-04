import { useState } from 'react';
import { analyticsApi, useAsync } from '../api';
import { centimesToDa } from '../constants';
import { Card, EmptyState, ErrorBanner, Input, PageHeader, PageLoader } from '../components/ui';

function toInputDate(d) {
  return d.toISOString().slice(0, 10);
}

export default function AnalyticsPage() {
  const [from, setFrom] = useState(toInputDate(new Date(Date.now() - 30 * 24 * 60 * 60 * 1000)));
  const [to, setTo] = useState(toInputDate(new Date()));

  const params = { from: from ? new Date(from) : undefined, to: to ? new Date(to) : undefined };

  const orders = useAsync(() => analyticsApi.ordersOverTime(params), [from, to]);
  const topVendors = useAsync(() => analyticsApi.topVendors(params), [from, to]);
  const topProducts = useAsync(() => analyticsApi.topProducts(params), [from, to]);
  const agents = useAsync(() => analyticsApi.agentLeaderboard(params), [from, to]);
  const cancellations = useAsync(() => analyticsApi.cancellationReasons(params), [from, to]);

  const anyLoading = [orders, topVendors, topProducts, agents, cancellations].some((q) => q.loading);
  const anyError = [orders, topVendors, topProducts, agents, cancellations].find((q) => q.error)?.error;

  const totalOrders = orders.data?.reduce((s, d) => s + d.orders, 0) ?? 0;
  const totalRevenue = orders.data?.reduce((s, d) => s + d.revenueCentimes, 0) ?? 0;
  const totalCancelled = orders.data?.reduce((s, d) => s + d.cancelled, 0) ?? 0;

  return (
    <div>
      <PageHeader title="الإحصائيات" />
      <div className="mb-5 grid grid-cols-2 gap-3 sm:flex sm:w-auto">
        <Input label="من" type="date" value={from} onChange={(e) => setFrom(e.target.value)} />
        <Input label="إلى" type="date" value={to} onChange={(e) => setTo(e.target.value)} />
      </div>

      <ErrorBanner message={anyError} />
      {anyLoading && <PageLoader />}

      {!anyLoading && (
        <div className="space-y-6">
          <div className="grid gap-3 sm:grid-cols-3 sm:gap-4">
            <Card>
              <p className="text-sm font-bold text-ink-muted">إجمالي الطلبات</p>
              <p className="num mt-1 text-2xl font-black">{totalOrders}</p>
            </Card>
            <Card>
              <p className="text-sm font-bold text-ink-muted">إجمالي الإيرادات</p>
              <p className="num mt-1 text-2xl font-black text-forest">{centimesToDa(totalRevenue)} د.ج</p>
            </Card>
            <Card>
              <p className="text-sm font-bold text-ink-muted">الطلبات الملغاة</p>
              <p className="num mt-1 text-2xl font-black text-tomato">{totalCancelled}</p>
            </Card>
          </div>

          <Card>
            <h2 className="mb-3 font-black">الطلبات عبر الزمن</h2>
            {!orders.data?.length ? (
              <EmptyState />
            ) : (
              <div className="-mx-4 overflow-x-auto px-4 sm:mx-0 sm:px-0">
                <table className="w-full min-w-[420px] text-sm">
                  <thead>
                    <tr className="text-ink-muted">
                      <th className="py-1 text-start font-bold">التاريخ</th>
                      <th className="py-1 text-start font-bold">الطلبات</th>
                      <th className="py-1 text-start font-bold">الإيرادات</th>
                      <th className="py-1 text-start font-bold">الملغاة</th>
                    </tr>
                  </thead>
                  <tbody>
                    {orders.data.map((d) => (
                      <tr key={d.date} className="num border-t border-ink/5">
                        <td className="py-1.5">{d.date}</td>
                        <td className="py-1.5">{d.orders}</td>
                        <td className="py-1.5">{centimesToDa(d.revenueCentimes)} د.ج</td>
                        <td className="py-1.5">{d.cancelled}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </Card>

          <div className="grid gap-6 md:grid-cols-2">
            <Card>
              <h2 className="mb-3 font-black">أفضل المتاجر</h2>
              {!topVendors.data?.length ? (
                <EmptyState />
              ) : (
                <ul className="space-y-2">
                  {topVendors.data.map((v) => (
                    <li key={v.vendorId} className="flex flex-wrap justify-between gap-x-3 gap-y-0.5 text-sm">
                      <span className="font-bold">{v.name}</span>
                      <span className="num text-ink-soft">
                        {v.orders} طلب · {centimesToDa(v.revenueCentimes)} د.ج
                      </span>
                    </li>
                  ))}
                </ul>
              )}
            </Card>

            <Card>
              <h2 className="mb-3 font-black">أفضل المنتجات</h2>
              {!topProducts.data?.length ? (
                <EmptyState />
              ) : (
                <ul className="space-y-2">
                  {topProducts.data.map((p) => (
                    <li key={p.productId} className="flex flex-wrap justify-between gap-x-3 gap-y-0.5 text-sm">
                      <span className="font-bold">{p.name}</span>
                      <span className="num text-ink-soft">
                        {p.qty} قطعة · {centimesToDa(p.revenueCentimes)} د.ج
                      </span>
                    </li>
                  ))}
                </ul>
              )}
            </Card>

            <Card>
              <h2 className="mb-3 font-black">ترتيب السائقين</h2>
              {!agents.data?.length ? (
                <EmptyState />
              ) : (
                <ul className="space-y-2">
                  {agents.data.map((a) => (
                    <li key={a.agentId} className="flex flex-wrap justify-between gap-x-3 gap-y-0.5 text-sm">
                      <span className="font-bold">{a.fullName}</span>
                      <span className="num text-ink-soft">
                        {a.deliveries} توصيلة · {centimesToDa(a.earningsCentimes)} د.ج · {a.avgMinutes} د
                      </span>
                    </li>
                  ))}
                </ul>
              )}
            </Card>

            <Card>
              <h2 className="mb-3 font-black">أسباب الإلغاء</h2>
              {!cancellations.data?.length ? (
                <EmptyState />
              ) : (
                <ul className="space-y-2">
                  {cancellations.data.map((c) => (
                    <li key={c.reason} className="flex flex-wrap justify-between gap-x-3 gap-y-0.5 text-sm">
                      <span className="font-bold">{c.reason}</span>
                      <span className="num text-ink-soft">{c.count}</span>
                    </li>
                  ))}
                </ul>
              )}
            </Card>
          </div>
        </div>
      )}
    </div>
  );
}
