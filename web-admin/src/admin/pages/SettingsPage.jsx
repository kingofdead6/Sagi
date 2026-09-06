import { useEffect, useState } from 'react';
import { settingsApi } from '../api/endpoints';
import { apiErrorMessage } from '../api/client';
import { useAsync } from '../lib/useAsync';
import { centimesToDa, daToCentimes } from '../lib/constants';
import { Button, Card, Checkbox, ErrorBanner, Input, PageLoader, Spinner } from '../components/ui';

export default function SettingsPage() {
  const { data: settings, loading, error, refetch } = useAsync(() => settingsApi.get(), []);
  const [form, setForm] = useState(null);
  const [saving, setSaving] = useState(false);
  const [saveError, setSaveError] = useState(null);
  const [saved, setSaved] = useState(false);

  useEffect(() => {
    if (settings) {
      setForm({
        serviceFeeDa: centimesToDa(settings.serviceFeeCentimes),
        vipSurchargeDa: centimesToDa(settings.vipSurchargeCentimes),
        assignTimeoutSec: settings.assignTimeoutSec,
        lateThresholdMin: settings.lateThresholdMin,
        supportPhone: settings.supportPhone,
        deliveryRadiusKm: settings.deliveryRadiusKm,
        pointsPerHundredDinars: settings.pointsPerHundredDinars,
        pointValueDa: centimesToDa(settings.pointValueCentimes),
        maxPointsPercentOfSubtotal: settings.maxPointsPercentOfSubtotal,
        electronicPaymentEnabled: settings.electronicPaymentEnabled,
      });
    }
  }, [settings]);

  function set(field, value) {
    setForm((f) => ({ ...f, [field]: value }));
    setSaved(false);
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setSaving(true);
    setSaveError(null);
    try {
      await settingsApi.update({
        serviceFeeCentimes: daToCentimes(form.serviceFeeDa),
        vipSurchargeCentimes: daToCentimes(form.vipSurchargeDa),
        assignTimeoutSec: Number(form.assignTimeoutSec),
        lateThresholdMin: Number(form.lateThresholdMin),
        supportPhone: form.supportPhone,
        deliveryRadiusKm: Number(form.deliveryRadiusKm),
        pointsPerHundredDinars: Number(form.pointsPerHundredDinars),
        pointValueCentimes: daToCentimes(form.pointValueDa),
        maxPointsPercentOfSubtotal: Number(form.maxPointsPercentOfSubtotal),
        electronicPaymentEnabled: form.electronicPaymentEnabled,
      });
      setSaved(true);
      refetch();
    } catch (err) {
      setSaveError(apiErrorMessage(err));
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="max-w-2xl">
      <h1 className="mb-6 text-2xl font-black">الإعدادات</h1>
      <ErrorBanner message={error} />
      {loading && <PageLoader />}

      {form && (
        <Card>
          <form className="space-y-5" onSubmit={handleSubmit}>
            <div className="grid gap-4 sm:grid-cols-2">
              <Input
                label="رسوم الخدمة (د.ج)"
                type="number"
                step="0.01"
                value={form.serviceFeeDa}
                onChange={(e) => set('serviceFeeDa', e.target.value)}
              />
              <Input
                label="رسوم VIP الإضافية (د.ج)"
                type="number"
                step="0.01"
                value={form.vipSurchargeDa}
                onChange={(e) => set('vipSurchargeDa', e.target.value)}
              />
            </div>

            <div className="grid gap-4 sm:grid-cols-2">
              <Input
                label="مهلة قبول السائق (ثانية)"
                type="number"
                value={form.assignTimeoutSec}
                onChange={(e) => set('assignTimeoutSec', e.target.value)}
              />
              <Input
                label="حد التأخير (دقيقة)"
                type="number"
                value={form.lateThresholdMin}
                onChange={(e) => set('lateThresholdMin', e.target.value)}
              />
            </div>

            <div className="grid gap-4 sm:grid-cols-2">
              <Input
                label="هاتف الدعم"
                value={form.supportPhone}
                onChange={(e) => set('supportPhone', e.target.value)}
              />
              <Input
                label="نطاق التوصيل (كم)"
                type="number"
                value={form.deliveryRadiusKm}
                onChange={(e) => set('deliveryRadiusKm', e.target.value)}
              />
            </div>

            <div className="grid gap-4 sm:grid-cols-3">
              <Input
                label="نقاط لكل 100 د.ج"
                type="number"
                value={form.pointsPerHundredDinars}
                onChange={(e) => set('pointsPerHundredDinars', e.target.value)}
              />
              <Input
                label="قيمة النقطة (د.ج)"
                type="number"
                step="0.01"
                value={form.pointValueDa}
                onChange={(e) => set('pointValueDa', e.target.value)}
              />
              <Input
                label="أقصى نسبة نقاط من المجموع (%)"
                type="number"
                value={form.maxPointsPercentOfSubtotal}
                onChange={(e) => set('maxPointsPercentOfSubtotal', e.target.value)}
              />
            </div>

            <Checkbox
              label="تفعيل الدفع الإلكتروني"
              checked={form.electronicPaymentEnabled}
              onChange={(e) => set('electronicPaymentEnabled', e.target.checked)}
            />

            <ErrorBanner message={saveError} />
            {saved && (
              <p className="text-sm font-bold text-brand-deep">تم حفظ الإعدادات بنجاح.</p>
            )}

            <div className="flex justify-end border-t border-black/5 pt-4">
              <Button type="submit" disabled={saving}>
                {saving ? <Spinner className="h-4 w-4" /> : 'حفظ الإعدادات'}
              </Button>
            </div>
          </form>
        </Card>
      )}
    </div>
  );
}
