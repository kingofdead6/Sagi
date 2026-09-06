import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { categoriesApi, vendorsApi } from '../api/endpoints';
import { apiErrorMessage } from '../api/client';
import { useAsync } from '../lib/useAsync';
import { ImageField } from '../components/ImageField';
import {
  Button,
  Card,
  Checkbox,
  ConfirmModal,
  ErrorBanner,
  Input,
  Modal,
  PageLoader,
  Select,
  Spinner,
  Textarea,
} from '../components/ui';

const DAYS = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];

function emptyForm() {
  return {
    name: '',
    slug: '',
    description: '',
    category: '',
    logo: null,
    cover: null,
    phone: '',
    addressText: '',
    lat: '',
    lng: '',
    prepTimeMin: 15,
    prepTimeMax: 30,
    deliveryFeeCentimes: 15000,
    minOrderCentimes: 0,
    isOpen: true,
    openingHours: [],
    isFeatured: false,
    sortOrder: 0,
    isActive: true,
  };
}

function toForm(v) {
  return {
    name: v.name,
    slug: v.slug,
    description: v.description ?? '',
    category: v.category?.id ?? v.category ?? '',
    logo: v.logo ?? null,
    cover: v.cover ?? null,
    phone: v.phone,
    addressText: v.addressText,
    lat: v.location?.coordinates?.[1] ?? '',
    lng: v.location?.coordinates?.[0] ?? '',
    prepTimeMin: v.prepTimeMin,
    prepTimeMax: v.prepTimeMax,
    deliveryFeeCentimes: v.deliveryFeeCentimes,
    minOrderCentimes: v.minOrderCentimes,
    isOpen: v.isOpen,
    openingHours: v.openingHours ?? [],
    isFeatured: v.isFeatured,
    sortOrder: v.sortOrder,
    isActive: v.isActive,
  };
}

