import { dashboardApi } from '../api/endpoints';
import { useAsync } from '../lib/useAsync';
import { Card, ErrorBanner, PageLoader } from '../components/ui';

function StatCard({ label, value, tone = 'text-ink' }) {
  return (
    <Card>
      <p className="text-sm font-bold text-ink-muted">{label}</p>
      <p className={`mt-2 text-3xl font-black ${tone}`}>{value}</p>
    </Card>
  );
}

export default function DashboardPage() {
  const { data: stats, loading, error } = useAsync(() => dashboardApi.stats(), []);

  return (
    <div>
      <h1 className="mb-6 text-2xl font-black">لوحة التحكم</h1>
      <ErrorBanner message={error} />
      {loading && <PageLoader />}
      {stats && (
        <div className="grid grid-cols-2 gap-4 md:grid-cols-3 lg:grid-cols-4">
          <StatCard label="طلبات اليوم" value={stats.todayOrders} />
          <StatCard label="إيرادات اليوم" value={stats.revenueLabel} tone="text-brand-deep" />
          <StatCard label="تم توصيلها اليوم" value={stats.deliveredToday} />
          <StatCard label="توصيلات نشطة" value={stats.activeDeliveries} />
          <StatCard label="متوسط وقت التوصيل" value={`${stats.avgDeliveryMinutes} د`} />
          <StatCard
            label="طلبات متأخرة"
            value={stats.lateOrders}
            tone={stats.lateOrders > 0 ? 'text-red-600' : 'text-ink'}
          />
          <StatCard label="طلبات قيد الانتظار" value={stats.pendingOrders} />
          <StatCard label="سائقون متصلون" value={stats.onlineAgents} tone="text-brand-deep" />
        </div>
      )}
    </div>
  );
}
