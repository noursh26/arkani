import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/providers.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/location_util.dart';
import '../../domain/entities/mosque.dart';
import 'mosques_state.dart';

part 'mosques_provider.g.dart';

@riverpod
class MosquesNotifier extends _$MosquesNotifier {
  @override
  MosquesState build() {
    return const MosquesState();
  }

  Future<void> loadNearbyMosques({bool forceRefresh = false}) async {
    final cacheBox = Hive.box(AppConstants.hiveBoxName);
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Check for cached data first (10 minute cache)
    if (!forceRefresh) {
      final cachedTime = cacheBox.get(AppConstants.mosquesCacheTimeKey) as int?;
      final cachedData = cacheBox.get(AppConstants.mosquesKey) as String?;
      
      if (cachedTime != null && cachedData != null) {
        final cacheAge = now - cachedTime;
        if (cacheAge < AppConstants.mosquesCacheDuration.inMilliseconds) {
          try {
            final location = await ref.read(locationUtilProvider).getCurrentLocation();
            final isDefaultLocation = 
                location.latitude == AppConstants.defaultLatitude &&
                location.longitude == AppConstants.defaultLongitude;
            
            final data = jsonDecode(cachedData) as List<dynamic>;
            final mosques = data
                .map((e) => Mosque.fromJson(e as Map<String, dynamic>))
                .toList();
            state = state.copyWith(
              mosques: mosques,
              currentLocation: location,
              isUsingDefaultLocation: isDefaultLocation,
              isLoading: false,
              isOffline: false,
              error: null,
            );
            return;
          } catch (e) {
            // Invalid cache, continue to fetch
          }
        }
      }
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final location = await ref.read(locationUtilProvider).getCurrentLocation();
      
      // Check if using default location
      final isDefaultLocation = 
          location.latitude == AppConstants.defaultLatitude &&
          location.longitude == AppConstants.defaultLongitude;

      final apiService = ref.read(apiServiceProvider);
      final mosquesData = await apiService.getNearbyMosques(
        lat: location.latitude,
        lng: location.longitude,
        radius: AppConstants.mosqueSearchRadius,
      );

      final mosques = mosquesData
          .map((json) => Mosque.fromJson(json as Map<String, dynamic>))
          .toList();

      // Save to cache
      await cacheBox.put(AppConstants.mosquesKey, jsonEncode(mosquesData));
      await cacheBox.put(AppConstants.mosquesCacheTimeKey, now);

      state = state.copyWith(
        isLoading: false,
        mosques: mosques,
        currentLocation: location,
        isUsingDefaultLocation: isDefaultLocation,
        isOffline: false,
        error: null,
      );
    } on NetworkException catch (e) {
      // Try to use cached data even if expired
      final cachedData = cacheBox.get(AppConstants.mosquesKey) as String?;
      if (cachedData != null) {
        try {
          final location = await ref.read(locationUtilProvider).getCurrentLocation();
          final isDefaultLocation = 
              location.latitude == AppConstants.defaultLatitude &&
              location.longitude == AppConstants.defaultLongitude;
          
          final data = jsonDecode(cachedData) as List<dynamic>;
          final mosques = data
              .map((e) => Mosque.fromJson(e as Map<String, dynamic>))
              .toList();
          state = state.copyWith(
            isLoading: false,
            mosques: mosques,
            currentLocation: location,
            isUsingDefaultLocation: isDefaultLocation,
            isOffline: true,
            error: null,
          );
        } catch (_) {
          state = state.copyWith(
            isLoading: false,
            isOffline: true,
            error: 'لا يوجد اتصال بالإنترنت',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          isOffline: true,
          error: 'لا يوجد اتصال بالإنترنت',
        );
      }
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'حدث خطأ غير متوقع',
      );
    }
  }

  Future<void> requestLocationPermission() async {
    final locationUtil = ref.read(locationUtilProvider);
    final granted = await locationUtil.requestPermission();

    if (granted) {
      state = state.copyWith(isLocationDenied: false);
      await loadNearbyMosques(forceRefresh: true);
    } else {
      state = state.copyWith(
        error: 'تم رفض إذن الموقع، سيتم استخدام الموقع الافتراضي',
        isUsingDefaultLocation: true,
        isLocationDenied: true,
      );
    }
  }

  void selectMosque(Mosque mosque) {
    state = state.copyWith(selectedMosque: mosque);
  }

  void clearSelection() {
    state = state.copyWith(selectedMosque: null);
  }
}
