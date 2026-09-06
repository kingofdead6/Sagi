import { useState } from 'react';
import { Navigate, useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '../auth/AuthContext';
import { apiErrorMessage } from '../api/client';
import { Button, ErrorBanner, Input, Spinner } from '../components/ui';

export default function LoginPage() {
  const { user, login } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState(null);
  const [busy, setBusy] = useState(false);

  if (user) {
    const from = location.state?.from?.pathname || '/';
    return <Navigate to={from} replace />;
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setError(null);
    setBusy(true);
    try {
      await login(phone, password);
      navigate(location.state?.from?.pathname || '/', { replace: true });
    } catch (err) {
      setError(err.message === 'هذا الحساب ليس حساب مدير' ? err.message : apiErrorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-canvas px-4">
      <div className="w-full max-w-sm rounded-2xl bg-white p-8 shadow-xl ring-1 ring-black/5">
        <div className="mb-6 flex flex-col items-center gap-2">
          <img src="./assets/logo-mark.png" alt="ساجي" className="h-14 w-14 rounded-xl object-contain" />
          <h1 className="text-xl font-black">دخول لوحة التحكم</h1>
          <p className="text-sm text-ink-muted">للمدراء فقط</p>
        </div>

        <form className="space-y-4" onSubmit={handleSubmit}>
          <Input
            label="رقم الهاتف"
            type="tel"
            inputMode="tel"
            placeholder="05xxxxxxxx"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            required
            autoFocus
          />
          <Input
            label="كلمة المرور"
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />

          <ErrorBanner message={error} />

          <Button type="submit" className="w-full" disabled={busy}>
            {busy ? <Spinner className="h-4 w-4" /> : 'تسجيل الدخول'}
          </Button>
        </form>
      </div>
    </div>
  );
}
