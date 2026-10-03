import { useEffect, useRef, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { AnimatePresence, motion } from 'framer-motion';
import { Icon, categoryVisual } from '../components/Icon';
import { Button, EmptyState, ErrorState, Segmented, Skeleton } from '../components/ui';
import { VendorCard, VendorCardSkeleton } from '../components/Catalog';
import { categoryName, useI18n } from '../state/i18n';
import { useLocation2 } from '../state/location';
import { useAsync, useDebounced, useSlow } from '../lib/hooks';
import { catalog } from '../lib/services';
import { errorInfo } from '../lib/api';

const PAGE = 12;

export default function Stores() {
  const { t, lang } = useI18n();
  const [params, setParams] = useSearchParams();
  const { position, status: locStatus, request } = useLocation2();

  const category = params.get('category') ?? '';
  const sort = params.get('sort') ?? 'featured';
  const openNowOnly = params.get('open') === '1';
  const hasOffer = params.get('offer') === '1';
  const [search, setSearch] = useState(params.get('search') ?? '');
  const debounced = useDebounced(search.trim());

  const set = (key, value) => {
    const next = new URLSearchParams(params);
    if (value) next.set(key, value);
    else next.delete(key);
    setParams(next, { replace: true });
  };

  useEffect(() => {
    set('search', debounced);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [debounced]);

  // Nearest-first needs a position; ask only when the shopper picks it.
  useEffect(() => {
    if (sort === 'nearest' && !position && locStatus === 'idle') request();
  }, [sort, position, locStatus, request]);

  const categories = useAsync(() => catalog.categories(), []);

  const [pages, setPages] = useState({ items: [], page: 0, hasMore: true, total: 0 });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const seq = useRef(0);
  const slow = useSlow(loading && pages.page === 0);

  const origin = sort === 'nearest' || position ? position : null;
  const queryKey = JSON.stringify({ category, sort, openNowOnly, hasOffer, search: params.get('search') ?? '', origin });

  const load = async (page) => {
    const id = ++seq.current;
    setLoading(true);
    setError(null);
    try {
      const res = await catalog.vendors({
        category: category || undefined,
        search: params.get('search') || undefined,
        sort: sort === 'nearest' && !origin ? 'featured' : sort,
        openNow: openNowOnly || undefined,
        hasOffer: hasOffer || undefined,
        lat: origin?.lat,
        lng: origin?.lng,
        page,
        limit: PAGE,
      });
      if (id !== seq.current) return;
      setPages((prev) => ({
        items: page === 1 ? res.items : [...prev.items, ...res.items],
        page,
        hasMore: res.hasMore,
        total: res.total,
      }));
    } catch (e) {
      if (id === seq.current) setError(e);
    } finally {
      if (id === seq.current) setLoading(false);
    }
  };

  useEffect(() => {
    setPages({ items: [], page: 0, hasMore: true, total: 0 });
    load(1);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [queryKey]);

  // Infinite scroll: fetch the next page as the sentinel nears the viewport.
  const sentinel = useRef(null);
  useEffect(() => {
    const el = sentinel.current;
    if (!el) return undefined;
    const io = new IntersectionObserver(
      ([entry]) => entry.isIntersecting && !loading && pages.hasMore && pages.page > 0 && load(pages.page + 1),
      { rootMargin: '400px' },
    );
    io.observe(el);
    return () => io.disconnect();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [loading, pages.hasMore, pages.page]);

  const sorts = [
    { value: 'featured', label: t('stores.sortFeatured'), icon: 'sparkles' },
    { value: 'nearest', label: t('stores.sortNearest'), icon: 'pin' },
    { value: 'fastest', label: t('stores.sortFastest'), icon: 'clock' },
    { value: 'rating', label: t('stores.sortRating'), icon: 'star' },
  ];

  return (
    <div className="container-x pb-10 pt-6">
      <div className="relative overflow-hidden rounded-[2.5rem] bg-forest px-6 py-10 text-white md:px-12 md:py-14">
        <motion.div
          aria-hidden="true"
          animate={{ x: [0, 30, 0], rotate: [0, 10, 0] }}
          transition={{ duration: 14, repeat: Infinity }}
          className="absolute -end-20 -top-20 h-72 w-72 rounded-full bg-leaf/30 blur-2xl"
        />
        <motion.h1 initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="relative text-4xl font-extrabold md:text-6xl">
          {t('stores.title')}
        </motion.h1>
        <motion.p initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.15 }} className="relative mt-2 text-white/75">
          {t('stores.subtitle')}
        </motion.p>
        <motion.label
          initial={{ opacity: 0, y: 14 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="relative mt-6 flex max-w-xl items-center gap-3 rounded-2xl bg-white px-4 text-ink shadow-lift focus-within:ring-4 focus-within:ring-leaf/30"
        >
          <Icon name="search" className="h-5 w-5 text-ink-muted" />
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder={t('stores.searchPlaceholder')}
            className="h-14 flex-1 bg-transparent text-lg outline-none placeholder:text-ink-muted"
          />
          <AnimatePresence>
            {search && (
              <motion.button
                type="button"
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                exit={{ scale: 0 }}
                onClick={() => setSearch('')}
                aria-label={t('common.close')}
                className="grid h-8 w-8 place-items-center rounded-full bg-ink/5"
              >
                <Icon name="x" className="h-4 w-4" />
              </motion.button>
            )}
          </AnimatePresence>
        </motion.label>
      </div>

      {/* categories */}
      <div className="scrollbar-none -mx-4 mt-6 flex gap-2 overflow-x-auto px-4 py-1">
        <button type="button" onClick={() => set('category', '')} className={`chip shrink-0 ${!category ? 'chip-on' : ''}`}>
          <Icon name="sparkles" className="h-4 w-4" />
          {t('stores.all')}
        </button>
        {categories.loading
          ? Array.from({ length: 5 }, (_, i) => <Skeleton key={i} className="h-10 w-28 shrink-0 rounded-full" />)
          : (categories.data ?? []).map((c) => {
              const v = categoryVisual(c.iconKey);
              const on = category === c.id;
              return (
                <motion.button
                  key={c.id}
                  type="button"
                  layout
                  whileTap={{ scale: 0.94 }}
                  onClick={() => set('category', on ? '' : c.id)}
                  className={`chip shrink-0 ${on ? 'chip-on' : ''}`}
                >
                  <Icon name={v.icon} className="h-4 w-4" />
                  {categoryName(c, lang)}
                </motion.button>
              );
            })}
      </div>

      {/* sort + toggles */}
      <div className="mt-4 flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
        <div className="scrollbar-none -mx-4 overflow-x-auto px-4">
          <Segmented options={sorts} value={sort} onChange={(v) => set('sort', v === 'featured' ? '' : v)} />
        </div>
        <div className="flex flex-wrap gap-2">
          <button type="button" onClick={() => set('open', openNowOnly ? '' : '1')} className={`chip ${openNowOnly ? 'chip-on' : ''}`}>
            <span className={`h-2 w-2 rounded-full ${openNowOnly ? 'bg-leaf-bright' : 'bg-leaf'}`} />
            {t('stores.openNow')}
          </button>
          <button type="button" onClick={() => set('offer', hasOffer ? '' : '1')} className={`chip ${hasOffer ? 'chip-on' : ''}`}>
            <Icon name="tag" className="h-4 w-4" />
            {t('stores.hasOffer')}
          </button>
        </div>
      </div>

      <AnimatePresence>
        {sort === 'nearest' && (locStatus === 'locating' || locStatus === 'denied') && (
          <motion.p
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
            className="mt-3 flex items-center gap-2 text-sm font-bold text-ink-soft"
          >
            <Icon name={locStatus === 'locating' ? 'target' : 'info'} className="h-4 w-4 text-leaf" />
            {locStatus === 'locating' ? t('stores.locating') : t('stores.locationDenied')}
          </motion.p>
        )}
      </AnimatePresence>

      {pages.page > 0 && (
        <motion.p key={pages.total} initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="num mt-6 text-sm font-bold text-ink-muted">
          {t('stores.count', { n: pages.total })}
        </motion.p>
      )}
      {slow && <p className="mt-6 text-center text-sm font-bold text-ink-muted">{t('common.waking')}</p>}

      <div className="mt-8">
        {error && pages.items.length === 0 ? (
          <ErrorState error={error} onRetry={() => load(1)} />
        ) : !loading && pages.items.length === 0 ? (
          <EmptyState icon="search" title={t('stores.noResults')} text={t('stores.noResultsText')} />
        ) : (
          <motion.div layout className="grid gap-x-6 gap-y-12 sm:grid-cols-2 lg:grid-cols-3">
            <AnimatePresence mode="popLayout">
              {pages.items.map((v, i) => (
                <motion.div key={v.id} layout exit={{ opacity: 0, scale: 0.9 }}>
                  <VendorCard vendor={v} index={i} />
                </motion.div>
              ))}
            </AnimatePresence>
            {loading && Array.from({ length: pages.page === 0 ? 6 : 3 }, (_, i) => <VendorCardSkeleton key={`s${i}`} />)}
          </motion.div>
        )}
        <div ref={sentinel} className="h-4" />
        {error && pages.items.length > 0 && (
          <div className="mt-6 text-center">
            <p className="mb-2 text-sm text-tomato">{errorInfo(error).message}</p>
            <Button variant="outline" icon="refresh" onClick={() => load(pages.page + 1)}>{t('common.retry')}</Button>
          </div>
        )}
      </div>
    </div>
  );
}
