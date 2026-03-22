import 'package:hive_flutter/hive_flutter.dart';

import '../../features/location/domain/entities/prayer_times.dart';
import '../../features/location/domain/entities/user_location.dart';
import '../constants/app_constants.dart';

class HiveConfig {
  HiveConfig._();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(UserLocationAdapter());
    Hive.registerAdapter(PrayerTimesAdapter());

    // Open boxes
    await Hive.openBox(AppConstants.hiveBoxName);
    await Hive.openBox(AppConstants.prefsBoxName);
    await Hive.openBox<UserLocation>('user_location');
    await Hive.openBox<PrayerTimes>('prayer_times');

    _initialized = true;
  }

  static Box get cacheBox => Hive.box(AppConstants.hiveBoxName);
  static Box get prefsBox => Hive.box(AppConstants.prefsBoxName);
  static Box<UserLocation> get locationBox => Hive.box<UserLocation>('user_location');
  static Box<PrayerTimes> get prayerTimesBox => Hive.box<PrayerTimes>('prayer_times');
}
