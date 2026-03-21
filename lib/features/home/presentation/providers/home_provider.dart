import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/providers.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/services/local_notification_service.dart';
import '../../../core/services/prayer_calculation_service.dart';
import '../../../core/utils/location_util.dart';
import '../../domain/entities/prayer_times.dart';
import 'home_state.dart';

part 'home_provider.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  Timer? _timer;

  @override
  HomeState build() {
    return const HomeState();
  }

  void dispose() {
    _timer?.cancel();
  }

  Future<void> loadPrayerTimes({bool forceRefresh = false}) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final cacheBox = Hive.box(AppConstants.hiveBoxName);
    
    // Check for cached data first
    if (!forceRefresh) {
      final cachedDate = cacheBox.get(AppConstants.prayerTimesDateKey) as String?;
      final cachedData = cacheBox.get(AppConstants.prayerTimesKey) as String?;
      
      if (cachedDate == today && cachedData != null) {
        try {
          final prayerTimes = PrayerTimes.fromJson(
            jsonDecode(cachedData) as Map<String, dynamic>,
          );
          state = state.copyWith(
            prayerTimes: prayerTimes,
            isLoading: false,
            isOffline: false,
            error: null,
          );
          _calculateNextPrayer(prayerTimes);
          return;
        } catch (e) {
          // Invalid cache, continue to fetch
        }
      }
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final location = await ref.read(locationUtilProvider).getCurrentLocation();
      final apiService = ref.read(apiServiceProvider);

      final response = await apiService.getPrayerTimes(
        lat: location.latitude,
        lng: location.longitude,
      );

      final data = response['data'] as Map<String, dynamic>;
      final prayerTimes = PrayerTimes.fromJson(data);

      // Save to cache
      await cacheBox.put(AppConstants.prayerTimesKey, jsonEncode(data));
      await cacheBox.put(AppConstants.prayerTimesDateKey, today);

      state = state.copyWith(
        isLoading: false,
        prayerTimes: prayerTimes,
        isOffline: false,
        error: null,
        locationPermissionGranted: true,
      );
      
      _calculateNextPrayer(prayerTimes);
      
      // Schedule prayer notifications
      await _schedulePrayerNotifications(prayerTimes);
    } on NetworkException catch (e) {
      // Try to use cached data first, then fallback to local calculation
      final cachedData = cacheBox.get(AppConstants.prayerTimesKey) as String?;
      if (cachedData != null) {
        try {
          final prayerTimes = PrayerTimes.fromJson(
            jsonDecode(cachedData) as Map<String, dynamic>,
          );
          state = state.copyWith(
            isLoading: false,
            prayerTimes: prayerTimes,
            isOffline: true,
            error: null,
          );
          _calculateNextPrayer(prayerTimes);
          await _schedulePrayerNotifications(prayerTimes);
        } catch (_) {
          // Fall back to local calculation
          await _fallbackToLocalCalculation(cacheBox, today);
        }
      } else {
        // No cached data, use local calculation
        await _fallbackToLocalCalculation(cacheBox, today);
      }
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } catch (e) {
      // Fallback to local calculation for any unexpected errors
      await _fallbackToLocalCalculation(cacheBox, today);
    }
  }

  void _fallbackToLocalCalculation(Box cacheBox, String today) async {
    try {
      // Use local calculation with default or retrieved location
      LocationData? location;
      try {
        location = await ref.read(locationUtilProvider).getCurrentLocation();
      } catch (_) {
        location = null;
      }
      
      final prayerTimes = PrayerCalculationService.calculatePrayerTimesEntity(
        latitude: location?.latitude ?? PrayerCalculationService.defaultLatitude,
        longitude: location?.longitude ?? PrayerCalculationService.defaultLongitude,
        city: location?.city,
        country: location?.country,
      );

      // Save to cache
      final prayerData = {
        'fajr': prayerTimes.fajr,
        'sunrise': prayerTimes.sunrise,
        'dhuhr': prayerTimes.dhuhr,
        'asr': prayerTimes.asr,
        'maghrib': prayerTimes.maghrib,
        'isha': prayerTimes.isha,
        'date': prayerTimes.date,
        'hijriDate': prayerTimes.hijriDate,
        'city': prayerTimes.city,
        'country': prayerTimes.country,
      };

      await cacheBox.put(AppConstants.prayerTimesKey, jsonEncode(prayerData));
      await cacheBox.put(AppConstants.prayerTimesDateKey, today);

      state = state.copyWith(
        isLoading: false,
        prayerTimes: prayerTimes,
        isOffline: true,
        error: null,
        locationPermissionGranted: location != null && 
          location.latitude != PrayerCalculationService.defaultLatitude,
      );
      _calculateNextPrayer(prayerTimes);
      
      // Schedule prayer notifications even with local calculation
      await _schedulePrayerNotifications(prayerTimes);
    } catch (localError) {
      state = state.copyWith(
        isLoading: false,
        isOffline: true,
        error: 'لا يوجد اتصال بالإنترنت',
        locationPermissionGranted: false,
      );
    }
  }

  void _calculateNextPrayer(PrayerTimes prayerTimes) {
    final now = DateTime.now();
    final today = now.toIso8601String().split('T')[0];
    
    final prayers = [
      {'name': 'الفجر', 'time': DateTime.parse('$today ${prayerTimes.fajr}')},
      {'name': 'الشروق', 'time': DateTime.parse('$today ${prayerTimes.sunrise}')},
      {'name': 'الظهر', 'time': DateTime.parse('$today ${prayerTimes.dhuhr}')},
      {'name': 'العصر', 'time': DateTime.parse('$today ${prayerTimes.asr}')},
      {'name': 'المغرب', 'time': DateTime.parse('$today ${prayerTimes.maghrib}')},
      {'name': 'العشاء', 'time': DateTime.parse('$today ${prayerTimes.isha}')},
    ];

    // Find next prayer
    var nextPrayer = prayers.firstWhere(
      (p) => (p['time'] as DateTime).isAfter(now),
      orElse: () => {
        'name': 'الفجر',
        'time': DateTime.parse('$today ${prayerTimes.fajr}').add(const Duration(days: 1)),
      },
    );

    // Find current prayer
    final currentPrayerIndex = prayers.indexWhere(
      (p) => (p['time'] as DateTime).isAfter(now),
    );
    String? currentPrayer;
    if (currentPrayerIndex > 0) {
      currentPrayer = prayers[currentPrayerIndex - 1]['name'] as String;
    }

    state = state.copyWith(
      currentPrayer: currentPrayer,
      nextPrayerTime: nextPrayer['time'] as DateTime,
    );

    // Start countdown timer
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateNextPrayer(prayerTimes);
    });
  }

  Future<void> _schedulePrayerNotifications(PrayerTimes prayerTimes) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      
      // Parse prayer times and schedule notifications
      final fajrTime = DateTime.parse('$today ${prayerTimes.fajr}');
      final dhuhrTime = DateTime.parse('$today ${prayerTimes.dhuhr}');
      final asrTime = DateTime.parse('$today ${prayerTimes.asr}');
      final maghribTime = DateTime.parse('$today ${prayerTimes.maghrib}');
      final ishaTime = DateTime.parse('$today ${prayerTimes.isha}');

      await LocalNotificationService().scheduleDailyPrayers(
        fajrTime: fajrTime,
        dhuhrTime: dhuhrTime,
        asrTime: asrTime,
        maghribTime: maghribTime,
        ishaTime: ishaTime,
      );

      if (kDebugMode) {
        print('Prayer notifications scheduled successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to schedule prayer notifications: $e');
      }
    }
  }

  Future<void> loadTodayNotification() async {
    try {
      final apiService = ref.read(apiServiceProvider);
      final notification = await apiService.getTodayNotification();

      if (notification != null) {
        state = state.copyWith(
          todayNotification: notification,
        );
      }
    } catch (e) {
      // Silently fail for notification
    }
  }

  Future<void> loadRandomMessage({String? prayerTime}) async {
    state = state.copyWith(
      motivationalLoading: true,
      motivationalError: null,
    );

    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.getRandomMessage(prayerTime: prayerTime);

      state = state.copyWith(
        motivationalLoading: false,
        motivationalMessage: response['data'] as Map<String, dynamic>?,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        motivationalLoading: false,
        motivationalError: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        motivationalLoading: false,
        motivationalError: 'حدث خطأ في تحميل الرسالة',
      );
    }
  }

  Future<void> refreshAll() async {
    await loadPrayerTimes(forceRefresh: true);
    await loadTodayNotification();
  }
}
