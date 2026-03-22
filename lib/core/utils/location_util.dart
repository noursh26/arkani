import 'package:flutter/foundation.dart';
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
      // Check if location services are enabled
      bool serviceEnabled;
      try {
        serviceEnabled = await Geolocator.isLocationServiceEnabled()
            .timeout(const Duration(seconds: 3), onTimeout: () => false);
      } catch (e) {
        debugPrint('Location service check error: $e');
        return _defaultLocation();
      }
      
      if (!serviceEnabled) {
        return _defaultLocation();
      }

      // Check permission
      LocationPermission permission;
      try {
        permission = await Geolocator.checkPermission()
            .timeout(const Duration(seconds: 3), onTimeout: () => LocationPermission.denied);
      } catch (e) {
        debugPrint('Permission check error: $e');
        return _defaultLocation();
      }
      
      if (permission == LocationPermission.denied) {
        try {
          permission = await Geolocator.requestPermission()
              .timeout(const Duration(seconds: 5), onTimeout: () => LocationPermission.denied);
        } catch (e) {
          debugPrint('Permission request error: $e');
          return _defaultLocation();
        }
        
        if (permission == LocationPermission.denied) {
          return _defaultLocation();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _defaultLocation();
      }

      // Get position
      Position position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        ).timeout(const Duration(seconds: 8), onTimeout: () {
          throw Exception('Location timeout');
        });
      } catch (e) {
        debugPrint('Get position error: $e');
        // Try with lower accuracy
        try {
          position = await Geolocator.getLastKnownPosition() ?? 
              Position(
                latitude: AppConstants.defaultLatitude,
                longitude: AppConstants.defaultLongitude,
                timestamp: DateTime.now(),
                accuracy: 0,
                altitude: 0,
                altitudeAccuracy: 0,
                heading: 0,
                headingAccuracy: 0,
                speed: 0,
                speedAccuracy: 0,
              );
        } catch (e2) {
          debugPrint('Last known position error: $e2');
          return _defaultLocation();
        }
      }

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      debugPrint('Location error: $e');
      return _defaultLocation();
    }
  }

  Future<bool> requestPermission() async {
    try {
      final permission = await Geolocator.requestPermission()
          .timeout(const Duration(seconds: 5), onTimeout: () => LocationPermission.denied);
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      debugPrint('Request permission error: $e');
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
