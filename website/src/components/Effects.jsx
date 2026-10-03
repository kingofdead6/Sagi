import { useEffect, useRef, useState } from 'react';
import { animate, motion, useMotionValue, useTransform } from 'framer-motion';
import { Icon } from './Icon';
import { useI18n } from '../state/i18n';
import { STEPS, stepIndex } from '../lib/orderStatus';

/** A one-shot confetti burst in the brand palette. No dependency, ~2.5s. */
export function Confetti({ fire = true }) {
  const ref = useRef(null);
  useEffect(() => {
    if (!fire || window.matchMedia('(prefers-reduced-motion: reduce)').matches) return undefined;
    const canvas = ref.current;
    const ctx = canvas.getContext('2d');
    const dpr = window.devicePixelRatio || 1;
    const resize = () => {
      canvas.width = window.innerWidth * dpr;
      canvas.height = window.innerHeight * dpr;
    };
    resize();
    const colors = ['#0E4D2B', '#5BB22F', '#7ACB45', '#F27A1A', '#E2402F', '#FFD24A'];
    const pieces = Array.from({ length: 160 }, (_, i) => {
      const fromLeft = i % 2 === 0;
      return {
        x: (fromLeft ? 0.1 : 0.9) * canvas.width,
        y: canvas.height * 0.7,
        vx: (fromLeft ? 1 : -1) * (6 + Math.random() * 10) * dpr,
        vy: -(14 + Math.random() * 12) * dpr,
        r: (4 + Math.random() * 6) * dpr,
        rot: Math.random() * Math.PI,
        vr: (Math.random() - 0.5) * 0.4,
        color: colors[i % colors.length],
        shape: i % 3,
      };
    });
    let raf;
    const t0 = performance.now();
    const tick = (now) => {
      const life = (now - t0) / 2600;
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      for (const p of pieces) {
        p.vy += 0.42 * dpr;
        p.vx *= 0.985;
        p.x += p.vx;
        p.y += p.vy;
        p.rot += p.vr;
        ctx.save();
        ctx.globalAlpha = Math.max(0, 1 - life);
        ctx.translate(p.x, p.y);
        ctx.rotate(p.rot);
        ctx.fillStyle = p.color;
        if (p.shape === 0) ctx.fillRect(-p.r, -p.r / 2, p.r * 2, p.r);
        else if (p.shape === 1) {
          ctx.beginPath();
          ctx.arc(0, 0, p.r / 1.4, 0, Math.PI * 2);
          ctx.fill();
        } else {
          // a little leaf, after the logo
          ctx.beginPath();
          ctx.ellipse(0, 0, p.r, p.r / 2.4, 0, 0, Math.PI * 2);
          ctx.fill();
        }
        ctx.restore();
      }
      if (life < 1) raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);
    window.addEventListener('resize', resize);
    return () => {
      cancelAnimationFrame(raf);
      window.removeEventListener('resize', resize);
    };
  }, [fire]);
  return <canvas ref={ref} aria-hidden="true" className="pointer-events-none fixed inset-0 z-[95] h-full w-full" />;
}

/** The success check: a circle that fills, then a tick that draws itself. */
export function DrawnCheck({ size = 120 }) {
  return (
    <motion.svg width={size} height={size} viewBox="0 0 120 120" initial="hidden" animate="show">
      <motion.circle
        cx="60" cy="60" r="54" fill="#5BB22F"
        variants={{ hidden: { scale: 0 }, show: { scale: 1, transition: { type: 'spring', stiffness: 200, damping: 12 } } }}
        style={{ originX: '50%', originY: '50%' }}
      />
      <motion.circle
        cx="60" cy="60" r="54" fill="none" stroke="#7ACB45" strokeWidth="4"
        variants={{ hidden: { scale: 1, opacity: 0.8 }, show: { scale: 1.5, opacity: 0, transition: { delay: 0.3, duration: 1, repeat: Infinity, repeatDelay: 0.6 } } }}
        style={{ originX: '50%', originY: '50%' }}
      />
      <motion.path
        d="M36 62 L52 78 L86 44" fill="none" stroke="white" strokeWidth="10" strokeLinecap="round" strokeLinejoin="round"
        variants={{ hidden: { pathLength: 0 }, show: { pathLength: 1, transition: { delay: 0.35, duration: 0.5, ease: 'easeOut' } } }}
      />
    </motion.svg>
  );
}

