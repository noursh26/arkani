import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'أركاني';
  static const String appNameEn = 'Arkani';
  static const String appVersion = '1.0.0';

  // API
  static const String apiVersion = 'v1';
  static const int apiTimeoutSeconds = 30;
  static const int maxRetries = 3;
  static const int retryDelaySeconds = 2;

  // Cache
  static const String hiveBoxName = 'arkani_cache';
  static const String prefsBoxName = 'arkani_prefs';
  static const Duration cacheDuration = Duration(hours: 24);
  static const Duration mosquesCacheDuration = Duration(minutes: 10);

  // Keys
  static const String deviceUuidKey = 'device_uuid';
  static const String oneSignalPlayerIdKey = 'onesignal_player_id';
  static const String lastCacheClearKey = 'last_cache_clear';
  static const String prayerMethodKey = 'prayer_method';
  static const String userLocationKey = 'user_location';

  // Hive Cache Keys
  static const String prayerTimesKey = 'prayer_times';
  static const String prayerTimesDateKey = 'prayer_times_date';
  static const String adhkarCategoriesKey = 'adhkar_categories';
  static const String adhkarPrefixKey = 'adhkar_';
  static const String rulingsTopicsKey = 'rulings_topics';
  static const String rulingsPrefixKey = 'rulings_';
  static const String mosquesKey = 'mosques';
  static const String mosquesCacheTimeKey = 'mosques_cache_time';

  // Location
  static const double defaultLatitude = 24.7136;
  static const double defaultLongitude = 46.6753;
  static const int mosqueSearchRadius = 3000;

  // Prayer Calculation Method (Islamic Society of North America = 2, Muslim World League = 3, Umm Al-Qura = 4)
  static const int defaultPrayerMethod = 4;

  // System UI
  static const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;

  // Debounce
  static const Duration searchDebounceMs = Duration(milliseconds: 500);
}
