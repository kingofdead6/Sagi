import axios from 'axios';

// Same hosted backend the mobile app talks to by default (see
// app/lib/core/network/api_endpoints.dart). Override with VITE_API_URL for
// local development against a backend running on localhost.
const HOSTED_API_URL = 'https://sagi-h2du.onrender.com/api/v1';
const API_URL = import.meta.env.VITE_API_URL || HOSTED_API_URL;

const ACCESS_KEY = 'saji_admin_access';
const REFRESH_KEY = 'saji_admin_refresh';

export function getTokens() {
  return {
    accessToken: localStorage.getItem(ACCESS_KEY),
    refreshToken: localStorage.getItem(REFRESH_KEY),
  };
}

export function setTokens({ accessToken, refreshToken }) {
  if (accessToken) localStorage.setItem(ACCESS_KEY, accessToken);
  if (refreshToken) localStorage.setItem(REFRESH_KEY, refreshToken);
}

export function clearTokens() {
  localStorage.removeItem(ACCESS_KEY);
  localStorage.removeItem(REFRESH_KEY);
}

export const api = axios.create({ baseURL: API_URL });

api.interceptors.request.use((config) => {
  const { accessToken } = getTokens();
  if (accessToken) config.headers.Authorization = `Bearer ${accessToken}`;
  return config;
});

let refreshPromise = null;

api.interceptors.response.use(
  (res) => res,
  async (error) => {
    const original = error.config;
    if (error.response?.status === 401 && !original._retry) {
      original._retry = true;
      const { refreshToken } = getTokens();
      if (!refreshToken) {
        clearTokens();
        return Promise.reject(error);
      }
      try {
        refreshPromise =
          refreshPromise ??
          axios.post(`${API_URL}/auth/refresh`, { refreshToken }).then((r) => r.data.data);
        const data = await refreshPromise;
        refreshPromise = null;
        setTokens({ accessToken: data.accessToken, refreshToken: data.refreshToken });
        original.headers.Authorization = `Bearer ${data.accessToken}`;
        return api(original);
      } catch (refreshErr) {
        refreshPromise = null;
        clearTokens();
        window.location.href = '/login';
        return Promise.reject(refreshErr);
      }
    }
    return Promise.reject(error);
  },
);

export function apiErrorMessage(err) {
  const data = err?.response?.data;
  const detail = Array.isArray(data?.details) && data.details[0]?.message;
  return detail || data?.message || err?.message || 'حدث خطأ غير متوقع';
}
