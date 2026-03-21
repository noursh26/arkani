import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';

class HiveConfig {
  HiveConfig._();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    await Hive.initFlutter();
    
    // Register adapters here if needed
    // Hive.registerAdapter(YourModelAdapter());
    
    // Open boxes
    await Hive.openBox(AppConstants.hiveBoxName);
    await Hive.openBox(AppConstants.prefsBoxName);
    
    _initialized = true;
  }

  static Box get cacheBox => Hive.box(AppConstants.hiveBoxName);
  static Box get prefsBox => Hive.box(AppConstants.prefsBoxName);
}
