import { dashboardApi, useAsync } from '../api';
import { Card, ErrorBanner, PageHeader, PageLoader } from '../components/ui';

function StatCard({ label, value, tone = 'text-ink' }) {
  return (
    <Card>
      <p className="text-xs font-bold text-ink-muted sm:text-sm">{label}</p>
      <p className={`num mt-1 break-words text-2xl font-black sm:mt-2 sm:text-3xl ${tone}`}>{value}</p>
    </Card>
  );
}

export default function DashboardPage() {
  const { data: stats, loading, error } = useAsync(() => dashboardApi.stats(), []);

  return (
    <div>
      <PageHeader title="لوحة التحكم" />
      <ErrorBanner message={error} />
      {loading && <PageLoader />}
      {stats && (
        <div className="grid grid-cols-2 gap-3 sm:gap-4 md:grid-cols-3 xl:grid-cols-4">
          <StatCard label="طلبات اليوم" value={stats.todayOrders} />
          <StatCard label="إيرادات اليوم" value={stats.revenueLabel} tone="text-forest" />
          <StatCard label="تم توصيلها اليوم" value={stats.deliveredToday} />
          <StatCard label="توصيلات نشطة" value={stats.activeDeliveries} />
          <StatCard label="متوسط وقت التوصيل" value={`${stats.avgDeliveryMinutes} د`} />
          <StatCard
            label="طلبات متأخرة"
            value={stats.lateOrders}
            tone={stats.lateOrders > 0 ? 'text-tomato' : 'text-ink'}
          />
          <StatCard label="طلبات قيد الانتظار" value={stats.pendingOrders} />
          <StatCard label="سائقون متصلون" value={stats.onlineAgents} tone="text-forest" />
        </div>
      )}
    </div>
  );
}
