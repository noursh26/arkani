// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mosque.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MosqueImpl _$$MosqueImplFromJson(Map<String, dynamic> json) => _$MosqueImpl(
      placeId: json['place_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      distanceMeters: (json['distance_meters'] as num).toInt(),
    );

Map<String, dynamic> _$$MosqueImplToJson(_$MosqueImpl instance) =>
    <String, dynamic>{
      'place_id': instance.placeId,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'rating': instance.rating,
      'distance_meters': instance.distanceMeters,
    };
