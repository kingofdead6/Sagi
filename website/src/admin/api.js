import { useCallback, useEffect, useRef, useState } from 'react';
import { http } from '../lib/api';

// The admin panel shares the site's session and HTTP client, so an admin who
// signs in on the site lands here with the same token and the same refresh
// handling as every other screen.

const unwrap = (p) => p.then((r) => r.data.data);

/** Drops empty filters so they never reach the query string. */
function clean(params) {
  return Object.fromEntries(
    Object.entries(params || {}).filter(([, v]) => v !== undefined && v !== null && v !== ''),
  );
}

export function apiErrorMessage(err) {
  const data = err?.response?.data;
  const detail = Array.isArray(data?.details) && data.details[0]?.message;
  return detail || data?.message || err?.message || 'حدث خطأ غير متوقع';
}

/** Runs `fn` whenever `deps` change; stale responses are dropped. */
export function useAsync(fn, deps) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const seq = useRef(0);

  const run = useCallback(() => {
    const id = ++seq.current;
    setLoading(true);
    setError(null);
    return fn()
      .then((res) => id === seq.current && setData(res))
      .catch((err) => id === seq.current && setError(apiErrorMessage(err)))
      .finally(() => id === seq.current && setLoading(false));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, deps);

  useEffect(() => {
    run();
  }, [run]);

  return { data, loading, error, refetch: run, setData };
}

// ─────────────────────────── dashboard ───────────────────────────
export const dashboardApi = {
  stats: () => unwrap(http.get('/admin/stats')),
};

// ─────────────────────────── orders ───────────────────────────
export const ordersApi = {
  list: (params) => unwrap(http.get('/admin/orders', { params: clean(params) })),
  get: (id) => unwrap(http.get(`/admin/orders/${id}`)),
  setStatus: (id, status, note) => unwrap(http.patch(`/admin/orders/${id}/status`, { status, note })),
  assign: (id, agentId) => unwrap(http.post(`/admin/orders/${id}/assign`, { agentId })),
  /** The export needs the bearer token, so it is fetched and saved rather than linked. */
  exportCsv: async (params) => {
    const res = await http.get('/admin/orders/export', {
      params: clean(params),
      responseType: 'blob',
      timeout: 90_000,
    });
    const url = URL.createObjectURL(res.data);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'saji-orders.csv';
    document.body.appendChild(a);
    a.click();
    a.remove();
    setTimeout(() => URL.revokeObjectURL(url), 1000);
  },
  availableAgents: (vendorId) => unwrap(http.get('/admin/agents/available', { params: clean({ vendorId }) })),
};

// ─────────────────────────── categories ───────────────────────────
export const categoriesApi = {
  list: () => unwrap(http.get('/admin/categories')),
  create: (body) => unwrap(http.post('/admin/categories', body)),
  update: (id, body) => unwrap(http.patch(`/admin/categories/${id}`, body)),
  remove: (id) => unwrap(http.delete(`/admin/categories/${id}`)),
};

// ─────────────────────────── vendors ───────────────────────────
export const vendorsApi = {
  list: (params) => unwrap(http.get('/admin/vendors', { params: clean(params) })),
  get: (id) => unwrap(http.get(`/admin/vendors/${id}`)),
  create: (body) => unwrap(http.post('/admin/vendors', body)),
  update: (id, body) => unwrap(http.patch(`/admin/vendors/${id}`, body)),
  remove: (id) => unwrap(http.delete(`/admin/vendors/${id}`)),
  // Permanent: wipes the shop, its menu and its offers. `force` is required
  // once the shop has past orders — those stay in the record either way.
  destroy: (id, { force } = {}) =>
    unwrap(http.delete(`/admin/vendors/${id}/permanent`, { params: force ? { force: true } : undefined })),
  createAccount: (id, body) => unwrap(http.post(`/admin/vendors/${id}/account`, body)),
  removeAccount: (id) => unwrap(http.delete(`/admin/vendors/${id}/account`)),
  sections: (id) => unwrap(http.get(`/admin/vendors/${id}/sections`)),
  createSection: (id, body) => unwrap(http.post(`/admin/vendors/${id}/sections`, body)),
  updateSection: (sectionId, body) => unwrap(http.patch(`/admin/sections/${sectionId}`, body)),
  removeSection: (sectionId) => unwrap(http.delete(`/admin/sections/${sectionId}`)),
};

