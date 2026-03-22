// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isOffline => throw _privateConstructorUsedError;
  PrayerTimes? get prayerTimes => throw _privateConstructorUsedError;
  Map<String, dynamic>? get todayNotification =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get motivationalMessage =>
      throw _privateConstructorUsedError;
  bool get motivationalLoading => throw _privateConstructorUsedError;
  String? get motivationalError => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get currentPrayer => throw _privateConstructorUsedError;
  DateTime? get nextPrayerTime => throw _privateConstructorUsedError;
  bool get locationPermissionGranted => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isOffline,
      PrayerTimes? prayerTimes,
      Map<String, dynamic>? todayNotification,
      Map<String, dynamic>? motivationalMessage,
      bool motivationalLoading,
      String? motivationalError,
      String? error,
      String? currentPrayer,
      DateTime? nextPrayerTime,
      bool locationPermissionGranted});

  $PrayerTimesCopyWith<$Res>? get prayerTimes;
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isOffline = null,
    Object? prayerTimes = freezed,
    Object? todayNotification = freezed,
    Object? motivationalMessage = freezed,
    Object? motivationalLoading = null,
    Object? motivationalError = freezed,
    Object? error = freezed,
    Object? currentPrayer = freezed,
    Object? nextPrayerTime = freezed,
    Object? locationPermissionGranted = null,
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
      prayerTimes: freezed == prayerTimes
          ? _value.prayerTimes
          : prayerTimes // ignore: cast_nullable_to_non_nullable
              as PrayerTimes?,
      todayNotification: freezed == todayNotification
          ? _value.todayNotification
          : todayNotification // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      motivationalMessage: freezed == motivationalMessage
          ? _value.motivationalMessage
          : motivationalMessage // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      motivationalLoading: null == motivationalLoading
          ? _value.motivationalLoading
          : motivationalLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      motivationalError: freezed == motivationalError
          ? _value.motivationalError
          : motivationalError // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      currentPrayer: freezed == currentPrayer
          ? _value.currentPrayer
          : currentPrayer // ignore: cast_nullable_to_non_nullable
              as String?,
      nextPrayerTime: freezed == nextPrayerTime
          ? _value.nextPrayerTime
          : nextPrayerTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      locationPermissionGranted: null == locationPermissionGranted
          ? _value.locationPermissionGranted
          : locationPermissionGranted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PrayerTimesCopyWith<$Res>? get prayerTimes {
    if (_value.prayerTimes == null) {
      return null;
    }

    return $PrayerTimesCopyWith<$Res>(_value.prayerTimes!, (value) {
      return _then(_value.copyWith(prayerTimes: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
          _$HomeStateImpl value, $Res Function(_$HomeStateImpl) then) =
      __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isOffline,
      PrayerTimes? prayerTimes,
      Map<String, dynamic>? todayNotification,
      Map<String, dynamic>? motivationalMessage,
      bool motivationalLoading,
      String? motivationalError,
      String? error,
      String? currentPrayer,
      DateTime? nextPrayerTime,
      bool locationPermissionGranted});

  @override
  $PrayerTimesCopyWith<$Res>? get prayerTimes;
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
      _$HomeStateImpl _value, $Res Function(_$HomeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isOffline = null,
    Object? prayerTimes = freezed,
    Object? todayNotification = freezed,
    Object? motivationalMessage = freezed,
    Object? motivationalLoading = null,
    Object? motivationalError = freezed,
    Object? error = freezed,
    Object? currentPrayer = freezed,
    Object? nextPrayerTime = freezed,
    Object? locationPermissionGranted = null,
  }) {
    return _then(_$HomeStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isOffline: null == isOffline
          ? _value.isOffline
          : isOffline // ignore: cast_nullable_to_non_nullable
              as bool,
      prayerTimes: freezed == prayerTimes
          ? _value.prayerTimes
          : prayerTimes // ignore: cast_nullable_to_non_nullable
              as PrayerTimes?,
      todayNotification: freezed == todayNotification
          ? _value._todayNotification
          : todayNotification // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      motivationalMessage: freezed == motivationalMessage
          ? _value._motivationalMessage
          : motivationalMessage // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      motivationalLoading: null == motivationalLoading
          ? _value.motivationalLoading
          : motivationalLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      motivationalError: freezed == motivationalError
          ? _value.motivationalError
          : motivationalError // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      currentPrayer: freezed == currentPrayer
          ? _value.currentPrayer
          : currentPrayer // ignore: cast_nullable_to_non_nullable
              as String?,
      nextPrayerTime: freezed == nextPrayerTime
          ? _value.nextPrayerTime
          : nextPrayerTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      locationPermissionGranted: null == locationPermissionGranted
          ? _value.locationPermissionGranted
          : locationPermissionGranted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl(
      {this.isLoading = false,
      this.isOffline = false,
      this.prayerTimes,
      final Map<String, dynamic>? todayNotification,
      final Map<String, dynamic>? motivationalMessage,
      this.motivationalLoading = false,
      this.motivationalError,
      this.error,
      this.currentPrayer,
      this.nextPrayerTime,
      this.locationPermissionGranted = false})
      : _todayNotification = todayNotification,
        _motivationalMessage = motivationalMessage;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isOffline;
  @override
  final PrayerTimes? prayerTimes;
  final Map<String, dynamic>? _todayNotification;
  @override
  Map<String, dynamic>? get todayNotification {
    final value = _todayNotification;
    if (value == null) return null;
    if (_todayNotification is EqualUnmodifiableMapView)
      return _todayNotification;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _motivationalMessage;
  @override
  Map<String, dynamic>? get motivationalMessage {
    final value = _motivationalMessage;
    if (value == null) return null;
    if (_motivationalMessage is EqualUnmodifiableMapView)
      return _motivationalMessage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool motivationalLoading;
  @override
  final String? motivationalError;
  @override
  final String? error;
  @override
  final String? currentPrayer;
  @override
  final DateTime? nextPrayerTime;
  @override
  @JsonKey()
  final bool locationPermissionGranted;

  @override
  String toString() {
    return 'HomeState(isLoading: $isLoading, isOffline: $isOffline, prayerTimes: $prayerTimes, todayNotification: $todayNotification, motivationalMessage: $motivationalMessage, motivationalLoading: $motivationalLoading, motivationalError: $motivationalError, error: $error, currentPrayer: $currentPrayer, nextPrayerTime: $nextPrayerTime, locationPermissionGranted: $locationPermissionGranted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isOffline, isOffline) ||
                other.isOffline == isOffline) &&
            (identical(other.prayerTimes, prayerTimes) ||
                other.prayerTimes == prayerTimes) &&
            const DeepCollectionEquality()
                .equals(other._todayNotification, _todayNotification) &&
            const DeepCollectionEquality()
                .equals(other._motivationalMessage, _motivationalMessage) &&
            (identical(other.motivationalLoading, motivationalLoading) ||
                other.motivationalLoading == motivationalLoading) &&
            (identical(other.motivationalError, motivationalError) ||
                other.motivationalError == motivationalError) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.currentPrayer, currentPrayer) ||
                other.currentPrayer == currentPrayer) &&
            (identical(other.nextPrayerTime, nextPrayerTime) ||
                other.nextPrayerTime == nextPrayerTime) &&
            (identical(other.locationPermissionGranted,
                    locationPermissionGranted) ||
                other.locationPermissionGranted == locationPermissionGranted));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isOffline,
      prayerTimes,
      const DeepCollectionEquality().hash(_todayNotification),
      const DeepCollectionEquality().hash(_motivationalMessage),
      motivationalLoading,
      motivationalError,
      error,
      currentPrayer,
      nextPrayerTime,
      locationPermissionGranted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState(
      {final bool isLoading,
      final bool isOffline,
      final PrayerTimes? prayerTimes,
      final Map<String, dynamic>? todayNotification,
      final Map<String, dynamic>? motivationalMessage,
      final bool motivationalLoading,
      final String? motivationalError,
      final String? error,
      final String? currentPrayer,
      final DateTime? nextPrayerTime,
      final bool locationPermissionGranted}) = _$HomeStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isOffline;
  @override
  PrayerTimes? get prayerTimes;
  @override
  Map<String, dynamic>? get todayNotification;
  @override
  Map<String, dynamic>? get motivationalMessage;
  @override
  bool get motivationalLoading;
  @override
  String? get motivationalError;
  @override
  String? get error;
  @override
  String? get currentPrayer;
  @override
  DateTime? get nextPrayerTime;
  @override
  bool get locationPermissionGranted;
  @override
  @JsonKey(ignore: true)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
