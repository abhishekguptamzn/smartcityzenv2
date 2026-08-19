// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'سمارت سيتيزن';

  @override
  String get appTagline => 'بوابتك الرقمية للخدمات المدنية';

  @override
  String get welcomeBack => 'مرحبًا بعودتك،';

  @override
  String get tapCardToFlip => 'اضغط على البطاقة لقلبها';

  @override
  String get myCity => 'مدينتي';

  @override
  String get cityInformation => 'معلومات';

  @override
  String get cityNews => 'الأخبار';

  @override
  String get cityHistory => 'التاريخ';

  @override
  String get capitalCity => 'العاصمة';

  @override
  String get timezoneLabel => 'المنطقة الزمنية';

  @override
  String get stateLabel => 'الولاية';

  @override
  String get aboutThisCity => 'عن هذه المدينة';

  @override
  String get latestUpdates => 'آخر التحديثات';

  @override
  String get placeholderContentNotice =>
      'محتوى تجريبي — التحديثات المباشرة قريبًا';

  @override
  String get heritageTimeline => 'الجدول الزمني للتراث';

  @override
  String get noCityAssigned => 'لا توجد مدينة مرتبطة بحسابك بعد';

  @override
  String get active => 'نشط';

  @override
  String validTill(String date) {
    return 'صالح حتى $date';
  }

  @override
  String get verifiedMember => 'عضو موثّق';

  @override
  String get exploreCityServices => 'استكشف خدمات المدينة';

  @override
  String get scanQrToCheckIn => 'امسح رمز QR لتسجيل الحضور';

  @override
  String get pointCameraAtQr =>
      'وجّه الكاميرا نحو رمز QR الخاص بتسجيل حضور الجيم';

  @override
  String get checkInSuccessful => 'تم تسجيل الحضور بنجاح';

  @override
  String get cameraPermissionDenied =>
      'يلزم الوصول إلى الكاميرا لمسح رمز QR الخاص بتسجيل الحضور';

  @override
  String get invalidQrCode => 'رمز QR هذا غير صالح لتسجيل الحضور';

  @override
  String get checkingIn => 'جارٍ تسجيل الحضور…';

  @override
  String get scanAnyQr => 'امسح أي رمز QR';

  @override
  String get checkInQrSubtitle => 'امسح رمز QR الخاص بتسجيل الحضور من عضويتك';

  @override
  String get uploadQr => 'تحميل رمز QR';

  @override
  String get torch => 'المصباح';

  @override
  String get oneAppTitle => 'تطبيق واحد. كل احتياجات مدينتك.';

  @override
  String get oneAppSubtitle => 'الوصول والتواصل وتبسيط حياتك في المدينة.';

  @override
  String get exploreNow => 'استكشف الآن';

  @override
  String get faqs => 'الأسئلة الشائعة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get feedback => 'الملاحظات';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'التسجيل';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get mobileNumber => 'رقم الجوال';

  @override
  String get selectYourCity => 'اختر مدينتك';

  @override
  String get createPassword => 'إنشاء كلمة مرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get accessPortal => 'الدخول إلى البوابة';

  @override
  String get createIdentity => 'إنشاء هوية';

  @override
  String get orContinueWith => 'أو المتابعة باستخدام';

  @override
  String get continueWithGoogle => 'جوجل';

  @override
  String get continueWithFacebook => 'فيسبوك';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get sendResetCode => 'إرسال رمز إعادة التعيين';

  @override
  String get resetCode => 'رمز إعادة التعيين';

  @override
  String get newPassword => 'كلمة مرور جديدة';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get home => 'الرئيسية';

  @override
  String get services => 'الخدمات';

  @override
  String get id => 'الهوية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get cityzenIdentity => 'هوية سيتيزن';

  @override
  String get searchServicesHint => 'ابحث عن الخدمات، المعرفات...';

  @override
  String get cityServices => 'خدمات المدينة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get myMemberships => 'عضوياتي';

  @override
  String get manage => 'إدارة';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get libraries => 'المكتبات';

  @override
  String get gyms => 'الصالات الرياضية';

  @override
  String get hospitals => 'المستشفيات';

  @override
  String get yoga => 'اليوغا';

  @override
  String get dance => 'الرقص';

  @override
  String get coaching => 'التدريب';

  @override
  String get photos => 'الصور';

  @override
  String get more => 'المزيد';

  @override
  String get searchFacilitiesHint => 'ابحث عن مكتبات، صالات رياضية...';

  @override
  String get openNow => 'مفتوح الآن';

  @override
  String get nearMe => 'بالقرب مني';

  @override
  String get freeWifi => 'واي فاي مجاني';

  @override
  String get filters => 'الفلاتر';

  @override
  String get closed => 'مغلق';

  @override
  String get available => 'متاح';

  @override
  String get limitedSpace => 'مساحة محدودة';

  @override
  String kmAway(String distance) {
    return 'على بعد $distance كم';
  }

  @override
  String openUntil(String time) {
    return 'حتى $time';
  }

  @override
  String get about => 'حول';

  @override
  String get amenities => 'المرافق';

  @override
  String get hours => 'ساعات العمل';

  @override
  String get location => 'الموقع';

  @override
  String get directions => 'الاتجاهات';

  @override
  String get call => 'اتصال';

  @override
  String get today => 'اليوم';

  @override
  String get membershipDetails => 'تفاصيل العضوية';

  @override
  String get validityStatus => 'حالة الصلاحية';

  @override
  String validUntil(String date) {
    return 'صالح حتى $date';
  }

  @override
  String get quickCheckIn => 'تسجيل حضور سريع';

  @override
  String get checkOut => 'تسجيل الخروج';

  @override
  String get details => 'التفاصيل';

  @override
  String get attendance => 'الحضور';

  @override
  String get payments => 'المدفوعات';

  @override
  String get memberInformation => 'معلومات العضو';

  @override
  String get memberId => 'معرف العضو';

  @override
  String get tier => 'الفئة';

  @override
  String get facilityAccess => 'الوصول إلى المرافق';

  @override
  String joined(String date) {
    return 'انضم في $date';
  }

  @override
  String get contactStaffToJoin => 'تواصل مع الموظفين للانضمام إلى هذا المرفق';

  @override
  String get contactStaffToRenew => 'تواصل مع الموظفين لتجديد عضويتك';

  @override
  String get contactStaffBody =>
      'التسجيل الذاتي غير متاح بعد. تواصل مباشرة مع المرفق وسيقوم موظفونا بإعداد عضويتك.';

  @override
  String get sendEmail => 'إرسال بريد إلكتروني';

  @override
  String get callFacility => 'الاتصال بالمرفق';

  @override
  String get myPayments => 'مدفوعاتي';

  @override
  String get paymentReceipt => 'إيصال الدفع';

  @override
  String get amount => 'المبلغ';

  @override
  String get status => 'الحالة';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get transactionReference => 'مرجع المعاملة';

  @override
  String get invoiceNumber => 'رقم الفاتورة';

  @override
  String get dueDate => 'تاريخ الاستحقاق';

  @override
  String get paidOn => 'تاريخ الدفع';

  @override
  String get notes => 'ملاحظات';

  @override
  String get invoiceEmailedNotice =>
      'تم إرسال فاتورة PDF مفصلة عبر البريد الإلكتروني عند تسجيل هذا الدفع.';

  @override
  String get myProfile => 'ملفي الشخصي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get role => 'الدور';

  @override
  String get accountStatus => 'حالة الحساب';

  @override
  String get security => 'الأمان';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get loginHistory => 'سجل تسجيل الدخول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutAllDevices => 'تسجيل الخروج من جميع الأجهزة';

  @override
  String get suspiciousLogin => 'مشبوه';

  @override
  String get device => 'الجهاز';

  @override
  String get ipAddress => 'عنوان IP';

  @override
  String get browser => 'المتصفح';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noMembershipsYet => 'ليس لديك أي عضويات حتى الآن';

  @override
  String get noPaymentsYet => 'لا يوجد سجل مدفوعات حتى الآن';

  @override
  String get noLoginHistoryYet => 'لا يوجد سجل تسجيل دخول حتى الآن';

  @override
  String get noExceptionsYet => 'لا توجد خصومات أو استثناءات نشطة';

  @override
  String get pullToRefresh => 'اسحب للتحديث';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'أدخل عنوان بريد إلكتروني صالح';

  @override
  String get passwordTooShort => 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get invalidPhone => 'أدخل رقم هاتف صالح';

  @override
  String get errorValidation => 'يرجى التحقق من البيانات التي أدخلتها';

  @override
  String get errorAuthentication => 'بريد إلكتروني أو كلمة مرور غير صحيحة';

  @override
  String get errorAuthorization => 'ليس لديك إذن للقيام بذلك';

  @override
  String get errorAccountBlocked => 'تم حظر حسابك. تواصل مع الدعم.';

  @override
  String get errorAccountInactive => 'حسابك غير نشط. تواصل مع الدعم.';

  @override
  String get errorNotFound => 'لم نتمكن من العثور على ذلك';

  @override
  String get errorConflict => 'يتعارض هذا الإجراء مع الحالة الحالية';

  @override
  String errorRateLimited(int seconds) {
    return 'محاولات كثيرة جداً. حاول مرة أخرى خلال $seconds ثانية';
  }

  @override
  String get errorServer => 'خطأ في الخادم. يرجى المحاولة مرة أخرى قريباً';

  @override
  String get errorGeneric => 'خطأ غير متوقع. يرجى المحاولة مرة أخرى';

  @override
  String get settings => 'الإعدادات';

  @override
  String get networkSettings => 'الشبكة';

  @override
  String get apiBaseUrl => 'رابط واجهة برمجة التطبيقات';

  @override
  String get apiBaseUrlHint => 'https://api.example.com/api/v1';

  @override
  String get invalidUrl => 'أدخل رابطاً صالحاً';

  @override
  String get connectTimeout => 'مهلة الاتصال';

  @override
  String get receiveTimeout => 'مهلة الاستقبال';

  @override
  String timeoutSeconds(int seconds) {
    return '$seconds ثانية';
  }

  @override
  String get requestLogging => 'تسجيل الطلبات';

  @override
  String get requestLoggingSubtitle => 'تسجيل طلبات الشبكة لأغراض التصحيح';

  @override
  String get testConnection => 'اختبار الاتصال';

  @override
  String get connectionSuccessful => 'تم الاتصال بنجاح';

  @override
  String get connectionFailed => 'فشل الاتصال';

  @override
  String get saveAnyway => 'الحفظ على أي حال';

  @override
  String get resetToDefaults => 'إعادة التعيين إلى الافتراضي';

  @override
  String get settingsSaved => 'تم حفظ الإعدادات';

  @override
  String get confirmResetSettings =>
      'سيؤدي هذا إلى استعادة رابط واجهة برمجة التطبيقات ومهلات الاتصال الافتراضية. هل تريد المتابعة؟';

  @override
  String get appearance => 'المظهر';

  @override
  String get theme => 'السمة';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystemSubtitle => 'مطابقة إعداد جهازك';

  @override
  String get themeLightSubtitle => 'استخدام السمة الفاتحة دائماً';

  @override
  String get themeDarkSubtitle => 'استخدام السمة الداكنة دائماً';

  @override
  String get activitiesAndAcademies => 'الأنشطة والأكاديميات';

  @override
  String get allActivities => 'جميع الأنشطة';

  @override
  String get verifiedAcademies => 'الأكاديميات المعتمدة';

  @override
  String get featuredStudios => 'الاستوديوهات المميزة';

  @override
  String get batchesAndSchedule => 'المجموعات وجدول المواعيد';

  @override
  String get coachesAndTrainers => 'المدربون والمعلمون';

  @override
  String get enrollAndGetPass => 'التسجيل والحصول على التصريح';

  @override
  String get citizenReviews => 'تقييمات المواطنين';

  @override
  String get writeReview => 'كتابة تقييم';
}
