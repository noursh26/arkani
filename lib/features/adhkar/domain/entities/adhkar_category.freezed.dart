// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adhkar_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `private` fields.');

AdhkarCategory _$AdhkarCategoryFromJson(Map<String, dynamic> json) {
  return _AdhkarCategory.fromJson(json);
}

/// @nodoc
mixin _$AdhkarCategory {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  int get adhkarCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdhkarCategoryCopyWith<AdhkarCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdhkarCategoryCopyWith<$Res> {
  factory $AdhkarCategoryCopyWith(
          AdhkarCategory value, $Res Function(AdhkarCategory) then) =
      _$AdhkarCategoryCopyWithImpl<$Res, AdhkarCategory>;
  @useResult
  $Res call({int id, String name, String slug, String icon, int adhkarCount});
}

/// @nodoc
class _$AdhkarCategoryCopyWithImpl<$Res, $Val extends AdhkarCategory>
    implements $AdhkarCategoryCopyWith<$Res> {
  _$AdhkarCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? icon = null,
    Object? adhkarCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      adhkarCount: null == adhkarCount
          ? _value.adhkarCount
          : adhkarCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdhkarCategoryImplCopyWith<$Res>
    implements $AdhkarCategoryCopyWith<$Res> {
  factory _$$AdhkarCategoryImplCopyWith(_$AdhkarCategoryImpl value,
          $Res Function(_$AdhkarCategoryImpl) then) =
      __$$AdhkarCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String slug, String icon, int adhkarCount});
}

