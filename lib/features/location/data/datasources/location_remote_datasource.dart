import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/entities/user_location.dart';

abstract class LocationRemoteDataSource {
  /// Get current device location
  Future<UserLocation> getCurrentLocation();

  /// Get location info from coordinates
  Future<UserLocation> getLocationFromCoordinates(double latitude, double longitude);

  /// Search locations by query
  Future<List<UserLocation>> searchLocations(String query);

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled();

  /// Check location permission status
  Future<bool> isLocationPermissionGranted();

  /// Request location permission
  Future<bool> requestLocationPermission();
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final GeolocatorPlatform geolocator;

  LocationRemoteDataSourceImpl({GeolocatorPlatform? geolocator})
      : geolocator = geolocator ?? GeolocatorPlatform.instance;

  @override
  Future<UserLocation> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      return await getLocationFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } on TimeoutException {
      throw const LocationException('انتهى الوقت المحدد للحصول على الموقع');
    } catch (e) {
      throw LocationException('فشل في الحصول على الموقع: $e');
    }
  }

  @override
  Future<UserLocation> getLocationFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        return UserLocation(
          latitude: latitude,
          longitude: longitude,
          isAutoDetected: false,
        );
      }

      final place = placemarks.first;
      final cityName = place.locality ??
          place.subAdministrativeArea ??
          place.administrativeArea ??
          place.subLocality;

      final countryName = place.country;

      final addressParts = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country,
      ].where((part) => part != null && part.isNotEmpty).toList();

      final address = addressParts.isNotEmpty ? addressParts.join(', ') : null;

      return UserLocation(
        latitude: latitude,
        longitude: longitude,
        cityName: cityName,
        countryName: countryName,
        address: address,
        countryCode: place.isoCountryCode,
        savedAt: DateTime.now(),
        isAutoDetected: true,
        timezone: DateTime.now().timeZoneName,
      );
    } catch (e) {
      return UserLocation(
        latitude: latitude,
        longitude: longitude,
        savedAt: DateTime.now(),
        isAutoDetected: false,
      );
    }
  }

  @override
  Future<List<UserLocation>> searchLocations(String query) async {
    try {
      final locations = await locationFromAddress(query);

      final results = <UserLocation>[];

      for (final location in locations.take(5)) {
        try {
          final userLocation = await getLocationFromCoordinates(
            location.latitude,
            location.longitude,
          );
          results.add(userLocation);
        } catch (_) {
          results.add(UserLocation(
            latitude: location.latitude,
            longitude: location.longitude,
            cityName: query,
            isAutoDetected: false,
          ));
        }
      }

      return results;
    } catch (e) {
      throw LocationException('فشل في البحث عن الموقع: $e');
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<bool> isLocationPermissionGranted() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}

class LocationException implements Exception {
  final String message;
  const LocationException(this.message);

  @override
  String toString() => message;
}
