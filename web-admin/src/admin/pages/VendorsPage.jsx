import { useState } from 'react';
import { Link } from 'react-router-dom';
import { vendorsApi } from '../api/endpoints';
import { useAsync } from '../lib/useAsync';
import { Badge, Button, Card, EmptyState, ErrorBanner, Input, PageLoader, Pagination } from '../components/ui';

export default function VendorsPage() {
  const [q, setQ] = useState('');
  const [page, setPage] = useState(1);
  const { data, loading, error, refetch } = useAsync(
    () => vendorsApi.list({ q: q || undefined, page, limit: 20 }),
    [q, page],
  );

  return (
    <div>
      <div className="mb-6 flex items-center justify-between">
        <h1 className="text-2xl font-black">المتاجر</h1>
        <Link to="/vendors/new">
          <Button>+ متجر جديد</Button>
        </Link>
      </div>

      <div className="mb-4 max-w-sm">
        <Input
          placeholder="بحث بالاسم..."
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
            <EmptyState>لا توجد متاجر</EmptyState>
          ) : (
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-black/5 text-ink-muted">
                  <th className="px-4 py-3 text-start font-bold">المتجر</th>
                  <th className="px-4 py-3 text-start font-bold">الفئة</th>
                  <th className="px-4 py-3 text-start font-bold">الهاتف</th>
                  <th className="px-4 py-3 text-start font-bold">التقييم</th>
                  <th className="px-4 py-3 text-start font-bold">الحالة</th>
                  <th className="px-4 py-3"></th>
                </tr>
              </thead>
              <tbody>
                {data.items.map((v) => (
                  <tr key={v.id} className="border-b border-black/5 last:border-0">
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-3">
                        {v.logo?.url ? (
                          <img src={v.logo.url} alt="" className="h-9 w-9 rounded-lg object-cover" />
                        ) : (
                          <div className="h-9 w-9 rounded-lg bg-black/5" />
                        )}
                        <span className="font-bold">{v.name}</span>
                      </div>
                    </td>
                    <td className="px-4 py-3 text-ink-soft">{v.category?.nameAr ?? '—'}</td>
                    <td className="px-4 py-3 text-ink-soft">{v.phone}</td>
                    <td className="px-4 py-3 text-ink-soft">
                      {v.rating?.toFixed(1) ?? '0.0'} ({v.ratingCount ?? 0})
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex flex-wrap gap-1">
                        <Badge tone={v.isActive ? 'green' : 'neutral'}>{v.isActive ? 'مفعّل' : 'معطّل'}</Badge>
                        <Badge tone={v.isOpen ? 'blue' : 'yellow'}>{v.isOpen ? 'مفتوح' : 'مغلق'}</Badge>
                        {v.isFeatured && <Badge tone="yellow">مميز</Badge>}
                      </div>
                    </td>
                    <td className="px-4 py-3 text-end">
                      <Link to={`/vendors/${v.id}`}>
                        <Button variant="outline">إدارة</Button>
                      </Link>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
          <Pagination page={data.page} total={data.total} limit={data.limit} onChange={setPage} />
        </Card>
      )}
    </div>
  );
}
