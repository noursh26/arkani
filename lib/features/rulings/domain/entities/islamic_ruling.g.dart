// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'islamic_ruling.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RulingTopicImpl _$$RulingTopicImplFromJson(Map<String, dynamic> json) =>
    _$RulingTopicImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      icon: json['icon'] as String,
      rulingsCount: (json['rulings_count'] as num).toInt(),
    );

Map<String, dynamic> _$$RulingTopicImplToJson(_$RulingTopicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'rulings_count': instance.rulingsCount,
    };

_$IslamicRulingImpl _$$IslamicRulingImplFromJson(Map<String, dynamic> json) =>
    _$IslamicRulingImpl(
      id: (json['id'] as num).toInt(),
      topic: json['topic'] == null
          ? null
          : RulingTopic.fromJson(json['topic'] as Map<String, dynamic>),
      question: json['question'] as String,
      answer: json['answer'] as String,
      evidence: json['evidence'] as String?,
    );

Map<String, dynamic> _$$IslamicRulingImplToJson(_$IslamicRulingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic?.toJson(),
      'question': instance.question,
      'answer': instance.answer,
      'evidence': instance.evidence,
    };

_$RulingsPaginatedImpl _$$RulingsPaginatedImplFromJson(
        Map<String, dynamic> json) =>
    _$RulingsPaginatedImpl(
      currentPage: (json['current_page'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => IslamicRuling.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RulingsPaginatedImplToJson(
        _$RulingsPaginatedImpl instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
