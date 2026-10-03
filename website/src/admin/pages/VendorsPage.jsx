import { useState } from 'react';
import { vendorsApi, useAsync } from '../api';
import { Badge, ButtonLink, Card, DataTable, ErrorBanner, Filters, Input, PageHeader, PageLoader, Pagination } from '../components/ui';

export default function VendorsPage() {
  const [q, setQ] = useState('');
  const [page, setPage] = useState(1);
  const { data, loading, error } = useAsync(
    () => vendorsApi.list({ q, page, limit: 20 }),
    [q, page],
  );

  const columns = [
    {
      key: 'name',
      header: 'المتجر',
      primary: true,
      cell: (v) => (
        <div className="flex min-w-0 items-center gap-3">
          {v.logo?.url ? (
            <img src={v.logo.url} alt="" className="h-10 w-10 shrink-0 rounded-xl object-cover" />
          ) : (
            <div className="h-10 w-10 shrink-0 rounded-xl bg-ink/5" />
          )}
          <span className="truncate font-bold">{v.name}</span>
        </div>
      ),
    },
    { key: 'category', header: 'الفئة', cell: (v) => v.category?.nameAr ?? '—' },
    { key: 'phone', header: 'الهاتف', cell: (v) => <span dir="ltr">{v.phone}</span> },
    {
      key: 'rating',
      header: 'التقييم',
      cell: (v) => (
        <span className="num">
          {v.rating?.toFixed(1) ?? '0.0'} ({v.ratingCount ?? 0})
        </span>
      ),
    },
    {
      key: 'status',
      header: 'الحالة',
      cell: (v) => (
        <div className="flex flex-wrap gap-1">
          <Badge tone={v.isActive ? 'green' : 'neutral'}>{v.isActive ? 'مفعّل' : 'معطّل'}</Badge>
          <Badge tone={v.isOpen ? 'blue' : 'yellow'}>{v.isOpen ? 'مفتوح' : 'مغلق'}</Badge>
          {v.isFeatured && <Badge tone="yellow">مميز</Badge>}
        </div>
      ),
    },
    {
      key: 'actions',
      actions: true,
      cell: (v) => (
        <ButtonLink variant="outline" to={`/admin/vendors/${v.id}`}>
          إدارة
        </ButtonLink>
      ),
    },
  ];

  return (
    <div>
      <PageHeader title="المتاجر">
        <ButtonLink to="/admin/vendors/new">+ متجر جديد</ButtonLink>
      </PageHeader>

      <Filters>
        <Input
          type="search"
          placeholder="بحث بالاسم..."
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
          <DataTable columns={columns} rows={data.items} empty="لا توجد متاجر" />
          <Pagination page={data.page} total={data.total} limit={data.limit} onChange={setPage} />
        </Card>
      )}
    </div>
  );
}
