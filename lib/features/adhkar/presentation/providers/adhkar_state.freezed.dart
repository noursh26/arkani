// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adhkar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AdhkarState {
  bool get isLoadingCategories => throw _privateConstructorUsedError;
  bool get isLoadingAdhkar => throw _privateConstructorUsedError;
  bool get isOffline => throw _privateConstructorUsedError;
  List<AdhkarCategory> get categories => throw _privateConstructorUsedError;
  AdhkarCollection? get currentCollection => throw _privateConstructorUsedError;
  AdhkarCategory? get selectedCategory => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AdhkarStateCopyWith<AdhkarState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdhkarStateCopyWith<$Res> {
  factory $AdhkarStateCopyWith(
          AdhkarState value, $Res Function(AdhkarState) then) =
      _$AdhkarStateCopyWithImpl<$Res, AdhkarState>;
  @useResult
  $Res call(
      {bool isLoadingCategories,
      bool isLoadingAdhkar,
      bool isOffline,
      List<AdhkarCategory> categories,
      AdhkarCollection? currentCollection,
      AdhkarCategory? selectedCategory,
      String? error});

  $AdhkarCollectionCopyWith<$Res>? get currentCollection;
  $AdhkarCategoryCopyWith<$Res>? get selectedCategory;
}

/// @nodoc
class _$AdhkarStateCopyWithImpl<$Res, $Val extends AdhkarState>
    implements $AdhkarStateCopyWith<$Res> {
  _$AdhkarStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoadingCategories = null,
    Object? isLoadingAdhkar = null,
    Object? isOffline = null,
    Object? categories = null,
    Object? currentCollection = freezed,
    Object? selectedCategory = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoadingCategories: null == isLoadingCategories
          ? _value.isLoadingCategories
          : isLoadingCategories // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingAdhkar: null == isLoadingAdhkar
          ? _value.isLoadingAdhkar
          : isLoadingAdhkar // ignore: cast_nullable_to_non_nullable
              as bool,
      isOffline: null == isOffline
          ? _value.isOffline
          : isOffline // ignore: cast_nullable_to_non_nullable
              as bool,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<AdhkarCategory>,
      currentCollection: freezed == currentCollection
          ? _value.currentCollection
          : currentCollection // ignore: cast_nullable_to_non_nullable
              as AdhkarCollection?,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as AdhkarCategory?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AdhkarCollectionCopyWith<$Res>? get currentCollection {
    if (_value.currentCollection == null) {
      return null;
    }

    return $AdhkarCollectionCopyWith<$Res>(_value.currentCollection!, (value) {
      return _then(_value.copyWith(currentCollection: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AdhkarCategoryCopyWith<$Res>? get selectedCategory {
    if (_value.selectedCategory == null) {
      return null;
    }

    return $AdhkarCategoryCopyWith<$Res>(_value.selectedCategory!, (value) {
      return _then(_value.copyWith(selectedCategory: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AdhkarStateImplCopyWith<$Res>
    implements $AdhkarStateCopyWith<$Res> {
  factory _$$AdhkarStateImplCopyWith(
          _$AdhkarStateImpl value, $Res Function(_$AdhkarStateImpl) then) =
      __$$AdhkarStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoadingCategories,
      bool isLoadingAdhkar,
      bool isOffline,
      List<AdhkarCategory> categories,
      AdhkarCollection? currentCollection,
      AdhkarCategory? selectedCategory,
      String? error});

  @override
  $AdhkarCollectionCopyWith<$Res>? get currentCollection;
  @override
  $AdhkarCategoryCopyWith<$Res>? get selectedCategory;
}

/// @nodoc
class __$$AdhkarStateImplCopyWithImpl<$Res>
    extends _$AdhkarStateCopyWithImpl<$Res, _$AdhkarStateImpl>
    implements _$$AdhkarStateImplCopyWith<$Res> {
  __$$AdhkarStateImplCopyWithImpl(
      _$AdhkarStateImpl _value, $Res Function(_$AdhkarStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoadingCategories = null,
    Object? isLoadingAdhkar = null,
    Object? isOffline = null,
    Object? categories = null,
    Object? currentCollection = freezed,
    Object? selectedCategory = freezed,
    Object? error = freezed,
  }) {
    return _then(_$AdhkarStateImpl(
      isLoadingCategories: null == isLoadingCategories
          ? _value.isLoadingCategories
          : isLoadingCategories // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingAdhkar: null == isLoadingAdhkar
          ? _value.isLoadingAdhkar
          : isLoadingAdhkar // ignore: cast_nullable_to_non_nullable
              as bool,
      isOffline: null == isOffline
          ? _value.isOffline
          : isOffline // ignore: cast_nullable_to_non_nullable
              as bool,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<AdhkarCategory>,
      currentCollection: freezed == currentCollection
          ? _value.currentCollection
          : currentCollection // ignore: cast_nullable_to_non_nullable
              as AdhkarCollection?,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as AdhkarCategory?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AdhkarStateImpl implements _AdhkarState {
  const _$AdhkarStateImpl(
      {this.isLoadingCategories = false,
      this.isLoadingAdhkar = false,
      this.isOffline = false,
      final List<AdhkarCategory> categories = const [],
      this.currentCollection,
      this.selectedCategory,
      this.error})
      : _categories = categories;

  @override
  @JsonKey()
  final bool isLoadingCategories;
  @override
  @JsonKey()
  final bool isLoadingAdhkar;
  @override
  @JsonKey()
  final bool isOffline;
  final List<AdhkarCategory> _categories;
  @override
  @JsonKey()
  List<AdhkarCategory> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final AdhkarCollection? currentCollection;
  @override
  final AdhkarCategory? selectedCategory;
  @override
  final String? error;

  @override
  String toString() {
    return 'AdhkarState(isLoadingCategories: $isLoadingCategories, isLoadingAdhkar: $isLoadingAdhkar, isOffline: $isOffline, categories: $categories, currentCollection: $currentCollection, selectedCategory: $selectedCategory, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdhkarStateImpl &&
            (identical(other.isLoadingCategories, isLoadingCategories) ||
                other.isLoadingCategories == isLoadingCategories) &&
            (identical(other.isLoadingAdhkar, isLoadingAdhkar) ||
                other.isLoadingAdhkar == isLoadingAdhkar) &&
            (identical(other.isOffline, isOffline) ||
                other.isOffline == isOffline) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.currentCollection, currentCollection) ||
                other.currentCollection == currentCollection) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoadingCategories,
      isLoadingAdhkar,
      isOffline,
      const DeepCollectionEquality().hash(_categories),
      currentCollection,
      selectedCategory,
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdhkarStateImplCopyWith<_$AdhkarStateImpl> get copyWith =>
      __$$AdhkarStateImplCopyWithImpl<_$AdhkarStateImpl>(this, _$identity);
}

abstract class _AdhkarState implements AdhkarState {
  const factory _AdhkarState(
      {final bool isLoadingCategories,
      final bool isLoadingAdhkar,
      final bool isOffline,
      final List<AdhkarCategory> categories,
      final AdhkarCollection? currentCollection,
      final AdhkarCategory? selectedCategory,
      final String? error}) = _$AdhkarStateImpl;

  @override
  bool get isLoadingCategories;
  @override
  bool get isLoadingAdhkar;
  @override
  bool get isOffline;
  @override
  List<AdhkarCategory> get categories;
  @override
  AdhkarCollection? get currentCollection;
  @override
  AdhkarCategory? get selectedCategory;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$AdhkarStateImplCopyWith<_$AdhkarStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
