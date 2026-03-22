import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

import '../constants/app_constants.dart';

/// Model for detailed location data
class LocationData {
  final String id;
  final double latitude;
  final double longitude;
  final String? city;
  final String? country;
  final String? address;
  final String? countryCode;
  final String? administrativeArea;
  final String? subAdministrativeArea;
  final String? locality;
  final String? subLocality;
  final DateTime? savedAt;
  final bool isAutoDetected;

  LocationData({
    String? id,
    required this.latitude,
    required this.longitude,
    this.city,
    this.country,
    this.address,
    this.countryCode,
    this.administrativeArea,
    this.subAdministrativeArea,
    this.locality,
    this.subLocality,
    this.savedAt,
    this.isAutoDetected = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  /// Get display name for the location
  String get displayName {
    if (city != null && country != null) {
      return '$city، $country';
    } else if (city != null) {
      return city!;
    } else if (address != null && address!.isNotEmpty) {
      return address!;
    } else if (locality != null) {
      return locality!;
    } else {
      return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    }
  }

  /// Get short display name
  String get shortName {
    return city ?? locality ?? address?.split(',').first ??
        '${latitude.toStringAsFixed(2)}°, ${longitude.toStringAsFixed(2)}°';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'country': country,
      'address': address,
      'countryCode': countryCode,
      'administrativeArea': administrativeArea,
      'subAdministrativeArea': subAdministrativeArea,
      'locality': locality,
      'subLocality': subLocality,
      'savedAt': savedAt?.toIso8601String(),
      'isAutoDetected': isAutoDetected,
    };
  }

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      id: json['id'] as String?,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      city: json['city'] as String?,
      country: json['country'] as String?,
      address: json['address'] as String?,
      countryCode: json['countryCode'] as String?,
      administrativeArea: json['administrativeArea'] as String?,
      subAdministrativeArea: json['subAdministrativeArea'] as String?,
      locality: json['locality'] as String?,
      subLocality: json['subLocality'] as String?,
      savedAt: json['savedAt'] != null
          ? DateTime.parse(json['savedAt'] as String)
          : null,
      isAutoDetected: json['isAutoDetected'] as bool? ?? false,
    );
  }

  LocationData copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? city,
    String? country,
    String? address,
    String? countryCode,
    String? administrativeArea,
    String? subAdministrativeArea,
    String? locality,
    String? subLocality,
    DateTime? savedAt,
    bool? isAutoDetected,
  }) {
    return LocationData(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      country: country ?? this.country,
      address: address ?? this.address,
      countryCode: countryCode ?? this.countryCode,
      administrativeArea: administrativeArea ?? this.administrativeArea,
      subAdministrativeArea:
          subAdministrativeArea ?? this.subAdministrativeArea,
      locality: locality ?? this.locality,
      subLocality: subLocality ?? this.subLocality,
      savedAt: savedAt ?? this.savedAt,
      isAutoDetected: isAutoDetected ?? this.isAutoDetected,
    );
  }

  @override
  String toString() =>
      'LocationData(id: $id, lat: $latitude, lng: $longitude, city: $city)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationData &&
        other.id == id &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(id, latitude, longitude);
}

/// Service for managing location operations
class LocationService {
  static const String _savedLocationsKey = 'saved_locations';
  static const String _currentLocationKey = 'current_location';

  /// Get current location with full address details
  Future<LocationData> getCurrentLocation({bool highAccuracy = false}) async {
    try {
      final bool serviceEnabled = await _checkLocationService();
      if (!serviceEnabled) {
        return _defaultLocation();
      }

      final LocationPermission permission = await _checkAndRequestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return _defaultLocation();
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy:
            highAccuracy ? LocationAccuracy.high : LocationAccuracy.medium,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Location timeout');
      });

