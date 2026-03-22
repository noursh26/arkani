import 'package:adhan/adhan.dart' as adhan;
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/prayer_times.dart';
import '../../domain/entities/user_location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_datasource.dart';
import '../datasources/location_remote_datasource.dart';

class LocationRepositoryImpl implements LocationRepository, PrayerTimesRepository {
  final LocationRemoteDataSource remoteDataSource;
  final LocationLocalDataSource localDataSource;

  LocationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserLocation>> getCurrentLocation() async {
    try {
      final location = await remoteDataSource.getCurrentLocation();
      await localDataSource.saveLocation(location);
      return Right(location);
    } on LocationException catch (e) {
      return Left(LocationFailure(message: e.message));
    } on PermissionException catch (e) {
      return Left(PermissionFailure(message: e.toString()));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserLocation>> getLocationFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final location = await remoteDataSource.getLocationFromCoordinates(
        latitude,
        longitude,
      );
      return Right(location);
    } on LocationException catch (e) {
      return Left(LocationFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserLocation>>> searchLocations(String query) async {
    try {
      final locations = await remoteDataSource.searchLocations(query);
      return Right(locations);
    } on LocationException catch (e) {
      return Left(LocationFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserLocation?>> getSavedLocation() async {
    try {
      final location = await localDataSource.getSavedLocation();
      return Right(location);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.toString()));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLocation(UserLocation location) async {
    try {
      await localDataSource.saveLocation(location);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.toString()));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearSavedLocation() async {
    try {
      await localDataSource.clearLocation();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.toString()));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLocationPermissionGranted() async {
    try {
      final isGranted = await remoteDataSource.isLocationPermissionGranted();
      return Right(isGranted);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> requestLocationPermission() async {
    try {
      final isGranted = await remoteDataSource.requestLocationPermission();
      return Right(isGranted);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLocationServiceEnabled() async {
    try {
      final isEnabled = await remoteDataSource.isLocationServiceEnabled();
      return Right(isEnabled);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PrayerTimes>> calculatePrayerTimes(
    UserLocation location, {
    DateTime? date,
    String? calculationMethod,
  }) async {
    try {
      final targetDate = date ?? DateTime.now();
      final method = _getCalculationMethod(calculationMethod ?? 'muslim_world_league');

      final coordinates = adhan.Coordinates(location.latitude, location.longitude);
      final params = adhan.CalculationMethod.values[method].getParameters();
      params.madhab = adhan.Madhab.shafi;

      final prayerTimes = adhan.PrayerTimes(
        coordinates,
        adhan.DateComponents(targetDate.year, targetDate.month, targetDate.day),
        params,
      );

      final sunnahTimes = adhan.SunnahTimes(prayerTimes);
      final qibla = adhan.Qibla(coordinates);

      final result = PrayerTimes(
        fajr: prayerTimes.fajr,
        sunrise: prayerTimes.sunrise,
        dhuhr: prayerTimes.dhuhr,
        asr: prayerTimes.asr,
        maghrib: prayerTimes.maghrib,
        isha: prayerTimes.isha,
        middleOfTheNight: sunnahTimes.middleOfTheNight,
        lastThirdOfTheNight: sunnahTimes.lastThirdOfTheNight,
        calculatedFor: targetDate,
        qiblaDirection: qibla.direction,
        calculationMethod: calculationMethod ?? 'muslim_world_league',
      );

      await localDataSource.savePrayerTimes(result);
      return Right(result);
    } catch (e) {
      return Left(UnexpectedFailure(message: 'فشل في حساب أوقات الصلاة: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PrayerTimes>>> calculateMonthlyPrayerTimes(
    UserLocation location,
    int year,
    int month, {
    String? calculationMethod,
  }) async {
    try {
      final results = <PrayerTimes>[];
      final daysInMonth = DateTime(year, month + 1, 0).day;

      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(year, month, day);
        final prayerTimesResult = await calculatePrayerTimes(
          location,
          date: date,
          calculationMethod: calculationMethod,
        );

        prayerTimesResult.fold(
          (failure) => throw Exception(failure.message),
          (prayerTimes) => results.add(prayerTimes),
        );
      }

      return Right(results);
    } catch (e) {
      return Left(UnexpectedFailure(message: 'فشل في حساب أوقات الصلاة الشهرية: $e'));
    }
  }

  @override
  Future<Either<Failure, PrayerTimes?>> getSavedPrayerTimes() async {
    try {
      final prayerTimes = await localDataSource.getSavedPrayerTimes();
      return Right(prayerTimes);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.toString()));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> savePrayerTimes(PrayerTimes prayerTimes) async {
    try {
      await localDataSource.savePrayerTimes(prayerTimes);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.toString()));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getQiblaDirection(UserLocation location) async {
    try {
      final coordinates = adhan.Coordinates(location.latitude, location.longitude);
      final qibla = adhan.Qibla(coordinates);
      return Right(qibla.direction);
    } catch (e) {
      return Left(UnexpectedFailure(message: 'فشل في حساب اتجاه القبلة: $e'));
    }
  }

  @override
  List<CalculationMethod> getAvailableCalculationMethods() {
    return CalculationMethod.defaultMethods;
  }

  int _getCalculationMethod(String methodId) {
    final methods = {
      'muslim_world_league': 0,
      'egyptian': 1,
      'karachi': 2,
      'umm_al_qura': 3,
      'dubai': 4,
      'makkah': 5,
      'kuwait': 6,
      'qatar': 7,
      'singapore': 8,
      'turkey': 9,
      'tehran': 10,
      'north_america': 11,
    };
    return methods[methodId] ?? 0;
  }
}

class PermissionException implements Exception {
  final String message;
  const PermissionException(this.message);

  @override
  String toString() => message;
}
