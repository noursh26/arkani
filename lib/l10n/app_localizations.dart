import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'app_name': 'أركاني',
      'home': 'الرئيسية',
      'prayer_times': 'مواقيت الصلاة',
      'fajr': 'الفجر',
      'sunrise': 'الشروق',
      'dhuhr': 'الظهر',
      'asr': 'العصر',
      'maghrib': 'المغرب',
      'isha': 'العشاء',
      'mosques': 'المساجد',
      'find_mosques': 'البحث عن مساجد',
      'mosques_nearby': 'مساجد بالقرب منك',
      'adhkar': 'الأذكار',
      'adhkar_categories': 'تصنيفات الأذكار',
      'rulings': 'الفتاوى',
      'settings': 'الإعدادات',
      'notification_permission_title': 'تفعيل الإشعارات',
      'notification_permission_description': 'نحتاج إلى إذنك لإرسال إشعارات مواقيت الصلاة والأذكار',
      'allow_notifications': 'السماح بالإشعارات',
      'maybe_later': 'ربما لاحقاً',
      'error': 'خطأ',
      'retry': 'إعادة المحاولة',
      'loading': 'جاري التحميل...',
      'no_internet': 'لا يوجد اتصال بالإنترنت',
      'pull_to_refresh': 'اسحب للتحديث',
      'location_permission_required': 'صلاحية الموقع مطلوبة',
      'enable_location': 'تفعيل الموقع',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'today': 'اليوم',
      'daily_adhkar': 'أذكار اليوم',
      'morning_adhkar': 'أذكار الصباح',
      'evening_adhkar': 'أذكار المساء',
      'sleep_adhkar': 'أذكار النوم',
      'count': 'العداد',
      'read': 'قراءة',
      'copied': 'تم النسخ',
      'share': 'مشاركة',
      'search': 'بحث',
      'no_results': 'لا توجد نتائج',
      'azan_time': 'حان وقت الآذان',
      'nafil_prayers': 'النوافل',
      'mosques_title': 'المساجد القريبة',
      'rulings_title': 'الأحكام الشرعية',
      'search_rulings': 'البحث في الأحكام...',
    },
  };

  String get appName => _localizedValues[locale.languageCode]?['app_name'] ?? 'أركاني';
  String get home => _localizedValues[locale.languageCode]?['home'] ?? 'الرئيسية';
  String get prayerTimes => _localizedValues[locale.languageCode]?['prayer_times'] ?? 'مواقيت الصلاة';
  String get fajr => _localizedValues[locale.languageCode]?['fajr'] ?? 'الفجر';
  String get sunrise => _localizedValues[locale.languageCode]?['sunrise'] ?? 'الشروق';
  String get dhuhr => _localizedValues[locale.languageCode]?['dhuhr'] ?? 'الظهر';
  String get asr => _localizedValues[locale.languageCode]?['asr'] ?? 'العصر';
  String get maghrib => _localizedValues[locale.languageCode]?['maghrib'] ?? 'المغرب';
  String get isha => _localizedValues[locale.languageCode]?['isha'] ?? 'العشاء';
  String get mosques => _localizedValues[locale.languageCode]?['mosques'] ?? 'المساجد';
  String get findMosques => _localizedValues[locale.languageCode]?['find_mosques'] ?? 'البحث عن مساجد';
  String get mosquesNearby => _localizedValues[locale.languageCode]?['mosques_nearby'] ?? 'مساجد بالقرب منك';
  String get adhkar => _localizedValues[locale.languageCode]?['adhkar'] ?? 'الأذكار';
  String get adhkarCategories => _localizedValues[locale.languageCode]?['adhkar_categories'] ?? 'تصنيفات الأذكار';
  String get rulings => _localizedValues[locale.languageCode]?['rulings'] ?? 'الفتاوى';
  String get settings => _localizedValues[locale.languageCode]?['settings'] ?? 'الإعدادات';
  String get notificationPermissionTitle => _localizedValues[locale.languageCode]?['notification_permission_title'] ?? 'تفعيل الإشعارات';
  String get notificationPermissionDescription => _localizedValues[locale.languageCode]?['notification_permission_description'] ?? 'نحتاج إلى إذنك لإرسال إشعارات مواقيت الصلاة والأذكار';
  String get allowNotifications => _localizedValues[locale.languageCode]?['allow_notifications'] ?? 'السماح بالإشعارات';
  String get maybeLater => _localizedValues[locale.languageCode]?['maybe_later'] ?? 'ربما لاحقاً';
  String get error => _localizedValues[locale.languageCode]?['error'] ?? 'خطأ';
  String get retry => _localizedValues[locale.languageCode]?['retry'] ?? 'إعادة المحاولة';
  String get loading => _localizedValues[locale.languageCode]?['loading'] ?? 'جاري التحميل...';
  String get noInternet => _localizedValues[locale.languageCode]?['no_internet'] ?? 'لا يوجد اتصال بالإنترنت';
  String get pullToRefresh => _localizedValues[locale.languageCode]?['pull_to_refresh'] ?? 'اسحب للتحديث';
  String get locationPermissionRequired => _localizedValues[locale.languageCode]?['location_permission_required'] ?? 'صلاحية الموقع مطلوبة';
  String get enableLocation => _localizedValues[locale.languageCode]?['enable_location'] ?? 'تفعيل الموقع';
  String get cancel => _localizedValues[locale.languageCode]?['cancel'] ?? 'إلغاء';
  String get confirm => _localizedValues[locale.languageCode]?['confirm'] ?? 'تأكيد';
  String get today => _localizedValues[locale.languageCode]?['today'] ?? 'اليوم';
  String get dailyAdhkar => _localizedValues[locale.languageCode]?['daily_adhkar'] ?? 'أذكار اليوم';
  String get morningAdhkar => _localizedValues[locale.languageCode]?['morning_adhkar'] ?? 'أذكار الصباح';
  String get eveningAdhkar => _localizedValues[locale.languageCode]?['evening_adhkar'] ?? 'أذكار المساء';
  String get sleepAdhkar => _localizedValues[locale.languageCode]?['sleep_adhkar'] ?? 'أذكار النوم';
  String get count => _localizedValues[locale.languageCode]?['count'] ?? 'العداد';
  String get read => _localizedValues[locale.languageCode]?['read'] ?? 'قراءة';
  String get copied => _localizedValues[locale.languageCode]?['copied'] ?? 'تم النسخ';
  String get share => _localizedValues[locale.languageCode]?['share'] ?? 'مشاركة';
  String get search => _localizedValues[locale.languageCode]?['search'] ?? 'بحث';
  String get noResults => _localizedValues[locale.languageCode]?['no_results'] ?? 'لا توجد نتائج';
  String get azanTime => _localizedValues[locale.languageCode]?['azan_time'] ?? 'حان وقت الآذان';
  String get nafilPrayers => _localizedValues[locale.languageCode]?['nafil_prayers'] ?? 'النوافل';
  String get mosquesTitle => _localizedValues[locale.languageCode]?['mosques_title'] ?? 'المساجد القريبة';
  String get rulingsTitle => _localizedValues[locale.languageCode]?['rulings_title'] ?? 'الأحكام الشرعية';
  String get searchRulings => _localizedValues[locale.languageCode]?['search_rulings'] ?? 'البحث في الأحكام...';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
