// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adhkar_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdhkarCategoryImpl _$$AdhkarCategoryImplFromJson(Map<String, dynamic> json) =>
    _$AdhkarCategoryImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      icon: json['icon'] as String,
      adhkarCount: (json['adhkar_count'] as num).toInt(),
    );

Map<String, dynamic> _$$AdhkarCategoryImplToJson(
        _$AdhkarCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'icon': instance.icon,
      'adhkar_count': instance.adhkarCount,
    };

_$DhikrImpl _$$DhikrImplFromJson(Map<String, dynamic> json) => _$DhikrImpl(
      id: (json['id'] as num).toInt(),
      text: json['text'] as String,
      source: json['source'] as String?,
      count: (json['count'] as num).toInt(),
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$$DhikrImplToJson(_$DhikrImpl instance) =>
    <String, dynamic>{
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
      'category': instance.category.toJson(),
      'adhkar': instance.adhkar.map((e) => e.toJson()).toList(),
    };