/// @nodoc
class __$$AdhkarCategoryImplCopyWithImpl<$Res>
    extends _$AdhkarCategoryCopyWithImpl<$Res, _$AdhkarCategoryImpl>
    implements _$$AdhkarCategoryImplCopyWith<$Res> {
  __$$AdhkarCategoryImplCopyWithImpl(
      _$AdhkarCategoryImpl _value, $Res Function(_$AdhkarCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? icon = null,
    Object? adhkarCount = null,
  }) {
    return _then(_$AdhkarCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      adhkarCount: null == adhkarCount
          ? _value.adhkarCount
          : adhkarCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdhkarCategoryImpl implements _AdhkarCategory {
  const _$AdhkarCategoryImpl(
      {required this.id,
      required this.name,
      required this.slug,
      required this.icon,
      required this.adhkarCount});

  factory _$AdhkarCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdhkarCategoryImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String icon;
  @override
  final int adhkarCount;

  @override
  String toString() {
    return 'AdhkarCategory(id: $id, name: $name, slug: $slug, icon: $icon, adhkarCount: $adhkarCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdhkarCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.adhkarCount, adhkarCount) ||
                other.adhkarCount == adhkarCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug, icon, adhkarCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdhkarCategoryImplCopyWith<_$AdhkarCategoryImpl> get copyWith =>
      __$$AdhkarCategoryImplCopyWithImpl<_$AdhkarCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdhkarCategoryImplToJson(
      this,
    );
  }
}

abstract class _AdhkarCategory implements AdhkarCategory {
  const factory _AdhkarCategory(
      {required final int id,
      required final String name,
      required final String slug,
      required final String icon,
      required final int adhkarCount}) = _$AdhkarCategoryImpl;

  factory _AdhkarCategory.fromJson(Map<String, dynamic> json) =
      _$AdhkarCategoryImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  String get icon;
  @override
  int get adhkarCount;
  @override
  @JsonKey(ignore: true)
  _$$AdhkarCategoryImplCopyWith<_$AdhkarCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Dhikr _$DhikrFromJson(Map<String, dynamic> json) {
  return _Dhikr.fromJson(json);
}

/// @nodoc
mixin _$Dhikr {
  int get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DhikrCopyWith<Dhikr> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DhikrCopyWith<$Res> {
  factory $DhikrCopyWith(Dhikr value, $Res Function(Dhikr) then) =
      _$DhikrCopyWithImpl<$Res, Dhikr>;
  @useResult
  $Res call({int id, String text, String? source, int count, int order});
}

/// @nodoc
class _$DhikrCopyWithImpl<$Res, $Val extends Dhikr>
    implements $DhikrCopyWith<$Res> {
  _$DhikrCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? source = freezed,
    Object? count = null,
    Object? order = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DhikrImplCopyWith<$Res> implements $DhikrCopyWith<$Res> {
  factory _$$DhikrImplCopyWith(
          _$DhikrImpl value, $Res Function(_$DhikrImpl) then) =
      __$$DhikrImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String text, String? source, int count, int order});
}

/// @nodoc
class __$$DhikrImplCopyWithImpl<$Res>
    extends _$DhikrCopyWithImpl<$Res, _$DhikrImpl>
    implements _$$DhikrImplCopyWith<$Res> {
  __$$DhikrImplCopyWithImpl(
      _$DhikrImpl _value, $Res Function(_$DhikrImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? source = freezed,
    Object? count = null,
    Object? order = null,
  }) {
    return _then(_$DhikrImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DhikrImpl implements _Dhikr {
  const _$DhikrImpl(
      {required this.id,
      required this.text,
      this.source,
      required this.count,
      required this.order});

  factory _$DhikrImpl.fromJson(Map<String, dynamic> json) =>
      _$$DhikrImplFromJson(json);

  @override
  final int id;
  @override
  final String text;
  @override
  final String? source;
  @override
  final int count;
  @override
  final int order;

  @override
  String toString() {
    return 'Dhikr(id: $id, text: $text, source: $source, count: $count, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DhikrImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, source, count, order);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DhikrImplCopyWith<_$DhikrImpl> get copyWith =>
      __$$DhikrImplCopyWithImpl<_$DhikrImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DhikrImplToJson(
      this,
    );
  }
}

abstract class _Dhikr implements Dhikr {
  const factory _Dhikr(
      {required final int id,
      required final String text,
      final String? source,
      required final int count,
      required final int order}) = _$DhikrImpl;

  factory _Dhikr.fromJson(Map<String, dynamic> json) = _$DhikrImpl.fromJson;

  @override
  int get id;
  @override
  String get text;
  @override
  String? get source;
  @override
  int get count;
  @override
  int get order;
  @override
  @JsonKey(ignore: true)
  _$$DhikrImplCopyWith<_$DhikrImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AdhkarCollection _$AdhkarCollectionFromJson(Map<String, dynamic> json) {
  return _AdhkarCollection.fromJson(json);
}

/// @nodoc
mixin _$AdhkarCollection {
  AdhkarCategory get category => throw _privateConstructorUsedError;
  List<Dhikr> get adhkar => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdhkarCollectionCopyWith<AdhkarCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdhkarCollectionCopyWith<$Res> {
  factory $AdhkarCollectionCopyWith(
          AdhkarCollection value, $Res Function(AdhkarCollection) then) =
      _$AdhkarCollectionCopyWithImpl<$Res, AdhkarCollection>;
  @useResult
  $Res call({AdhkarCategory category, List<Dhikr> adhkar});

  $AdhkarCategoryCopyWith<$Res> get category;
}

/// @nodoc
class _$AdhkarCollectionCopyWithImpl<$Res, $Val extends AdhkarCollection>
    implements $AdhkarCollectionCopyWith<$Res> {
  _$AdhkarCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? adhkar = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as AdhkarCategory,
      adhkar: null == adhkar
          ? _value.adhkar
          : adhkar // ignore: cast_nullable_to_non_nullable
              as List<Dhikr>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AdhkarCategoryCopyWith<$Res> get category {
    return $AdhkarCategoryCopyWith<$Res>(_value.category, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AdhkarCollectionImplCopyWith<$Res>
    implements $AdhkarCollectionCopyWith<$Res> {
  factory _$$AdhkarCollectionImplCopyWith(_$AdhkarCollectionImpl value,
          $Res Function(_$AdhkarCollectionImpl) then) =
      __$$AdhkarCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AdhkarCategory category, List<Dhikr> adhkar});

  @override
  $AdhkarCategoryCopyWith<$Res> get category;
}

/// @nodoc
class __$$AdhkarCollectionImplCopyWithImpl<$Res>
    extends _$AdhkarCollectionCopyWithImpl<$Res, _$AdhkarCollectionImpl>
    implements _$$AdhkarCollectionImplCopyWith<$Res> {
  __$$AdhkarCollectionImplCopyWithImpl(_$AdhkarCollectionImpl _value,
      $Res Function(_$AdhkarCollectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? adhkar = null,
  }) {
    return _then(_$AdhkarCollectionImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as AdhkarCategory,
      adhkar: null == adhkar
          ? _value._adhkar
          : adhkar // ignore: cast_nullable_to_non_nullable
              as List<Dhikr>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdhkarCollectionImpl implements _AdhkarCollection {
  const _$AdhkarCollectionImpl(
      {required this.category, required final List<Dhikr> adhkar})
      : _adhkar = adhkar;

  factory _$AdhkarCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdhkarCollectionImplFromJson(json);

  @override
  final AdhkarCategory category;
  final List<Dhikr> _adhkar;
  @override
  List<Dhikr> get adhkar {
    return _adhkar;
  }

  @override
  String toString() {
    return 'AdhkarCollection(category: $category, adhkar: $adhkar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdhkarCollectionImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._adhkar, _adhkar));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, category, const DeepCollectionEquality().hash(_adhkar));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdhkarCollectionImplCopyWith<_$AdhkarCollectionImpl> get copyWith =>
      __$$AdhkarCollectionImplCopyWithImpl<_$AdhkarCollectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdhkarCollectionImplToJson(
      this,
    );
  }
}

abstract class _AdhkarCollection implements AdhkarCollection {
  const factory _AdhkarCollection(
      {required final AdhkarCategory category,
      required final List<Dhikr> adhkar}) = _$AdhkarCollectionImpl;

  factory _AdhkarCollection.fromJson(Map<String, dynamic> json) =
      _$AdhkarCollectionImpl.fromJson;

  @override
  AdhkarCategory get category;
  @override
  List<Dhikr> get adhkar;
  @override
  @JsonKey(ignore: true)
  _$$AdhkarCollectionImplCopyWith<_$AdhkarCollectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
