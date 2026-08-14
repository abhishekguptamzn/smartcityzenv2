// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'स्मार्ट सिटीज़न';

  @override
  String get appTagline => 'नागरिक सेवाओं का आपका डिजिटल प्रवेश द्वार';

  @override
  String get welcomeBack => 'वापसी पर स्वागत है,';

  @override
  String get tapCardToFlip => 'पलटने के लिए कार्ड पर टैप करें';

  @override
  String get myCity => 'मेरा शहर';

  @override
  String get cityInformation => 'जानकारी';

  @override
  String get cityNews => 'समाचार';

  @override
  String get cityHistory => 'इतिहास';

  @override
  String get capitalCity => 'राजधानी शहर';

  @override
  String get timezoneLabel => 'समय क्षेत्र';

  @override
  String get stateLabel => 'राज्य';

  @override
  String get aboutThisCity => 'इस शहर के बारे में';

  @override
  String get latestUpdates => 'नवीनतम अपडेट';

  @override
  String get placeholderContentNotice =>
      'नमूना सामग्री — लाइव अपडेट जल्द आ रहे हैं';

  @override
  String get heritageTimeline => 'विरासत समयरेखा';

  @override
  String get noCityAssigned => 'आपके खाते से अभी तक कोई शहर जुड़ा नहीं है';

  @override
  String get active => 'सक्रिय';

  @override
  String validTill(String date) {
    return '$date तक मान्य';
  }

  @override
  String get verifiedMember => 'सत्यापित सदस्य';

  @override
  String get exploreCityServices => 'शहर सेवाएं देखें';

  @override
  String get scanQrToCheckIn => 'चेक-इन के लिए QR स्कैन करें';

  @override
  String get pointCameraAtQr => 'जिम चेक-इन QR कोड पर अपना कैमरा रखें';

  @override
  String get checkInSuccessful => 'चेक-इन सफल';

  @override
  String get cameraPermissionDenied =>
      'चेक-इन QR कोड स्कैन करने के लिए कैमरा एक्सेस आवश्यक है';

  @override
  String get invalidQrCode => 'यह QR कोड मान्य जिम चेक-इन कोड नहीं है';

  @override
  String get checkingIn => 'चेक-इन हो रहा है…';

  @override
  String get scanAnyQr => 'कोई भी QR स्कैन करें';

  @override
  String get checkInQrSubtitle => 'अपनी सदस्यता से चेक-इन QR स्कैन करें';

  @override
  String get uploadQr => 'QR अपलोड करें';

  @override
  String get torch => 'टॉर्च';

  @override
  String get oneAppTitle => 'एक ऐप। आपकी सभी शहर की ज़रूरतें।';

  @override
  String get oneAppSubtitle =>
      'अपने शहर के जीवन को एक्सेस करें, जुड़ें और सरल बनाएं।';

  @override
  String get exploreNow => 'अभी देखें';

  @override
  String get faqs => 'सामान्य प्रश्न';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get contactUs => 'संपर्क करें';

  @override
  String get feedback => 'प्रतिक्रिया';

  @override
  String get login => 'लॉग इन करें';

  @override
  String get register => 'पंजीकरण करें';

  @override
  String get emailAddress => 'ईमेल पता';

  @override
  String get password => 'पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get selectYourCity => 'अपना शहर चुनें';

  @override
  String get createPassword => 'पासवर्ड बनाएं';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get accessPortal => 'पोर्टल तक पहुंचें';

  @override
  String get createIdentity => 'पहचान बनाएं';

  @override
  String get orContinueWith => 'या इसके साथ जारी रखें';

  @override
  String get continueWithGoogle => 'गूगल';

  @override
  String get continueWithFacebook => 'फेसबुक';

  @override
  String get resetPassword => 'पासवर्ड रीसेट करें';

  @override
  String get sendResetCode => 'रीसेट कोड भेजें';

  @override
  String get resetCode => 'रीसेट कोड';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get backToLogin => 'लॉगिन पर वापस जाएं';

  @override
  String get home => 'होम';

  @override
  String get services => 'सेवाएं';

  @override
  String get id => 'आईडी';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get cityzenIdentity => 'सिटीज़न पहचान';

  @override
  String get searchServicesHint => 'सेवाएं, आईडी खोजें...';

  @override
  String get cityServices => 'शहर सेवाएं';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get myMemberships => 'मेरी सदस्यताएं';

  @override
  String get manage => 'प्रबंधित करें';

  @override
  String get viewDetails => 'विवरण देखें';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get libraries => 'पुस्तकालय';

  @override
  String get gyms => 'जिम';

  @override
  String get hospitals => 'अस्पताल';

  @override
  String get yoga => 'योग';

  @override
  String get dance => 'नृत्य';

  @override
  String get coaching => 'कोचिंग';

  @override
  String get photos => 'फ़ोटो';

  @override
  String get more => 'अधिक';

  @override
  String get searchFacilitiesHint => 'पुस्तकालय, जिम खोजें...';

  @override
  String get openNow => 'अभी खुला है';

  @override
  String get nearMe => 'मेरे पास';

  @override
  String get freeWifi => 'मुफ़्त वाईफाई';

  @override
  String get filters => 'फ़िल्टर';

  @override
  String get closed => 'बंद';

  @override
  String get available => 'उपलब्ध';

  @override
  String get limitedSpace => 'सीमित स्थान';

  @override
  String kmAway(String distance) {
    return '$distance किमी दूर';
  }

  @override
  String openUntil(String time) {
    return '$time तक';
  }

  @override
  String get about => 'के बारे में';

  @override
  String get amenities => 'सुविधाएं';

  @override
  String get hours => 'समय';

  @override
  String get location => 'स्थान';

  @override
  String get directions => 'दिशा-निर्देश';

  @override
  String get call => 'कॉल करें';

  @override
  String get today => 'आज';

  @override
  String get membershipDetails => 'सदस्यता विवरण';

  @override
  String get validityStatus => 'वैधता स्थिति';

  @override
  String validUntil(String date) {
    return '$date तक मान्य';
  }

  @override
  String get quickCheckIn => 'त्वरित चेक-इन';

  @override
  String get checkOut => 'चेक आउट';

  @override
  String get details => 'विवरण';

  @override
  String get attendance => 'उपस्थिति';

  @override
  String get payments => 'भुगतान';

  @override
  String get memberInformation => 'सदस्य जानकारी';

  @override
  String get memberId => 'सदस्य आईडी';

  @override
  String get tier => 'स्तर';

  @override
  String get facilityAccess => 'सुविधा पहुंच';

  @override
  String joined(String date) {
    return '$date को शामिल हुए';
  }

  @override
  String get contactStaffToJoin =>
      'इस सुविधा में शामिल होने के लिए स्टाफ से संपर्क करें';

  @override
  String get contactStaffToRenew =>
      'अपनी सदस्यता नवीनीकृत करने के लिए स्टाफ से संपर्क करें';

  @override
  String get contactStaffBody =>
      'स्व-सेवा नामांकन अभी उपलब्ध नहीं है। सीधे सुविधा से संपर्क करें और हमारा स्टाफ आपकी सदस्यता सेट करेगा।';

  @override
  String get sendEmail => 'ईमेल भेजें';

  @override
  String get callFacility => 'सुविधा को कॉल करें';

  @override
  String get myPayments => 'मेरे भुगतान';

  @override
  String get paymentReceipt => 'भुगतान रसीद';

  @override
  String get amount => 'राशि';

  @override
  String get status => 'स्थिति';

  @override
  String get paymentMethod => 'भुगतान विधि';

  @override
  String get transactionReference => 'लेनदेन संदर्भ';

  @override
  String get invoiceNumber => 'चालान संख्या';

  @override
  String get dueDate => 'नियत तारीख';

  @override
  String get paidOn => 'भुगतान तिथि';

  @override
  String get notes => 'टिप्पणियाँ';

  @override
  String get invoiceEmailedNotice =>
      'यह भुगतान दर्ज होने पर आपको एक विस्तृत पीडीएफ चालान ईमेल किया गया था।';

  @override
  String get myProfile => 'मेरी प्रोफ़ाइल';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get saveChanges => 'परिवर्तन सहेजें';

  @override
  String get role => 'भूमिका';

  @override
  String get accountStatus => 'खाता स्थिति';

  @override
  String get security => 'सुरक्षा';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get currentPassword => 'वर्तमान पासवर्ड';

  @override
  String get loginHistory => 'लॉगिन इतिहास';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get logoutAllDevices => 'सभी डिवाइस से लॉग आउट करें';

  @override
  String get suspiciousLogin => 'संदिग्ध';

  @override
  String get device => 'डिवाइस';

  @override
  String get ipAddress => 'आईपी पता';

  @override
  String get browser => 'ब्राउज़र';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get somethingWentWrong => 'कुछ गलत हो गया';

  @override
  String get noInternetConnection => 'इंटरनेट कनेक्शन नहीं है';

  @override
  String get noResultsFound => 'कोई परिणाम नहीं मिला';

  @override
  String get noMembershipsYet => 'आपके पास अभी तक कोई सदस्यता नहीं है';

  @override
  String get noPaymentsYet => 'अभी तक कोई भुगतान इतिहास नहीं है';

  @override
  String get noLoginHistoryYet => 'अभी तक कोई लॉगिन इतिहास नहीं है';

  @override
  String get noExceptionsYet => 'कोई सक्रिय छूट या अपवाद नहीं';

  @override
  String get pullToRefresh => 'रीफ़्रेश करने के लिए खींचें';

  @override
  String get requiredField => 'यह फ़ील्ड आवश्यक है';

  @override
  String get invalidEmail => 'एक मान्य ईमेल पता दर्ज करें';

  @override
  String get passwordTooShort => 'पासवर्ड कम से कम 8 वर्णों का होना चाहिए';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get invalidPhone => 'एक मान्य फ़ोन नंबर दर्ज करें';

  @override
  String get errorValidation => 'कृपया दर्ज किए गए विवरण जांचें';

  @override
  String get errorAuthentication => 'गलत ईमेल या पासवर्ड';

  @override
  String get errorAuthorization => 'आपके पास ऐसा करने की अनुमति नहीं है';

  @override
  String get errorAccountBlocked =>
      'आपका खाता अवरुद्ध कर दिया गया है। सहायता से संपर्क करें।';

  @override
  String get errorAccountInactive =>
      'आपका खाता निष्क्रिय है। सहायता से संपर्क करें।';

  @override
  String get errorNotFound => 'हमें वह नहीं मिला';

  @override
  String get errorConflict => 'यह क्रिया वर्तमान स्थिति के साथ टकराती है';

  @override
  String errorRateLimited(int seconds) {
    return 'बहुत सारे प्रयास। $seconds सेकंड में पुनः प्रयास करें';
  }

  @override
  String get errorServer =>
      'सर्वर त्रुटि। कृपया थोड़ी देर बाद पुनः प्रयास करें';

  @override
  String get errorGeneric => 'अप्रत्याशित त्रुटि। कृपया पुनः प्रयास करें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get networkSettings => 'नेटवर्क';

  @override
  String get apiBaseUrl => 'एपीआई बेस यूआरएल';

  @override
  String get apiBaseUrlHint => 'https://api.example.com/api/v1';

  @override
  String get invalidUrl => 'एक मान्य यूआरएल दर्ज करें';

  @override
  String get connectTimeout => 'कनेक्ट टाइमआउट';

  @override
  String get receiveTimeout => 'रिसीव टाइमआउट';

  @override
  String timeoutSeconds(int seconds) {
    return '$seconds सेकंड';
  }

  @override
  String get requestLogging => 'अनुरोध लॉगिंग';

  @override
  String get requestLoggingSubtitle => 'डिबगिंग के लिए नेटवर्क अनुरोध लॉग करें';

  @override
  String get testConnection => 'कनेक्शन जांचें';

  @override
  String get connectionSuccessful => 'कनेक्शन सफल रहा';

  @override
  String get connectionFailed => 'कनेक्शन विफल रहा';

  @override
  String get saveAnyway => 'फिर भी सहेजें';

  @override
  String get resetToDefaults => 'डिफ़ॉल्ट पर रीसेट करें';

  @override
  String get settingsSaved => 'सेटिंग्स सहेजी गईं';

  @override
  String get confirmResetSettings =>
      'इससे डिफ़ॉल्ट एपीआई यूआरएल और टाइमआउट पुनर्स्थापित हो जाएंगे। जारी रखें?';

  @override
  String get appearance => 'दिखावट';

  @override
  String get theme => 'थीम';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeSystemSubtitle => 'आपके डिवाइस की सेटिंग से मेल खाता है';

  @override
  String get themeLightSubtitle => 'हमेशा लाइट थीम का उपयोग करें';

  @override
  String get themeDarkSubtitle => 'हमेशा डार्क थीम का उपयोग करें';
}