const STEP_ICONS = ['receipt', 'check', 'flame', 'bike', 'home'];

/**
 * The five-step customer tracker. The line fills to the current step and a
 * scooter rides its leading edge; the active step pulses.
 */
export function StatusStepper({ status }) {
  const { t, isRtl } = useI18n();
  const cancelled = status === 'cancelled';
  const current = cancelled ? -1 : stepIndex(status);
  const pct = cancelled ? 0 : (current / (STEPS.length - 1)) * 100;
  return (
    <div className="relative px-2 pt-8">
      <div className="absolute inset-x-8 top-[3.25rem] h-1.5 rounded-full bg-ink/10" />
      <div className="absolute inset-x-8 top-[3.25rem] h-1.5">
        <motion.div
          className={`h-full rounded-full bg-gradient-to-r from-leaf to-forest ${isRtl ? 'ms-auto bg-gradient-to-l' : ''}`}
          initial={{ width: 0 }}
          animate={{ width: `${pct}%` }}
          transition={{ type: 'spring', stiffness: 60, damping: 18 }}
        />
        {!cancelled && current < STEPS.length - 1 && (
          <motion.div
            className="absolute -top-8"
            initial={{ [isRtl ? 'right' : 'left']: '0%' }}
            animate={{ [isRtl ? 'right' : 'left']: `${pct}%` }}
            transition={{ type: 'spring', stiffness: 60, damping: 18 }}
            style={{ x: isRtl ? '50%' : '-50%' }}
          >
            <motion.span
              animate={{ y: [0, -3, 0], rotate: [0, -3, 0] }}
              transition={{ duration: 0.6, repeat: Infinity }}
              className={`block text-2xl ${isRtl ? '' : '-scale-x-100'}`}
            >
              🛵
            </motion.span>
          </motion.div>
        )}
      </div>
      <ol className="relative flex justify-between">
        {STEPS.map((step, i) => {
          const done = i < current;
          const active = i === current;
          return (
            <li key={step} className="flex w-16 flex-col items-center gap-2 text-center">
              <motion.span
                initial={false}
                animate={{ scale: active ? 1.15 : 1 }}
                className={`relative grid h-11 w-11 place-items-center rounded-full ring-4 ring-white transition-colors duration-500 ${
                  done ? 'bg-forest text-white' : active ? 'bg-leaf text-white' : 'bg-white text-ink/30'
                }`}
              >
                {active && <span className="absolute inset-0 animate-ping2 rounded-full bg-leaf/50" />}
                <Icon name={done ? 'check' : STEP_ICONS[i]} className="relative h-5 w-5" strokeWidth={2.4} />
              </motion.span>
              <span className={`text-xs font-bold leading-tight ${done || active ? 'text-forest' : 'text-ink-muted'}`}>
                {t(`steps.${step}`)}
              </span>
            </li>
          );
        })}
      </ol>
    </div>
  );
}

/** A draining ring for time-boxed agent offers. */
export function CountdownRing({ expiresAt, totalSec, size = 64, onExpire }) {
  const [left, setLeft] = useState(() => Math.max(0, (new Date(expiresAt) - Date.now()) / 1000));
  useEffect(() => {
    const id = setInterval(() => {
      const s = Math.max(0, (new Date(expiresAt) - Date.now()) / 1000);
      setLeft(s);
      if (s <= 0) {
        clearInterval(id);
        onExpire?.();
      }
    }, 250);
    return () => clearInterval(id);
  }, [expiresAt]); // eslint-disable-line react-hooks/exhaustive-deps
  const total = Math.max(1, totalSec || 60);
  const frac = Math.min(1, left / total);
  const r = size / 2 - 5;
  const c = 2 * Math.PI * r;
  const urgent = left < 10;
  return (
    <div className="relative grid place-items-center" style={{ width: size, height: size }}>
      <svg width={size} height={size} className="-rotate-90">
        <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke="currentColor" strokeOpacity=".12" strokeWidth="6" />
        <circle
          cx={size / 2} cy={size / 2} r={r} fill="none"
          stroke={urgent ? '#E2402F' : '#5BB22F'} strokeWidth="6" strokeLinecap="round"
          strokeDasharray={c} strokeDashoffset={c * (1 - frac)}
          style={{ transition: 'stroke-dashoffset .25s linear, stroke .3s' }}
        />
      </svg>
      <motion.span
        animate={urgent ? { scale: [1, 1.15, 1] } : { scale: 1 }}
        transition={{ duration: 0.5, repeat: urgent ? Infinity : 0 }}
        className={`num absolute font-display text-lg font-bold ${urgent ? 'text-tomato' : 'text-forest'}`}
      >
        {Math.ceil(left)}
      </motion.span>
    </div>
  );
}

