// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adhkar_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdhkarCategoryImpl _$$AdhkarCategoryImplFromJson(Map<String, dynamic> json) =>
    _$AdhkarCategoryImpl(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      icon: json['icon'] as String,
      adhkarCount: json['adhkarCount'] as int,
    );

Map<String, dynamic> _$$AdhkarCategoryImplToJson(_$AdhkarCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'icon': instance.icon,
      'adhkarCount': instance.adhkarCount,
    };

_$DhikrImpl _$$DhikrImplFromJson(Map<String, dynamic> json) => _$DhikrImpl(
      id: json['id'] as int,
      text: json['text'] as String,
      source: json['source'] as String?,
      count: json['count'] as int,
      order: json['order'] as int,
    );

Map<String, dynamic> _$$DhikrImplToJson(_$DhikrImpl instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'source': instance.source,
      'count': instance.count,
      'order': instance.order,
    };

_$AdhkarCollectionImpl _$$AdhkarCollectionImplFromJson(
        Map<String, dynamic> json) =>
    _$AdhkarCollectionImpl(
      category:
          AdhkarCategory.fromJson(json['category'] as Map<String, dynamic>),
      adhkar: (json['adhkar'] as List<dynamic>)
          .map((e) => Dhikr.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AdhkarCollectionImplToJson(
        _$AdhkarCollectionImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'adhkar': instance.adhkar,
    };
