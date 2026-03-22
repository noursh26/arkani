// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_times.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrayerTimesImpl _$$PrayerTimesImplFromJson(Map<String, dynamic> json) =>
    _$PrayerTimesImpl(
      fajr: json['fajr'] as String,
      sunrise: json['sunrise'] as String,
      dhuhr: json['dhuhr'] as String,
      asr: json['asr'] as String,
      maghrib: json['maghrib'] as String,
      isha: json['isha'] as String,
      midnight: json['midnight'] as String?,
      lastThird: json['last_third'] as String?,
      date: json['date'] as String,
      hijriDate: json['hijri_date'] as String,
      city: json['city'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$$PrayerTimesImplToJson(_$PrayerTimesImpl instance) =>
    <String, dynamic>{
      'fajr': instance.fajr,
      'sunrise': instance.sunrise,
      'dhuhr': instance.dhuhr,
      'asr': instance.asr,
      'maghrib': instance.maghrib,
      'isha': instance.isha,
      'midnight': instance.midnight,
      'last_third': instance.lastThird,
      'date': instance.date,
      'hijri_date': instance.hijriDate,
      'city': instance.city,
      'country': instance.country,
    };

_$PrayerMetaImpl _$$PrayerMetaImplFromJson(Map<String, dynamic> json) =>
    _$PrayerMetaImpl(
      timezone: json['timezone'] as String,
      method: json['method'] as String,
      school: json['school'] as String,
      midnightMode: json['midnight_mode'] as String,
      latitudeAdjustment: json['latitude_adjustment'] as String,
    );

Map<String, dynamic> _$$PrayerMetaImplToJson(_$PrayerMetaImpl instance) =>
    <String, dynamic>{
      'timezone': instance.timezone,
      'method': instance.method,
      'school': instance.school,
      'midnight_mode': instance.midnightMode,
      'latitude_adjustment': instance.latitudeAdjustment,
    };
