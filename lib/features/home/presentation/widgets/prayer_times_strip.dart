import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../domain/entities/prayer_times.dart';

class PrayerTimesStrip extends StatelessWidget {
  final PrayerTimes prayerTimes;

  const PrayerTimesStrip({super.key, required this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final format = DateFormat('HH:mm');

    final prayers = [
      _PrayerStripData('الفجر', prayerTimes.fajr, AppColors.fajrColor, Icons.wb_twilight),
      _PrayerStripData('الظهر', prayerTimes.dhuhr, AppColors.dhuhrColor, Icons.sunny),
      _PrayerStripData('العصر', prayerTimes.asr, AppColors.asrColor, Icons.wb_sunny),
      _PrayerStripData('المغرب', prayerTimes.maghrib, AppColors.maghribColor, Icons.wb_twilight),
      _PrayerStripData('العشاء', prayerTimes.isha, AppColors.ishaColor, Icons.nights_stay_outlined),
    ];

    // Find active prayer
    int activeIndex = 0;
    for (int i = 0; i < prayers.length; i++) {
      final prayerTime = format.parse(prayers[i].time);
      final prayerDateTime = DateTime(now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);
      
      if (prayerDateTime.isAfter(now)) {
        activeIndex = i;
        break;
      }
      if (i == prayers.length - 1) {
        activeIndex = 0; // Next day's Fajr
      }
    }

    return Container(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: prayers.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final prayer = prayers[index];
          final isActive = index == activeIndex;
          return _PrayerStripItem(
            prayer: prayer,
            isActive: isActive,
          );
        },
      ),
    );
  }
}

class _PrayerStripItem extends StatelessWidget {
  final _PrayerStripData prayer;
  final bool isActive;

  const _PrayerStripItem({
    required this.prayer,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
                colors: [prayer.color, prayer.color.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
        color: isActive ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? prayer.color : AppColors.divider,
          width: isActive ? 0 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: prayer.color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            prayer.icon,
            color: isActive ? Colors.white : prayer.color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            prayer.name,
            style: AppTypography.textTheme.labelSmall?.copyWith(
              color: isActive ? Colors.white : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            prayer.time,
            style: AppTypography.textTheme.labelLarge?.copyWith(
              color: isActive ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerStripData {
  final String name;
  final String time;
  final Color color;
  final IconData icon;

  _PrayerStripData(this.name, this.time, this.color, this.icon);
}
