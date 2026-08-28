export interface Page<T> {
  items: T[];
  page: number;
  limit: number;
  total: number;
  hasMore: boolean;
}

export function buildPage<T>(items: T[], page: number, limit: number, total: number): Page<T> {
  return { items, page, limit, total, hasMore: page * limit < total };
}

export function skipFor(page: number, limit: number): number {
  return (Math.max(1, page) - 1) * limit;
}
