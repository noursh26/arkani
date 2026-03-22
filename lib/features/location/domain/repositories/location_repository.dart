import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/prayer_times.dart';
import '../entities/user_location.dart';

abstract class LocationRepository {
  /// Get current device location with GPS
  Future<Either<Failure, UserLocation>> getCurrentLocation();

  /// Get location from coordinates (reverse geocoding)
  Future<Either<Failure, UserLocation>> getLocationFromCoordinates(
    double latitude,
    double longitude,
  );

  /// Search for locations by query
  Future<Either<Failure, List<UserLocation>>> searchLocations(String query);

  /// Get saved location from local storage
  Future<Either<Failure, UserLocation?>> getSavedLocation();

  /// Save location to local storage
  Future<Either<Failure, Unit>> saveLocation(UserLocation location);

  /// Clear saved location
  Future<Either<Failure, Unit>> clearSavedLocation();

  /// Check if location permission is granted
  Future<Either<Failure, bool>> isLocationPermissionGranted();

  /// Request location permission
  Future<Either<Failure, bool>> requestLocationPermission();

  /// Check if location services are enabled
  Future<Either<Failure, bool>> isLocationServiceEnabled();
}

abstract class PrayerTimesRepository {
  /// Calculate prayer times for a location
  Future<Either<Failure, PrayerTimes>> calculatePrayerTimes(
    UserLocation location, {
    DateTime? date,
    String? calculationMethod,
  });

  /// Get prayer times for the whole month
  Future<Either<Failure, List<PrayerTimes>>> calculateMonthlyPrayerTimes(
    UserLocation location,
    int year,
    int month, {
    String? calculationMethod,
  });

  /// Get saved prayer times for today
  Future<Either<Failure, PrayerTimes?>> getSavedPrayerTimes();

  /// Save prayer times to local storage
  Future<Either<Failure, Unit>> savePrayerTimes(PrayerTimes prayerTimes);

  /// Get Qibla direction for a location
  Future<Either<Failure, double>> getQiblaDirection(UserLocation location);

  /// Get available calculation methods
  List<CalculationMethod> getAvailableCalculationMethods();
}

class CalculationMethod {
  final String id;
  final String name;
  final String? description;

  const CalculationMethod({
    required this.id,
    required this.name,
    this.description,
  });

  static const List<CalculationMethod> defaultMethods = [
    CalculationMethod(
      id: 'muslim_world_league',
      name: 'رابطة العالم الإسلامي',
      description: 'تستخدم في أوروبا وأمريكا وكندا',
    ),
    CalculationMethod(
      id: 'egyptian',
      name: 'الهيئة المصرية العامة للمساحة',
      description: 'تستخدم في مصر والسودان وسوريا',
    ),
    CalculationMethod(
      id: 'karachi',
      name: 'جامعة العلوم الإسلامية بكراتشي',
      description: 'تستخدم في باكستان وأفغانستان والهند',
    ),
    CalculationMethod(
      id: 'umm_al_qura',
      name: 'أم القرى',
      description: 'تستخدم في السعودية',
    ),
    CalculationMethod(
      id: 'dubai',
      name: 'دائرة الأوقاف بدبي',
      description: 'تستخدم في الإمارات العربية المتحدة',
    ),
    CalculationMethod(
      id: 'makkah',
      name: 'جامعة أم القرى بمكة المكرمة',
      description: 'تستخدم في مكة المكرمة',
    ),
    CalculationMethod(
      id: 'kuwait',
      name: 'الكويت',
      description: 'تستخدم في الكويت',
    ),
    CalculationMethod(
      id: 'qatar',
      name: 'دولة قطر',
      description: 'تستخدم في قطر',
    ),
    CalculationMethod(
      id: 'singapore',
      name: 'مجلس الفتوى الإسلامي بسنغافورة',
      description: 'تستخدم في سنغافورة وماليزيا وإندونيسيا',
    ),
    CalculationMethod(
      id: 'turkey',
      name: 'الهيئة التركية للشؤون الدينية',
      description: 'تستخدم في تركيا',
    ),
    CalculationMethod(
      id: 'tehran',
      name: 'معهد الجيوفيزياء بجامعة طهران',
      description: 'تستخدم في إيران والكويت والبحرين',
    ),
    CalculationMethod(
      id: 'north_america',
      name: 'الإسلامي لشمال أمريكا',
      description: 'تستخدم في الولايات المتحدة وكندا',
    ),
  ];
}
