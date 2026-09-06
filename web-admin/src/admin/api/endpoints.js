import { api } from './client';

const unwrap = (p) => p.then((r) => r.data.data);

// ─────────────────────────── auth ───────────────────────────
export const authApi = {
  login: (phone, password) => unwrap(api.post('/auth/login', { phone, password })),
  me: () => unwrap(api.get('/auth/me')),
  logout: (refreshToken) => unwrap(api.post('/auth/logout', { refreshToken })),
};

// ─────────────────────────── dashboard ───────────────────────────
export const dashboardApi = {
  stats: () => unwrap(api.get('/admin/stats')),
};

// ─────────────────────────── orders ───────────────────────────
export const ordersApi = {
  list: (params) => unwrap(api.get('/admin/orders', { params })),
  get: (id) => unwrap(api.get(`/admin/orders/${id}`)),
  setStatus: (id, status, note) => unwrap(api.patch(`/admin/orders/${id}/status`, { status, note })),
  assign: (id, agentId) => unwrap(api.post(`/admin/orders/${id}/assign`, { agentId })),
  exportUrl: (params) => {
    const q = new URLSearchParams(
      Object.entries(params || {}).filter(([, v]) => v !== undefined && v !== null && v !== ''),
    ).toString();
    return `${api.defaults.baseURL}/admin/orders/export${q ? `?${q}` : ''}`;
  },
  availableAgents: (vendorId) => unwrap(api.get('/admin/agents/available', { params: { vendorId } })),
  agentLocations: () => unwrap(api.get('/admin/agents/locations')),
};

// ─────────────────────────── categories ───────────────────────────
export const categoriesApi = {
  list: () => unwrap(api.get('/admin/categories')),
  create: (body) => unwrap(api.post('/admin/categories', body)),
  update: (id, body) => unwrap(api.patch(`/admin/categories/${id}`, body)),
  remove: (id) => unwrap(api.delete(`/admin/categories/${id}`)),
};

// ─────────────────────────── vendors ───────────────────────────
export const vendorsApi = {
  list: (params) => unwrap(api.get('/admin/vendors', { params })),
  get: (id) => unwrap(api.get(`/admin/vendors/${id}`)),
  create: (body) => unwrap(api.post('/admin/vendors', body)),
  update: (id, body) => unwrap(api.patch(`/admin/vendors/${id}`, body)),
  remove: (id) => unwrap(api.delete(`/admin/vendors/${id}`)),
  createAccount: (id, body) => unwrap(api.post(`/admin/vendors/${id}/account`, body)),
  removeAccount: (id) => unwrap(api.delete(`/admin/vendors/${id}/account`)),
  sections: (id) => unwrap(api.get(`/admin/vendors/${id}/sections`)),
  createSection: (id, body) => unwrap(api.post(`/admin/vendors/${id}/sections`, body)),
  updateSection: (sectionId, body) => unwrap(api.patch(`/admin/sections/${sectionId}`, body)),
  removeSection: (sectionId) => unwrap(api.delete(`/admin/sections/${sectionId}`)),
};

// ─────────────────────────── products ───────────────────────────
export const productsApi = {
  list: (params) => unwrap(api.get('/admin/products', { params })),
  create: (body) => unwrap(api.post('/admin/products', body)),
  update: (id, body) => unwrap(api.patch(`/admin/products/${id}`, body)),
  remove: (id) => unwrap(api.delete(`/admin/products/${id}`)),
  reorder: (items) => unwrap(api.post('/admin/products/reorder', { items })),
  setAvailability: (ids, isAvailable) =>
    unwrap(api.post('/admin/products/availability', { ids, isAvailable })),
};

// ─────────────────────────── offers ───────────────────────────
export const offersApi = {
  list: () => unwrap(api.get('/admin/offers')),
  create: (body) => unwrap(api.post('/admin/offers', body)),
  update: (id, body) => unwrap(api.patch(`/admin/offers/${id}`, body)),
  remove: (id) => unwrap(api.delete(`/admin/offers/${id}`)),
};

// ─────────────────────────── vouchers ───────────────────────────
export const vouchersApi = {
  list: () => unwrap(api.get('/admin/vouchers')),
  create: (body) => unwrap(api.post('/admin/vouchers', body)),
  update: (id, body) => unwrap(api.patch(`/admin/vouchers/${id}`, body)),
  remove: (id) => unwrap(api.delete(`/admin/vouchers/${id}`)),
};

// ─────────────────────────── agents ───────────────────────────
export const agentsApi = {
  list: (params) => unwrap(api.get('/admin/agents', { params })),
  create: (body) => unwrap(api.post('/admin/agents', body)),
  update: (id, body) => unwrap(api.patch(`/admin/agents/${id}`, body)),
  stats: (id, params) => unwrap(api.get(`/admin/agents/${id}/stats`, { params })),
};

// ─────────────────────────── customers ───────────────────────────
export const customersApi = {
  list: (params) => unwrap(api.get('/admin/customers', { params })),
  get: (id) => unwrap(api.get(`/admin/customers/${id}`)),
  update: (id, body) => unwrap(api.patch(`/admin/customers/${id}`, body)),
};

// ─────────────────────────── analytics ───────────────────────────
export const analyticsApi = {
  ordersOverTime: (params) => unwrap(api.get('/admin/analytics/orders', { params })),
  topVendors: (params) => unwrap(api.get('/admin/analytics/top-vendors', { params })),
  topProducts: (params) => unwrap(api.get('/admin/analytics/top-products', { params })),
  agentLeaderboard: (params) => unwrap(api.get('/admin/analytics/agents', { params })),
  cancellationReasons: (params) => unwrap(api.get('/admin/analytics/cancellations', { params })),
};

// ─────────────────────────── settings ───────────────────────────
export const settingsApi = {
  get: () => unwrap(api.get('/admin/settings')),
  update: (body) => unwrap(api.patch('/admin/settings', body)),
};

// ─────────────────────────── uploads ───────────────────────────
export const uploadsApi = {
  image: (file, folder, replacesPublicId) => {
    const form = new FormData();
    form.append('image', file);
    form.append('folder', folder);
    if (replacesPublicId) form.append('replacesPublicId', replacesPublicId);
    return unwrap(api.post('/uploads/image', form, { headers: { 'Content-Type': 'multipart/form-data' } }));
  },
  remove: (publicId) => unwrap(api.delete(`/uploads/${encodeURIComponent(publicId)}`)),
};