      // Get address details from coordinates
      final Placemark? placemark = await _getPlacemarkFromPosition(position);

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        city: placemark?.locality ?? placemark?.subAdministrativeArea,
        country: placemark?.country,
        address: _formatAddress(placemark),
        countryCode: placemark?.isoCountryCode,
        administrativeArea: placemark?.administrativeArea,
        subAdministrativeArea: placemark?.subAdministrativeArea,
        locality: placemark?.locality,
        subLocality: placemark?.subLocality,
        savedAt: DateTime.now(),
        isAutoDetected: true,
      );
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return _defaultLocation();
    }
  }

  /// Search for locations by query
  Future<List<LocationData>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final List<Location> locations =
          await locationFromAddress(query, localeIdentifier: 'ar');

      final List<LocationData> results = [];
      for (final Location location in locations.take(5)) {
        try {
          final List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
            localeIdentifier: 'ar',
          );

          if (placemarks.isNotEmpty) {
            final Placemark placemark = placemarks.first;
            results.add(LocationData(
              latitude: location.latitude,
              longitude: location.longitude,
              city: placemark.locality ?? placemark.subAdministrativeArea,
              country: placemark.country,
              address: _formatAddress(placemark),
              countryCode: placemark.isoCountryCode,
              administrativeArea: placemark.administrativeArea,
              subAdministrativeArea: placemark.subAdministrativeArea,
              locality: placemark.locality,
              subLocality: placemark.subLocality,
              savedAt: DateTime.now(),
              isAutoDetected: false,
            ));
          }
        } catch (e) {
          // Skip this location if geocoding fails
          continue;
        }
      }

      return results;
    } catch (e) {
      debugPrint('Error searching locations: $e');
      return [];
    }
  }

  /// Get location details from coordinates
  Future<LocationData> getLocationFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
        localeIdentifier: 'ar',
      );

      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks.first;
        return LocationData(
          latitude: latitude,
          longitude: longitude,
          city: placemark.locality ?? placemark.subAdministrativeArea,
          country: placemark.country,
          address: _formatAddress(placemark),
          countryCode: placemark.isoCountryCode,
          administrativeArea: placemark.administrativeArea,
          subAdministrativeArea: placemark.subAdministrativeArea,
          locality: placemark.locality,
          subLocality: placemark.subLocality,
          savedAt: DateTime.now(),
          isAutoDetected: false,
        );
      }

      return LocationData(
        latitude: latitude,
        longitude: longitude,
        savedAt: DateTime.now(),
      );
    } catch (e) {
      return LocationData(
        latitude: latitude,
        longitude: longitude,
        savedAt: DateTime.now(),
      );
    }
  }

  /// Get saved locations from storage
  Future<List<LocationData>> getSavedLocations() async {
    try {
      final Box box = Hive.box(AppConstants.hiveBoxName);
      final String? jsonStr = box.get(_savedLocationsKey) as String?;

      if (jsonStr == null || jsonStr.isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(jsonStr) as List<dynamic>;
      return jsonList
          .map((json) => LocationData.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error getting saved locations: $e');
      return [];
    }
  }

  /// Save a location to saved locations
  Future<void> saveLocation(LocationData location) async {
    try {
      final Box box = Hive.box(AppConstants.hiveBoxName);
      final List<LocationData> savedLocations = await getSavedLocations();

      // Check if location already exists
      final bool exists = savedLocations.any((l) =>
          l.latitude == location.latitude && l.longitude == location.longitude);

      if (!exists) {
        savedLocations.add(location.copyWith(savedAt: DateTime.now()));
        await box.put(
            _savedLocationsKey,
            jsonEncode(savedLocations.map((l) => l.toJson()).toList()));
      }
    } catch (e) {
      debugPrint('Error saving location: $e');
    }
  }

  /// Remove a location from saved locations
  Future<void> removeSavedLocation(String id) async {
    try {
      final Box box = Hive.box(AppConstants.hiveBoxName);
      final List<LocationData> savedLocations = await getSavedLocations();

      savedLocations.removeWhere((l) => l.id == id);
      await box.put(
          _savedLocationsKey,
          jsonEncode(savedLocations.map((l) => l.toJson()).toList()));
    } catch (e) {
      debugPrint('Error removing saved location: $e');
    }
  }

  /// Get last selected location
  Future<LocationData?> getLastSelectedLocation() async {
    try {
      final Box box = Hive.box(AppConstants.hiveBoxName);
      final String? jsonStr = box.get(_currentLocationKey) as String?;

      if (jsonStr == null || jsonStr.isEmpty) return null;

      return LocationData.fromJson(
          jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting last selected location: $e');
      return null;
    }
  }

  /// Save current selected location
  Future<void> saveCurrentLocation(LocationData location) async {
    try {
      final Box box = Hive.box(AppConstants.hiveBoxName);
      await box.put(_currentLocationKey, jsonEncode(location.toJson()));
    } catch (e) {
      debugPrint('Error saving current location: $e');
    }
  }

  /// Check location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<bool> requestPermission() async {
    try {
      final LocationPermission permission =
          await Geolocator.requestPermission();
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  /// Check if location service is enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Open location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  // Private helper methods
  Future<bool> _checkLocationService() async {
    try {
      return await Geolocator.isLocationServiceEnabled()
          .timeout(const Duration(seconds: 3), onTimeout: () => false);
    } catch (e) {
      return false;
    }
  }

  Future<LocationPermission> _checkAndRequestPermission() async {
    try {
      LocationPermission permission =
          await Geolocator.checkPermission().timeout(
        const Duration(seconds: 3),
        onTimeout: () => LocationPermission.denied,
      );

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission().timeout(
          const Duration(seconds: 5),
          onTimeout: () => LocationPermission.denied,
        );
      }

      return permission;
    } catch (e) {
      return LocationPermission.denied;
    }
  }

  Future<Placemark?> _getPlacemarkFromPosition(Position position) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: 'ar',
      ).timeout(const Duration(seconds: 5));

      return placemarks.isNotEmpty ? placemarks.first : null;
    } catch (e) {
      return null;
    }
  }

  String? _formatAddress(Placemark? placemark) {
    if (placemark == null) return null;

    final List<String> parts = [
      if (placemark.street != null && placemark.street!.isNotEmpty)
        placemark.street!,
      if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty)
        placemark.subLocality!,
      if (placemark.locality != null && placemark.locality!.isNotEmpty)
        placemark.locality!,
      if (placemark.administrativeArea != null &&
          placemark.administrativeArea!.isNotEmpty)
        placemark.administrativeArea!,
      if (placemark.country != null && placemark.country!.isNotEmpty)
        placemark.country!,
    ];

    return parts.isNotEmpty ? parts.join(', ') : null;
  }

  LocationData _defaultLocation() {
    return LocationData(
      id: 'default',
      latitude: AppConstants.defaultLatitude,
      longitude: AppConstants.defaultLongitude,
      city: 'الرياض',
      country: 'المملكة العربية السعودية',
      address: 'الرياض، المملكة العربية السعودية',
      isAutoDetected: false,
    );
  }
}

// Legacy class for backward compatibility
@Deprecated('Use LocationService instead')
class LocationUtil extends LocationService {
  @override
  Future<LocationData> getCurrentLocation({bool highAccuracy = false}) async {
    return super.getCurrentLocation(highAccuracy: highAccuracy);
  }
}
