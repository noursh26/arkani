import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/prayer_times.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool isLoading,
    @Default(false) bool isOffline,
    PrayerTimes? prayerTimes,
    Map<String, dynamic>? todayNotification,
    Map<String, dynamic>? motivationalMessage,
    @Default(false) bool motivationalLoading,
    String? motivationalError,
    String? error,
    String? currentPrayer,
    DateTime? nextPrayerTime,
    @Default(false) bool locationPermissionGranted,
  }) = _HomeState;
}
