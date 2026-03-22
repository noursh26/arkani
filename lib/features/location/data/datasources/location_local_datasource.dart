import 'package:hive/hive.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/prayer_times.dart';
import '../../domain/entities/user_location.dart';

abstract class LocationLocalDataSource {
  /// Get saved user location
  Future<UserLocation?> getSavedLocation();

  /// Save user location
  Future<void> saveLocation(UserLocation location);

  /// Clear saved location
  Future<void> clearLocation();

  /// Get saved prayer times
  Future<PrayerTimes?> getSavedPrayerTimes();

  /// Save prayer times
  Future<void> savePrayerTimes(PrayerTimes prayerTimes);

  /// Clear saved prayer times
  Future<void> clearPrayerTimes();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  static const String _locationBoxName = 'user_location';
  static const String _prayerTimesBoxName = 'prayer_times';
  static const String _locationKey = 'saved_location';
  static const String _prayerTimesKey = 'saved_prayer_times';

  late Box<UserLocation> _locationBox;
  late Box<PrayerTimes> _prayerTimesBox;
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;

    if (!Hive.isAdapterRegistered(1)) {
      throw const CacheException('UserLocation adapter not registered');
    }
    if (!Hive.isAdapterRegistered(2)) {
      throw const CacheException('PrayerTimes adapter not registered');
    }

    _locationBox = await Hive.openBox<UserLocation>(_locationBoxName);
    _prayerTimesBox = await Hive.openBox<PrayerTimes>(_prayerTimesBoxName);
    _initialized = true;
  }

  @override
  Future<UserLocation?> getSavedLocation() async {
    try {
      await _init();
      return _locationBox.get(_locationKey);
    } catch (e) {
      throw CacheException('Failed to get saved location: $e');
    }
  }

  @override
  Future<void> saveLocation(UserLocation location) async {
    try {
      await _init();
      await _locationBox.put(_locationKey, location);
    } catch (e) {
      throw CacheException('Failed to save location: $e');
    }
  }

  @override
  Future<void> clearLocation() async {
    try {
      await _init();
      await _locationBox.delete(_locationKey);
    } catch (e) {
      throw CacheException('Failed to clear location: $e');
    }
  }

  @override
  Future<PrayerTimes?> getSavedPrayerTimes() async {
    try {
      await _init();
      final saved = _prayerTimesBox.get(_prayerTimesKey);

      if (saved == null) return null;

      final today = DateTime.now();
      final savedDate = saved.calculatedFor;

      if (savedDate.year != today.year ||
          savedDate.month != today.month ||
          savedDate.day != today.day) {
        await clearPrayerTimes();
        return null;
      }

      return saved;
    } catch (e) {
      throw CacheException('Failed to get saved prayer times: $e');
    }
  }

  @override
  Future<void> savePrayerTimes(PrayerTimes prayerTimes) async {
    try {
      await _init();
      await _prayerTimesBox.put(_prayerTimesKey, prayerTimes);
    } catch (e) {
      throw CacheException('Failed to save prayer times: $e');
    }
  }

  @override
  Future<void> clearPrayerTimes() async {
    try {
      await _init();
      await _prayerTimesBox.delete(_prayerTimesKey);
    } catch (e) {
      throw CacheException('Failed to clear prayer times: $e');
    }
  }
}
