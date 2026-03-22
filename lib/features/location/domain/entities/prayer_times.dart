import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'prayer_times.g.dart';

@HiveType(typeId: 2)
class PrayerTimes extends Equatable {
  @HiveField(0)
  final DateTime fajr;

  @HiveField(1)
  final DateTime sunrise;

  @HiveField(2)
  final DateTime dhuhr;

  @HiveField(3)
  final DateTime asr;

  @HiveField(4)
  final DateTime maghrib;

  @HiveField(5)
  final DateTime isha;

  @HiveField(6)
  final DateTime? middleOfTheNight;

  @HiveField(7)
  final DateTime? lastThirdOfTheNight;

  @HiveField(8)
  final DateTime calculatedFor;

  @HiveField(9)
  final double qiblaDirection;

  @HiveField(10)
  final String calculationMethod;

  const PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    this.middleOfTheNight,
    this.lastThirdOfTheNight,
    required this.calculatedFor,
    required this.qiblaDirection,
    required this.calculationMethod,
  });

  PrayerTimes copyWith({
    DateTime? fajr,
    DateTime? sunrise,
    DateTime? dhuhr,
    DateTime? asr,
    DateTime? maghrib,
    DateTime? isha,
    DateTime? middleOfTheNight,
    DateTime? lastThirdOfTheNight,
    DateTime? calculatedFor,
    double? qiblaDirection,
    String? calculationMethod,
  }) {
    return PrayerTimes(
      fajr: fajr ?? this.fajr,
      sunrise: sunrise ?? this.sunrise,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
      middleOfTheNight: middleOfTheNight ?? this.middleOfTheNight,
      lastThirdOfTheNight: lastThirdOfTheNight ?? this.lastThirdOfTheNight,
      calculatedFor: calculatedFor ?? this.calculatedFor,
      qiblaDirection: qiblaDirection ?? this.qiblaDirection,
      calculationMethod: calculationMethod ?? this.calculationMethod,
    );
  }

  DateTime? get nextPrayer {
    final now = DateTime.now();
    final prayers = [
      ('fajr', fajr),
      ('sunrise', sunrise),
      ('dhuhr', dhuhr),
      ('asr', asr),
      ('maghrib', maghrib),
      ('isha', isha),
    ];

    for (final (_, time) in prayers) {
      if (time.isAfter(now)) {
        return time;
      }
    }
    return null;
  }

  String? get nextPrayerName {
    final now = DateTime.now();
    final prayers = [
      ('fajr', fajr),
      ('sunrise', sunrise),
      ('dhuhr', dhuhr),
      ('asr', asr),
      ('maghrib', maghrib),
      ('isha', isha),
    ];

    for (final (name, time) in prayers) {
      if (time.isAfter(now)) {
        return name;
      }
    }
    return 'fajr';
  }

  Duration? get timeUntilNextPrayer {
    final next = nextPrayer;
    if (next == null) return null;
    return next.difference(DateTime.now());
  }

  Map<String, DateTime> get allPrayers => {
        'fajr': fajr,
        'sunrise': sunrise,
        'dhuhr': dhuhr,
        'asr': asr,
        'maghrib': maghrib,
        'isha': isha,
      };

  @override
  List<Object?> get props => [
        fajr,
        sunrise,
        dhuhr,
        asr,
        maghrib,
        isha,
        middleOfTheNight,
        lastThirdOfTheNight,
        calculatedFor,
        qiblaDirection,
        calculationMethod,
      ];
}