// ─────────────────────────── products ───────────────────────────
export const productsApi = {
  list: (params) => unwrap(http.get('/admin/products', { params: clean(params) })),
  create: (body) => unwrap(http.post('/admin/products', body)),
  update: (id, body) => unwrap(http.patch(`/admin/products/${id}`, body)),
  remove: (id) => unwrap(http.delete(`/admin/products/${id}`)),
  approve: (id) => unwrap(http.patch(`/admin/products/${id}/status`, { status: 'approved' })),
  reject: (id, rejectionReason) =>
    unwrap(http.patch(`/admin/products/${id}/status`, { status: 'rejected', rejectionReason })),
};

// ─────────────────────────── offers ───────────────────────────
export const offersApi = {
  list: () => unwrap(http.get('/admin/offers')),
  create: (body) => unwrap(http.post('/admin/offers', body)),
  update: (id, body) => unwrap(http.patch(`/admin/offers/${id}`, body)),
  remove: (id) => unwrap(http.delete(`/admin/offers/${id}`)),
};

// ─────────────────────────── vouchers ───────────────────────────
export const vouchersApi = {
  list: () => unwrap(http.get('/admin/vouchers')),
  create: (body) => unwrap(http.post('/admin/vouchers', body)),
  update: (id, body) => unwrap(http.patch(`/admin/vouchers/${id}`, body)),
  remove: (id) => unwrap(http.delete(`/admin/vouchers/${id}`)),
};

// ─────────────────────────── agents ───────────────────────────
export const agentsApi = {
  list: (params) => unwrap(http.get('/admin/agents', { params: clean(params) })),
  create: (body) => unwrap(http.post('/admin/agents', body)),
  update: (id, body) => unwrap(http.patch(`/admin/agents/${id}`, body)),
};

// ─────────────────────────── customers ───────────────────────────
export const customersApi = {
  list: (params) => unwrap(http.get('/admin/customers', { params: clean(params) })),
  get: (id) => unwrap(http.get(`/admin/customers/${id}`)),
  update: (id, body) => unwrap(http.patch(`/admin/customers/${id}`, body)),
};

// ─────────────────────────── analytics ───────────────────────────
export const analyticsApi = {
  ordersOverTime: (params) => unwrap(http.get('/admin/analytics/orders', { params: clean(params) })),
  topVendors: (params) => unwrap(http.get('/admin/analytics/top-vendors', { params: clean(params) })),
  topProducts: (params) => unwrap(http.get('/admin/analytics/top-products', { params: clean(params) })),
  agentLeaderboard: (params) => unwrap(http.get('/admin/analytics/agents', { params: clean(params) })),
  cancellationReasons: (params) => unwrap(http.get('/admin/analytics/cancellations', { params: clean(params) })),
};

// ─────────────────────────── settings ───────────────────────────
export const settingsApi = {
  get: () => unwrap(http.get('/admin/settings')),
  update: (body) => unwrap(http.patch('/admin/settings', body)),
};

// ─────────────────────────── uploads ───────────────────────────
export const uploadsApi = {
  image: (file, folder, replacesPublicId) => {
    const form = new FormData();
    form.append('image', file);
    form.append('folder', folder);
    if (replacesPublicId) form.append('replacesPublicId', replacesPublicId);
    return unwrap(http.post('/uploads/image', form, { timeout: 90_000 }));
  },
  remove: (publicId) => unwrap(http.delete(`/uploads/${encodeURIComponent(publicId)}`)),
};
