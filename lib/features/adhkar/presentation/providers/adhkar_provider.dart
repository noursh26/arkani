import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/adhkar_category.dart';
import 'adhkar_state.dart';

part 'adhkar_provider.g.dart';

@riverpod
class AdhkarNotifier extends _$AdhkarNotifier {
  @override
  AdhkarState build() {
    return const AdhkarState();
  }

  Future<void> loadCategories({bool forceRefresh = false}) async {
    final cacheBox = Hive.box(AppConstants.hiveBoxName);
    
    // Check for cached data first
    if (!forceRefresh) {
      final cachedData = cacheBox.get(AppConstants.adhkarCategoriesKey) as String?;
      if (cachedData != null) {
        try {
          final data = jsonDecode(cachedData) as List<dynamic>;
          final categories = data
              .map((e) => AdhkarCategory.fromJson(e as Map<String, dynamic>))
              .toList();
          state = state.copyWith(
            categories: categories,
            isLoadingCategories: false,
            isOffline: false,
            error: null,
          );
          return;
        } catch (e) {
          // Invalid cache, continue to fetch
        }
      }
    }

    state = state.copyWith(isLoadingCategories: true, error: null);

    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.getAdhkarCategories();

      final data = response['data'] as List<dynamic>;
      final categories = data
          .map((e) => AdhkarCategory.fromJson(e as Map<String, dynamic>))
          .toList();

      // Save to cache
      await cacheBox.put(AppConstants.adhkarCategoriesKey, jsonEncode(data));

      state = state.copyWith(
        isLoadingCategories: false,
        categories: categories,
        isOffline: false,
        error: null,
      );
    } on NetworkException catch (e) {
      // Try to use cached data if available
      final cachedData = cacheBox.get(AppConstants.adhkarCategoriesKey) as String?;
      if (cachedData != null) {
        try {
          final data = jsonDecode(cachedData) as List<dynamic>;
          final categories = data
              .map((e) => AdhkarCategory.fromJson(e as Map<String, dynamic>))
              .toList();
          state = state.copyWith(
            isLoadingCategories: false,
            categories: categories,
            isOffline: true,
            error: null,
          );
        } catch (_) {
          state = state.copyWith(
            isLoadingCategories: false,
            isOffline: true,
            error: 'لا يوجد اتصال بالإنترنت',
          );
        }
      } else {
        state = state.copyWith(
          isLoadingCategories: false,
          isOffline: true,
          error: 'لا يوجد اتصال بالإنترنت',
        );
      }
    } on AppException catch (e) {
      state = state.copyWith(
        isLoadingCategories: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingCategories: false,
        error: 'حدث خطأ غير متوقع',
      );
    }
  }

  Future<void> loadAdhkarByCategory(String slug, {bool forceRefresh = false}) async {
    final cacheBox = Hive.box(AppConstants.hiveBoxName);
    final cacheKey = '${AppConstants.adhkarPrefixKey}$slug';
    
    // Check for cached data first
    if (!forceRefresh) {
      final cachedData = cacheBox.get(cacheKey) as String?;
      if (cachedData != null) {
        try {
          final data = jsonDecode(cachedData) as List<dynamic>;
          final adhkar = data
              .map((e) => Dhikr.fromJson(e as Map<String, dynamic>))
              .toList();
          state = state.copyWith(
            currentCollection: AdhkarCollection(adhkar: adhkar, category: AdhkarCategory(slug: slug)),
            isLoadingAdhkar: false,
            isOffline: false,
            error: null,
          );
          return;
        } catch (e) {
          // Invalid cache, continue to fetch
        }
      }
    }

    state = state.copyWith(isLoadingAdhkar: true, error: null);

    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.getAdhkarByCategory(slug);

      final data = response['data'] as List<dynamic>;
      final adhkar = data
          .map((e) => Dhikr.fromJson(e as Map<String, dynamic>))
          .toList();

      // Save to cache
      await cacheBox.put(cacheKey, jsonEncode(data));

      state = state.copyWith(
        isLoadingAdhkar: false,
        currentCollection: AdhkarCollection(adhkar: adhkar, category: AdhkarCategory(slug: slug)),
        isOffline: false,
        error: null,
      );
    } on NetworkException catch (e) {
      // Try to use cached data if available
      final cachedData = cacheBox.get(cacheKey) as String?;
      if (cachedData != null) {
        try {
          final data = jsonDecode(cachedData) as List<dynamic>;
          final adhkar = data
              .map((e) => Dhikr.fromJson(e as Map<String, dynamic>))
              .toList();
          state = state.copyWith(
            isLoadingAdhkar: false,
            currentCollection: AdhkarCollection(adhkar: adhkar, category: AdhkarCategory(slug: slug)),
            isOffline: true,
            error: null,
          );
        } catch (_) {
          state = state.copyWith(
            isLoadingAdhkar: false,
            isOffline: true,
            error: 'لا يوجد اتصال بالإنترنت',
          );
        }
      } else {
        state = state.copyWith(
          isLoadingAdhkar: false,
          isOffline: true,
          error: 'لا يوجد اتصال بالإنترنت',
        );
      }
    } on AppException catch (e) {
      state = state.copyWith(
        isLoadingAdhkar: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingAdhkar: false,
        error: 'حدث خطأ غير متوقع',
      );
    }
  }

  void selectCategory(AdhkarCategory category) {
    state = state.copyWith(selectedCategory: category);
    loadAdhkarByCategory(category.slug);
  }

  void clearCurrentCollection() {
    state = state.copyWith(
      currentCollection: null,
      selectedCategory: null,
    );
  }

  Future<void> refreshAll() async {
    await loadCategories(forceRefresh: true);
    if (state.selectedCategory != null) {
      await loadAdhkarByCategory(state.selectedCategory!.slug, forceRefresh: true);
    }
  }
}