export default function VendorFormPage() {
  const { id } = useParams();
  const isNew = !id || id === 'new';
  const navigate = useNavigate();

  const { data: categories } = useAsync(() => categoriesApi.list(), []);
  const {
    data: vendor,
    loading: loadingVendor,
    error: loadError,
    refetch: refetchVendor,
  } = useAsync(() => (isNew ? Promise.resolve(null) : vendorsApi.get(id)), [id]);

  const [form, setForm] = useState(emptyForm());
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (vendor) setForm(toForm(vendor));
  }, [vendor]);

  function set(field, value) {
    setForm((f) => ({ ...f, [field]: value }));
  }

  function addHour() {
    set('openingHours', [...form.openingHours, { day: 0, from: '08:00', to: '23:00' }]);
  }
  function updateHour(i, patch) {
    set(
      'openingHours',
      form.openingHours.map((h, idx) => (idx === i ? { ...h, ...patch } : h)),
    );
  }
  function removeHour(i) {
    set('openingHours', form.openingHours.filter((_, idx) => idx !== i));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setSaving(true);
    setError(null);
    try {
      const body = {
        name: form.name,
        slug: form.slug,
        description: form.description || undefined,
        category: form.category,
        logo: form.logo,
        cover: form.cover,
        phone: form.phone,
        addressText: form.addressText,
        lat: Number(form.lat),
        lng: Number(form.lng),
        prepTimeMin: Number(form.prepTimeMin),
        prepTimeMax: Number(form.prepTimeMax),
        deliveryFeeCentimes: Number(form.deliveryFeeCentimes),
        minOrderCentimes: Number(form.minOrderCentimes),
        isOpen: form.isOpen,
        openingHours: form.openingHours,
        isFeatured: form.isFeatured,
        sortOrder: Number(form.sortOrder),
        isActive: form.isActive,
      };
      if (isNew) {
        const created = await vendorsApi.create(body);
        navigate(`/vendors/${created.id}`, { replace: true });
      } else {
        await vendorsApi.update(id, body);
        refetchVendor();
      }
    } catch (err) {
      setError(apiErrorMessage(err));
    } finally {
      setSaving(false);
    }
  }

  if (!isNew && loadingVendor) return <PageLoader />;

  return (
    <div className="max-w-4xl">
      <div className="mb-6 flex items-center justify-between">
        <h1 className="text-2xl font-black">{isNew ? 'متجر جديد' : `تعديل: ${vendor?.name ?? ''}`}</h1>
        <Button variant="ghost" onClick={() => navigate('/vendors')}>
          رجوع للقائمة
        </Button>
      </div>

      <ErrorBanner message={loadError || error} />

      <Card>
        <form className="space-y-5" onSubmit={handleSubmit}>
          <div className="grid gap-4 sm:grid-cols-2">
            <Input label="الاسم" value={form.name} onChange={(e) => set('name', e.target.value)} required />
            <Input
              label="المعرّف (slug)"
              value={form.slug}
              onChange={(e) => set('slug', e.target.value)}
              placeholder="my-shop"
              required
            />
          </div>

          <Textarea
            label="الوصف"
            value={form.description}
            onChange={(e) => set('description', e.target.value)}
            rows={3}
          />

          <Select label="الفئة" value={form.category} onChange={(e) => set('category', e.target.value)} required>
            <option value="">اختر فئة</option>
            {categories?.map((c) => (
              <option key={c.id} value={c.id}>
                {c.nameAr}
              </option>
            ))}
          </Select>

          <div className="grid gap-4 sm:grid-cols-2">
            <ImageField label="الشعار" value={form.logo} onChange={(v) => set('logo', v)} folder="vendors" />
            <ImageField label="صورة الغلاف" value={form.cover} onChange={(v) => set('cover', v)} folder="vendors" />
          </div>

          <div className="grid gap-4 sm:grid-cols-2">
            <Input label="الهاتف" value={form.phone} onChange={(e) => set('phone', e.target.value)} required />
            <Input
              label="العنوان"
              value={form.addressText}
              onChange={(e) => set('addressText', e.target.value)}
              required
            />
          </div>

          <div className="grid gap-4 sm:grid-cols-2">
            <Input
              label="خط العرض (lat)"
              type="number"
              step="any"
              value={form.lat}
              onChange={(e) => set('lat', e.target.value)}
              required
            />
            <Input
              label="خط الطول (lng)"
              type="number"
              step="any"
              value={form.lng}
              onChange={(e) => set('lng', e.target.value)}
              required
            />
          </div>

          <div className="grid gap-4 sm:grid-cols-2 md:grid-cols-4">
            <Input
              label="أقل وقت تحضير (د)"
              type="number"
              value={form.prepTimeMin}
              onChange={(e) => set('prepTimeMin', e.target.value)}
            />
            <Input
              label="أقصى وقت تحضير (د)"
              type="number"
              value={form.prepTimeMax}
              onChange={(e) => set('prepTimeMax', e.target.value)}
            />
            <Input
              label="رسوم التوصيل (سنتيم)"
              type="number"
              value={form.deliveryFeeCentimes}
              onChange={(e) => set('deliveryFeeCentimes', e.target.value)}
            />
            <Input
              label="أقل قيمة طلب (سنتيم)"
              type="number"
              value={form.minOrderCentimes}
              onChange={(e) => set('minOrderCentimes', e.target.value)}
            />
          </div>

          <div>
            <div className="mb-2 flex items-center justify-between">
              <span className="text-sm font-bold text-ink-soft">أوقات العمل</span>
              <Button type="button" variant="outline" onClick={addHour}>
                + إضافة وقت
              </Button>
            </div>
            <div className="space-y-2">
              {form.openingHours.map((h, i) => (
                <div key={i} className="flex items-center gap-2">
                  <Select value={h.day} onChange={(e) => updateHour(i, { day: Number(e.target.value) })} className="w-32">
                    {DAYS.map((d, idx) => (
                      <option key={idx} value={idx}>
                        {d}
                      </option>
                    ))}
                  </Select>
                  <Input type="time" value={h.from} onChange={(e) => updateHour(i, { from: e.target.value })} />
                  <span className="text-ink-muted">إلى</span>
                  <Input type="time" value={h.to} onChange={(e) => updateHour(i, { to: e.target.value })} />
                  <Button type="button" variant="danger" onClick={() => removeHour(i)}>
                    حذف
                  </Button>
                </div>
              ))}
            </div>
          </div>

          <div className="grid gap-3 sm:grid-cols-2 md:grid-cols-4">
            <Checkbox label="مفتوح الآن" checked={form.isOpen} onChange={(e) => set('isOpen', e.target.checked)} />
            <Checkbox
              label="مميز"
              checked={form.isFeatured}
              onChange={(e) => set('isFeatured', e.target.checked)}
            />
            <Checkbox label="مفعّل" checked={form.isActive} onChange={(e) => set('isActive', e.target.checked)} />
            <Input
              label="الترتيب"
              type="number"
              value={form.sortOrder}
              onChange={(e) => set('sortOrder', e.target.value)}
            />
          </div>

          <div className="flex justify-end gap-2 border-t border-black/5 pt-4">
            <Button type="submit" disabled={saving}>
              {saving ? <Spinner className="h-4 w-4" /> : 'حفظ'}
            </Button>
          </div>
        </form>
      </Card>

      {!isNew && vendor && (
        <>
          <AccountCard vendor={vendor} refetch={refetchVendor} />
          <SectionsCard vendorId={id} />
          <DangerCard vendor={vendor} navigate={navigate} />
        </>
      )}
    </div>
  );
}

