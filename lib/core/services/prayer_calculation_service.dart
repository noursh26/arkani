import 'package:adhan/adhan.dart' as adhan;
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
  static const adhan.CalculationMethod calculationMethod = adhan.CalculationMethod.muslim_world_league;

  /// Calculate prayer times for a specific date and location
  static adhan.PrayerTimes calculatePrayerTimes({
    required double latitude,
    required double longitude,
    DateTime? date,
  }) {
    final coordinates = adhan.Coordinates(latitude, longitude);
    final params = calculationMethod.getParameters();
    params.madhab = adhan.Madhab.shafi;
    
    final prayerDate = date ?? DateTime.now();
    final dateComponents = adhan.DateComponents(prayerDate.year, prayerDate.month, prayerDate.day);
    
    return adhan.PrayerTimes(coordinates, dateComponents, params);
  }

  /// Calculate prayer times and convert to PrayerTimes entity
  static PrayerTimes calculatePrayerTimesEntity({
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
    
    return PrayerTimes(
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
  static adhan.Prayer? getCurrentPrayer({
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
  static adhan.Prayer getNextPrayer({
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
    required adhan.Prayer prayer,
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
      case adhan.Prayer.fajr:
        return prayerTimes.fajr;
      case adhan.Prayer.sunrise:
        return prayerTimes.sunrise;
      case adhan.Prayer.dhuhr:
        return prayerTimes.dhuhr;
      case adhan.Prayer.asr:
        return prayerTimes.asr;
      case adhan.Prayer.maghrib:
        return prayerTimes.maghrib;
      case adhan.Prayer.isha:
        return prayerTimes.isha;
      default:
        return null;
    }
  }

  /// Convert adhan Prayer enum to Arabic name
  static String prayerToArabic(adhan.Prayer prayer) {
    switch (prayer) {
      case adhan.Prayer.fajr:
        return 'الفجر';
      case adhan.Prayer.sunrise:
        return 'الشروق';
      case adhan.Prayer.dhuhr:
        return 'الظهر';
      case adhan.Prayer.asr:
        return 'العصر';
      case adhan.Prayer.maghrib:
        return 'المغرب';
      case adhan.Prayer.isha:
        return 'العشاء';
      default:
        return 'الفجر';
    }
  }
}
