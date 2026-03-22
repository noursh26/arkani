import 'package:freezed_annotation/freezed_annotation.dart';

part 'islamic_ruling.freezed.dart';
part 'islamic_ruling.g.dart';

@freezed
class RulingTopic with _$RulingTopic {
  const factory RulingTopic({
    required int id,
    required String name,
    required String icon,
    @JsonKey(name: 'rulings_count') required int rulingsCount,
  }) = _RulingTopic;

  factory RulingTopic.fromJson(Map<String, dynamic> json) =>
      _$RulingTopicFromJson(json);
}

@freezed
class IslamicRuling with _$IslamicRuling {
  const factory IslamicRuling({
    required int id,
    required RulingTopic? topic,
    required String question,
    required String answer,
    String? evidence,
  }) = _IslamicRuling;

  factory IslamicRuling.fromJson(Map<String, dynamic> json) =>
      _$IslamicRulingFromJson(json);
}

@freezed
class RulingsPaginated with _$RulingsPaginated {
  const factory RulingsPaginated({
    @JsonKey(name: 'current_page') required int currentPage,
    @JsonKey(name: 'last_page') required int lastPage,
    @JsonKey(name: 'per_page') required int perPage,
    required int total,
    required List<IslamicRuling> items,
  }) = _RulingsPaginated;

  factory RulingsPaginated.fromJson(Map<String, dynamic> json) =>
      _$RulingsPaginatedFromJson(json);
}
