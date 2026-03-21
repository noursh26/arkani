import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_times.freezed.dart';
part 'prayer_times.g.dart';

@freezed
class PrayerTimes with _$PrayerTimes {
  const factory PrayerTimes({
    required String fajr,
    required String sunrise,
    required String dhuhr,
    required String asr,
    required String maghrib,
    required String isha,
    String? midnight,
    String? lastThird,
    required String date,
    required String hijriDate,
    String? city,
    String? country,
  }) = _PrayerTimes;

  factory PrayerTimes.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimesFromJson(json);
}

@freezed
class PrayerMeta with _$PrayerMeta {
  const factory PrayerMeta({
    required String timezone,
    required String method,
    required String school,
    required String midnightMode,
    required String latitudeAdjustment,
  }) = _PrayerMeta;

  factory PrayerMeta.fromJson(Map<String, dynamic> json) =>
      _$PrayerMetaFromJson(json);
}
