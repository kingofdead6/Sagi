import { Link, useLocation, useParams } from 'react-router-dom';
import { motion } from 'framer-motion';
import { Button } from '../components/ui';
import { Confetti, DrawnCheck } from '../components/Effects';
import { useI18n } from '../state/i18n';

export default function OrderSuccess() {
  const { id } = useParams();
  const { state } = useLocation();
  const { t } = useI18n();
  return (
    <div className="container-x grid min-h-[70vh] place-items-center py-12">
      <Confetti />
      <motion.div
        initial={{ opacity: 0, scale: 0.9, y: 30 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        transition={{ type: 'spring', stiffness: 160, damping: 18 }}
        className="relative w-full max-w-lg overflow-hidden rounded-[2.5rem] bg-white p-8 text-center shadow-lift md:p-12"
      >
        <div aria-hidden="true" className="absolute inset-x-0 top-0 h-40 bg-gradient-to-b from-leaf-tint to-transparent" />
        <div className="relative mx-auto w-fit">
          <DrawnCheck />
        </div>
        <motion.h1
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
          className="relative mt-6 text-4xl font-extrabold text-forest"
        >
          {t('success.title')}
        </motion.h1>
        <motion.p initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.75 }} className="relative mt-3 text-ink-soft">
          {t('success.text')}
        </motion.p>
        {state?.code && (
          <motion.div
            initial={{ opacity: 0, rotateX: 90 }}
            animate={{ opacity: 1, rotateX: 0 }}
            transition={{ delay: 0.9, type: 'spring' }}
            className="relative mx-auto mt-6 w-fit rounded-2xl border-2 border-dashed border-leaf/50 bg-cream px-6 py-3"
          >
            <p className="text-xs font-bold text-ink-muted">{t('success.code')}</p>
            <p className="num font-display text-2xl font-extrabold tracking-widest text-forest">{state.code}</p>
          </motion.div>
        )}
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 1.05 }}
          className="relative mt-8 flex flex-col gap-3 sm:flex-row"
        >
          <Link to={`/orders/${id}`} className="flex-1">
            <Button size="lg" className="w-full" icon="pin">{t('success.track')}</Button>
          </Link>
          <Link to="/" className="flex-1">
            <Button size="lg" variant="outline" className="w-full">{t('success.home')}</Button>
          </Link>
        </motion.div>
      </motion.div>
    </div>
  );
}
