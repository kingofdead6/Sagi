import { createContext, useCallback, useContext, useMemo, useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { Icon } from '../components/Icon';

const ToastContext = createContext(null);
let nextId = 1;

const TONES = {
  success: { icon: 'check', ring: 'bg-leaf text-white' },
  error: { icon: 'alert', ring: 'bg-tomato text-white' },
  info: { icon: 'bell', ring: 'bg-forest text-white' },
};

export function ToastProvider({ children }) {
  const [toasts, setToasts] = useState([]);

  const dismiss = useCallback((id) => setToasts((all) => all.filter((t) => t.id !== id)), []);

  const push = useCallback(
    (message, tone = 'info', ms = 3800) => {
      const id = nextId++;
      setToasts((all) => [...all.slice(-3), { id, message, tone }]);
      setTimeout(() => dismiss(id), ms);
    },
    [dismiss],
  );

  const api = useMemo(
    () => ({
      success: (m) => push(m, 'success'),
      error: (m) => push(m, 'error', 5200),
      info: (m) => push(m, 'info'),
    }),
    [push],
  );

  return (
    <ToastContext.Provider value={api}>
      {children}
      <div
        aria-live="polite"
        className="pointer-events-none fixed inset-x-0 bottom-24 z-[80] flex flex-col items-center gap-2 px-4 md:bottom-8"
      >
        <AnimatePresence initial={false}>
          {toasts.map((toast) => {
            const tone = TONES[toast.tone];
            return (
              <motion.button
                key={toast.id}
                layout
                type="button"
                onClick={() => dismiss(toast.id)}
                initial={{ opacity: 0, y: 24, scale: 0.9 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                exit={{ opacity: 0, y: 12, scale: 0.95, transition: { duration: 0.18 } }}
                transition={{ type: 'spring', stiffness: 420, damping: 30 }}
                className="pointer-events-auto flex max-w-md items-center gap-3 rounded-2xl bg-forest-deep/95 px-4 py-3 text-start text-sm font-bold text-white shadow-lift backdrop-blur"
              >
                <span className={`grid h-7 w-7 shrink-0 place-items-center rounded-full ${tone.ring}`}>
                  <Icon name={tone.icon} className="h-4 w-4" />
                </span>
                <span>{toast.message}</span>
              </motion.button>
            );
          })}
        </AnimatePresence>
      </div>
    </ToastContext.Provider>
  );
}

export function useToast() {
  return useContext(ToastContext);
}
