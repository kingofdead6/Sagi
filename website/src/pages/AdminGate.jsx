import { motion } from 'framer-motion';
import { Icon } from '../components/Icon';
import { Button } from '../components/ui';
import { useI18n } from '../state/i18n';
import { ADMIN_URL } from '../lib/api';

/**
 * Admins have a full dedicated panel (web-admin). Rather than duplicate it,
 * the site recognises the role and hands them over.
 */
export default function AdminGate() {
  const { t } = useI18n();
  return (
    <div className="container-x grid min-h-[60vh] place-items-center py-12">
      <motion.div
        initial={{ opacity: 0, y: 30, scale: 0.96 }}
        animate={{ opacity: 1, y: 0, scale: 1 }}
        className="w-full max-w-lg rounded-[2.5rem] bg-white p-10 text-center shadow-lift"
      >
        <motion.div
          animate={{ rotate: [0, -8, 8, 0] }}
          transition={{ duration: 3, repeat: Infinity }}
          className="mx-auto grid h-20 w-20 place-items-center rounded-3xl bg-forest text-white"
        >
          <Icon name="shield" className="h-10 w-10" />
        </motion.div>
        <h1 className="mt-6 text-3xl font-extrabold">{t('admin.title')}</h1>
        <p className="mt-2 text-ink-soft">{t('admin.text')}</p>
        <a href={ADMIN_URL} className="mt-8 inline-block">
          <Button size="lg" iconEnd="arrow" type="button">{t('admin.open')}</Button>
        </a>
      </motion.div>
    </div>
  );
}
