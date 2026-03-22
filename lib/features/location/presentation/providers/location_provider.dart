import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/location_local_datasource.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/entities/prayer_times.dart';
import '../../domain/entities/user_location.dart';
import '../../domain/repositories/location_repository.dart';

part 'location_provider.g.dart';

/// Remote DataSource Provider
final locationRemoteDataSourceProvider = Provider<LocationRemoteDataSource>((ref) {
  return LocationRemoteDataSourceImpl();
});

/// Local DataSource Provider
final locationLocalDataSourceProvider = Provider<LocationLocalDataSource>((ref) {
  return LocationLocalDataSourceImpl();
});

/// Repository Provider
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl(
    remoteDataSource: ref.watch(locationRemoteDataSourceProvider),
    localDataSource: ref.watch(locationLocalDataSourceProvider),
  );
});

/// PrayerTimes Repository Provider
final prayerTimesRepositoryProvider = Provider<PrayerTimesRepository>((ref) {
  return LocationRepositoryImpl(
    remoteDataSource: ref.watch(locationRemoteDataSourceProvider),
    localDataSource: ref.watch(locationLocalDataSourceProvider),
  );
});

/// Saved Location Provider
@Riverpod(keepAlive: true)
class SavedLocation extends _$SavedLocation {
  @override
  Future<UserLocation?> build() async {
    final repository = ref.watch(locationRepositoryProvider);
    final result = await repository.getSavedLocation();
    return result.fold(
      (failure) => null,
      (location) => location,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final repository = ref.read(locationRepositoryProvider);
    final result = await repository.getSavedLocation();
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (location) => AsyncData(location),
    );
  }

  Future<void> saveLocation(UserLocation location) async {
    final repository = ref.read(locationRepositoryProvider);
    final result = await repository.saveLocation(location);
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (_) => state = AsyncData(location),
    );
  }

  Future<void> detectLocation() async {
    state = const AsyncLoading();
    final repository = ref.read(locationRepositoryProvider);
    final result = await repository.getCurrentLocation();
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (location) => state = AsyncData(location),
    );
  }

  Future<void> clearLocation() async {
    final repository = ref.read(locationRepositoryProvider);
    final result = await repository.clearSavedLocation();
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (_) => state = const AsyncData(null),
    );
  }
}

/// Current PrayerTimes Provider
@Riverpod(keepAlive: true)
class CurrentPrayerTimes extends _$CurrentPrayerTimes {
  @override
  Future<PrayerTimes?> build() async {
    final repository = ref.watch(prayerTimesRepositoryProvider);
    final savedLocationAsync = ref.watch(savedLocationProvider);

    final savedPrayerTimes = await repository.getSavedPrayerTimes();
    final savedPrayerTimesResult = savedPrayerTimes.fold(
      (failure) => null,
      (prayerTimes) => prayerTimes,
    );

    if (savedPrayerTimesResult != null) {
      return savedPrayerTimesResult;
    }

    final location = savedLocationAsync.valueOrNull;
    if (location == null) return null;

    final result = await repository.calculatePrayerTimes(location);
    return result.fold(
      (failure) => null,
      (prayerTimes) => prayerTimes,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final repository = ref.read(prayerTimesRepositoryProvider);
    final locationAsync = ref.read(savedLocationProvider);

    final location = locationAsync.valueOrNull;
    if (location == null) {
      state = const AsyncData(null);
      return;
    }

    final result = await repository.calculatePrayerTimes(location);
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (prayerTimes) => AsyncData(prayerTimes),
    );
  }

  Future<void> calculateForLocation(UserLocation location) async {
    state = const AsyncLoading();
    final repository = ref.read(prayerTimesRepositoryProvider);
    final result = await repository.calculatePrayerTimes(location);
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (prayerTimes) => state = AsyncData(prayerTimes),
    );
  }

  Future<void> calculateWithMethod(String methodId) async {
    state = const AsyncLoading();
    final repository = ref.read(prayerTimesRepositoryProvider);
    final locationAsync = ref.read(savedLocationProvider);

    final location = locationAsync.valueOrNull;
    if (location == null) {
      state = const AsyncData(null);
      return;
    }

    final result = await repository.calculatePrayerTimes(
      location,
      calculationMethod: methodId,
    );
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (prayerTimes) => AsyncData(prayerTimes),
    );
  }
}

/// Location Permission Provider
@Riverpod(keepAlive: true)
class LocationPermission extends _$LocationPermission {
  @override
  Future<bool> build() async {
    final repository = ref.watch(locationRepositoryProvider);
    final result = await repository.isLocationPermissionGranted();
    return result.fold(
      (failure) => false,
      (isGranted) => isGranted,
    );
  }

  Future<bool> request() async {
    state = const AsyncLoading();
    final repository = ref.read(locationRepositoryProvider);
    final result = await repository.requestLocationPermission();
    final isGranted = result.fold(
      (failure) => false,
      (granted) => granted,
    );
    state = AsyncData(isGranted);
    return isGranted;
  }

  Future<void> check() async {
    final repository = ref.read(locationRepositoryProvider);
    final result = await repository.isLocationPermissionGranted();
    state = result.fold(
      (failure) => const AsyncData(false),
      (isGranted) => AsyncData(isGranted),
    );
  }
}

