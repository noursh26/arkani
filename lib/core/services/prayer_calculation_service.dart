import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

import '../../features/home/domain/entities/prayer_times.dart';

/// Service for calculating prayer times locally using the adhan library.
/// This serves as a fallback when the API is unavailable.
class PrayerCalculationService {
  PrayerCalculationService._();

  static final PrayerCalculationService _instance = PrayerCalculationService._();
  static PrayerCalculationService get instance => _instance;

  /// Default coordinates (can be overridden)
  static const double defaultLatitude = 24.7136;  // Riyadh
  static const double defaultLongitude = 46.6753;

  /// Calculation method - Muslim World League
  static const CalculationMethod calculationMethod = CalculationMethod.muslim_world_league;

  /// Calculate prayer times for a specific date and location
  static PrayerTimes calculatePrayerTimes({
    required double latitude,
    required double longitude,
    DateTime? date,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    final params = calculationMethod.getParameters();
    params.madhab = Madhab.shafi;
    
    final prayerDate = date ?? DateTime.now();
    final dateComponents = DateComponents(prayerDate.year, prayerDate.month, prayerDate.day);
    
    return PrayerTimes(coordinates, dateComponents, params);
  }

  /// Calculate prayer times and convert to PrayerTimes entity
  static PrayerTimesEntity calculatePrayerTimesEntity({
    double? latitude,
    double? longitude,
    DateTime? date,
    String? city,
    String? country,
  }) {
    final lat = latitude ?? defaultLatitude;
    final lng = longitude ?? defaultLongitude;
    
    final adhanPrayerTimes = calculatePrayerTimes(
      latitude: lat,
      longitude: lng,
      date: date,
    );

    final prayerDate = date ?? DateTime.now();
    final timeFormat = DateFormat('HH:mm');
    
    return PrayerTimesEntity(
      fajr: timeFormat.format(adhanPrayerTimes.fajr),
      sunrise: timeFormat.format(adhanPrayerTimes.sunrise),
      dhuhr: timeFormat.format(adhanPrayerTimes.dhuhr),
      asr: timeFormat.format(adhanPrayerTimes.asr),
      maghrib: timeFormat.format(adhanPrayerTimes.maghrib),
      isha: timeFormat.format(adhanPrayerTimes.isha),
      date: prayerDate.toIso8601String().split('T')[0],
      hijriDate: '', // Can be filled using hijri package if needed
      city: city,
      country: country,
    );
  }

  /// Get current prayer time
  static Prayer? getCurrentPrayer({
    double? latitude,
    double? longitude,
    DateTime? date,
  }) {
    final prayerTimes = calculatePrayerTimes(
      latitude: latitude ?? defaultLatitude,
      longitude: longitude ?? defaultLongitude,
      date: date,
    );
    return prayerTimes.currentPrayer();
  }

  /// Get next prayer time
  static Prayer getNextPrayer({
    double? latitude,
    double? longitude,
    DateTime? date,
  }) {
    final prayerTimes = calculatePrayerTimes(
      latitude: latitude ?? defaultLatitude,
      longitude: longitude ?? defaultLongitude,
      date: date,
    );
    return prayerTimes.nextPrayer();
  }

  /// Get time for a specific prayer
  static DateTime? getPrayerTime({
    required Prayer prayer,
    double? latitude,
    double? longitude,
    DateTime? date,
  }) {
    final prayerTimes = calculatePrayerTimes(
      latitude: latitude ?? defaultLatitude,
      longitude: longitude ?? defaultLongitude,
      date: date,
    );
    
    switch (prayer) {
      case Prayer.fajr:
        return prayerTimes.fajr;
      case Prayer.sunrise:
        return prayerTimes.sunrise;
      case Prayer.dhuhr:
        return prayerTimes.dhuhr;
      case Prayer.asr:
        return prayerTimes.asr;
      case Prayer.maghrib:
        return prayerTimes.maghrib;
      case Prayer.isha:
        return prayerTimes.isha;
      default:
        return null;
    }
  }

  /// Convert adhan Prayer enum to Arabic name
  static String prayerToArabic(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.sunrise:
        return 'الشروق';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      default:
        return 'الفجر';
    }
  }
}
