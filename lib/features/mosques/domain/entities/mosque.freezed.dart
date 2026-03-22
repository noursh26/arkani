// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mosque.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Mosque _$MosqueFromJson(Map<String, dynamic> json) {
  return _Mosque.fromJson(json);
}

/// @nodoc
mixin _$Mosque {
  String get placeId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  int get distanceMeters => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MosqueCopyWith<Mosque> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MosqueCopyWith<$Res> {
  factory $MosqueCopyWith(Mosque value, $Res Function(Mosque) then) =
      _$MosqueCopyWithImpl<$Res, Mosque>;
  @useResult
  $Res call(
      {String placeId,
      String name,
      String address,
      double latitude,
      double longitude,
      double? rating,
      int distanceMeters});
}

/// @nodoc
class _$MosqueCopyWithImpl<$Res, $Val extends Mosque>
    implements $MosqueCopyWith<$Res> {
  _$MosqueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? name = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? rating = freezed,
    Object? distanceMeters = null,
  }) {
    return _then(_value.copyWith(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceMeters: null == distanceMeters
          ? _value.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MosqueImplCopyWith<$Res> implements $MosqueCopyWith<$Res> {
  factory _$$MosqueImplCopyWith(
          _$MosqueImpl value, $Res Function(_$MosqueImpl) then) =
      __$$MosqueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String placeId,
      String name,
      String address,
      double latitude,
      double longitude,
      double? rating,
      int distanceMeters});
}

/// @nodoc
class __$$MosqueImplCopyWithImpl<$Res>
    extends _$MosqueCopyWithImpl<$Res, _$MosqueImpl>
    implements _$$MosqueImplCopyWith<$Res> {
  __$$MosqueImplCopyWithImpl(
      _$MosqueImpl _value, $Res Function(_$MosqueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? name = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? rating = freezed,
    Object? distanceMeters = null,
  }) {
    return _then(_$MosqueImpl(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceMeters: null == distanceMeters
          ? _value.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MosqueImpl implements _Mosque {
  const _$MosqueImpl(
      {required this.placeId,
      required this.name,
      required this.address,
      required this.latitude,
      required this.longitude,
      this.rating,
      required this.distanceMeters});

  factory _$MosqueImpl.fromJson(Map<String, dynamic> json) =>
      _$$MosqueImplFromJson(json);

  @override
  final String placeId;
  @override
  final String name;
  @override
  final String address;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double? rating;
  @override
  final int distanceMeters;

  @override
  String toString() {
    return 'Mosque(placeId: $placeId, name: $name, address: $address, latitude: $latitude, longitude: $longitude, rating: $rating, distanceMeters: $distanceMeters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MosqueImpl &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.distanceMeters, distanceMeters) ||
                other.distanceMeters == distanceMeters));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, placeId, name, address, latitude,
      longitude, rating, distanceMeters);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MosqueImplCopyWith<_$MosqueImpl> get copyWith =>
      __$$MosqueImplCopyWithImpl<_$MosqueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MosqueImplToJson(
      this,
    );
  }
}

abstract class _Mosque implements Mosque {
  const factory _Mosque(
      {required final String placeId,
      required final String name,
      required final String address,
      required final double latitude,
      required final double longitude,
      final double? rating,
      required final int distanceMeters}) = _$MosqueImpl;

  factory _Mosque.fromJson(Map<String, dynamic> json) = _$MosqueImpl.fromJson;

  @override
  String get placeId;
  @override
  String get name;
  @override
  String get address;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double? get rating;
  @override
  int get distanceMeters;
  @override
  @JsonKey(ignore: true)
  _$$MosqueImplCopyWith<_$MosqueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
