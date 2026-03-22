// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mosques_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MosquesState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isOffline => throw _privateConstructorUsedError;
  List<Mosque> get mosques => throw _privateConstructorUsedError;
  LocationData? get currentLocation => throw _privateConstructorUsedError;
  Mosque? get selectedMosque => throw _privateConstructorUsedError;
  bool get isUsingDefaultLocation => throw _privateConstructorUsedError;
  bool get isLocationDenied => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MosquesStateCopyWith<MosquesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MosquesStateCopyWith<$Res> {
  factory $MosquesStateCopyWith(
          MosquesState value, $Res Function(MosquesState) then) =
      _$MosquesStateCopyWithImpl<$Res, MosquesState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isOffline,
      List<Mosque> mosques,
      LocationData? currentLocation,
      Mosque? selectedMosque,
      bool isUsingDefaultLocation,
      bool isLocationDenied,
      String? error});

  $MosqueCopyWith<$Res>? get selectedMosque;
}

/// @nodoc
class _$MosquesStateCopyWithImpl<$Res, $Val extends MosquesState>
    implements $MosquesStateCopyWith<$Res> {
  _$MosquesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isOffline = null,
    Object? mosques = null,
    Object? currentLocation = freezed,
    Object? selectedMosque = freezed,
    Object? isUsingDefaultLocation = null,
    Object? isLocationDenied = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isOffline: null == isOffline
          ? _value.isOffline
          : isOffline // ignore: cast_nullable_to_non_nullable
              as bool,
      mosques: null == mosques
          ? _value.mosques
          : mosques // ignore: cast_nullable_to_non_nullable
              as List<Mosque>,
      currentLocation: freezed == currentLocation
          ? _value.currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as LocationData?,
      selectedMosque: freezed == selectedMosque
          ? _value.selectedMosque
          : selectedMosque // ignore: cast_nullable_to_non_nullable
              as Mosque?,
      isUsingDefaultLocation: null == isUsingDefaultLocation
          ? _value.isUsingDefaultLocation
          : isUsingDefaultLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      isLocationDenied: null == isLocationDenied
          ? _value.isLocationDenied
          : isLocationDenied // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MosqueCopyWith<$Res>? get selectedMosque {
    if (_value.selectedMosque == null) {
      return null;
    }

    return $MosqueCopyWith<$Res>(_value.selectedMosque!, (value) {
      return _then(_value.copyWith(selectedMosque: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MosquesStateImplCopyWith<$Res>
    implements $MosquesStateCopyWith<$Res> {
  factory _$$MosquesStateImplCopyWith(
          _$MosquesStateImpl value, $Res Function(_$MosquesStateImpl) then) =
      __$$MosquesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isOffline,
      List<Mosque> mosques,
      LocationData? currentLocation,
      Mosque? selectedMosque,
      bool isUsingDefaultLocation,
      bool isLocationDenied,
      String? error});

  @override
  $MosqueCopyWith<$Res>? get selectedMosque;
}

/// @nodoc
class __$$MosquesStateImplCopyWithImpl<$Res>
    extends _$MosquesStateCopyWithImpl<$Res, _$MosquesStateImpl>
    implements _$$MosquesStateImplCopyWith<$Res> {
  __$$MosquesStateImplCopyWithImpl(
      _$MosquesStateImpl _value, $Res Function(_$MosquesStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isOffline = null,
    Object? mosques = null,
    Object? currentLocation = freezed,
    Object? selectedMosque = freezed,
    Object? isUsingDefaultLocation = null,
    Object? isLocationDenied = null,
    Object? error = freezed,
  }) {
    return _then(_$MosquesStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isOffline: null == isOffline
          ? _value.isOffline
          : isOffline // ignore: cast_nullable_to_non_nullable
              as bool,
      mosques: null == mosques
          ? _value._mosques
          : mosques // ignore: cast_nullable_to_non_nullable
              as List<Mosque>,
      currentLocation: freezed == currentLocation
          ? _value.currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as LocationData?,
      selectedMosque: freezed == selectedMosque
          ? _value.selectedMosque
          : selectedMosque // ignore: cast_nullable_to_non_nullable
              as Mosque?,
      isUsingDefaultLocation: null == isUsingDefaultLocation
          ? _value.isUsingDefaultLocation
          : isUsingDefaultLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      isLocationDenied: null == isLocationDenied
          ? _value.isLocationDenied
          : isLocationDenied // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MosquesStateImpl implements _MosquesState {
  const _$MosquesStateImpl(
      {this.isLoading = false,
      this.isOffline = false,
      final List<Mosque> mosques = const [],
      this.currentLocation,
      this.selectedMosque,
      this.isUsingDefaultLocation = false,
      this.isLocationDenied = false,
      this.error})
      : _mosques = mosques;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isOffline;
  final List<Mosque> _mosques;
  @override
  @JsonKey()
  List<Mosque> get mosques {
    if (_mosques is EqualUnmodifiableListView) return _mosques;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mosques);
  }

  @override
  final LocationData? currentLocation;
  @override
  final Mosque? selectedMosque;
  @override
  @JsonKey()
  final bool isUsingDefaultLocation;
  @override
  @JsonKey()
  final bool isLocationDenied;
  @override
  final String? error;

  @override
  String toString() {
    return 'MosquesState(isLoading: $isLoading, isOffline: $isOffline, mosques: $mosques, currentLocation: $currentLocation, selectedMosque: $selectedMosque, isUsingDefaultLocation: $isUsingDefaultLocation, isLocationDenied: $isLocationDenied, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MosquesStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isOffline, isOffline) ||
                other.isOffline == isOffline) &&
            const DeepCollectionEquality().equals(other._mosques, _mosques) &&
            (identical(other.currentLocation, currentLocation) ||
                other.currentLocation == currentLocation) &&
            (identical(other.selectedMosque, selectedMosque) ||
                other.selectedMosque == selectedMosque) &&
            (identical(other.isUsingDefaultLocation, isUsingDefaultLocation) ||
                other.isUsingDefaultLocation == isUsingDefaultLocation) &&
            (identical(other.isLocationDenied, isLocationDenied) ||
                other.isLocationDenied == isLocationDenied) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isOffline,
      const DeepCollectionEquality().hash(_mosques),
      currentLocation,
      selectedMosque,
      isUsingDefaultLocation,
      isLocationDenied,
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MosquesStateImplCopyWith<_$MosquesStateImpl> get copyWith =>
      __$$MosquesStateImplCopyWithImpl<_$MosquesStateImpl>(this, _$identity);
}

abstract class _MosquesState implements MosquesState {
  const factory _MosquesState(
      {final bool isLoading,
      final bool isOffline,
      final List<Mosque> mosques,
      final LocationData? currentLocation,
      final Mosque? selectedMosque,
      final bool isUsingDefaultLocation,
      final bool isLocationDenied,
      final String? error}) = _$MosquesStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isOffline;
  @override
  List<Mosque> get mosques;
  @override
  LocationData? get currentLocation;
  @override
  Mosque? get selectedMosque;
  @override
  bool get isUsingDefaultLocation;
  @override
  bool get isLocationDenied;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$MosquesStateImplCopyWith<_$MosquesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
