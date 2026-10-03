import { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import ar from '../i18n/ar';
import fr from '../i18n/fr';
import en from '../i18n/en';
import { errorInfo } from '../lib/api';

const DICTS = { ar, fr, en };
export const LANGUAGES = [
  { code: 'ar', label: 'العربية' },
  { code: 'fr', label: 'Français' },
  { code: 'en', label: 'English' },
];

const KEY = 'saji.lang';
const I18nContext = createContext(null);

function lookup(dict, path) {
  return path.split('.').reduce((node, part) => (node == null ? node : node[part]), dict);
}

function initialLang() {
  try {
    const saved = localStorage.getItem(KEY);
    if (saved && DICTS[saved]) return saved;
  } catch {
    /* storage unavailable */
  }
  // Arabic is the product's first language, exactly as in the app.
  return 'ar';
}

export function I18nProvider({ children }) {
  const [lang, setLangState] = useState(initialLang);

  useEffect(() => {
    document.documentElement.lang = lang;
    document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
  }, [lang]);

  const setLang = useCallback((next) => {
    setLangState(next);
    try {
      localStorage.setItem(KEY, next);
    } catch {
      /* fine */
    }
  }, []);

  /** `t('stores.minOrder', { amount })` — falls back to Arabic, then the key. */
  const t = useCallback(
    (path, vars) => {
      let value = lookup(DICTS[lang], path) ?? lookup(ar, path) ?? path;
      if (typeof value === 'string' && vars) {
        value = value.replace(/\{(\w+)\}/g, (_, k) => (vars[k] ?? `{${k}}`));
      }
      return value;
    },
    [lang],
  );

  /**
   * The message to show for a failed request. Arabic readers get the server's
   * own wording (it is written in Arabic and is the most specific); everyone
   * else gets a translation picked by the error code.
   */
  const errorText = useCallback(
    (error) => {
      const info = errorInfo(error);
      if (info.code === 'NETWORK') return t('common.errorNetwork');
      if (info.code === 'TIMEOUT') return t('common.errorTimeout');
      if (lang === 'ar' && info.message) {
        const detail = info.details?.[0]?.message;
        return detail && info.code === 'VALIDATION_ERROR' ? detail : info.message;
      }
      const byCode = {
        UNAUTHORIZED: 'errorAuth',
        FORBIDDEN: 'errorForbidden',
        NOT_FOUND: 'errorNotFound',
        VALIDATION_ERROR: 'errorValidation',
        CONFLICT: 'errorConflict',
      };
      return t(`common.${byCode[info.code] ?? 'errorGeneric'}`);
    },
    [lang, t],
  );

  const value = useMemo(
    () => ({ lang, setLang, t, errorText, dir: lang === 'ar' ? 'rtl' : 'ltr', isRtl: lang === 'ar' }),
    [lang, setLang, t, errorText],
  );
  return <I18nContext.Provider value={value}>{children}</I18nContext.Provider>;
}

export function useI18n() {
  return useContext(I18nContext);
}

/** A category's name in the current language (the API stores ar + fr). */
export function categoryName(category, lang) {
  if (!category) return '';
  return lang === 'ar' ? category.nameAr : category.nameFr || category.nameAr;
}
