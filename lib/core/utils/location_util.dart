import 'package:geolocator/geolocator.dart';

import '../constants/app_constants.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final String? city;
  final String? country;

  LocationData({
    required this.latitude,
    required this.longitude,
    this.city,
    this.country,
  });
}

class LocationUtil {
  Future<LocationData> getCurrentLocation() async {
    try {
      // Check if location services are enabled (with timeout)
      final serviceEnabled = await Geolocator.isLocationServiceEnabled()
          .timeout(const Duration(seconds: 3), onTimeout: () => false);
      if (!serviceEnabled) {
        return _defaultLocation();
      }

      // Check permission (with timeout)
      var permission = await Geolocator.checkPermission()
          .timeout(const Duration(seconds: 3), onTimeout: () => LocationPermission.denied);
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission()
            .timeout(const Duration(seconds: 5), onTimeout: () => LocationPermission.denied);
        if (permission == LocationPermission.denied) {
          return _defaultLocation();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _defaultLocation();
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(const Duration(seconds: 8), onTimeout: () {
        throw Exception('Location timeout');
      });

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      return _defaultLocation();
    }
  }

  Future<bool> requestPermission() async {
    try {
      final permission = await Geolocator.requestPermission()
          .timeout(const Duration(seconds: 5), onTimeout: () => LocationPermission.denied);
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (_) {
      return false;
    }
  }

  LocationData _defaultLocation() {
    return LocationData(
      latitude: AppConstants.defaultLatitude,
      longitude: AppConstants.defaultLongitude,
      city: 'الرياض',
      country: 'المملكة العربية السعودية',
    );
  }
}
