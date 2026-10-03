import { useCallback, useEffect, useRef, useState } from 'react';

/** Runs an async loader on mount and whenever `deps` change; stale responses are dropped. */
export function useAsync(loader, deps = []) {
  const [state, setState] = useState({ data: undefined, error: null, loading: true });
  const seq = useRef(0);
  const run = useCallback(() => {
    const id = ++seq.current;
    setState((s) => ({ ...s, loading: true, error: null }));
    return loader()
      .then((data) => {
        if (id === seq.current) setState({ data, error: null, loading: false });
        return data;
      })
      .catch((error) => {
        if (id === seq.current) setState((s) => ({ ...s, error, loading: false }));
      });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, deps);
  useEffect(() => {
    run();
  }, [run]);
  const setData = useCallback((updater) => {
    setState((s) => ({ ...s, data: typeof updater === 'function' ? updater(s.data) : updater }));
  }, []);
  return { ...state, reload: run, setData };
}

/** True once a slow first request has taken long enough to explain the wait. */
export function useSlow(loading, ms = 4000) {
  const [slow, setSlow] = useState(false);
  useEffect(() => {
    if (!loading) {
      setSlow(false);
      return undefined;
    }
    const id = setTimeout(() => setSlow(true), ms);
    return () => clearTimeout(id);
  }, [loading, ms]);
  return slow;
}

export function useDebounced(value, ms = 350) {
  const [v, setV] = useState(value);
  useEffect(() => {
    const id = setTimeout(() => setV(value), ms);
    return () => clearTimeout(id);
  }, [value, ms]);
  return v;
}