function AccountCard({ vendor, refetch }) {
  const [open, setOpen] = useState(false);
  const [form, setForm] = useState({ fullName: '', phone: '', password: '' });
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);
  const [confirmRemove, setConfirmRemove] = useState(false);

  async function handleCreate(e) {
    e.preventDefault();
    setBusy(true);
    setError(null);
    try {
      await vendorsApi.createAccount(vendor.id, form);
      setOpen(false);
      refetch();
    } catch (err) {
      setError(apiErrorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  async function handleRemove() {
    setBusy(true);
    try {
      await vendorsApi.removeAccount(vendor.id);
      setConfirmRemove(false);
      refetch();
    } catch (err) {
      setError(apiErrorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card className="mt-6">
      <h2 className="mb-3 text-lg font-black">حساب دخول المتجر</h2>
      {vendor.owner ? (
        <div className="flex items-center justify-between">
          <p className="text-sm text-ink-soft">لهذا المتجر حساب دخول مفعّل.</p>
          <Button variant="danger" onClick={() => setConfirmRemove(true)}>
            حذف الحساب
          </Button>
        </div>
      ) : (
        <div className="flex items-center justify-between">
          <p className="text-sm text-ink-soft">لا يوجد حساب دخول لهذا المتجر بعد.</p>
          <Button variant="outline" onClick={() => setOpen(true)}>
            إنشاء حساب
          </Button>
        </div>
      )}
      <ErrorBanner message={error} />

      <Modal open={open} onClose={() => setOpen(false)} title="إنشاء حساب المتجر">
        <form className="space-y-4" onSubmit={handleCreate}>
          <Input
            label="اسم المالك"
            value={form.fullName}
            onChange={(e) => setForm((f) => ({ ...f, fullName: e.target.value }))}
            required
          />
          <Input
            label="رقم الهاتف"
            value={form.phone}
            onChange={(e) => setForm((f) => ({ ...f, phone: e.target.value }))}
            required
          />
          <Input
            label="كلمة المرور"
            type="password"
            value={form.password}
            onChange={(e) => setForm((f) => ({ ...f, password: e.target.value }))}
            required
          />
          <div className="flex justify-end gap-2">
            <Button type="button" variant="ghost" onClick={() => setOpen(false)}>
              إلغاء
            </Button>
            <Button type="submit" disabled={busy}>
              {busy ? <Spinner className="h-4 w-4" /> : 'إنشاء'}
            </Button>
          </div>
        </form>
      </Modal>

      <ConfirmModal
        open={confirmRemove}
        onClose={() => setConfirmRemove(false)}
        onConfirm={handleRemove}
        loading={busy}
        title="حذف حساب المتجر"
        message="سيفقد المالك القدرة على الدخول. هذا لا يؤثر على المتجر أو قائمته."
      />
    </Card>
  );
}

function SectionsCard({ vendorId }) {
  const { data: sections, refetch } = useAsync(() => vendorsApi.sections(vendorId), [vendorId]);
  const [name, setName] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);
  const [deleteTarget, setDeleteTarget] = useState(null);

  async function handleAdd(e) {
    e.preventDefault();
    if (!name.trim()) return;
    setBusy(true);
    setError(null);
    try {
      await vendorsApi.createSection(vendorId, { name: name.trim(), sortOrder: sections?.length ?? 0 });
      setName('');
      refetch();
    } catch (err) {
      setError(apiErrorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  async function handleDelete() {
    setBusy(true);
    try {
      await vendorsApi.removeSection(deleteTarget.id);
      setDeleteTarget(null);
      refetch();
    } catch (err) {
      setError(apiErrorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card className="mt-6">
      <h2 className="mb-3 text-lg font-black">أقسام القائمة</h2>
      <ErrorBanner message={error} />
      <div className="space-y-2">
        {sections?.map((s) => (
          <div key={s.id} className="flex items-center justify-between rounded-xl bg-black/5 px-4 py-2">
            <span className="font-bold">{s.name}</span>
            <Button variant="danger" onClick={() => setDeleteTarget(s)}>
              حذف
            </Button>
          </div>
        ))}
        {sections?.length === 0 && <p className="text-sm text-ink-muted">لا توجد أقسام بعد</p>}
      </div>
      <form className="mt-4 flex gap-2" onSubmit={handleAdd}>
        <Input placeholder="اسم القسم الجديد" value={name} onChange={(e) => setName(e.target.value)} />
        <Button type="submit" disabled={busy}>
          إضافة
        </Button>
      </form>

      <ConfirmModal
        open={!!deleteTarget}
        onClose={() => setDeleteTarget(null)}
        onConfirm={handleDelete}
        loading={busy}
        title="حذف القسم"
        message={`هل تريد حذف "${deleteTarget?.name}"؟ سيصبح منتجوه بلا قسم.`}
      />
    </Card>
  );
}

function DangerCard({ vendor, navigate }) {
  const [confirmDisable, setConfirmDisable] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);

  async function handleDisable() {
    setBusy(true);
    setError(null);
    try {
      await vendorsApi.remove(vendor.id);
      setConfirmDisable(false);
      navigate('/vendors');
    } catch (err) {
      setError(apiErrorMessage(err));
      setConfirmDisable(false);
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card className="mt-6 ring-red-100">
      <h2 className="mb-2 text-lg font-black text-red-700">منطقة الخطر</h2>
      <ErrorBanner message={error} />
      <div className="flex items-center justify-between">
        <p className="text-sm text-ink-soft">تعطيل المتجر يوقفه عن الظهور دون حذف بياناته أو طلباته السابقة.</p>
        <Button variant="danger" onClick={() => setConfirmDisable(true)}>
          تعطيل المتجر
        </Button>
      </div>
      <ConfirmModal
        open={confirmDisable}
        onClose={() => setConfirmDisable(false)}
        onConfirm={handleDisable}
        loading={busy}
        title="تعطيل المتجر"
        message={`هل تريد تعطيل "${vendor.name}"؟`}
      />
    </Card>
  );
}