/// Search Locations Provider
@Riverpod(keepAlive: true)
class SearchLocations extends _$SearchLocations {
  @override
  Future<List<UserLocation>> build() async {
    return [];
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    final repository = ref.read(locationRepositoryProvider);
    final result = await repository.searchLocations(query);
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (locations) => AsyncData(locations),
    );
  }

  void clear() {
    state = const AsyncData([]);
  }
}

/// Qibla Direction Provider
@Riverpod(keepAlive: true)
class QiblaDirection extends _$QiblaDirection {
  @override
  Future<double?> build() async {
    final repository = ref.watch(prayerTimesRepositoryProvider);
    final locationAsync = ref.watch(savedLocationProvider);

    final location = locationAsync.valueOrNull;
    if (location == null) return null;

    final result = await repository.getQiblaDirection(location);
    return result.fold(
      (failure) => null,
      (direction) => direction,
    );
  }
}

/// Calculation Methods Provider
final calculationMethodsProvider = Provider<List<CalculationMethod>>((ref) {
  final repository = ref.watch(prayerTimesRepositoryProvider);
  return repository.getAvailableCalculationMethods();
});

/// Selected Calculation Method Provider
@Riverpod(keepAlive: true)
class SelectedCalculationMethod extends _$SelectedCalculationMethod {
  static const String _defaultMethod = 'muslim_world_league';

  @override
  String build() {
    return _defaultMethod;
  }

  void select(String methodId) {
    state = methodId;
  }
}

/// Next Prayer Provider
final nextPrayerProvider = Provider<Map<String, dynamic>?>((ref) {
  final prayerTimesAsync = ref.watch(currentPrayerTimesProvider);

  return prayerTimesAsync.when(
    data: (prayerTimes) {
      if (prayerTimes == null) return null;

      final now = DateTime.now();
      final prayers = [
        {'name': 'الفجر', 'key': 'fajr', 'time': prayerTimes.fajr},
        {'name': 'الشروق', 'key': 'sunrise', 'time': prayerTimes.sunrise},
        {'name': 'الظهر', 'key': 'dhuhr', 'time': prayerTimes.dhuhr},
        {'name': 'العصر', 'key': 'asr', 'time': prayerTimes.asr},
        {'name': 'المغرب', 'key': 'maghrib', 'time': prayerTimes.maghrib},
        {'name': 'العشاء', 'key': 'isha', 'time': prayerTimes.isha},
      ];

      for (final prayer in prayers) {
        final time = prayer['time'] as DateTime;
        if (time.isAfter(now)) {
          final remaining = time.difference(now);
          return {
            'name': prayer['name'],
            'key': prayer['key'],
            'time': time,
            'remaining': remaining,
            'hours': remaining.inHours,
            'minutes': remaining.inMinutes % 60,
          };
        }
      }

      return {
        'name': 'الفجر',
        'key': 'fajr',
        'time': prayerTimes.fajr.add(const Duration(days: 1)),
        'remaining': prayerTimes.fajr.add(const Duration(days: 1)).difference(now),
        'hours': prayerTimes.fajr.add(const Duration(days: 1)).difference(now).inHours,
        'minutes': prayerTimes.fajr.add(const Duration(days: 1)).difference(now).inMinutes % 60,
      };
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Current Prayer Provider
final currentPrayerProvider = Provider<String?>((ref) {
  final prayerTimesAsync = ref.watch(currentPrayerTimesProvider);

  return prayerTimesAsync.when(
    data: (prayerTimes) {
      if (prayerTimes == null) return null;

      final now = DateTime.now();

      if (now.isAfter(prayerTimes.fajr) && now.isBefore(prayerTimes.sunrise)) {
        return 'الفجر';
      } else if (now.isAfter(prayerTimes.sunrise) && now.isBefore(prayerTimes.dhuhr)) {
        return 'الشروق';
      } else if (now.isAfter(prayerTimes.dhuhr) && now.isBefore(prayerTimes.asr)) {
        return 'الظهر';
      } else if (now.isAfter(prayerTimes.asr) && now.isBefore(prayerTimes.maghrib)) {
        return 'العصر';
      } else if (now.isAfter(prayerTimes.maghrib) && now.isBefore(prayerTimes.isha)) {
        return 'المغرب';
      } else if (now.isAfter(prayerTimes.isha) || now.isBefore(prayerTimes.fajr)) {
        return 'العشاء';
      }

      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Location Service Enabled Provider
@Riverpod(keepAlive: true)
class LocationServiceEnabled extends _$LocationServiceEnabled {
  @override
  Future<bool> build() async {
    final repository = ref.watch(locationRepositoryProvider);
    final result = await repository.isLocationServiceEnabled();
    return result.fold(
      (failure) => false,
      (isEnabled) => isEnabled,
    );
  }

  Future<void> check() async {
    final repository = ref.read(locationRepositoryProvider);
    final result = await repository.isLocationServiceEnabled();
    state = result.fold(
      (failure) => const AsyncData(false),
      (isEnabled) => AsyncData(isEnabled),
    );
  }
}
