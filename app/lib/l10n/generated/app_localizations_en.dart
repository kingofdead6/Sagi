// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'ساجي';

  @override
  String get welcomeTitle => 'مرحباً بك في ساجي';

  @override
  String get welcomeSubtitle => 'كل ما تحتاجه، يصلك إلى باب دارك';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonConfirm => 'تأكيد';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonEdit => 'تعديل';

  @override
  String get commonAdd => 'إضافة';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get commonSearch => 'بحث';

  @override
  String get commonNext => 'التالي';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonSeeAll => 'عرض الكل';

  @override
  String get commonYes => 'نعم';

  @override
  String get commonNo => 'لا';

  @override
  String get commonLoading => 'جارٍ التحميل…';

  @override
  String get commonOptional => 'اختياري';

  @override
  String get commonRequired => 'مطلوب';

  @override
  String get commonCall => 'اتصال';

  @override
  String get commonFilter => 'تصفية';

  @override
  String get commonApply => 'تطبيق';

  @override
  String get commonReset => 'إعادة تعيين';

  @override
  String get commonToday => 'اليوم';

  @override
  String get commonNone => 'لا شيء';

  @override
  String get commonRefresh => 'تحديث';

  @override
  String get commonExport => 'تصدير';

  @override
  String get errorGeneric => 'حدث خطأ غير متوقع، حاول من جديد';

  @override
  String get errorNetwork => 'لا يوجد اتصال بالإنترنت، تحقق من الشبكة';

  @override
  String get errorTimeout => 'استغرق الطلب وقتاً طويلاً، حاول من جديد';

  @override
  String get errorServer => 'الخادم لا يستجيب حالياً، حاول بعد قليل';

  @override
  String get errorUnauthorized => 'انتهت الجلسة، سجّل الدخول من جديد';

  @override
  String get errorForbidden => 'لا تملك صلاحية هذا الإجراء';

  @override
  String get errorNotFound => 'العنصر غير موجود';

  @override
  String get errorConflict => 'لا يمكن تنفيذ هذا الإجراء الآن';

  @override
  String get errorValidation => 'تحقق من البيانات المُدخلة';

  @override
  String get errorTooMany => 'محاولات كثيرة، انتظر قليلاً';

  @override
  String get authLoginTitle => 'تسجيل الدخول';

  @override
  String get authRegisterTitle => 'إنشاء حساب';

  @override
  String get authPhone => 'رقم الهاتف';

  @override
  String get authPhoneHint => '0X XX XX XX XX';

  @override
  String get authPassword => 'كلمة المرور';

  @override
  String get authPasswordHint => '6 أحرف على الأقل';

  @override
  String get authFullName => 'الاسم الكامل';

  @override
  String get authFullNameHint => 'اسمك ولقبك';

  @override
  String get authLogin => 'دخول';

  @override
  String get authRegister => 'إنشاء الحساب';

  @override
  String get authNoAccount => 'ليس لديك حساب؟';

  @override
  String get authHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get authLogout => 'تسجيل الخروج';

  @override
  String get authLogoutConfirm => 'هل تريد تسجيل الخروج من حسابك؟';

  @override
  String get authInvalidPhone => 'أدخل رقم هاتف جزائري صالح';

  @override
  String get authInvalidPassword => 'كلمة المرور يجب أن تحتوي 6 أحرف على الأقل';

  @override
  String get authInvalidName => 'أدخل اسمك الكامل';

  @override
  String get authOtpTitle => 'رمز التحقق';

  @override
  String authOtpSubtitle(String phone) {
    return 'أدخل الرمز المرسل إلى $phone';
  }

  @override
  String get authOtpResend => 'إعادة إرسال الرمز';

  @override
  String get authOtpDisabled =>
      'التحقق عبر الرمز غير مفعّل حالياً، استعمل كلمة المرور';

  @override
  String get authChangePassword => 'تغيير كلمة المرور';

  @override
  String get authCurrentPassword => 'كلمة المرور الحالية';

  @override
  String get authNewPassword => 'كلمة المرور الجديدة';

  @override
  String get locationTitle => 'أين نوصّل طلبك؟';

  @override
  String get locationSubtitle => 'حدّد موقعك على الخريطة أو اكتب عنوانك';

  @override
  String get locationUseGps => 'استعمال موقعي الحالي';

  @override
  String get locationPermissionDenied =>
      'لم يُسمح بالوصول إلى الموقع، اكتب عنوانك يدوياً';

  @override
  String get locationServiceDisabled =>
      'خدمة الموقع مغلقة، شغّلها أو اكتب عنوانك يدوياً';

  @override
  String get locationManualEntry => 'إدخال العنوان يدوياً';

  @override
  String get locationSearching => 'جارٍ تحديد العنوان…';

  @override
  String get locationUnknownAddress => 'تعذّر تحديد اسم المكان، اكتبه بنفسك';

  @override
  String get locationConfirm => 'تأكيد الموقع';

  @override
  String get addressTitle => 'عناويني';

  @override
  String get addressAdd => 'إضافة عنوان';

  @override
  String get addressEdit => 'تعديل العنوان';

  @override
  String get addressLabel => 'اسم العنوان';

  @override
  String get addressLabelHint => 'المنزل، العمل…';

  @override
  String get addressWilaya => 'الولاية';

  @override
  String get addressCommune => 'البلدية';

  @override
  String get addressStreet => 'الشارع والرقم';

  @override
  String get addressNotes => 'ملاحظات للسائق';

  @override
  String get addressNotesHint => 'الطابق، رقم الباب، علامة مميزة…';

  @override
  String get addressSetDefault => 'اجعله العنوان الافتراضي';

  @override
  String get addressDefault => 'افتراضي';

  @override
  String get addressEmpty => 'لم تضف أي عنوان بعد';

  @override
  String get addressDeleteConfirm => 'هل تريد حذف هذا العنوان؟';

  @override
  String get homeDeliverTo => 'التوصيل إلى';

  @override
  String get homeSearchHint => 'ماذا تريد أن تأكل؟';

  @override
  String get homeCategories => 'الفئات';

  @override
  String get homePopularNearby => 'الأكثر شعبية بالقرب منك';

  @override
  String get homeOffers => 'العروض';

  @override
  String get homeNoVendors => 'لا توجد متاجر متاحة في منطقتك حالياً';

  @override
  String get homeNoOffers => 'لا توجد عروض حالياً';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navOrders => 'الطلبات';

  @override
  String get navProfile => 'حسابي';

  @override
  String get navCart => 'السلة';

  @override
  String get vendorsTitle => 'المتاجر';

  @override
  String get vendorClosed => 'مغلق حالياً';

  @override
  String get vendorOpen => 'مفتوح';

  @override
  String vendorMinOrder(String amount) {
    return 'الحد الأدنى $amount';
  }

  @override
  String vendorDeliveryFee(String amount) {
    return 'التوصيل $amount';
  }

  @override
  String vendorMinutes(int count) {
    return '$count دقيقة';
  }

  @override
  String vendorKm(String value) {
    return '$value كلم';
  }

  @override
  String vendorRatings(int count) {
    return '($count تقييم)';
  }

  @override
  String get vendorSearchHint => 'ابحث في القائمة';

  @override
  String get vendorSpecialOffers => 'عروض خاصة';

  @override
  String get vendorEmptyMenu => 'لا توجد منتجات في هذا المتجر بعد';

  @override
  String get vendorClosedCta => 'المتجر مغلق حالياً';

  @override
  String get filterTitle => 'تصفية النتائج';

  @override
  String get filterOpenNow => 'مفتوح الآن';

  @override
  String get filterHasOffer => 'لديه عروض';

  @override
  String get filterSort => 'الترتيب';

  @override
  String get filterSortNearest => 'الأقرب';

  @override
  String get filterSortFastest => 'الأسرع';

  @override
  String get filterSortRating => 'الأعلى تقييماً';

  @override
  String get filterSortFeatured => 'المميزة';

  @override
  String get filterCategory => 'الفئة';

  @override
  String get filterAll => 'الكل';

  @override
  String get productAddToCart => 'إضافة إلى السلة';

  @override
  String get productUnavailable => 'غير متوفر حالياً';

  @override
  String get productQuantity => 'الكمية';

  @override
  String get productRequiredOption => 'اختيار مطلوب';

  @override
  String get productChooseOne => 'اختر واحداً';

  @override
  String get productChooseMany => 'اختر ما تريد';

  @override
  String get productAdded => 'تمت الإضافة إلى السلة';

  @override
  String get cartTitle => 'السلة';

  @override
  String get cartEmpty => 'سلتك فارغة';

  @override
  String get cartEmptyAction => 'تصفّح المتاجر';

  @override
  String get cartGoToCart => 'إذهب إلى السلة';

  @override
  String get cartTotal => 'المجموع';

  @override
  String get cartClearTitle => 'متجر مختلف';

  @override
  String get cartClearMessage =>
      'سلتك تحتوي منتجات من متجر آخر. هل تريد إفراغها والبدء من جديد؟';

  @override
  String get cartClearConfirm => 'إفراغ السلة';

  @override
  String cartItemCount(int count) {
    return '$count منتج';
  }

  @override
  String get cartRemoveItem => 'حذف المنتج';

  @override
  String get checkoutTitle => 'إتمام الطلب';

  @override
  String get checkoutAddress => 'عنوان التوصيل';

  @override
  String get checkoutChangeAddress => 'تغيير';

  @override
  String get checkoutDeliveryType => 'نوع التوصيل';

  @override
  String get checkoutDeliveryNormal => 'توصيل عادي';

  @override
  String get checkoutDeliveryVip => 'توصيل VIP';

  @override
  String get checkoutDeliveryVipHint => 'أولوية في التحضير والتوصيل';

  @override
  String get checkoutPayment => 'طريقة الدفع';

  @override
  String get checkoutPaymentCash => 'كاش';

  @override
  String get checkoutPaymentElectronic => 'الكتروني';

  @override
  String get checkoutPaymentSoon => 'قريباً';

  @override
  String get checkoutVoucher => 'القسيمة';

  @override
  String get checkoutVoucherHint => 'أدخل رمز القسيمة';

  @override
  String get checkoutVoucherApply => 'تطبيق';

  @override
  String get checkoutVoucherRemove => 'إزالة';

  @override
  String get checkoutUsePoints => 'استخدام النقاط';

  @override
  String checkoutPointsBalance(int count) {
    return 'لديك $count نقطة';
  }

  @override
  String get checkoutNote => 'ملاحظة للمتجر';

  @override
  String get checkoutNoteHint => 'مثال: بدون بصل، اتصل عند الوصول…';

  @override
  String get checkoutSubtotal => 'المجموع';

  @override
  String get checkoutServiceFee => 'رسوم الخدمة';

  @override
  String get checkoutDeliveryFee => 'التوصيل';

  @override
  String get checkoutDiscount => 'الخصم';

  @override
  String get checkoutGrandTotal => 'المجموع الكلي';

  @override
  String get checkoutSubmit => 'تاكيد الطلب';

  @override
  String get checkoutNoAddress => 'أضف عنواناً قبل إتمام الطلب';

  @override
  String get successTitle => 'تم استلام طلبك';

  @override
  String get successMessage => 'سنتصل بك لتأكيد الطلب';

  @override
  String successOrderCode(String code) {
    return 'رقم الطلب $code';
  }

  @override
  String get successTrack => 'تتبّع الطلب';

  @override
  String get successBackHome => 'العودة إلى الرئيسية';

  @override
  String get ordersTitle => 'طلباتي';

  @override
  String get ordersEmpty => 'لم تطلب أي شيء بعد';

  @override
  String get ordersEmptyAction => 'ابدأ التسوّق';

  @override
  String get ordersActive => 'الجارية';

  @override
  String get ordersHistory => 'السابقة';

  @override
  String get ordersReorder => 'إعادة الطلب';

  @override
  String get ordersRate => 'تقييم الطلب';

  @override
  String get ordersCancel => 'إلغاء الطلب';

  @override
  String get ordersCancelReason => 'سبب الإلغاء';

  @override
  String get ordersCancelReasonHint => 'أخبرنا لماذا تريد الإلغاء';

  @override
  String get ordersCancelled => 'تم إلغاء الطلب';

  @override
  String get ordersDetails => 'تفاصيل الطلب';

  @override
  String get ordersItems => 'المنتجات';

  @override
  String get ordersCallAgent => 'الاتصال بالسائق';

  @override
  String get ordersCallVendor => 'الاتصال بالمتجر';

  @override
  String get ordersCallSupport => 'الاتصال بالدعم';

  @override
  String get ordersAgentOnWay => 'السائق في الطريق إليك';

  @override
  String get ordersNoAgentYet => 'لم يُسند الطلب إلى سائق بعد';

  @override
  String get statusPending => 'بانتظار التأكيد';

  @override
  String get statusConfirmed => 'تم التأكيد';

  @override
  String get statusSentToVendor => 'أُرسل إلى المتجر';

  @override
  String get statusPreparing => 'قيد التحضير';

  @override
  String get statusReady => 'جاهز للاستلام';

  @override
  String get statusAssigned => 'أُسند إلى سائق';

  @override
  String get statusAccepted => 'قبله السائق';

  @override
  String get statusPickedUp => 'استلمه السائق';

  @override
  String get statusOnTheWay => 'في الطريق إليك';

  @override
  String get statusDelivered => 'تم التوصيل';

  @override
  String get statusCancelled => 'ملغى';

  @override
  String get statusLate => 'متأخر';

  @override
  String get ratingTitle => 'كيف كانت تجربتك؟';

  @override
  String get ratingVendor => 'تقييم المتجر';

  @override
  String get ratingAgent => 'تقييم السائق';

  @override
  String get ratingComment => 'تعليقك';

  @override
  String get ratingCommentHint => 'شاركنا رأيك (اختياري)';

  @override
  String get ratingSubmit => 'إرسال التقييم';

  @override
  String get ratingThanks => 'شكراً على تقييمك';

  @override
  String get profileTitle => 'حسابي';

  @override
  String get profileAccount => 'الحساب';

  @override
  String get profileEditProfile => 'تعديل الملف الشخصي';

  @override
  String get profileMyAddresses => 'عناويني';

  @override
  String get profileMyPoints => 'نقاطي';

  @override
  String profilePointsValue(int count) {
    return '$count نقطة';
  }

  @override
  String get profileVouchers => 'قسائم و كوبونات';

  @override
  String get profileSettings => 'الإعدادات';

  @override
  String get profileNotifications => 'الإشعارات';

  @override
  String get profileLanguage => 'اللغة';

  @override
  String get profileFollowUs => 'تابعنا';

  @override
  String get profileJoinUs => 'انضم إلينا';

  @override
  String get profileJoinUsHint => 'هل لديك متجر أو تريد العمل كسائق؟';

  @override
  String get profileSupport => 'الدعم والمساعدة';

  @override
  String get profileAbout => 'عن ساجي';

  @override
  String get profileDangerZone => 'منطقة الخطر';

  @override
  String get profileDeleteAccount => 'حذف الحساب';

  @override
  String get profileDeleteConfirm => 'سيتم حذف حسابك نهائياً. هل أنت متأكد؟';

  @override
  String get agentTitle => 'لوحة السائق';

  @override
  String get agentOnline => 'متصل';

  @override
  String get agentOffline => 'غير متصل';

  @override
  String get agentGoOnline => 'ابدأ العمل';

  @override
  String get agentGoOffline => 'أنهِ العمل';

  @override
  String get agentOfflineHint => 'لن تصلك طلبات وأنت غير متصل';

  @override
  String get agentNewOffer => 'طلب توصيل جديد';

  @override
  String get agentAccept => 'قبول';

  @override
  String get agentReject => 'رفض';

  @override
  String get agentRejectReason => 'سبب الرفض';

  @override
  String get agentRejectTooFar => 'المسافة بعيدة';

  @override
  String get agentRejectBusy => 'مشغول بطلب آخر';

  @override
  String get agentRejectVehicle => 'مشكل في المركبة';

  @override
  String get agentRejectOther => 'سبب آخر';

  @override
  String get agentNoOffers => 'لا توجد طلبات جديدة الآن';

  @override
  String get agentActiveDelivery => 'التوصيل الحالي';

  @override
  String get agentNoActiveDelivery => 'لا يوجد توصيل جارٍ';

  @override
  String get agentPickup => 'الاستلام';

  @override
  String get agentDropoff => 'التسليم';

  @override
  String get agentNavigate => 'فتح الخريطة';

  @override
  String get agentSwipePickedUp => 'اسحب لتأكيد الاستلام';

  @override
  String get agentSwipeOnTheWay => 'اسحب لبدء التوصيل';

  @override
  String get agentSwipeDelivered => 'اسحب لتأكيد التسليم';

  @override
  String get agentCashCollected => 'أكّد استلام المبلغ نقداً';

  @override
  String agentCashAmount(String amount) {
    return 'المبلغ المطلوب $amount';
  }

  @override
  String get agentHistory => 'سجل التوصيلات';

  @override
  String get agentStats => 'إحصائياتي';

  @override
  String get agentDeliveries => 'التوصيلات';

  @override
  String get agentEarnings => 'الأرباح';

  @override
  String get agentAvgTime => 'متوسط المدة';

  @override
  String get agentTodayDeliveries => 'توصيلات اليوم';

  @override
  String agentOfferExpires(int seconds) {
    return 'تبقّى $seconds ثانية';
  }

  @override
  String get agentOfferExpired => 'انتهت مهلة هذا الطلب';

  @override
  String get agentPayout => 'أجر التوصيل';

  @override
  String get agentDistance => 'المسافة';

  @override
  String get agentLocationRunning => 'تتبّع الموقع نشط';

  @override
  String get adminDashboard => 'لوحة القيادة';

  @override
  String get adminOrders => 'الطلبات';

  @override
  String get adminCustomers => 'العملاء';

  @override
  String get adminAgents => 'السائقون';

  @override
  String get adminVendors => 'المتاجر';

  @override
  String get adminProducts => 'المنتجات';

  @override
  String get adminCategories => 'الفئات';

  @override
  String get adminOffers => 'العروض';

  @override
  String get adminVouchers => 'القسائم';

  @override
  String get adminAnalytics => 'التحليلات';

  @override
  String get adminFleet => 'خريطة الأسطول';

  @override
  String get adminSettings => 'الإعدادات';

  @override
  String get adminStatTodayOrders => 'طلبات اليوم';

  @override
  String get adminStatRevenue => 'المداخيل';

  @override
  String get adminStatActiveDeliveries => 'توصيلات جارية';

  @override
  String get adminStatAvgTime => 'متوسط مدة التوصيل';

  @override
  String get adminStatLate => 'طلبات متأخرة';

  @override
  String get adminStatPending => 'بانتظار التأكيد';

  @override
  String get adminStatOnlineAgents => 'سائقون متصلون';

  @override
  String get adminOrderNew => 'طلب جديد وصل';

  @override
  String get adminOrderLate => 'طلب متأخر';

  @override
  String get adminCustomerInfo => 'معلومات الزبون';

  @override
  String get adminDeliveryInfo => 'معلومات التوصيل';

  @override
  String get adminCustomerNote => 'ملاحظة من الزبون';

  @override
  String get adminCallCustomer => 'اتصل بالزبون';

  @override
  String get adminCallVendor => 'اتصل بالمتجر';

  @override
  String get adminConfirmOrder => 'تأكيد الطلب';

  @override
  String get adminSendToVendor => 'إرسال إلى المتجر';

  @override
  String get adminMarkPreparing => 'بدأ التحضير';

  @override
  String get adminMarkReady => 'جاهز';

  @override
  String get adminAssignAgent => 'إسناد إلى سائق';

  @override
  String get adminCancelOrder => 'إلغاء الطلب';

  @override
  String get adminCancelReason => 'سبب الإلغاء';

  @override
  String get adminAssignTitle => 'اختر سائقاً';

  @override
  String get adminAssignEmpty => 'لا يوجد سائق متصل حالياً';

  @override
  String adminAgentLoad(int count) {
    return '$count طلب جارٍ';
  }

  @override
  String get adminSearchOrders => 'ابحث برقم الطلب أو الهاتف';

  @override
  String get adminExportCsv => 'تصدير CSV';

  @override
  String get adminNoOrders => 'لا توجد طلبات مطابقة';

  @override
  String get adminColOrderCode => 'رقم الطلب';

  @override
  String get adminColTime => 'الوقت';

  @override
  String get adminColStatus => 'الحالة';

  @override
  String get adminColUses => 'الاستعمالات';

  @override
  String get adminColName => 'الاسم';

  @override
  String get adminColActions => 'إجراءات';

  @override
  String get adminVendorNew => 'متجر جديد';

  @override
  String get adminVendorEdit => 'تعديل المتجر';

  @override
  String get adminVendorName => 'اسم المتجر';

  @override
  String get adminVendorSlug => 'المعرّف';

  @override
  String get adminVendorDescription => 'الوصف';

  @override
  String get adminVendorPhone => 'هاتف المتجر';

  @override
  String get adminVendorAddress => 'العنوان';

  @override
  String get adminVendorLocation => 'الموقع على الخريطة';

  @override
  String get adminVendorHours => 'أوقات العمل';

  @override
  String get adminVendorFees => 'الرسوم';

  @override
  String get adminVendorPrepTime => 'مدة التحضير (دقيقة)';

  @override
  String get adminVendorFeatured => 'متجر مميز';

  @override
  String get adminVendorIsOpen => 'مفتوح';

  @override
  String get adminVendorLogo => 'الشعار';

  @override
  String get adminVendorCover => 'صورة الغلاف';

  @override
  String get adminSectionNew => 'قسم جديد';

  @override
  String get adminSectionName => 'اسم القسم';

  @override
  String get adminProductNew => 'منتج جديد';

  @override
  String get adminProductEdit => 'تعديل المنتج';

  @override
  String get adminProductName => 'اسم المنتج';

  @override
  String get adminProductPrice => 'السعر بالدينار';

  @override
  String get adminProductAvailable => 'متوفر';

  @override
  String get adminProductOptions => 'الخيارات';

  @override
  String get adminProductOptionName => 'اسم الخيار';

  @override
  String get adminProductOptionValue => 'القيمة';

  @override
  String get adminProductOptionDelta => 'فرق السعر';

  @override
  String get adminProductAddOption => 'إضافة خيار';

  @override
  String get adminProductBulkAvailable => 'تفعيل المحدد';

  @override
  String get adminProductBulkUnavailable => 'تعطيل المحدد';

  @override
  String get adminOfferNew => 'عرض جديد';

  @override
  String get adminOfferTitle => 'عنوان العرض';

  @override
  String get adminOfferSubtitle => 'العنوان الفرعي';

  @override
  String get adminOfferType => 'نوع العرض';

  @override
  String get adminOfferTypePercentage => 'نسبة مئوية';

  @override
  String get adminOfferTypeFixed => 'مبلغ ثابت';

  @override
  String get adminOfferTypeFreeDelivery => 'توصيل مجاني';

  @override
  String get adminOfferTypeBundle => 'عرض مجمّع';

  @override
  String get adminOfferValue => 'القيمة';

  @override
  String get adminOfferScope => 'نطاق العرض';

  @override
  String get adminOfferPlatform => 'كل المنصة';

  @override
  String get adminOfferSchedule => 'الفترة';

  @override
  String get adminOfferShowOnHome => 'إظهار في الصفحة الرئيسية';

  @override
  String get adminOfferPreview => 'معاينة';

  @override
  String get adminVoucherNew => 'قسيمة جديدة';

  @override
  String get adminVoucherCode => 'الرمز';

  @override
  String get adminVoucherMinOrder => 'الحد الأدنى للطلب';

  @override
  String get adminVoucherMaxUses => 'أقصى عدد استعمالات';

  @override
  String get adminVoucherPerUser => 'لكل مستخدم';

  @override
  String adminVoucherUsed(int count) {
    return 'استُعملت $count مرة';
  }

  @override
  String get adminAgentNew => 'سائق جديد';

  @override
  String get adminAgentTempPassword => 'كلمة مرور مؤقتة';

  @override
  String get adminAgentSuspend => 'تعليق الحساب';

  @override
  String get adminAgentActivate => 'تفعيل الحساب';

  @override
  String get adminCustomerBlock => 'حظر العميل';

  @override
  String get adminCustomerUnblock => 'رفع الحظر';

  @override
  String get adminCustomerBlocked => 'محظور';

  @override
  String get adminCustomerOrders => 'عدد الطلبات';

  @override
  String get adminCustomerSpent => 'إجمالي المشتريات';

  @override
  String get adminAnalyticsOrdersOverTime => 'الطلبات عبر الزمن';

  @override
  String get adminAnalyticsTopVendors => 'أفضل المتاجر';

  @override
  String get adminAnalyticsTopProducts => 'أكثر المنتجات مبيعاً';

  @override
  String get adminAnalyticsAgents => 'ترتيب السائقين';

  @override
  String get adminAnalyticsCancellations => 'أسباب الإلغاء';

  @override
  String get adminAnalyticsRange => 'الفترة';

  @override
  String get adminFleetIdle => 'متفرّغ';

  @override
  String get adminFleetOnDelivery => 'في توصيل';

  @override
  String get adminFleetEmpty => 'لا يوجد سائق متصل';

  @override
  String adminFleetLastSeen(String time) {
    return 'آخر ظهور $time';
  }

  @override
  String get settingsServiceFee => 'رسوم الخدمة';

  @override
  String get settingsVipSurcharge => 'رسوم VIP الإضافية';

  @override
  String get settingsAssignTimeout => 'مهلة قبول الطلب (ثانية)';

  @override
  String get settingsLateThreshold => 'حد التأخير (دقيقة)';

  @override
  String get settingsSupportPhone => 'هاتف الدعم';

  @override
  String get settingsDeliveryRadius => 'نطاق التوصيل (كلم)';

  @override
  String get settingsPointsPerHundred => 'نقاط لكل 100 دج';

  @override
  String get settingsPointValue => 'قيمة النقطة بالسنتيم';

  @override
  String get settingsMaxPointsPercent => 'أقصى نسبة نقاط من المجموع';

  @override
  String get settingsElectronicPayment => 'تفعيل الدفع الإلكتروني';

  @override
  String get settingsSaved => 'تم حفظ الإعدادات';

  @override
  String get emptyTitle => 'لا يوجد شيء هنا';

  @override
  String get emptySearch => 'لا توجد نتائج لبحثك';

  @override
  String get errorRetryTitle => 'تعذّر تحميل البيانات';

  @override
  String get offlineBanner => 'أنت غير متصل — نعرض آخر البيانات المحفوظة';

  @override
  String get currencySymbol => 'د.ج';

  @override
  String amountWithCurrency(String amount) {
    return '$amount د.ج';
  }

  @override
  String get adminImagePick => 'Tap to choose an image';

  @override
  String get adminImageRemove => 'Remove image';

  @override
  String get adminProductImage => 'Product image';

  @override
  String get adminOfferImage => 'Offer image';
}
