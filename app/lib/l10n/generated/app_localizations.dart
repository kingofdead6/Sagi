import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'ساجي'**
  String get appName;

  /// No description provided for @welcomeTitle.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك في ساجي'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'كل ما تحتاجه، يصلك إلى باب دارك'**
  String get welcomeSubtitle;

  /// No description provided for @commonRetry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get commonConfirm;

  /// No description provided for @commonSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get commonEdit;

  /// No description provided for @commonAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get commonAdd;

  /// No description provided for @commonClose.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get commonClose;

  /// No description provided for @commonSearch.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get commonSearch;

  /// No description provided for @commonNext.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get commonBack;

  /// No description provided for @commonSeeAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get commonSeeAll;

  /// No description provided for @commonYes.
  ///
  /// In ar, this message translates to:
  /// **'نعم'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In ar, this message translates to:
  /// **'لا'**
  String get commonNo;

  /// No description provided for @commonLoading.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ التحميل…'**
  String get commonLoading;

  /// No description provided for @commonOptional.
  ///
  /// In ar, this message translates to:
  /// **'اختياري'**
  String get commonOptional;

  /// No description provided for @commonRequired.
  ///
  /// In ar, this message translates to:
  /// **'مطلوب'**
  String get commonRequired;

  /// No description provided for @commonCall.
  ///
  /// In ar, this message translates to:
  /// **'اتصال'**
  String get commonCall;

  /// No description provided for @commonFilter.
  ///
  /// In ar, this message translates to:
  /// **'تصفية'**
  String get commonFilter;

  /// No description provided for @commonApply.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق'**
  String get commonApply;

  /// No description provided for @commonReset.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين'**
  String get commonReset;

  /// No description provided for @commonToday.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get commonToday;

  /// No description provided for @commonNone.
  ///
  /// In ar, this message translates to:
  /// **'لا شيء'**
  String get commonNone;

  /// No description provided for @commonRefresh.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get commonRefresh;

  /// No description provided for @commonExport.
  ///
  /// In ar, this message translates to:
  /// **'تصدير'**
  String get commonExport;

  /// No description provided for @errorGeneric.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع، حاول من جديد'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد اتصال بالإنترنت، تحقق من الشبكة'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In ar, this message translates to:
  /// **'استغرق الطلب وقتاً طويلاً، حاول من جديد'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In ar, this message translates to:
  /// **'الخادم لا يستجيب حالياً، حاول بعد قليل'**
  String get errorServer;

  /// No description provided for @errorUnauthorized.
  ///
  /// In ar, this message translates to:
  /// **'انتهت الجلسة، سجّل الدخول من جديد'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In ar, this message translates to:
  /// **'لا تملك صلاحية هذا الإجراء'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In ar, this message translates to:
  /// **'العنصر غير موجود'**
  String get errorNotFound;

  /// No description provided for @errorConflict.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن تنفيذ هذا الإجراء الآن'**
  String get errorConflict;

  /// No description provided for @errorValidation.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من البيانات المُدخلة'**
  String get errorValidation;

  /// No description provided for @errorTooMany.
  ///
  /// In ar, this message translates to:
  /// **'محاولات كثيرة، انتظر قليلاً'**
  String get errorTooMany;

  /// No description provided for @authLoginTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get authLoginTitle;

  /// No description provided for @authRegisterTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get authRegisterTitle;

  /// No description provided for @authPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get authPhone;

  /// No description provided for @authPhoneHint.
  ///
  /// In ar, this message translates to:
  /// **'0X XX XX XX XX'**
  String get authPhoneHint;

  /// No description provided for @authPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get authPassword;

  /// No description provided for @authPasswordHint.
  ///
  /// In ar, this message translates to:
  /// **'6 أحرف على الأقل'**
  String get authPasswordHint;

  /// No description provided for @authFullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get authFullName;

  /// No description provided for @authFullNameHint.
  ///
  /// In ar, this message translates to:
  /// **'اسمك ولقبك'**
  String get authFullNameHint;

  /// No description provided for @authLogin.
  ///
  /// In ar, this message translates to:
  /// **'دخول'**
  String get authLogin;

  /// No description provided for @authRegister.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الحساب'**
  String get authRegister;

  /// No description provided for @authNoAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟'**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'لديك حساب بالفعل؟'**
  String get authHaveAccount;

  /// No description provided for @authLogout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get authLogout;

  /// No description provided for @authLogoutConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد تسجيل الخروج من حسابك؟'**
  String get authLogoutConfirm;

  /// No description provided for @authInvalidPhone.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم هاتف جزائري صالح'**
  String get authInvalidPhone;

  /// No description provided for @authInvalidPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور يجب أن تحتوي 6 أحرف على الأقل'**
  String get authInvalidPassword;

  /// No description provided for @authInvalidName.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسمك الكامل'**
  String get authInvalidName;

  /// No description provided for @authOtpTitle.
  ///
  /// In ar, this message translates to:
  /// **'رمز التحقق'**
  String get authOtpTitle;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرمز المرسل إلى {phone}'**
  String authOtpSubtitle(String phone);

  /// No description provided for @authOtpResend.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال الرمز'**
  String get authOtpResend;

  /// No description provided for @authOtpDisabled.
  ///
  /// In ar, this message translates to:
  /// **'التحقق عبر الرمز غير مفعّل حالياً، استعمل كلمة المرور'**
  String get authOtpDisabled;

  /// No description provided for @authChangePassword.
  ///
  /// In ar, this message translates to:
  /// **'تغيير كلمة المرور'**
  String get authChangePassword;

  /// No description provided for @authCurrentPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الحالية'**
  String get authCurrentPassword;

  /// No description provided for @authNewPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الجديدة'**
  String get authNewPassword;

  /// No description provided for @locationTitle.
  ///
  /// In ar, this message translates to:
  /// **'أين نوصّل طلبك؟'**
  String get locationTitle;

  /// No description provided for @locationSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حدّد موقعك على الخريطة أو اكتب عنوانك'**
  String get locationSubtitle;

  /// No description provided for @locationUseGps.
  ///
  /// In ar, this message translates to:
  /// **'استعمال موقعي الحالي'**
  String get locationUseGps;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In ar, this message translates to:
  /// **'لم يُسمح بالوصول إلى الموقع، اكتب عنوانك يدوياً'**
  String get locationPermissionDenied;

  /// No description provided for @locationServiceDisabled.
  ///
  /// In ar, this message translates to:
  /// **'خدمة الموقع مغلقة، شغّلها أو اكتب عنوانك يدوياً'**
  String get locationServiceDisabled;

  /// No description provided for @locationManualEntry.
  ///
  /// In ar, this message translates to:
  /// **'إدخال العنوان يدوياً'**
  String get locationManualEntry;

  /// No description provided for @locationSearching.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تحديد العنوان…'**
  String get locationSearching;

  /// No description provided for @locationUnknownAddress.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحديد اسم المكان، اكتبه بنفسك'**
  String get locationUnknownAddress;

  /// No description provided for @locationConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الموقع'**
  String get locationConfirm;

  /// No description provided for @addressTitle.
  ///
  /// In ar, this message translates to:
  /// **'عناويني'**
  String get addressTitle;

  /// No description provided for @addressAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عنوان'**
  String get addressAdd;

  /// No description provided for @addressEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل العنوان'**
  String get addressEdit;

  /// No description provided for @addressLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم العنوان'**
  String get addressLabel;

  /// No description provided for @addressLabelHint.
  ///
  /// In ar, this message translates to:
  /// **'المنزل، العمل…'**
  String get addressLabelHint;

  /// No description provided for @addressWilaya.
  ///
  /// In ar, this message translates to:
  /// **'الولاية'**
  String get addressWilaya;

  /// No description provided for @addressCommune.
  ///
  /// In ar, this message translates to:
  /// **'البلدية'**
  String get addressCommune;

  /// No description provided for @addressStreet.
  ///
  /// In ar, this message translates to:
  /// **'الشارع والرقم'**
  String get addressStreet;

  /// No description provided for @addressNotes.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات للسائق'**
  String get addressNotes;

  /// No description provided for @addressNotesHint.
  ///
  /// In ar, this message translates to:
  /// **'الطابق، رقم الباب، علامة مميزة…'**
  String get addressNotesHint;

  /// No description provided for @addressSetDefault.
  ///
  /// In ar, this message translates to:
  /// **'اجعله العنوان الافتراضي'**
  String get addressSetDefault;

  /// No description provided for @addressDefault.
  ///
  /// In ar, this message translates to:
  /// **'افتراضي'**
  String get addressDefault;

  /// No description provided for @addressEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لم تضف أي عنوان بعد'**
  String get addressEmpty;

  /// No description provided for @addressDeleteConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد حذف هذا العنوان؟'**
  String get addressDeleteConfirm;

  /// No description provided for @homeDeliverTo.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل إلى'**
  String get homeDeliverTo;

  /// No description provided for @homeSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ماذا تريد أن تأكل؟'**
  String get homeSearchHint;

  /// No description provided for @homeCategories.
  ///
  /// In ar, this message translates to:
  /// **'الفئات'**
  String get homeCategories;

  /// No description provided for @homePopularNearby.
  ///
  /// In ar, this message translates to:
  /// **'الأكثر شعبية بالقرب منك'**
  String get homePopularNearby;

  /// No description provided for @homeOffers.
  ///
  /// In ar, this message translates to:
  /// **'العروض'**
  String get homeOffers;

  /// No description provided for @homeNoVendors.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد متاجر متاحة في منطقتك حالياً'**
  String get homeNoVendors;

  /// No description provided for @homeNoOffers.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عروض حالياً'**
  String get homeNoOffers;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @navOrders.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات'**
  String get navOrders;

  /// No description provided for @navProfile.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get navProfile;

  /// No description provided for @navCart.
  ///
  /// In ar, this message translates to:
  /// **'السلة'**
  String get navCart;

  /// No description provided for @vendorsTitle.
  ///
  /// In ar, this message translates to:
  /// **'المتاجر'**
  String get vendorsTitle;

  /// No description provided for @vendorClosed.
  ///
  /// In ar, this message translates to:
  /// **'مغلق حالياً'**
  String get vendorClosed;

  /// No description provided for @vendorOpen.
  ///
  /// In ar, this message translates to:
  /// **'مفتوح'**
  String get vendorOpen;

  /// No description provided for @vendorMinOrder.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى {amount}'**
  String vendorMinOrder(String amount);

  /// No description provided for @vendorDeliveryFee.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل {amount}'**
  String vendorDeliveryFee(String amount);

  /// No description provided for @vendorMinutes.
  ///
  /// In ar, this message translates to:
  /// **'{count} دقيقة'**
  String vendorMinutes(int count);

  /// No description provided for @vendorKm.
  ///
  /// In ar, this message translates to:
  /// **'{value} كلم'**
  String vendorKm(String value);

  /// No description provided for @vendorRatings.
  ///
  /// In ar, this message translates to:
  /// **'({count} تقييم)'**
  String vendorRatings(int count);

  /// No description provided for @vendorSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في القائمة'**
  String get vendorSearchHint;

  /// No description provided for @vendorSpecialOffers.
  ///
  /// In ar, this message translates to:
  /// **'عروض خاصة'**
  String get vendorSpecialOffers;

  /// No description provided for @vendorEmptyMenu.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد منتجات في هذا المتجر بعد'**
  String get vendorEmptyMenu;

  /// No description provided for @vendorClosedCta.
  ///
  /// In ar, this message translates to:
  /// **'المتجر مغلق حالياً'**
  String get vendorClosedCta;

  /// No description provided for @filterTitle.
  ///
  /// In ar, this message translates to:
  /// **'تصفية النتائج'**
  String get filterTitle;

  /// No description provided for @filterOpenNow.
  ///
  /// In ar, this message translates to:
  /// **'مفتوح الآن'**
  String get filterOpenNow;

  /// No description provided for @filterHasOffer.
  ///
  /// In ar, this message translates to:
  /// **'لديه عروض'**
  String get filterHasOffer;

  /// No description provided for @filterSort.
  ///
  /// In ar, this message translates to:
  /// **'الترتيب'**
  String get filterSort;

  /// No description provided for @filterSortNearest.
  ///
  /// In ar, this message translates to:
  /// **'الأقرب'**
  String get filterSortNearest;

  /// No description provided for @filterSortFastest.
  ///
  /// In ar, this message translates to:
  /// **'الأسرع'**
  String get filterSortFastest;

  /// No description provided for @filterSortRating.
  ///
  /// In ar, this message translates to:
  /// **'الأعلى تقييماً'**
  String get filterSortRating;

  /// No description provided for @filterSortFeatured.
  ///
  /// In ar, this message translates to:
  /// **'المميزة'**
  String get filterSortFeatured;

  /// No description provided for @filterCategory.
  ///
  /// In ar, this message translates to:
  /// **'الفئة'**
  String get filterCategory;

  /// No description provided for @filterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get filterAll;

  /// No description provided for @productAddToCart.
  ///
  /// In ar, this message translates to:
  /// **'إضافة إلى السلة'**
  String get productAddToCart;

  /// No description provided for @productUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر حالياً'**
  String get productUnavailable;

  /// No description provided for @productQuantity.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get productQuantity;

  /// No description provided for @productRequiredOption.
  ///
  /// In ar, this message translates to:
  /// **'اختيار مطلوب'**
  String get productRequiredOption;

  /// No description provided for @productChooseOne.
  ///
  /// In ar, this message translates to:
  /// **'اختر واحداً'**
  String get productChooseOne;

  /// No description provided for @productChooseMany.
  ///
  /// In ar, this message translates to:
  /// **'اختر ما تريد'**
  String get productChooseMany;

  /// No description provided for @productAdded.
  ///
  /// In ar, this message translates to:
  /// **'تمت الإضافة إلى السلة'**
  String get productAdded;

  /// No description provided for @cartTitle.
  ///
  /// In ar, this message translates to:
  /// **'السلة'**
  String get cartTitle;

  /// No description provided for @cartEmpty.
  ///
  /// In ar, this message translates to:
  /// **'سلتك فارغة'**
  String get cartEmpty;

  /// No description provided for @cartEmptyAction.
  ///
  /// In ar, this message translates to:
  /// **'تصفّح المتاجر'**
  String get cartEmptyAction;

  /// No description provided for @cartGoToCart.
  ///
  /// In ar, this message translates to:
  /// **'إذهب إلى السلة'**
  String get cartGoToCart;

  /// No description provided for @cartTotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع'**
  String get cartTotal;

  /// No description provided for @cartClearTitle.
  ///
  /// In ar, this message translates to:
  /// **'متجر مختلف'**
  String get cartClearTitle;

  /// No description provided for @cartClearMessage.
  ///
  /// In ar, this message translates to:
  /// **'سلتك تحتوي منتجات من متجر آخر. هل تريد إفراغها والبدء من جديد؟'**
  String get cartClearMessage;

  /// No description provided for @cartClearConfirm.
  ///
  /// In ar, this message translates to:
  /// **'إفراغ السلة'**
  String get cartClearConfirm;

  /// No description provided for @cartItemCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} منتج'**
  String cartItemCount(int count);

  /// No description provided for @cartRemoveItem.
  ///
  /// In ar, this message translates to:
  /// **'حذف المنتج'**
  String get cartRemoveItem;

  /// No description provided for @checkoutTitle.
  ///
  /// In ar, this message translates to:
  /// **'إتمام الطلب'**
  String get checkoutTitle;

  /// No description provided for @checkoutAddress.
  ///
  /// In ar, this message translates to:
  /// **'عنوان التوصيل'**
  String get checkoutAddress;

  /// No description provided for @checkoutChangeAddress.
  ///
  /// In ar, this message translates to:
  /// **'تغيير'**
  String get checkoutChangeAddress;

  /// No description provided for @checkoutDeliveryType.
  ///
  /// In ar, this message translates to:
  /// **'نوع التوصيل'**
  String get checkoutDeliveryType;

  /// No description provided for @checkoutDeliveryNormal.
  ///
  /// In ar, this message translates to:
  /// **'توصيل عادي'**
  String get checkoutDeliveryNormal;

  /// No description provided for @checkoutDeliveryVip.
  ///
  /// In ar, this message translates to:
  /// **'توصيل VIP'**
  String get checkoutDeliveryVip;

  /// No description provided for @checkoutDeliveryVipHint.
  ///
  /// In ar, this message translates to:
  /// **'أولوية في التحضير والتوصيل'**
  String get checkoutDeliveryVipHint;

  /// No description provided for @checkoutPayment.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get checkoutPayment;

  /// No description provided for @checkoutPaymentCash.
  ///
  /// In ar, this message translates to:
  /// **'كاش'**
  String get checkoutPaymentCash;

  /// No description provided for @checkoutPaymentElectronic.
  ///
  /// In ar, this message translates to:
  /// **'الكتروني'**
  String get checkoutPaymentElectronic;

  /// No description provided for @checkoutPaymentSoon.
  ///
  /// In ar, this message translates to:
  /// **'قريباً'**
  String get checkoutPaymentSoon;

  /// No description provided for @checkoutVoucher.
  ///
  /// In ar, this message translates to:
  /// **'القسيمة'**
  String get checkoutVoucher;

  /// No description provided for @checkoutVoucherHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز القسيمة'**
  String get checkoutVoucherHint;

  /// No description provided for @checkoutVoucherApply.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق'**
  String get checkoutVoucherApply;

  /// No description provided for @checkoutVoucherRemove.
  ///
  /// In ar, this message translates to:
  /// **'إزالة'**
  String get checkoutVoucherRemove;

  /// No description provided for @checkoutUsePoints.
  ///
  /// In ar, this message translates to:
  /// **'استخدام النقاط'**
  String get checkoutUsePoints;

  /// No description provided for @checkoutPointsBalance.
  ///
  /// In ar, this message translates to:
  /// **'لديك {count} نقطة'**
  String checkoutPointsBalance(int count);

  /// No description provided for @checkoutNote.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة للمتجر'**
  String get checkoutNote;

  /// No description provided for @checkoutNoteHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: بدون بصل، اتصل عند الوصول…'**
  String get checkoutNoteHint;

  /// No description provided for @checkoutSubtotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع'**
  String get checkoutSubtotal;

  /// No description provided for @checkoutServiceFee.
  ///
  /// In ar, this message translates to:
  /// **'رسوم الخدمة'**
  String get checkoutServiceFee;

  /// No description provided for @checkoutDeliveryFee.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل'**
  String get checkoutDeliveryFee;

  /// No description provided for @checkoutDiscount.
  ///
  /// In ar, this message translates to:
  /// **'الخصم'**
  String get checkoutDiscount;

  /// No description provided for @checkoutGrandTotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع الكلي'**
  String get checkoutGrandTotal;

  /// No description provided for @checkoutSubmit.
  ///
  /// In ar, this message translates to:
  /// **'تاكيد الطلب'**
  String get checkoutSubmit;

  /// No description provided for @checkoutNoAddress.
  ///
  /// In ar, this message translates to:
  /// **'أضف عنواناً قبل إتمام الطلب'**
  String get checkoutNoAddress;

  /// No description provided for @successTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم استلام طلبك'**
  String get successTitle;

  /// No description provided for @successMessage.
  ///
  /// In ar, this message translates to:
  /// **'سنتصل بك لتأكيد الطلب'**
  String get successMessage;

  /// No description provided for @successOrderCode.
  ///
  /// In ar, this message translates to:
  /// **'رقم الطلب {code}'**
  String successOrderCode(String code);

  /// No description provided for @successTrack.
  ///
  /// In ar, this message translates to:
  /// **'تتبّع الطلب'**
  String get successTrack;

  /// No description provided for @successBackHome.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى الرئيسية'**
  String get successBackHome;

  /// No description provided for @ordersTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلباتي'**
  String get ordersTitle;

  /// No description provided for @ordersEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لم تطلب أي شيء بعد'**
  String get ordersEmpty;

  /// No description provided for @ordersEmptyAction.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ التسوّق'**
  String get ordersEmptyAction;

  /// No description provided for @ordersActive.
  ///
  /// In ar, this message translates to:
  /// **'الجارية'**
  String get ordersActive;

  /// No description provided for @ordersHistory.
  ///
  /// In ar, this message translates to:
  /// **'السابقة'**
  String get ordersHistory;

  /// No description provided for @ordersReorder.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الطلب'**
  String get ordersReorder;

  /// No description provided for @ordersRate.
  ///
  /// In ar, this message translates to:
  /// **'تقييم الطلب'**
  String get ordersRate;

  /// No description provided for @ordersCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب'**
  String get ordersCancel;

  /// No description provided for @ordersCancelReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب الإلغاء'**
  String get ordersCancelReason;

  /// No description provided for @ordersCancelReasonHint.
  ///
  /// In ar, this message translates to:
  /// **'أخبرنا لماذا تريد الإلغاء'**
  String get ordersCancelReasonHint;

  /// No description provided for @ordersCancelled.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء الطلب'**
  String get ordersCancelled;

  /// No description provided for @ordersDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الطلب'**
  String get ordersDetails;

  /// No description provided for @ordersItems.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات'**
  String get ordersItems;

  /// No description provided for @ordersCallAgent.
  ///
  /// In ar, this message translates to:
  /// **'الاتصال بالسائق'**
  String get ordersCallAgent;

  /// No description provided for @ordersCallVendor.
  ///
  /// In ar, this message translates to:
  /// **'الاتصال بالمتجر'**
  String get ordersCallVendor;

  /// No description provided for @ordersCallSupport.
  ///
  /// In ar, this message translates to:
  /// **'الاتصال بالدعم'**
  String get ordersCallSupport;

  /// No description provided for @ordersAgentOnWay.
  ///
  /// In ar, this message translates to:
  /// **'السائق في الطريق إليك'**
  String get ordersAgentOnWay;

  /// No description provided for @ordersNoAgentYet.
  ///
  /// In ar, this message translates to:
  /// **'لم يُسند الطلب إلى سائق بعد'**
  String get ordersNoAgentYet;

  /// No description provided for @statusPending.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار التأكيد'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In ar, this message translates to:
  /// **'تم التأكيد'**
  String get statusConfirmed;

  /// No description provided for @statusSentToVendor.
  ///
  /// In ar, this message translates to:
  /// **'أُرسل إلى المتجر'**
  String get statusSentToVendor;

  /// No description provided for @statusPreparing.
  ///
  /// In ar, this message translates to:
  /// **'قيد التحضير'**
  String get statusPreparing;

  /// No description provided for @statusReady.
  ///
  /// In ar, this message translates to:
  /// **'جاهز للاستلام'**
  String get statusReady;

  /// No description provided for @statusAssigned.
  ///
  /// In ar, this message translates to:
  /// **'أُسند إلى سائق'**
  String get statusAssigned;

  /// No description provided for @statusAccepted.
  ///
  /// In ar, this message translates to:
  /// **'قبله السائق'**
  String get statusAccepted;

  /// No description provided for @statusPickedUp.
  ///
  /// In ar, this message translates to:
  /// **'استلمه السائق'**
  String get statusPickedUp;

  /// No description provided for @statusOnTheWay.
  ///
  /// In ar, this message translates to:
  /// **'في الطريق إليك'**
  String get statusOnTheWay;

  /// No description provided for @statusDelivered.
  ///
  /// In ar, this message translates to:
  /// **'تم التوصيل'**
  String get statusDelivered;

  /// No description provided for @statusCancelled.
  ///
  /// In ar, this message translates to:
  /// **'ملغى'**
  String get statusCancelled;

  /// No description provided for @statusLate.
  ///
  /// In ar, this message translates to:
  /// **'متأخر'**
  String get statusLate;

  /// No description provided for @ratingTitle.
  ///
  /// In ar, this message translates to:
  /// **'كيف كانت تجربتك؟'**
  String get ratingTitle;

  /// No description provided for @ratingVendor.
  ///
  /// In ar, this message translates to:
  /// **'تقييم المتجر'**
  String get ratingVendor;

  /// No description provided for @ratingAgent.
  ///
  /// In ar, this message translates to:
  /// **'تقييم السائق'**
  String get ratingAgent;

  /// No description provided for @ratingComment.
  ///
  /// In ar, this message translates to:
  /// **'تعليقك'**
  String get ratingComment;

  /// No description provided for @ratingCommentHint.
  ///
  /// In ar, this message translates to:
  /// **'شاركنا رأيك (اختياري)'**
  String get ratingCommentHint;

  /// No description provided for @ratingSubmit.
  ///
  /// In ar, this message translates to:
  /// **'إرسال التقييم'**
  String get ratingSubmit;

  /// No description provided for @ratingThanks.
  ///
  /// In ar, this message translates to:
  /// **'شكراً على تقييمك'**
  String get ratingThanks;

  /// No description provided for @profileTitle.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get profileTitle;

  /// No description provided for @profileAccount.
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get profileAccount;

  /// No description provided for @profileEditProfile.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملف الشخصي'**
  String get profileEditProfile;

  /// No description provided for @profileMyAddresses.
  ///
  /// In ar, this message translates to:
  /// **'عناويني'**
  String get profileMyAddresses;

  /// No description provided for @profileMyPoints.
  ///
  /// In ar, this message translates to:
  /// **'نقاطي'**
  String get profileMyPoints;

  /// No description provided for @profilePointsValue.
  ///
  /// In ar, this message translates to:
  /// **'{count} نقطة'**
  String profilePointsValue(int count);

  /// No description provided for @profileVouchers.
  ///
  /// In ar, this message translates to:
  /// **'قسائم و كوبونات'**
  String get profileVouchers;

  /// No description provided for @profileSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get profileSettings;

  /// No description provided for @profileNotifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get profileNotifications;

  /// No description provided for @profileLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get profileLanguage;

  /// No description provided for @profileFollowUs.
  ///
  /// In ar, this message translates to:
  /// **'تابعنا'**
  String get profileFollowUs;

  /// No description provided for @profileJoinUs.
  ///
  /// In ar, this message translates to:
  /// **'انضم إلينا'**
  String get profileJoinUs;

  /// No description provided for @profileJoinUsHint.
  ///
  /// In ar, this message translates to:
  /// **'هل لديك متجر أو تريد العمل كسائق؟'**
  String get profileJoinUsHint;

  /// No description provided for @profileSupport.
  ///
  /// In ar, this message translates to:
  /// **'الدعم والمساعدة'**
  String get profileSupport;

  /// No description provided for @profileAbout.
  ///
  /// In ar, this message translates to:
  /// **'عن ساجي'**
  String get profileAbout;

  /// No description provided for @profileDangerZone.
  ///
  /// In ar, this message translates to:
  /// **'منطقة الخطر'**
  String get profileDangerZone;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteConfirm.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حذف حسابك نهائياً. هل أنت متأكد؟'**
  String get profileDeleteConfirm;

  /// No description provided for @agentTitle.
  ///
  /// In ar, this message translates to:
  /// **'لوحة السائق'**
  String get agentTitle;

  /// No description provided for @agentOnline.
  ///
  /// In ar, this message translates to:
  /// **'متصل'**
  String get agentOnline;

  /// No description provided for @agentOffline.
  ///
  /// In ar, this message translates to:
  /// **'غير متصل'**
  String get agentOffline;

  /// No description provided for @agentGoOnline.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ العمل'**
  String get agentGoOnline;

  /// No description provided for @agentGoOffline.
  ///
  /// In ar, this message translates to:
  /// **'أنهِ العمل'**
  String get agentGoOffline;

  /// No description provided for @agentOfflineHint.
  ///
  /// In ar, this message translates to:
  /// **'لن تصلك طلبات وأنت غير متصل'**
  String get agentOfflineHint;

  /// No description provided for @agentNewOffer.
  ///
  /// In ar, this message translates to:
  /// **'طلب توصيل جديد'**
  String get agentNewOffer;

  /// No description provided for @agentAccept.
  ///
  /// In ar, this message translates to:
  /// **'قبول'**
  String get agentAccept;

  /// No description provided for @agentReject.
  ///
  /// In ar, this message translates to:
  /// **'رفض'**
  String get agentReject;

  /// No description provided for @agentRejectReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب الرفض'**
  String get agentRejectReason;

  /// No description provided for @agentRejectTooFar.
  ///
  /// In ar, this message translates to:
  /// **'المسافة بعيدة'**
  String get agentRejectTooFar;

  /// No description provided for @agentRejectBusy.
  ///
  /// In ar, this message translates to:
  /// **'مشغول بطلب آخر'**
  String get agentRejectBusy;

  /// No description provided for @agentRejectVehicle.
  ///
  /// In ar, this message translates to:
  /// **'مشكل في المركبة'**
  String get agentRejectVehicle;

  /// No description provided for @agentRejectOther.
  ///
  /// In ar, this message translates to:
  /// **'سبب آخر'**
  String get agentRejectOther;

  /// No description provided for @agentNoOffers.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات جديدة الآن'**
  String get agentNoOffers;

  /// No description provided for @agentActiveDelivery.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل الحالي'**
  String get agentActiveDelivery;

  /// No description provided for @agentNoActiveDelivery.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد توصيل جارٍ'**
  String get agentNoActiveDelivery;

  /// No description provided for @agentPickup.
  ///
  /// In ar, this message translates to:
  /// **'الاستلام'**
  String get agentPickup;

  /// No description provided for @agentDropoff.
  ///
  /// In ar, this message translates to:
  /// **'التسليم'**
  String get agentDropoff;

  /// No description provided for @agentNavigate.
  ///
  /// In ar, this message translates to:
  /// **'فتح الخريطة'**
  String get agentNavigate;

  /// No description provided for @agentSwipePickedUp.
  ///
  /// In ar, this message translates to:
  /// **'اسحب لتأكيد الاستلام'**
  String get agentSwipePickedUp;

  /// No description provided for @agentSwipeOnTheWay.
  ///
  /// In ar, this message translates to:
  /// **'اسحب لبدء التوصيل'**
  String get agentSwipeOnTheWay;

  /// No description provided for @agentSwipeDelivered.
  ///
  /// In ar, this message translates to:
  /// **'اسحب لتأكيد التسليم'**
  String get agentSwipeDelivered;

  /// No description provided for @agentCashCollected.
  ///
  /// In ar, this message translates to:
  /// **'أكّد استلام المبلغ نقداً'**
  String get agentCashCollected;

  /// No description provided for @agentCashAmount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المطلوب {amount}'**
  String agentCashAmount(String amount);

  /// No description provided for @agentHistory.
  ///
  /// In ar, this message translates to:
  /// **'سجل التوصيلات'**
  String get agentHistory;

  /// No description provided for @agentStats.
  ///
  /// In ar, this message translates to:
  /// **'إحصائياتي'**
  String get agentStats;

  /// No description provided for @agentDeliveries.
  ///
  /// In ar, this message translates to:
  /// **'التوصيلات'**
  String get agentDeliveries;

  /// No description provided for @agentEarnings.
  ///
  /// In ar, this message translates to:
  /// **'الأرباح'**
  String get agentEarnings;

  /// No description provided for @agentAvgTime.
  ///
  /// In ar, this message translates to:
  /// **'متوسط المدة'**
  String get agentAvgTime;

  /// No description provided for @agentTodayDeliveries.
  ///
  /// In ar, this message translates to:
  /// **'توصيلات اليوم'**
  String get agentTodayDeliveries;

  /// No description provided for @agentOfferExpires.
  ///
  /// In ar, this message translates to:
  /// **'تبقّى {seconds} ثانية'**
  String agentOfferExpires(int seconds);

  /// No description provided for @agentOfferExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت مهلة هذا الطلب'**
  String get agentOfferExpired;

  /// No description provided for @agentPayout.
  ///
  /// In ar, this message translates to:
  /// **'أجر التوصيل'**
  String get agentPayout;

  /// No description provided for @agentDistance.
  ///
  /// In ar, this message translates to:
  /// **'المسافة'**
  String get agentDistance;

  /// No description provided for @agentLocationRunning.
  ///
  /// In ar, this message translates to:
  /// **'تتبّع الموقع نشط'**
  String get agentLocationRunning;

  /// No description provided for @adminDashboard.
  ///
  /// In ar, this message translates to:
  /// **'لوحة القيادة'**
  String get adminDashboard;

  /// No description provided for @adminOrders.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات'**
  String get adminOrders;

  /// No description provided for @adminCustomers.
  ///
  /// In ar, this message translates to:
  /// **'العملاء'**
  String get adminCustomers;

  /// No description provided for @adminAgents.
  ///
  /// In ar, this message translates to:
  /// **'السائقون'**
  String get adminAgents;

  /// No description provided for @adminVendors.
  ///
  /// In ar, this message translates to:
  /// **'المتاجر'**
  String get adminVendors;

  /// No description provided for @adminProducts.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات'**
  String get adminProducts;

  /// No description provided for @adminCategories.
  ///
  /// In ar, this message translates to:
  /// **'الفئات'**
  String get adminCategories;

  /// No description provided for @adminOffers.
  ///
  /// In ar, this message translates to:
  /// **'العروض'**
  String get adminOffers;

  /// No description provided for @adminVouchers.
  ///
  /// In ar, this message translates to:
  /// **'القسائم'**
  String get adminVouchers;

  /// No description provided for @adminAnalytics.
  ///
  /// In ar, this message translates to:
  /// **'التحليلات'**
  String get adminAnalytics;

  /// No description provided for @adminFleet.
  ///
  /// In ar, this message translates to:
  /// **'خريطة الأسطول'**
  String get adminFleet;

  /// No description provided for @adminSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get adminSettings;

  /// No description provided for @adminStatTodayOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلبات اليوم'**
  String get adminStatTodayOrders;

  /// No description provided for @adminStatRevenue.
  ///
  /// In ar, this message translates to:
  /// **'المداخيل'**
  String get adminStatRevenue;

  /// No description provided for @adminStatActiveDeliveries.
  ///
  /// In ar, this message translates to:
  /// **'توصيلات جارية'**
  String get adminStatActiveDeliveries;

  /// No description provided for @adminStatAvgTime.
  ///
  /// In ar, this message translates to:
  /// **'متوسط مدة التوصيل'**
  String get adminStatAvgTime;

  /// No description provided for @adminStatLate.
  ///
  /// In ar, this message translates to:
  /// **'طلبات متأخرة'**
  String get adminStatLate;

  /// No description provided for @adminStatPending.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار التأكيد'**
  String get adminStatPending;

  /// No description provided for @adminStatOnlineAgents.
  ///
  /// In ar, this message translates to:
  /// **'سائقون متصلون'**
  String get adminStatOnlineAgents;

  /// No description provided for @adminOrderNew.
  ///
  /// In ar, this message translates to:
  /// **'طلب جديد وصل'**
  String get adminOrderNew;

  /// No description provided for @adminOrderLate.
  ///
  /// In ar, this message translates to:
  /// **'طلب متأخر'**
  String get adminOrderLate;

  /// No description provided for @adminCustomerInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الزبون'**
  String get adminCustomerInfo;

  /// No description provided for @adminDeliveryInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات التوصيل'**
  String get adminDeliveryInfo;

  /// No description provided for @adminCustomerNote.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة من الزبون'**
  String get adminCustomerNote;

  /// No description provided for @adminCallCustomer.
  ///
  /// In ar, this message translates to:
  /// **'اتصل بالزبون'**
  String get adminCallCustomer;

  /// No description provided for @adminCallVendor.
  ///
  /// In ar, this message translates to:
  /// **'اتصل بالمتجر'**
  String get adminCallVendor;

  /// No description provided for @adminConfirmOrder.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الطلب'**
  String get adminConfirmOrder;

  /// No description provided for @adminSendToVendor.
  ///
  /// In ar, this message translates to:
  /// **'إرسال إلى المتجر'**
  String get adminSendToVendor;

  /// No description provided for @adminMarkPreparing.
  ///
  /// In ar, this message translates to:
  /// **'بدأ التحضير'**
  String get adminMarkPreparing;

  /// No description provided for @adminMarkReady.
  ///
  /// In ar, this message translates to:
  /// **'جاهز'**
  String get adminMarkReady;

  /// No description provided for @adminAssignAgent.
  ///
  /// In ar, this message translates to:
  /// **'إسناد إلى سائق'**
  String get adminAssignAgent;

  /// No description provided for @adminCancelOrder.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب'**
  String get adminCancelOrder;

  /// No description provided for @adminCancelReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب الإلغاء'**
  String get adminCancelReason;

  /// No description provided for @adminAssignTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر سائقاً'**
  String get adminAssignTitle;

  /// No description provided for @adminAssignEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد سائق متصل حالياً'**
  String get adminAssignEmpty;

  /// No description provided for @adminAgentLoad.
  ///
  /// In ar, this message translates to:
  /// **'{count} طلب جارٍ'**
  String adminAgentLoad(int count);

  /// No description provided for @adminSearchOrders.
  ///
  /// In ar, this message translates to:
  /// **'ابحث برقم الطلب أو الهاتف'**
  String get adminSearchOrders;

  /// No description provided for @adminExportCsv.
  ///
  /// In ar, this message translates to:
  /// **'تصدير CSV'**
  String get adminExportCsv;

  /// No description provided for @adminNoOrders.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات مطابقة'**
  String get adminNoOrders;

  /// No description provided for @adminColOrderCode.
  ///
  /// In ar, this message translates to:
  /// **'رقم الطلب'**
  String get adminColOrderCode;

  /// No description provided for @adminColTime.
  ///
  /// In ar, this message translates to:
  /// **'الوقت'**
  String get adminColTime;

  /// No description provided for @adminColStatus.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get adminColStatus;

  /// No description provided for @adminColUses.
  ///
  /// In ar, this message translates to:
  /// **'الاستعمالات'**
  String get adminColUses;

  /// No description provided for @adminColName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get adminColName;

  /// No description provided for @adminColActions.
  ///
  /// In ar, this message translates to:
  /// **'إجراءات'**
  String get adminColActions;

  /// No description provided for @adminVendorNew.
  ///
  /// In ar, this message translates to:
  /// **'متجر جديد'**
  String get adminVendorNew;

  /// No description provided for @adminVendorEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المتجر'**
  String get adminVendorEdit;

  /// No description provided for @adminVendorName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المتجر'**
  String get adminVendorName;

  /// No description provided for @adminVendorSlug.
  ///
  /// In ar, this message translates to:
  /// **'المعرّف'**
  String get adminVendorSlug;

  /// No description provided for @adminVendorDescription.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get adminVendorDescription;

  /// No description provided for @adminVendorPhone.
  ///
  /// In ar, this message translates to:
  /// **'هاتف المتجر'**
  String get adminVendorPhone;

  /// No description provided for @adminVendorAddress.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get adminVendorAddress;

  /// No description provided for @adminVendorLocation.
  ///
  /// In ar, this message translates to:
  /// **'الموقع على الخريطة'**
  String get adminVendorLocation;

  /// No description provided for @adminVendorHours.
  ///
  /// In ar, this message translates to:
  /// **'أوقات العمل'**
  String get adminVendorHours;

  /// No description provided for @adminVendorFees.
  ///
  /// In ar, this message translates to:
  /// **'الرسوم'**
  String get adminVendorFees;

  /// No description provided for @adminVendorPrepTime.
  ///
  /// In ar, this message translates to:
  /// **'مدة التحضير (دقيقة)'**
  String get adminVendorPrepTime;

  /// No description provided for @adminVendorFeatured.
  ///
  /// In ar, this message translates to:
  /// **'متجر مميز'**
  String get adminVendorFeatured;

  /// No description provided for @adminVendorIsOpen.
  ///
  /// In ar, this message translates to:
  /// **'مفتوح'**
  String get adminVendorIsOpen;

  /// No description provided for @adminVendorLogo.
  ///
  /// In ar, this message translates to:
  /// **'الشعار'**
  String get adminVendorLogo;

  /// No description provided for @adminVendorCover.
  ///
  /// In ar, this message translates to:
  /// **'صورة الغلاف'**
  String get adminVendorCover;

  /// No description provided for @adminSectionNew.
  ///
  /// In ar, this message translates to:
  /// **'قسم جديد'**
  String get adminSectionNew;

  /// No description provided for @adminSectionName.
  ///
  /// In ar, this message translates to:
  /// **'اسم القسم'**
  String get adminSectionName;

  /// No description provided for @adminProductNew.
  ///
  /// In ar, this message translates to:
  /// **'منتج جديد'**
  String get adminProductNew;

  /// No description provided for @adminProductEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المنتج'**
  String get adminProductEdit;

  /// No description provided for @adminProductName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المنتج'**
  String get adminProductName;

  /// No description provided for @adminProductPrice.
  ///
  /// In ar, this message translates to:
  /// **'السعر بالدينار'**
  String get adminProductPrice;

  /// No description provided for @adminProductAvailable.
  ///
  /// In ar, this message translates to:
  /// **'متوفر'**
  String get adminProductAvailable;

  /// No description provided for @adminProductOptions.
  ///
  /// In ar, this message translates to:
  /// **'الخيارات'**
  String get adminProductOptions;

  /// No description provided for @adminProductOptionName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الخيار'**
  String get adminProductOptionName;

  /// No description provided for @adminProductOptionValue.
  ///
  /// In ar, this message translates to:
  /// **'القيمة'**
  String get adminProductOptionValue;

  /// No description provided for @adminProductOptionDelta.
  ///
  /// In ar, this message translates to:
  /// **'فرق السعر'**
  String get adminProductOptionDelta;

  /// No description provided for @adminProductAddOption.
  ///
  /// In ar, this message translates to:
  /// **'إضافة خيار'**
  String get adminProductAddOption;

  /// No description provided for @adminProductBulkAvailable.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل المحدد'**
  String get adminProductBulkAvailable;

  /// No description provided for @adminProductBulkUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'تعطيل المحدد'**
  String get adminProductBulkUnavailable;

  /// No description provided for @adminOfferNew.
  ///
  /// In ar, this message translates to:
  /// **'عرض جديد'**
  String get adminOfferNew;

  /// No description provided for @adminOfferTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان العرض'**
  String get adminOfferTitle;

  /// No description provided for @adminOfferSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'العنوان الفرعي'**
  String get adminOfferSubtitle;

  /// No description provided for @adminOfferType.
  ///
  /// In ar, this message translates to:
  /// **'نوع العرض'**
  String get adminOfferType;

  /// No description provided for @adminOfferTypePercentage.
  ///
  /// In ar, this message translates to:
  /// **'نسبة مئوية'**
  String get adminOfferTypePercentage;

  /// No description provided for @adminOfferTypeFixed.
  ///
  /// In ar, this message translates to:
  /// **'مبلغ ثابت'**
  String get adminOfferTypeFixed;

  /// No description provided for @adminOfferTypeFreeDelivery.
  ///
  /// In ar, this message translates to:
  /// **'توصيل مجاني'**
  String get adminOfferTypeFreeDelivery;

  /// No description provided for @adminOfferTypeBundle.
  ///
  /// In ar, this message translates to:
  /// **'عرض مجمّع'**
  String get adminOfferTypeBundle;

  /// No description provided for @adminOfferValue.
  ///
  /// In ar, this message translates to:
  /// **'القيمة'**
  String get adminOfferValue;

  /// No description provided for @adminOfferScope.
  ///
  /// In ar, this message translates to:
  /// **'نطاق العرض'**
  String get adminOfferScope;

  /// No description provided for @adminOfferPlatform.
  ///
  /// In ar, this message translates to:
  /// **'كل المنصة'**
  String get adminOfferPlatform;

  /// No description provided for @adminOfferSchedule.
  ///
  /// In ar, this message translates to:
  /// **'الفترة'**
  String get adminOfferSchedule;

  /// No description provided for @adminOfferShowOnHome.
  ///
  /// In ar, this message translates to:
  /// **'إظهار في الصفحة الرئيسية'**
  String get adminOfferShowOnHome;

  /// No description provided for @adminOfferPreview.
  ///
  /// In ar, this message translates to:
  /// **'معاينة'**
  String get adminOfferPreview;

  /// No description provided for @adminVoucherNew.
  ///
  /// In ar, this message translates to:
  /// **'قسيمة جديدة'**
  String get adminVoucherNew;

  /// No description provided for @adminVoucherCode.
  ///
  /// In ar, this message translates to:
  /// **'الرمز'**
  String get adminVoucherCode;

  /// No description provided for @adminVoucherMinOrder.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى للطلب'**
  String get adminVoucherMinOrder;

  /// No description provided for @adminVoucherMaxUses.
  ///
  /// In ar, this message translates to:
  /// **'أقصى عدد استعمالات'**
  String get adminVoucherMaxUses;

  /// No description provided for @adminVoucherPerUser.
  ///
  /// In ar, this message translates to:
  /// **'لكل مستخدم'**
  String get adminVoucherPerUser;

  /// No description provided for @adminVoucherUsed.
  ///
  /// In ar, this message translates to:
  /// **'استُعملت {count} مرة'**
  String adminVoucherUsed(int count);

  /// No description provided for @adminAgentNew.
  ///
  /// In ar, this message translates to:
  /// **'سائق جديد'**
  String get adminAgentNew;

  /// No description provided for @adminAgentTempPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة مرور مؤقتة'**
  String get adminAgentTempPassword;

  /// No description provided for @adminAgentSuspend.
  ///
  /// In ar, this message translates to:
  /// **'تعليق الحساب'**
  String get adminAgentSuspend;

  /// No description provided for @adminAgentActivate.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الحساب'**
  String get adminAgentActivate;

  /// No description provided for @adminCustomerBlock.
  ///
  /// In ar, this message translates to:
  /// **'حظر العميل'**
  String get adminCustomerBlock;

  /// No description provided for @adminCustomerUnblock.
  ///
  /// In ar, this message translates to:
  /// **'رفع الحظر'**
  String get adminCustomerUnblock;

  /// No description provided for @adminCustomerBlocked.
  ///
  /// In ar, this message translates to:
  /// **'محظور'**
  String get adminCustomerBlocked;

  /// No description provided for @adminCustomerOrders.
  ///
  /// In ar, this message translates to:
  /// **'عدد الطلبات'**
  String get adminCustomerOrders;

  /// No description provided for @adminCustomerSpent.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المشتريات'**
  String get adminCustomerSpent;

  /// No description provided for @adminAnalyticsOrdersOverTime.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات عبر الزمن'**
  String get adminAnalyticsOrdersOverTime;

  /// No description provided for @adminAnalyticsTopVendors.
  ///
  /// In ar, this message translates to:
  /// **'أفضل المتاجر'**
  String get adminAnalyticsTopVendors;

  /// No description provided for @adminAnalyticsTopProducts.
  ///
  /// In ar, this message translates to:
  /// **'أكثر المنتجات مبيعاً'**
  String get adminAnalyticsTopProducts;

  /// No description provided for @adminAnalyticsAgents.
  ///
  /// In ar, this message translates to:
  /// **'ترتيب السائقين'**
  String get adminAnalyticsAgents;

  /// No description provided for @adminAnalyticsCancellations.
  ///
  /// In ar, this message translates to:
  /// **'أسباب الإلغاء'**
  String get adminAnalyticsCancellations;

  /// No description provided for @adminAnalyticsRange.
  ///
  /// In ar, this message translates to:
  /// **'الفترة'**
  String get adminAnalyticsRange;

  /// No description provided for @adminFleetIdle.
  ///
  /// In ar, this message translates to:
  /// **'متفرّغ'**
  String get adminFleetIdle;

  /// No description provided for @adminFleetOnDelivery.
  ///
  /// In ar, this message translates to:
  /// **'في توصيل'**
  String get adminFleetOnDelivery;

  /// No description provided for @adminFleetEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد سائق متصل'**
  String get adminFleetEmpty;

  /// No description provided for @adminFleetLastSeen.
  ///
  /// In ar, this message translates to:
  /// **'آخر ظهور {time}'**
  String adminFleetLastSeen(String time);

  /// No description provided for @settingsServiceFee.
  ///
  /// In ar, this message translates to:
  /// **'رسوم الخدمة'**
  String get settingsServiceFee;

  /// No description provided for @settingsVipSurcharge.
  ///
  /// In ar, this message translates to:
  /// **'رسوم VIP الإضافية'**
  String get settingsVipSurcharge;

  /// No description provided for @settingsAssignTimeout.
  ///
  /// In ar, this message translates to:
  /// **'مهلة قبول الطلب (ثانية)'**
  String get settingsAssignTimeout;

  /// No description provided for @settingsLateThreshold.
  ///
  /// In ar, this message translates to:
  /// **'حد التأخير (دقيقة)'**
  String get settingsLateThreshold;

  /// No description provided for @settingsSupportPhone.
  ///
  /// In ar, this message translates to:
  /// **'هاتف الدعم'**
  String get settingsSupportPhone;

  /// No description provided for @settingsDeliveryRadius.
  ///
  /// In ar, this message translates to:
  /// **'نطاق التوصيل (كلم)'**
  String get settingsDeliveryRadius;

  /// No description provided for @settingsPointsPerHundred.
  ///
  /// In ar, this message translates to:
  /// **'نقاط لكل 100 دج'**
  String get settingsPointsPerHundred;

  /// No description provided for @settingsPointValue.
  ///
  /// In ar, this message translates to:
  /// **'قيمة النقطة بالسنتيم'**
  String get settingsPointValue;

  /// No description provided for @settingsMaxPointsPercent.
  ///
  /// In ar, this message translates to:
  /// **'أقصى نسبة نقاط من المجموع'**
  String get settingsMaxPointsPercent;

  /// No description provided for @settingsElectronicPayment.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الدفع الإلكتروني'**
  String get settingsElectronicPayment;

  /// No description provided for @settingsSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ الإعدادات'**
  String get settingsSaved;

  /// No description provided for @emptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد شيء هنا'**
  String get emptyTitle;

  /// No description provided for @emptySearch.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج لبحثك'**
  String get emptySearch;

  /// No description provided for @errorRetryTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل البيانات'**
  String get errorRetryTitle;

  /// No description provided for @offlineBanner.
  ///
  /// In ar, this message translates to:
  /// **'أنت غير متصل — نعرض آخر البيانات المحفوظة'**
  String get offlineBanner;

  /// No description provided for @currencySymbol.
  ///
  /// In ar, this message translates to:
  /// **'د.ج'**
  String get currencySymbol;

  /// No description provided for @amountWithCurrency.
  ///
  /// In ar, this message translates to:
  /// **'{amount} د.ج'**
  String amountWithCurrency(String amount);

  /// No description provided for @adminImagePick.
  ///
  /// In ar, this message translates to:
  /// **'اضغط لاختيار صورة'**
  String get adminImagePick;

  /// No description provided for @adminImageRemove.
  ///
  /// In ar, this message translates to:
  /// **'حذف الصورة'**
  String get adminImageRemove;

  /// No description provided for @adminProductImage.
  ///
  /// In ar, this message translates to:
  /// **'صورة المنتج'**
  String get adminProductImage;

  /// No description provided for @adminOfferImage.
  ///
  /// In ar, this message translates to:
  /// **'صورة العرض'**
  String get adminOfferImage;

  /// No description provided for @vouchersEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد قسائم'**
  String get vouchersEmptyTitle;

  /// No description provided for @vouchersEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر هنا القسائم المتاحة لك'**
  String get vouchersEmptyMessage;

  /// No description provided for @vouchersCopy.
  ///
  /// In ar, this message translates to:
  /// **'نسخ الرمز'**
  String get vouchersCopy;

  /// No description provided for @vouchersFreeDelivery.
  ///
  /// In ar, this message translates to:
  /// **'توصيل مجاني'**
  String get vouchersFreeDelivery;

  /// No description provided for @vouchersCopied.
  ///
  /// In ar, this message translates to:
  /// **'تم نسخ {code}'**
  String vouchersCopied(String code);

  /// No description provided for @vouchersMinOrder.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى للطلب {amount}'**
  String vouchersMinOrder(String amount);

  /// No description provided for @vouchersExpires.
  ///
  /// In ar, this message translates to:
  /// **'تنتهي في {date}'**
  String vouchersExpires(String date);

  /// No description provided for @vouchersPercentOff.
  ///
  /// In ar, this message translates to:
  /// **'خصم {value}%'**
  String vouchersPercentOff(String value);

  /// No description provided for @vouchersAmountOff.
  ///
  /// In ar, this message translates to:
  /// **'خصم {amount}'**
  String vouchersAmountOff(String amount);

  /// No description provided for @notificationsCategories.
  ///
  /// In ar, this message translates to:
  /// **'أنواع الإشعارات'**
  String get notificationsCategories;

  /// No description provided for @notificationsOrderUpdates.
  ///
  /// In ar, this message translates to:
  /// **'تحديثات الطلب'**
  String get notificationsOrderUpdates;

  /// No description provided for @notificationsOrderUpdatesHint.
  ///
  /// In ar, this message translates to:
  /// **'إشعار عند تغيّر حالة طلبك'**
  String get notificationsOrderUpdatesHint;

  /// No description provided for @notificationsPromotions.
  ///
  /// In ar, this message translates to:
  /// **'العروض'**
  String get notificationsPromotions;

  /// No description provided for @notificationsPromotionsHint.
  ///
  /// In ar, this message translates to:
  /// **'تخفيضات وقسائم جديدة'**
  String get notificationsPromotionsHint;

  /// No description provided for @notificationsNewVendors.
  ///
  /// In ar, this message translates to:
  /// **'متاجر جديدة'**
  String get notificationsNewVendors;

  /// No description provided for @notificationsNewVendorsHint.
  ///
  /// In ar, this message translates to:
  /// **'عند إضافة متجر قريب منك'**
  String get notificationsNewVendorsHint;

  /// No description provided for @notificationsEnabled.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات مفعّلة'**
  String get notificationsEnabled;

  /// No description provided for @notificationsEnabledHint.
  ///
  /// In ar, this message translates to:
  /// **'ستصلك تنبيهات حسب اختيارك'**
  String get notificationsEnabledHint;

  /// No description provided for @notificationsDisabled.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات موقوفة'**
  String get notificationsDisabled;

  /// No description provided for @notificationsDisabledHint.
  ///
  /// In ar, this message translates to:
  /// **'فعّلها حتى تصلك تحديثات طلبك'**
  String get notificationsDisabledHint;

  /// No description provided for @notificationsEnable.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل'**
  String get notificationsEnable;

  /// No description provided for @languageHint.
  ///
  /// In ar, this message translates to:
  /// **'تُطبَّق اللغة على التطبيق كامل'**
  String get languageHint;

  /// No description provided for @portalTitle.
  ///
  /// In ar, this message translates to:
  /// **'متجري'**
  String get portalTitle;

  /// No description provided for @portalOpen.
  ///
  /// In ar, this message translates to:
  /// **'المتجر مفتوح — نستقبل الطلبات'**
  String get portalOpen;

  /// No description provided for @portalClosed.
  ///
  /// In ar, this message translates to:
  /// **'المتجر مغلق — لا نستقبل الطلبات'**
  String get portalClosed;

  /// No description provided for @portalSections.
  ///
  /// In ar, this message translates to:
  /// **'الأقسام'**
  String get portalSections;

  /// No description provided for @portalAddSection.
  ///
  /// In ar, this message translates to:
  /// **'إضافة قسم'**
  String get portalAddSection;

  /// No description provided for @portalSectionName.
  ///
  /// In ar, this message translates to:
  /// **'اسم القسم'**
  String get portalSectionName;

  /// No description provided for @portalDeleteSectionHint.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حذف القسم، وتبقى منتجاته بدون قسم'**
  String get portalDeleteSectionHint;

  /// No description provided for @portalAddProduct.
  ///
  /// In ar, this message translates to:
  /// **'منتج جديد'**
  String get portalAddProduct;

  /// No description provided for @portalEditProduct.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المنتج'**
  String get portalEditProduct;

  /// No description provided for @portalUnsectioned.
  ///
  /// In ar, this message translates to:
  /// **'بدون قسم'**
  String get portalUnsectioned;

  /// No description provided for @portalUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر'**
  String get portalUnavailable;

  /// No description provided for @portalEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'القائمة فارغة'**
  String get portalEmptyTitle;

  /// No description provided for @portalEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'أضف أقسامك ومنتجاتك ليراها الزبائن'**
  String get portalEmptyMessage;

  /// No description provided for @adminVendorAccount.
  ///
  /// In ar, this message translates to:
  /// **'حساب المتجر'**
  String get adminVendorAccount;

  /// No description provided for @adminVendorAccountCreate.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب دخول'**
  String get adminVendorAccountCreate;

  /// No description provided for @adminVendorAccountExists.
  ///
  /// In ar, this message translates to:
  /// **'لهذا المتجر حساب دخول'**
  String get adminVendorAccountExists;

  /// No description provided for @adminVendorAccountNone.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد حساب دخول'**
  String get adminVendorAccountNone;

  /// No description provided for @adminVendorAccountHint.
  ///
  /// In ar, this message translates to:
  /// **'يدخل صاحب المتجر ليدير قائمته فقط'**
  String get adminVendorAccountHint;

  /// No description provided for @adminVendorAccountRevoke.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب'**
  String get adminVendorAccountRevoke;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
