import { useState } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { AnimatePresence, motion } from 'framer-motion';
import { Icon } from '../components/Icon';
import { Button, Field, Input } from '../components/ui';
import { homeFor, useAuth } from '../state/auth';
import { useI18n } from '../state/i18n';
import { useToast } from '../state/toast';
import { errorInfo } from '../lib/api';
import { isValidPhone } from '../lib/format';

function BrandPanel() {
  const { t } = useI18n();
  const bubbles = ['🍔', '🥕', '🍎', '🥖', '🛒', '🍰', '🥩', '🍊'];
  return (
    <div className="relative hidden overflow-hidden rounded-[2.5rem] bg-forest p-10 text-white lg:flex lg:flex-col lg:justify-between">
      <div aria-hidden="true" className="absolute inset-0">
        {bubbles.map((b, i) => (
          <motion.span
            key={b}
            className="absolute text-4xl"
            style={{ left: `${8 + ((i * 37) % 84)}%`, top: `${10 + ((i * 53) % 78)}%` }}
            animate={{ y: [0, -24, 0], rotate: [0, i % 2 ? 15 : -15, 0], opacity: [0.35, 0.8, 0.35] }}
            transition={{ duration: 5 + (i % 4), repeat: Infinity, delay: i * 0.4, ease: 'easeInOut' }}
          >
            {b}
          </motion.span>
        ))}
        <div className="absolute -bottom-40 -end-40 h-96 w-96 rounded-full bg-leaf/30 blur-3xl" />
      </div>
      <motion.div initial={{ opacity: 0, y: -20 }} animate={{ opacity: 1, y: 0 }} className="relative w-fit rounded-3xl bg-cream p-3">
        <img src="/brand/logo-mark.png" alt="Saji" className="h-20 mix-blend-multiply" />
      </motion.div>
      <div className="relative">
        <motion.h2
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2, duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
          className="font-display text-6xl font-extrabold leading-none"
        >
          {t('auth.sideTitle')}
        </motion.h2>
        <motion.p initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.4 }} className="mt-4 max-w-sm text-lg text-white/80">
          {t('auth.sideText')}
        </motion.p>
      </div>
    </div>
  );
}

function PasswordInput({ value, onChange, invalid, autoComplete }) {
  const { t } = useI18n();
  const [show, setShow] = useState(false);
  return (
    <div className="relative">
      <Input type={show ? 'text' : 'password'} value={value} onChange={onChange} invalid={invalid} autoComplete={autoComplete} className="pe-12" />
      <button
        type="button"
        onClick={() => setShow((s) => !s)}
        aria-label={show ? t('auth.hide') : t('auth.show')}
        className="absolute end-3 top-1/2 grid h-8 w-8 -translate-y-1/2 place-items-center rounded-full text-ink-muted hover:bg-ink/5"
      >
        <Icon name={show ? 'eyeOff' : 'eye'} className="h-5 w-5" />
      </button>
    </div>
  );
}

function Shell({ title, text, children }) {
  return (
    <div className="container-x grid min-h-[80vh] gap-8 py-6 lg:grid-cols-2">
      <BrandPanel />
      <div className="flex items-center justify-center">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, ease: [0.16, 1, 0.3, 1] }}
          className="w-full max-w-md"
        >
          <h1 className="text-4xl font-extrabold md:text-5xl">{title}</h1>
          <p className="mt-2 text-lg text-ink-soft">{text}</p>
          <div className="mt-8">{children}</div>
        </motion.div>
      </div>
    </div>
  );
}

function useAfterAuth() {
  const navigate = useNavigate();
  const location = useLocation();
  return (user) => {
    const from = location.state?.from;
    // Only a customer resumes where they were (checkout, an order); staff go to their hub.
    navigate(user.role === 'customer' && from ? from : homeFor(user.role), { replace: true });
  };
}

function FormError({ message }) {
  return (
    <AnimatePresence>
      {message && (
        <motion.p
          initial={{ opacity: 0, height: 0 }}
          animate={{ opacity: 1, height: 'auto', x: [0, -8, 8, -4, 4, 0] }}
          exit={{ opacity: 0, height: 0 }}
          className="flex items-center gap-2 rounded-2xl bg-red-50 p-3 text-sm font-bold text-tomato"
        >
          <Icon name="alert" className="h-5 w-5 shrink-0" />
          {message}
        </motion.p>
      )}
    </AnimatePresence>
  );
}

