import { useCallback, useEffect, useState } from 'react';
import { apiErrorMessage } from '../api/client';

/** Runs `fn` whenever `deps` change, exposing data/loading/error + a manual refetch. */
export function useAsync(fn, deps) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const run = useCallback(() => {
    setLoading(true);
    setError(null);
    return fn()
      .then((res) => setData(res))
      .catch((err) => setError(apiErrorMessage(err)))
      .finally(() => setLoading(false));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, deps);

  useEffect(() => {
    run();
  }, [run]);

  return { data, loading, error, refetch: run, setData };
}
