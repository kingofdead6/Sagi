import { createContext, useCallback, useContext, useEffect, useState } from 'react';
import { clearTokens, getTokens, setTokens } from '../api/client';
import { authApi } from '../api/endpoints';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const loadMe = useCallback(async () => {
    const { accessToken } = getTokens();
    if (!accessToken) {
      setLoading(false);
      return;
    }
    try {
      const me = await authApi.me();
      if (me.role !== 'admin') {
        clearTokens();
        setUser(null);
      } else {
        setUser(me);
      }
    } catch {
      clearTokens();
      setUser(null);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadMe();
  }, [loadMe]);

  const login = useCallback(async (phone, password) => {
    setError(null);
    const result = await authApi.login(phone, password);
    if (result.user?.role !== 'admin') {
      throw new Error('هذا الحساب ليس حساب مدير');
    }
    setTokens({ accessToken: result.accessToken, refreshToken: result.refreshToken });
    setUser(result.user);
    return result.user;
  }, []);

  const logout = useCallback(async () => {
    const { refreshToken } = getTokens();
    try {
      if (refreshToken) await authApi.logout(refreshToken);
    } catch {
      // ignore — clearing local tokens is what actually matters
    }
    clearTokens();
    setUser(null);
  }, []);

  return (
    <AuthContext.Provider value={{ user, loading, error, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within AuthProvider');
  return ctx;
}
