import { useNavigate } from 'react-router-dom';
import { useAuth } from '../state/auth';
import { useI18n } from '../state/i18n';
import { useToast } from '../state/toast';
import { useSocketEvent } from '../lib/socket';

const PREFS_KEY = 'saji.notif';

export function readPrefs() {
  try {
    return { orders: true, sound: true, ...JSON.parse(localStorage.getItem(PREFS_KEY) || '{}') };
  } catch {
    return { orders: true, sound: true };
  }
}

export function writePrefs(prefs) {
  try {
    localStorage.setItem(PREFS_KEY, JSON.stringify(prefs));
  } catch {
    /* fine */
  }
}

/** A short two-note chime from WebAudio — no sound file to ship. */
export function chime() {
  try {
    const ctx = new (window.AudioContext || window.webkitAudioContext)();
    [880, 1320].forEach((freq, i) => {
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.frequency.value = freq;
      osc.type = 'sine';
      gain.gain.setValueAtTime(0.0001, ctx.currentTime + i * 0.16);
      gain.gain.exponentialRampToValueAtTime(0.25, ctx.currentTime + i * 0.16 + 0.02);
      gain.gain.exponentialRampToValueAtTime(0.0001, ctx.currentTime + i * 0.16 + 0.3);
      osc.connect(gain).connect(ctx.destination);
      osc.start(ctx.currentTime + i * 0.16);
      osc.stop(ctx.currentTime + i * 0.16 + 0.32);
    });
    setTimeout(() => ctx.close(), 800);
  } catch {
    /* audio blocked until the first user gesture — the toast still shows */
  }
}

function systemNotify(title, body, onClick) {
  if (!('Notification' in window) || Notification.permission !== 'granted') return;
  if (document.visibilityState === 'visible') return; // the toast covers it
  try {
    const n = new Notification(title, { body, icon: '/favicon.png', tag: title });
    n.onclick = () => {
      window.focus();
      onClick?.();
      n.close();
    };
  } catch {
    /* some browsers only allow notifications from a service worker */
  }
}

/** Lives for the whole app: turns socket events into toasts and notifications. */
export function OrderNotifier() {
  const { role, isAuthed } = useAuth();
  const { t } = useI18n();
  const toast = useToast();
  const navigate = useNavigate();

  useSocketEvent(
    'order:status',
    (p) => {
      if (!isAuthed || role !== 'customer' || !p?.to) return;
      const prefs = readPrefs();
      if (!prefs.orders) return;
      const title = t('orders.notifTitle', { code: p.code });
      const body = t(`status.${p.to}`);
      toast.info(`${title} — ${body}`);
      if (prefs.sound) chime();
      systemNotify(title, body, () => navigate(`/orders/${p.orderId}`));
    },
    [role, isAuthed, t],
  );

  useSocketEvent(
    'order:assigned',
    (p) => {
      if (role !== 'agent') return;
      const prefs = readPrefs();
      toast.info(t('driver.newOffer'));
      if (prefs.sound) chime();
      systemNotify(t('driver.newOffer'), p?.order?.vendor?.name ?? '', () => navigate('/driver'));
    },
    [role, t],
  );

  return null;
}