export function Login() {
  const { t, lang, errorText } = useI18n();
  const { login } = useAuth();
  const done = useAfterAuth();
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [tried, setTried] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);
  const phoneOk = isValidPhone(phone);

  const submit = async (e) => {
    e.preventDefault();
    setTried(true);
    if (!phoneOk || !password) return;
    setBusy(true);
    setError(null);
    try {
      done(await login(phone, password));
    } catch (err) {
      const info = errorInfo(err);
      setError(info.code === 'UNAUTHORIZED' && lang !== 'ar' ? t('auth.wrongCredentials') : errorText(err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <Shell title={t('auth.loginTitle')} text={t('auth.loginText')}>
      <form onSubmit={submit} className="space-y-4" noValidate>
        <Field label={t('auth.phone')} error={tried && !phoneOk ? t('auth.invalidPhone') : null}>
          <Input type="tel" inputMode="tel" value={phone} onChange={(e) => setPhone(e.target.value)} placeholder={t('auth.phonePlaceholder')} className="num" invalid={tried && !phoneOk} autoComplete="tel" dir="ltr" />
        </Field>
        <Field label={t('auth.password')}>
          <PasswordInput value={password} onChange={(e) => setPassword(e.target.value)} invalid={tried && !password} autoComplete="current-password" />
        </Field>
        <FormError message={error} />
        <Button type="submit" size="lg" className="w-full" loading={busy} iconEnd="arrow">{t('auth.login')}</Button>
      </form>
      <p className="mt-6 text-center text-ink-soft">
        {t('auth.noAccount')}{' '}
        <Link to="/register" className="font-bold text-forest hover:underline">{t('auth.register')}</Link>
      </p>
    </Shell>
  );
}

export function Register() {
  const { t, lang, errorText } = useI18n();
  const { register } = useAuth();
  const done = useAfterAuth();
  const toast = useToast();
  const [form, setForm] = useState({ fullName: '', phone: '', password: '' });
  const [tried, setTried] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);
  const errors = {
    fullName: form.fullName.trim().length < 2 ? t('auth.shortName') : null,
    phone: !isValidPhone(form.phone) ? t('auth.invalidPhone') : null,
    password: form.password.length < 6 ? t('auth.shortPassword') : null,
  };
  const set = (k) => (e) => setForm((f) => ({ ...f, [k]: e.target.value }));

  const submit = async (e) => {
    e.preventDefault();
    setTried(true);
    if (Object.values(errors).some(Boolean)) return;
    setBusy(true);
    setError(null);
    try {
      const user = await register(form.fullName.trim(), form.phone, form.password);
      toast.success(t('account.hello', { name: user.fullName }));
      done(user);
    } catch (err) {
      const info = errorInfo(err);
      setError(info.code === 'CONFLICT' && lang !== 'ar' ? t('auth.phoneTaken') : errorText(err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <Shell title={t('auth.registerTitle')} text={t('auth.registerText')}>
      <form onSubmit={submit} className="space-y-4" noValidate>
        <Field label={t('auth.fullName')} error={tried && errors.fullName}>
          <Input value={form.fullName} onChange={set('fullName')} invalid={tried && errors.fullName} autoComplete="name" maxLength={80} />
        </Field>
        <Field label={t('auth.phone')} error={tried && errors.phone}>
          <Input type="tel" inputMode="tel" value={form.phone} onChange={set('phone')} placeholder={t('auth.phonePlaceholder')} className="num" invalid={tried && errors.phone} autoComplete="tel" dir="ltr" />
        </Field>
        <Field label={t('auth.password')} error={tried && errors.password}>
          <PasswordInput value={form.password} onChange={set('password')} invalid={tried && errors.password} autoComplete="new-password" />
        </Field>
        <FormError message={error} />
        <Button type="submit" size="lg" className="w-full" loading={busy} iconEnd="arrow">{t('auth.register')}</Button>
      </form>
      <p className="mt-6 text-center text-ink-soft">
        {t('auth.haveAccount')}{' '}
        <Link to="/login" className="font-bold text-forest hover:underline">{t('auth.login')}</Link>
      </p>
    </Shell>
  );
}
