import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/islamic_ruling.dart';
import 'rulings_state.dart';

part 'rulings_provider.g.dart';

@riverpod
class RulingsNotifier extends _$RulingsNotifier {
  Timer? _searchDebounceTimer;

  @override
  RulingsState build() {
    return const RulingsState();
  }

  void dispose() {
    _searchDebounceTimer?.cancel();
  }

  Future<void> loadTopics({bool forceRefresh = false}) async {
    final cacheBox = Hive.box(AppConstants.hiveBoxName);
    
    // Check for cached data first
    if (!forceRefresh) {
      final cachedData = cacheBox.get(AppConstants.rulingsTopicsKey) as String?;
      if (cachedData != null) {
        try {
          final data = jsonDecode(cachedData) as List<dynamic>;
          final topics = data
              .map((e) => RulingTopic.fromJson(e as Map<String, dynamic>))
              .toList();
          state = state.copyWith(
            isLoadingTopics: false,
            topics: topics,
            isOffline: false,
            error: null,
          );
          return;
        } catch (e) {
          // Invalid cache, continue to fetch
        }
      }
    }

    state = state.copyWith(isLoadingTopics: true, error: null);

    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.getRulingTopics();

      final data = response['data'] as List<dynamic>;
      final topics = data
          .map((e) => RulingTopic.fromJson(e as Map<String, dynamic>))
          .toList();

      // Save to cache
      await cacheBox.put(AppConstants.rulingsTopicsKey, jsonEncode(data));

      state = state.copyWith(
        isLoadingTopics: false,
        topics: topics,
        isOffline: false,
        error: null,
      );
    } on NetworkException catch (e) {
      // Try to use cached data if available
      final cachedData = cacheBox.get(AppConstants.rulingsTopicsKey) as String?;
      if (cachedData != null) {
        try {
          final data = jsonDecode(cachedData) as List<dynamic>;
          final topics = data
              .map((e) => RulingTopic.fromJson(e as Map<String, dynamic>))
              .toList();
          state = state.copyWith(
            isLoadingTopics: false,
            topics: topics,
            isOffline: true,
            error: null,
          );
        } catch (_) {
          state = state.copyWith(
            isLoadingTopics: false,
            isOffline: true,
            error: 'لا يوجد اتصال بالإنترنت',
          );
        }
      } else {
        state = state.copyWith(
          isLoadingTopics: false,
          isOffline: true,
          error: 'لا يوجد اتصال بالإنترنت',
        );
      }
    } on AppException catch (e) {
      state = state.copyWith(
        isLoadingTopics: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingTopics: false,
        error: 'حدث خطأ غير متوقع',
      );
    }
  }

  Future<void> loadRulings({int? topicId, String? search, bool refresh = false}) async {
    final page = refresh ? 1 : state.currentPage + 1;
    final cacheBox = Hive.box(AppConstants.hiveBoxName);
    final cacheKey = '${AppConstants.rulingsPrefixKey}${topicId ?? "all"}_${search ?? "all"}_$page';

    // Check cache for first page only
    if (!refresh && page == 1) {
      final cachedData = cacheBox.get(cacheKey) as String?;
      if (cachedData != null) {
        try {
          final data = jsonDecode(cachedData) as Map<String, dynamic>;
          final paginated = RulingsPaginated.fromJson(data);
          state = state.copyWith(
            isLoadingRulings: false,
            rulings: paginated.items,
            currentPage: paginated.currentPage,
            hasMore: paginated.currentPage < paginated.lastPage,
            isOffline: false,
            error: null,
          );
          return;
        } catch (e) {
          // Invalid cache, continue to fetch
        }
      }
    }

    if (refresh) {
      state = state.copyWith(
        isLoadingRulings: true,
        rulings: [],
        currentPage: 1,
        hasMore: true,
        error: null,
      );
    } else {
      state = state.copyWith(isLoadingMore: true, error: null);
    }

    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.getRulings(
        topicId: topicId ?? state.selectedTopicId,
        search: search ?? state.searchQuery,
        page: page,
      );

      final data = response['data'] as Map<String, dynamic>;
      final paginated = RulingsPaginated.fromJson(data);

      final allRulings = refresh
          ? paginated.items
          : [...state.rulings, ...paginated.items];

      // Save first page to cache
      if (page == 1) {
        await cacheBox.put(cacheKey, jsonEncode(data));
      }

      state = state.copyWith(
        isLoadingRulings: false,
        isLoadingMore: false,
        rulings: allRulings,
        currentPage: paginated.currentPage,
        hasMore: paginated.currentPage < paginated.lastPage,
        isOffline: false,
        error: null,
      );
    } on NetworkException catch (e) {
      // Try to use cached data for first page
      if (page == 1) {
        final cachedData = cacheBox.get(cacheKey) as String?;
        if (cachedData != null) {
          try {
            final data = jsonDecode(cachedData) as Map<String, dynamic>;
            final paginated = RulingsPaginated.fromJson(data);
            state = state.copyWith(
              isLoadingRulings: false,
              rulings: paginated.items,
              currentPage: paginated.currentPage,
              hasMore: paginated.currentPage < paginated.lastPage,
              isOffline: true,
              error: null,
            );
            return;
          } catch (_) {}
        }
      }
      state = state.copyWith(
        isLoadingRulings: false,
        isLoadingMore: false,
        isOffline: true,
        error: 'لا يوجد اتصال بالإنترنت',
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoadingRulings: false,
        isLoadingMore: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingRulings: false,
        isLoadingMore: false,
        error: 'حدث خطأ غير متوقع',
      );
    }
  }

  void selectTopic(RulingTopic topic) {
    state = state.copyWith(
      selectedTopicId: topic.id,
      searchQuery: null,
    );
    loadRulings(topicId: topic.id, refresh: true);
  }

  void clearTopicFilter() {
    state = state.copyWith(
      selectedTopicId: null,
      searchQuery: null,
    );
    loadRulings(refresh: true);
  }

  void search(String query) {
    // Cancel previous timer
    _searchDebounceTimer?.cancel();
    
    // Debounce search
    _searchDebounceTimer = Timer(AppConstants.searchDebounceMs, () {
      state = state.copyWith(
        searchQuery: query.isEmpty ? null : query,
        selectedTopicId: null,
      );
      loadRulings(search: query.isEmpty ? null : query, refresh: true);
    });
  }

  void clearSearch() {
    _searchDebounceTimer?.cancel();
    state = state.copyWith(searchQuery: null);
    loadRulings(refresh: true);
  }

  Future<void> refreshAll() async {
    await loadTopics(forceRefresh: true);
    await loadRulings(refresh: true);
  }
}