/**
 * Drag the knob to the far end to confirm — the web twin of the app's swipe
 * control, so a status change can't happen by an accidental tap.
 */
export function SlideToConfirm({ label, onConfirm, disabled, tone = 'forest' }) {
  const { isRtl } = useI18n();
  const track = useRef(null);
  const x = useMotionValue(0);
  const [max, setMax] = useState(240);
  const [busy, setBusy] = useState(false);
  const dir = isRtl ? -1 : 1;
  const fill = useTransform(x, (v) => `${Math.min(100, ((Math.abs(v) + 56) / (max + 56)) * 100)}%`);
  const textOpacity = useTransform(x, (v) => 1 - Math.min(1, Math.abs(v) / (max * 0.6)));

  useEffect(() => {
    const measure = () => track.current && setMax(track.current.offsetWidth - 64);
    measure();
    window.addEventListener('resize', measure);
    return () => window.removeEventListener('resize', measure);
  }, []);

  const end = async () => {
    if (Math.abs(x.get()) > max * 0.85 && !busy) {
      animate(x, dir * max, { type: 'spring', stiffness: 400, damping: 30 });
      setBusy(true);
      try {
        await onConfirm();
      } finally {
        setBusy(false);
        animate(x, 0, { type: 'spring', stiffness: 300, damping: 26 });
      }
    } else {
      animate(x, 0, { type: 'spring', stiffness: 500, damping: 30 });
    }
  };

  const bg = tone === 'accent' ? 'bg-tangerine' : 'bg-forest';
  return (
    <div ref={track} className={`relative h-16 select-none overflow-hidden rounded-full ${disabled ? 'opacity-50' : ''} bg-forest/10`}>
      <motion.div style={{ width: fill }} className={`absolute inset-y-0 start-0 rounded-full ${bg} opacity-90`} />
      <motion.span style={{ opacity: textOpacity }} className="absolute inset-0 grid place-items-center px-16 text-center font-bold text-forest">
        <span className="flex items-center gap-2">
          {label}
          <motion.span animate={{ x: [0, 6 * dir, 0] }} transition={{ duration: 1.2, repeat: Infinity }}>
            <Icon name="arrow" className="h-4 w-4" />
          </motion.span>
        </span>
      </motion.span>
      <motion.button
        type="button"
        drag={disabled || busy ? false : 'x'}
        dragConstraints={isRtl ? { left: -max, right: 0 } : { left: 0, right: max }}
        dragElastic={0.04}
        dragMomentum={false}
        style={{ x }}
        onDragEnd={end}
        aria-label={label}
        onKeyDown={(e) => e.key === 'Enter' && !disabled && !busy && onConfirm()}
        className={`absolute start-1 top-1 grid h-14 w-14 cursor-grab place-items-center rounded-full ${bg} text-white shadow-lift active:cursor-grabbing`}
      >
        {busy ? (
          <motion.span animate={{ rotate: 360 }} transition={{ repeat: Infinity, duration: 0.8, ease: 'linear' }}>
            <Icon name="refresh" />
          </motion.span>
        ) : (
          <Icon name="arrow" className="h-6 w-6" />
        )}
      </motion.button>
    </div>
  );
}
