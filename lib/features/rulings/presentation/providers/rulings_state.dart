import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/islamic_ruling.dart';

part 'rulings_state.freezed.dart';

@freezed
class RulingsState with _$RulingsState {
  const factory RulingsState({
    @Default(false) bool isLoadingTopics,
    @Default(false) bool isLoadingRulings,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isOffline,
    @Default([]) List<RulingTopic> topics,
    @Default([]) List<IslamicRuling> rulings,
    @Default(1) int currentPage,
    @Default(true) bool hasMore,
    int? selectedTopicId,
    String? searchQuery,
    String? error,
  }) = _RulingsState;
}
