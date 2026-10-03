import { Link } from 'react-router-dom';
import { motion } from 'framer-motion';
import { Button } from '../components/ui';
import { useI18n } from '../state/i18n';

export default function NotFound() {
  const { t } = useI18n();
  return (
    <div className="container-x grid min-h-[60vh] place-items-center py-12 text-center">
      <div>
        <motion.div
          className="font-display text-[9rem] font-extrabold leading-none text-forest"
          initial={{ scale: 0.6, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ type: 'spring', stiffness: 160, damping: 12 }}
        >
          4
          <motion.span
            className="inline-block"
            animate={{ rotate: [0, 360] }}
            transition={{ duration: 3, repeat: Infinity, ease: 'linear' }}
          >
            🍊
          </motion.span>
          4
        </motion.div>
        <h1 className="mt-4 text-3xl font-extrabold">{t('notFound.title')}</h1>
        <p className="mt-2 text-ink-soft">{t('notFound.text')}</p>
        <Link to="/" className="mt-8 inline-block">
          <Button size="lg" icon="home">{t('notFound.home')}</Button>
        </Link>
      </div>
    </div>
  );
}
