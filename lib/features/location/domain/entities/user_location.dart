import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_location.g.dart';

@HiveType(typeId: 1)
class UserLocation extends Equatable {
  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  @HiveField(2)
  final String? cityName;

  @HiveField(3)
  final String? countryName;

  @HiveField(4)
  final String? address;

  @HiveField(5)
  final String? countryCode;

  @HiveField(6)
  final DateTime? savedAt;

  @HiveField(7)
  final bool isAutoDetected;

  @HiveField(8)
  final String? timezone;

  const UserLocation({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.countryName,
    this.address,
    this.countryCode,
    this.savedAt,
    this.isAutoDetected = false,
    this.timezone,
  });

  UserLocation copyWith({
    double? latitude,
    double? longitude,
    String? cityName,
    String? countryName,
    String? address,
    String? countryCode,
    DateTime? savedAt,
    bool? isAutoDetected,
    String? timezone,
  }) {
    return UserLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
      countryName: countryName ?? this.countryName,
      address: address ?? this.address,
      countryCode: countryCode ?? this.countryCode,
      savedAt: savedAt ?? this.savedAt,
      isAutoDetected: isAutoDetected ?? this.isAutoDetected,
      timezone: timezone ?? this.timezone,
    );
  }

  String get displayName {
    if (cityName != null && countryName != null) {
      return '$cityName, $countryName';
    } else if (cityName != null) {
      return cityName!;
    } else if (address != null) {
      return address!;
    }
    return '$latitude, $longitude';
  }

  String get shortDisplayName {
    return cityName ?? address?.split(',').first ?? '$latitude, $longitude';
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        cityName,
        countryName,
        address,
        countryCode,
        isAutoDetected,
        timezone,
      ];

  @override
  String toString() {
    return 'UserLocation(lat: $latitude, lng: $longitude, city: $cityName, country: $countryName)';
  }
}
