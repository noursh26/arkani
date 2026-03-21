// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'islamic_ruling.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RulingTopicImpl _$$RulingTopicImplFromJson(Map<String, dynamic> json) =>
    _$RulingTopicImpl(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
      rulingsCount: json['rulingsCount'] as int,
    );

Map<String, dynamic> _$$RulingTopicImplToJson(_$RulingTopicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'rulingsCount': instance.rulingsCount,
    };

_$IslamicRulingImpl _$$IslamicRulingImplFromJson(Map<String, dynamic> json) =>
    _$IslamicRulingImpl(
      id: json['id'] as int,
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
      'topic': instance.topic,
      'question': instance.question,
      'answer': instance.answer,
      'evidence': instance.evidence,
    };

_$RulingsPaginatedImpl _$$RulingsPaginatedImplFromJson(
        Map<String, dynamic> json) =>
    _$RulingsPaginatedImpl(
      currentPage: json['currentPage'] as int,
      lastPage: json['lastPage'] as int,
      perPage: json['perPage'] as int,
      total: json['total'] as int,
      items: (json['items'] as List<dynamic>)
          .map((e) => IslamicRuling.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RulingsPaginatedImplToJson(
        _$RulingsPaginatedImpl instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'lastPage': instance.lastPage,
      'perPage': instance.perPage,
      'total': instance.total,
      'items': instance.items,
    };
