// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'islamic_ruling.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RulingTopic _$RulingTopicFromJson(Map<String, dynamic> json) {
  return _RulingTopic.fromJson(json);
}

/// @nodoc
mixin _$RulingTopic {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  int get rulingsCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RulingTopicCopyWith<RulingTopic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RulingTopicCopyWith<$Res> {
  factory $RulingTopicCopyWith(
          RulingTopic value, $Res Function(RulingTopic) then) =
      _$RulingTopicCopyWithImpl<$Res, RulingTopic>;
  @useResult
  $Res call({int id, String name, String icon, int rulingsCount});
}

/// @nodoc
class _$RulingTopicCopyWithImpl<$Res, $Val extends RulingTopic>
    implements $RulingTopicCopyWith<$Res> {
  _$RulingTopicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
    Object? rulingsCount = null,
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
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      rulingsCount: null == rulingsCount
          ? _value.rulingsCount
          : rulingsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RulingTopicImplCopyWith<$Res>
    implements $RulingTopicCopyWith<$Res> {
  factory _$$RulingTopicImplCopyWith(
          _$RulingTopicImpl value, $Res Function(_$RulingTopicImpl) then) =
      __$$RulingTopicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String icon, int rulingsCount});
}

/// @nodoc
class __$$RulingTopicImplCopyWithImpl<$Res>
    extends _$RulingTopicCopyWithImpl<$Res, _$RulingTopicImpl>
    implements _$$RulingTopicImplCopyWith<$Res> {
  __$$RulingTopicImplCopyWithImpl(
      _$RulingTopicImpl _value, $Res Function(_$RulingTopicImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
    Object? rulingsCount = null,
  }) {
    return _then(_$RulingTopicImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      rulingsCount: null == rulingsCount
          ? _value.rulingsCount
          : rulingsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RulingTopicImpl implements _RulingTopic {
  const _$RulingTopicImpl(
      {required this.id,
      required this.name,
      required this.icon,
      required this.rulingsCount});

  factory _$RulingTopicImpl.fromJson(Map<String, dynamic> json) =>
      _$$RulingTopicImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String icon;
  @override
  final int rulingsCount;

  @override
  String toString() {
    return 'RulingTopic(id: $id, name: $name, icon: $icon, rulingsCount: $rulingsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RulingTopicImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.rulingsCount, rulingsCount) ||
                other.rulingsCount == rulingsCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, icon, rulingsCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RulingTopicImplCopyWith<_$RulingTopicImpl> get copyWith =>
      __$$RulingTopicImplCopyWithImpl<_$RulingTopicImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RulingTopicImplToJson(
      this,
    );
  }
}

abstract class _RulingTopic implements RulingTopic {
  const factory _RulingTopic(
      {required final int id,
      required final String name,
      required final String icon,
      required final int rulingsCount}) = _$RulingTopicImpl;

  factory _RulingTopic.fromJson(Map<String, dynamic> json) =
      _$RulingTopicImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get icon;
  @override
  int get rulingsCount;
  @override
  @JsonKey(ignore: true)
  _$$RulingTopicImplCopyWith<_$RulingTopicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IslamicRuling _$IslamicRulingFromJson(Map<String, dynamic> json) {
  return _IslamicRuling.fromJson(json);
}

/// @nodoc
mixin _$IslamicRuling {
  int get id => throw _privateConstructorUsedError;
  RulingTopic? get topic => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  String get answer => throw _privateConstructorUsedError;
  String? get evidence => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IslamicRulingCopyWith<IslamicRuling> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IslamicRulingCopyWith<$Res> {
  factory $IslamicRulingCopyWith(
          IslamicRuling value, $Res Function(IslamicRuling) then) =
      _$IslamicRulingCopyWithImpl<$Res, IslamicRuling>;
  @useResult
  $Res call(
      {int id,
      RulingTopic? topic,
      String question,
      String answer,
      String? evidence});

  $RulingTopicCopyWith<$Res>? get topic;
}

/// @nodoc
class _$IslamicRulingCopyWithImpl<$Res, $Val extends IslamicRuling>
    implements $IslamicRulingCopyWith<$Res> {
  _$IslamicRulingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topic = freezed,
    Object? question = null,
    Object? answer = null,
    Object? evidence = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as RulingTopic?,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
      evidence: freezed == evidence
          ? _value.evidence
          : evidence // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RulingTopicCopyWith<$Res>? get topic {
    if (_value.topic == null) {
      return null;
    }

    return $RulingTopicCopyWith<$Res>(_value.topic!, (value) {
      return _then(_value.copyWith(topic: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$IslamicRulingImplCopyWith<$Res>
    implements $IslamicRulingCopyWith<$Res> {
  factory _$$IslamicRulingImplCopyWith(
          _$IslamicRulingImpl value, $Res Function(_$IslamicRulingImpl) then) =
      __$$IslamicRulingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      RulingTopic? topic,
      String question,
      String answer,
      String? evidence});

  @override
  $RulingTopicCopyWith<$Res>? get topic;
}

/// @nodoc
class __$$IslamicRulingImplCopyWithImpl<$Res>
    extends _$IslamicRulingCopyWithImpl<$Res, _$IslamicRulingImpl>
    implements _$$IslamicRulingImplCopyWith<$Res> {
  __$$IslamicRulingImplCopyWithImpl(
      _$IslamicRulingImpl _value, $Res Function(_$IslamicRulingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topic = freezed,
    Object? question = null,
    Object? answer = null,
    Object? evidence = freezed,
  }) {
    return _then(_$IslamicRulingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as RulingTopic?,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
      evidence: freezed == evidence
          ? _value.evidence
          : evidence // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IslamicRulingImpl implements _IslamicRuling {
  const _$IslamicRulingImpl(
      {required this.id,
      required this.topic,
      required this.question,
      required this.answer,
      this.evidence});

  factory _$IslamicRulingImpl.fromJson(Map<String, dynamic> json) =>
      _$$IslamicRulingImplFromJson(json);

  @override
  final int id;
  @override
  final RulingTopic? topic;
  @override
  final String question;
  @override
  final String answer;
  @override
  final String? evidence;

  @override
  String toString() {
    return 'IslamicRuling(id: $id, topic: $topic, question: $question, answer: $answer, evidence: $evidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IslamicRulingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.evidence, evidence) ||
                other.evidence == evidence));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, topic, question, answer, evidence);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IslamicRulingImplCopyWith<_$IslamicRulingImpl> get copyWith =>
      __$$IslamicRulingImplCopyWithImpl<_$IslamicRulingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IslamicRulingImplToJson(
      this,
    );
  }
}

abstract class _IslamicRuling implements IslamicRuling {
  const factory _IslamicRuling(
      {required final int id,
      required final RulingTopic? topic,
      required final String question,
      required final String answer,
      final String? evidence}) = _$IslamicRulingImpl;

  factory _IslamicRuling.fromJson(Map<String, dynamic> json) =
      _$IslamicRulingImpl.fromJson;

  @override
  int get id;
  @override
  RulingTopic? get topic;
  @override
  String get question;
  @override
  String get answer;
  @override
  String? get evidence;
  @override
  @JsonKey(ignore: true)
  _$$IslamicRulingImplCopyWith<_$IslamicRulingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RulingsPaginated _$RulingsPaginatedFromJson(Map<String, dynamic> json) {
  return _RulingsPaginated.fromJson(json);
}

/// @nodoc
mixin _$RulingsPaginated {
  int get currentPage => throw _privateConstructorUsedError;
  int get lastPage => throw _privateConstructorUsedError;
  int get perPage => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  List<IslamicRuling> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RulingsPaginatedCopyWith<RulingsPaginated> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RulingsPaginatedCopyWith<$Res> {
  factory $RulingsPaginatedCopyWith(
          RulingsPaginated value, $Res Function(RulingsPaginated) then) =
      _$RulingsPaginatedCopyWithImpl<$Res, RulingsPaginated>;
  @useResult
  $Res call(
      {int currentPage,
      int lastPage,
      int perPage,
      int total,
      List<IslamicRuling> items});
}

/// @nodoc
class _$RulingsPaginatedCopyWithImpl<$Res, $Val extends RulingsPaginated>
    implements $RulingsPaginatedCopyWith<$Res> {
  _$RulingsPaginatedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? lastPage = null,
    Object? perPage = null,
    Object? total = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<IslamicRuling>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RulingsPaginatedImplCopyWith<$Res>
    implements $RulingsPaginatedCopyWith<$Res> {
  factory _$$RulingsPaginatedImplCopyWith(_$RulingsPaginatedImpl value,
          $Res Function(_$RulingsPaginatedImpl) then) =
      __$$RulingsPaginatedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentPage,
      int lastPage,
      int perPage,
      int total,
      List<IslamicRuling> items});
}

/// @nodoc
class __$$RulingsPaginatedImplCopyWithImpl<$Res>
    extends _$RulingsPaginatedCopyWithImpl<$Res, _$RulingsPaginatedImpl>
    implements _$$RulingsPaginatedImplCopyWith<$Res> {
  __$$RulingsPaginatedImplCopyWithImpl(_$RulingsPaginatedImpl _value,
      $Res Function(_$RulingsPaginatedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? lastPage = null,
    Object? perPage = null,
    Object? total = null,
    Object? items = null,
  }) {
    return _then(_$RulingsPaginatedImpl(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<IslamicRuling>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RulingsPaginatedImpl implements _RulingsPaginated {
  const _$RulingsPaginatedImpl(
      {required this.currentPage,
      required this.lastPage,
      required this.perPage,
      required this.total,
      required final List<IslamicRuling> items})
      : _items = items;

  factory _$RulingsPaginatedImpl.fromJson(Map<String, dynamic> json) =>
      _$$RulingsPaginatedImplFromJson(json);

  @override
  final int currentPage;
  @override
  final int lastPage;
  @override
  final int perPage;
  @override
  final int total;
  final List<IslamicRuling> _items;
  @override
  List<IslamicRuling> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'RulingsPaginated(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RulingsPaginatedImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.lastPage, lastPage) ||
                other.lastPage == lastPage) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, currentPage, lastPage, perPage,
      total, const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RulingsPaginatedImplCopyWith<_$RulingsPaginatedImpl> get copyWith =>
      __$$RulingsPaginatedImplCopyWithImpl<_$RulingsPaginatedImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RulingsPaginatedImplToJson(
      this,
    );
  }
}

abstract class _RulingsPaginated implements RulingsPaginated {
  const factory _RulingsPaginated(
      {required final int currentPage,
      required final int lastPage,
      required final int perPage,
      required final int total,
      required final List<IslamicRuling> items}) = _$RulingsPaginatedImpl;

  factory _RulingsPaginated.fromJson(Map<String, dynamic> json) =
      _$RulingsPaginatedImpl.fromJson;

  @override
  int get currentPage;
  @override
  int get lastPage;
  @override
  int get perPage;
  @override
  int get total;
  @override
  List<IslamicRuling> get items;
  @override
  @JsonKey(ignore: true)
  _$$RulingsPaginatedImplCopyWith<_$RulingsPaginatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
