import axios from 'axios';

export const API_URL = (import.meta.env.VITE_API_URL || 'https://sagi-h2du.onrender.com').replace(/\/$/, '');
export const ADMIN_URL = import.meta.env.VITE_ADMIN_URL || 'http://localhost:5174';
const PREFIX = '/api/v1';

const SESSION_KEY = 'saji.session';

/** The persisted session: `{ user, accessToken, refreshToken }`, or null. */
export const session = {
  read() {
    try {
      return JSON.parse(localStorage.getItem(SESSION_KEY) || 'null');
    } catch {
      return null;
    }
  },
  write(value) {
    try {
      if (value) localStorage.setItem(SESSION_KEY, JSON.stringify(value));
      else localStorage.removeItem(SESSION_KEY);
    } catch {
      /* private mode: the session simply lives for this tab only */
    }
    listeners.forEach((fn) => fn(value));
  },
};

const listeners = new Set();
export function onSessionChange(fn) {
  listeners.add(fn);
  return () => listeners.delete(fn);
}

export const http = axios.create({
  baseURL: API_URL + PREFIX,
  // Free Render instances sleep when idle; the first request can take ~30s.
  timeout: 45_000,
});

http.interceptors.request.use((config) => {
  const token = session.read()?.accessToken;
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

/**
 * One refresh at a time. The server rotates refresh tokens and treats a reused
 * one as theft — revoking the whole family — so two parallel 401s must share a
 * single refresh rather than each spending the same token.
 */
let refreshing = null;

async function refreshSession() {
  const current = session.read();
  if (!current?.refreshToken) throw new Error('no refresh token');
  const { data } = await axios.post(`${API_URL}${PREFIX}/auth/refresh`, {
    refreshToken: current.refreshToken,
  });
  const next = {
    user: data.data.user,
    accessToken: data.data.accessToken,
    refreshToken: data.data.refreshToken,
  };
  session.write(next);
  return next;
}

http.interceptors.response.use(
  (response) => response,
  async (error) => {
    const original = error.config;
    const status = error.response?.status;
    const isAuthCall = original?.url?.startsWith('/auth/');
    if (status === 401 && original && !original._retried && !isAuthCall && session.read()?.refreshToken) {
      original._retried = true;
      try {
        refreshing ??= refreshSession().finally(() => {
          refreshing = null;
        });
        const fresh = await refreshing;
        original.headers.Authorization = `Bearer ${fresh.accessToken}`;
        return http(original);
      } catch {
        session.write(null);
      }
    }
    return Promise.reject(error);
  },
);

/** Unwraps the `{ success, data }` envelope every endpoint returns. */
async function call(promise) {
  const { data } = await promise;
  return data.data;
}

export const api = {
  get: (url, params) => call(http.get(url, { params })),
  post: (url, body) => call(http.post(url, body)),
  patch: (url, body) => call(http.patch(url, body)),
  del: (url, body) => call(http.delete(url, { data: body })),
  upload: (url, form) => call(http.post(url, form, { timeout: 90_000 })),
};

/**
 * A readable message for a failed request. The server's own messages are in
 * Arabic, so they are shown as-is for Arabic readers; other languages get a
 * translated message chosen by the error code.
 */
export function errorInfo(error) {
  const body = error?.response?.data;
  if (!error?.response) {
    return { code: error?.code === 'ECONNABORTED' ? 'TIMEOUT' : 'NETWORK', message: null, details: [] };
  }
  return {
    code: body?.code || 'INTERNAL',
    message: body?.message || null,
    details: Array.isArray(body?.details) ? body.details : [],
    status: error.response.status,
  };
}
