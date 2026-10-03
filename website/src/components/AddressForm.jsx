import { Suspense, lazy, useEffect, useState } from 'react';
import { Button, Field, Input, Modal, Skeleton, Switch } from './ui';
import { useI18n } from '../state/i18n';
import { useToast } from '../state/toast';
import { addresses } from '../lib/services';
import { toLatLng } from '../lib/format';
import { DEFAULT_CENTER } from '../state/location';

const MapPicker = lazy(() => import('./Maps').then((m) => ({ default: m.MapPicker })));

/** Create or edit a delivery address. Resolves `onSaved(address)` on success. */
export function AddressForm({ open, address, onClose, onSaved }) {
  const { t, errorText } = useI18n();
  const toast = useToast();
  const [form, setForm] = useState(blank());
  const [point, setPoint] = useState(DEFAULT_CENTER);
  const [errors, setErrors] = useState({});
  const [saving, setSaving] = useState(false);
  // Geocoding only fills fields the shopper has not typed in themselves.
  const [touched, setTouched] = useState({});
  // The map reads its start point once on mount, so it waits for the form.
  const [ready, setReady] = useState(false);

  function blank() {
    return { label: t('account.labelHome'), wilaya: '', commune: '', street: '', notes: '', isDefault: false };
  }

  useEffect(() => {
    if (!open) {
      setReady(false);
      return;
    }
    setErrors({});
    setTouched({});
    if (address) {
      setForm({
        label: address.label ?? '',
        wilaya: address.wilaya ?? '',
        commune: address.commune ?? '',
        street: address.street ?? '',
        notes: address.notes ?? '',
        isDefault: Boolean(address.isDefault),
      });
      setPoint(toLatLng(address.location) ?? DEFAULT_CENTER);
    } else {
      setForm(blank());
      setPoint(DEFAULT_CENTER);
    }
    setReady(true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, address]);

  const set = (key) => (e) => {
    setTouched((s) => ({ ...s, [key]: true }));
    setForm((f) => ({ ...f, [key]: e.target.value }));
  };

  const geocoded = (found) => {
    setForm((f) => ({
      ...f,
      wilaya: touched.wilaya || !found.wilaya ? f.wilaya : found.wilaya,
      commune: touched.commune || !found.commune ? f.commune : found.commune,
      street: touched.street || !found.street ? f.street : found.street,
    }));
  };

  const submit = async (e) => {
    e.preventDefault();
    // Mirrors the server's address schema.
    const next = {};
    if (form.label.trim().length < 1) next.label = t('common.errorValidation');
    if (form.wilaya.trim().length < 2) next.wilaya = t('common.errorValidation');
    if (form.commune.trim().length < 2) next.commune = t('common.errorValidation');
    if (form.street.trim().length < 2) next.street = t('common.errorValidation');
    setErrors(next);
    if (Object.keys(next).length) return;

    setSaving(true);
    const body = {
      label: form.label.trim().slice(0, 30),
      wilaya: form.wilaya.trim(),
      commune: form.commune.trim(),
      street: form.street.trim(),
      ...(form.notes.trim() ? { notes: form.notes.trim() } : {}),
      lat: point[0],
      lng: point[1],
      isDefault: form.isDefault,
    };
    try {
      const saved = address ? await addresses.update(address.id, body) : await addresses.create(body);
      toast.success(t('account.saved'));
      onSaved?.(saved);
      onClose();
    } catch (err) {
      toast.error(errorText(err));
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal open={open} onClose={onClose} wide title={address ? t('account.addressEdit') : t('account.addressNew')}>
      <form onSubmit={submit} className="space-y-4 p-6">
        {open && ready && (
          <Suspense fallback={<Skeleton className="h-72 rounded-4xl" />}>
            <MapPicker value={point} onChange={setPoint} onAddress={geocoded} />
          </Suspense>
        )}
        <div className="flex flex-wrap gap-2">
          {[t('account.labelHome'), t('account.labelWork')].map((l) => (
            <button
              key={l}
              type="button"
              onClick={() => setForm((f) => ({ ...f, label: l }))}
              className={`chip ${form.label === l ? 'chip-on' : ''}`}
            >
              {l}
            </button>
          ))}
        </div>
        <div className="grid gap-4 sm:grid-cols-2">
          <Field label={t('account.label')} error={errors.label}>
            <Input value={form.label} onChange={set('label')} maxLength={30} invalid={errors.label} />
          </Field>
          <Field label={t('account.wilaya')} error={errors.wilaya}>
            <Input value={form.wilaya} onChange={set('wilaya')} maxLength={60} invalid={errors.wilaya} />
          </Field>
          <Field label={t('account.commune')} error={errors.commune}>
            <Input value={form.commune} onChange={set('commune')} maxLength={60} invalid={errors.commune} />
          </Field>
          <Field label={t('account.street')} error={errors.street}>
            <Input value={form.street} onChange={set('street')} maxLength={160} invalid={errors.street} />
          </Field>
        </div>
        <Field label={`${t('account.notes')} (${t('common.optional')})`}>
          <Input value={form.notes} onChange={set('notes')} maxLength={200} />
        </Field>
        <div className="flex items-center justify-between rounded-2xl bg-cream px-4 py-3">
          <span className="font-bold">{t('account.setDefault')}</span>
          <Switch checked={form.isDefault} onChange={(v) => setForm((f) => ({ ...f, isDefault: v }))} label={t('account.setDefault')} />
        </div>
        <Button type="submit" size="lg" className="w-full" loading={saving} icon="check">
          {t('common.save')}
        </Button>
      </form>
    </Modal>
  );
}
