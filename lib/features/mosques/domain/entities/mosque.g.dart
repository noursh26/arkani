// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mosque.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MosqueImpl _$$MosqueImplFromJson(Map<String, dynamic> json) => _$MosqueImpl(
      placeId: json['placeId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      distanceMeters: json['distanceMeters'] as int,
    );

Map<String, dynamic> _$$MosqueImplToJson(_$MosqueImpl instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'rating': instance.rating,
      'distanceMeters': instance.distanceMeters,
    };
