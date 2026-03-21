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
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _defaultLocation();
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return _defaultLocation();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return _defaultLocation();
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      return _defaultLocation();
    }
  }

  Future<bool> requestPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
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
