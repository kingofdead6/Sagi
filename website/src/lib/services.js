import { api } from './api';

/** Every server call, grouped the way the app groups its repositories. */

export const auth = {
  login: (phone, password) => api.post('/auth/login', { phone, password }),
  register: (fullName, phone, password) => api.post('/auth/register', { fullName, phone, password }),
  logout: (refreshToken) => api.post('/auth/logout', { refreshToken }),
  me: () => api.get('/auth/me'),
  updateMe: (body) => api.patch('/auth/me', body),
  changePassword: (currentPassword, newPassword) =>
    api.post('/auth/change-password', { currentPassword, newPassword }),
};

export const catalog = {
  categories: () => api.get('/categories'),
  homeOffers: () => api.get('/offers/home'),
  /** `query`: { category, search, lat, lng, sort, openNow, hasOffer, page, limit } */
  vendors: (query) => api.get('/vendors', clean(query)),
  vendor: (id, origin) => api.get(`/vendors/${id}`, origin ? { lat: origin.lat, lng: origin.lng } : undefined),
  menu: (id) => api.get(`/vendors/${id}/menu`),
  product: (id) => api.get(`/products/${id}`),
};

export const addresses = {
  list: () => api.get('/addresses'),
  create: (body) => api.post('/addresses', body),
  update: (id, body) => api.patch(`/addresses/${id}`, body),
  setDefault: (id) => api.patch(`/addresses/${id}/default`),
  remove: (id) => api.del(`/addresses/${id}`),
};

export const orders = {
  quote: (body) => api.post('/orders/quote', body),
  create: (body) => api.post('/orders', body),
  list: (query) => api.get('/orders', clean(query)),
  reorderable: (page = 1) => api.get('/orders/reorderable', { page, limit: 20 }),
  get: (id) => api.get(`/orders/${id}`),
  cancel: (id, reason) => api.patch(`/orders/${id}/cancel`, { reason }),
  rate: (id, body) => api.post(`/orders/${id}/rating`, body),
};

export const vouchers = {
  mine: () => api.get('/vouchers/mine'),
  validate: (code, subtotalCentimes, deliveryFeeCentimes) =>
    api.post('/vouchers/validate', { code, subtotalCentimes, deliveryFeeCentimes }),
};

export const agent = {
  status: () => api.get('/agent/me/status'),
  setOnline: (isOnline) => api.patch('/agent/status', { isOnline }),
  offers: () => api.get('/agent/offers'),
  accept: (orderId) => api.post(`/agent/offers/${orderId}/accept`),
  reject: (orderId, reason) => api.post(`/agent/offers/${orderId}/reject`, { reason }),
  active: () => api.get('/agent/orders/active'),
  setStatus: (orderId, status, extra = {}) => api.patch(`/agent/orders/${orderId}/status`, { status, ...extra }),
  history: (query) => api.get('/agent/orders/history', clean(query)),
  stats: (query) => api.get('/agent/stats', clean(query)),
  location: (point) => api.post('/agent/location', point),
};

export const portal = {
  me: () => api.get('/portal/me'),
  setOpen: (isOpen) => api.patch('/portal/me', { isOpen }),
  sections: () => api.get('/portal/sections'),
  createSection: (body) => api.post('/portal/sections', body),
  updateSection: (id, body) => api.patch(`/portal/sections/${id}`, body),
  deleteSection: (id) => api.del(`/portal/sections/${id}`),
  products: () => api.get('/portal/products'),
  createProduct: (body) => api.post('/portal/products', body),
  updateProduct: (id, body) => api.patch(`/portal/products/${id}`, body),
  deleteProduct: (id) => api.del(`/portal/products/${id}`),
  reorderProducts: (items) => api.post('/portal/products/reorder', { items }),
};

export const uploads = {
  /** Shop owners may only upload into `products`; the server enforces it. */
  image(file, { folder = 'products', replacesPublicId } = {}) {
    const form = new FormData();
    form.append('image', file);
    form.append('folder', folder);
    if (replacesPublicId) form.append('replacesPublicId', replacesPublicId);
    return api.upload('/uploads/image', form);
  },
};

/** Drops undefined/null/'' so they never reach the query string. */
function clean(query = {}) {
  return Object.fromEntries(
    Object.entries(query).filter(([, v]) => v !== undefined && v !== null && v !== '' && v !== false),
  );
}
