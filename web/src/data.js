/**
 * Page content in one place, so copy edits never mean touching layout code.
 * Arabic is the product's primary language, so it is the page's language too.
 */

/** Where the download button points. Kept here because it changes per deploy. */
export const APK_URL = 'https://drive.google.com/uc?export=download&id=1CxwTrPBFyhL2xa3b8YA_5KtlTD6LtU8k';

/** Shown next to the button so nobody starts a 22MB download blind. */
export const APK_SIZE = '22 ميغابايت';

export const APK_MIN_ANDROID = 'أندرويد 6 أو أحدث';

/** The four category groups from the Saji logo. */
export const CATEGORIES = [
  { icon: '🍔', label: 'أكل', hint: 'مطاعم ووجبات سريعة' },
  { icon: '🥬', label: 'خضر وفواكه', hint: 'طازجة من السوق' },
  { icon: '💊', label: 'صيدلية', hint: 'دواء ومستلزمات' },
  { icon: '📦', label: 'أي حاجة', hint: 'كل ما تحتاجه' },
];

export const FEATURES = [
  {
    icon: '📍',
    title: 'تتبّع مباشر',
    body: 'تابع موقع عامل التوصيل على الخريطة لحظة بلحظة حتى يصل إلى بابك.',
  },
  {
    icon: '📞',
    title: 'تأكيد بمكالمة',
    body: 'نتصل بك لتأكيد كل طلب قبل تحضيره — لا طلبات خاطئة ولا مفاجآت.',
  },
  {
    icon: '🏪',
    title: 'متاجر قريبة منك',
    body: 'مطاعم ومحلات بئر العاتر في مكان واحد، مع أسعار ورسوم توصيل واضحة.',
  },
  {
    icon: '🎟️',
    title: 'قسائم وعروض',
    body: 'خصومات وتوصيل مجاني على مدار الأسبوع، تظهر لك مباشرة في التطبيق.',
  },
];

/** Mirrors the real order lifecycle in the API. */
export const STEPS = [
  { n: '١', title: 'اختر متجرك', body: 'تصفّح المتاجر القريبة وأضف ما تريد إلى السلة.' },
  { n: '٢', title: 'أكّد الطلب', body: 'نتصل بك هاتفياً لتأكيد الطلب والعنوان.' },
  { n: '٣', title: 'تابع التوصيل', body: 'شاهد عامل التوصيل على الخريطة حتى باب دارك.' },
];
