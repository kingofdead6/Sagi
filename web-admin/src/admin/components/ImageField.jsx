import { useRef, useState } from 'react';
import { uploadsApi } from '../api/endpoints';
import { apiErrorMessage } from '../api/client';
import { Button, Spinner } from './ui';

/** value: { url, publicId, width?, height? } | null */
export function ImageField({ label, value, onChange, folder }) {
  const inputRef = useRef(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);

  async function handleFile(e) {
    const file = e.target.files?.[0];
    if (!file) return;
    setBusy(true);
    setError(null);
    try {
      const uploaded = await uploadsApi.image(file, folder, value?.publicId);
      onChange({
        url: uploaded.url,
        publicId: uploaded.publicId,
        width: uploaded.width,
        height: uploaded.height,
      });
    } catch (err) {
      setError(apiErrorMessage(err));
    } finally {
      setBusy(false);
      if (inputRef.current) inputRef.current.value = '';
    }
  }

  async function handleRemove() {
    if (!value?.publicId) return;
    setBusy(true);
    try {
      await uploadsApi.remove(value.publicId);
    } catch {
      // best-effort — clear it locally regardless
    } finally {
      onChange(null);
      setBusy(false);
    }
  }

  return (
    <div>
      {label && <span className="mb-1 block text-sm font-bold text-ink-soft">{label}</span>}
      <div className="flex items-center gap-3">
        <div className="flex h-20 w-20 shrink-0 items-center justify-center overflow-hidden rounded-xl bg-black/5 ring-1 ring-black/10">
          {busy ? (
            <Spinner className="h-5 w-5" />
          ) : value?.url ? (
            <img src={value.url} alt="" className="h-full w-full object-cover" />
          ) : (
            <span className="text-xs text-ink-muted">لا صورة</span>
          )}
        </div>
        <div className="flex flex-col gap-2">
          <Button type="button" variant="outline" onClick={() => inputRef.current?.click()} disabled={busy}>
            {value?.url ? 'تغيير الصورة' : 'رفع صورة'}
          </Button>
          {value?.url && (
            <Button type="button" variant="ghost" onClick={handleRemove} disabled={busy}>
              إزالة
            </Button>
          )}
          <input ref={inputRef} type="file" accept="image/*" className="hidden" onChange={handleFile} />
        </div>
      </div>
      {error && <p className="mt-1 text-xs text-red-600">{error}</p>}
    </div>
  );
}
