import { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { onSessionChange, session } from '../lib/api';
import { auth as authApi } from '../lib/services';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [state, setState] = useState(() => session.read());

  // The API client rewrites the session on refresh or clears it on a dead
  // token; mirror that here so every screen sees the same user.
  useEffect(() => onSessionChange((next) => setState(next)), []);

  // Pull a fresh profile on load: points and the default address change on
  // the server (a delivered order awards points) without the client knowing.
  useEffect(() => {
    if (!session.read()?.accessToken) return;
    authApi
      .me()
      .then((user) => {
        const current = session.read();
        if (current) session.write({ ...current, user });
      })
      .catch(() => {
        /* a 401 here already cleared the session via the interceptor */
      });
  }, []);

  const signIn = useCallback((data) => {
    session.write({ user: data.user, accessToken: data.accessToken, refreshToken: data.refreshToken });
  }, []);

  const login = useCallback(async (phone, password) => {
    const data = await authApi.login(phone, password);
    signIn(data);
    return data.user;
  }, [signIn]);

  const register = useCallback(async (fullName, phone, password) => {
    const data = await authApi.register(fullName, phone, password);
    signIn(data);
    return data.user;
  }, [signIn]);

  const logout = useCallback(async () => {
    const refreshToken = session.read()?.refreshToken;
    session.write(null);
    if (refreshToken) authApi.logout(refreshToken).catch(() => {});
  }, []);

  const setUser = useCallback((user) => {
    const current = session.read();
    if (current) session.write({ ...current, user: { ...current.user, ...user } });
  }, []);

  const refreshMe = useCallback(async () => {
    const user = await authApi.me();
    setUser(user);
    return user;
  }, [setUser]);

  const value = useMemo(
    () => ({
      user: state?.user ?? null,
      role: state?.user?.role ?? null,
      isAuthed: Boolean(state?.accessToken),
      login,
      register,
      logout,
      setUser,
      refreshMe,
    }),
    [state, login, register, logout, setUser, refreshMe],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  return useContext(AuthContext);
}

/** Where each role lands after signing in. */
export function homeFor(role) {
  if (role === 'agent') return '/driver';
  if (role === 'vendor') return '/portal';
  if (role === 'admin') return '/admin';
  return '/';
}
