// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

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
      lastThird: json['lastThird'] as String?,
      date: json['date'] as String,
      hijriDate: json['hijriDate'] as String,
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
      'lastThird': instance.lastThird,
      'date': instance.date,
      'hijriDate': instance.hijriDate,
      'city': instance.city,
      'country': instance.country,
    };

_$PrayerMetaImpl _$$PrayerMetaImplFromJson(Map<String, dynamic> json) =>
    _$PrayerMetaImpl(
      timezone: json['timezone'] as String,
      method: json['method'] as String,
      school: json['school'] as String,
      midnightMode: json['midnightMode'] as String,
      latitudeAdjustment: json['latitudeAdjustment'] as String,
    );

Map<String, dynamic> _$$PrayerMetaImplToJson(_$PrayerMetaImpl instance) =>
    <String, dynamic>{
      'timezone': instance.timezone,
      'method': instance.method,
      'school': instance.school,
      'midnightMode': instance.midnightMode,
      'latitudeAdjustment': instance.latitudeAdjustment,
    };
