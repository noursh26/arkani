import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:intl/intl.dart';

class NextPrayerCard extends StatelessWidget {
  final dynamic prayerTimes;

  const NextPrayerCard({super.key, required this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    final nextPrayer = _getNextPrayer();
    
    if (nextPrayer == null) {
      return const SizedBox.shrink();
    }

    final timeRemaining = _calculateTimeRemaining(nextPrayer.time);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryLight, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time,
                color: AppColors.onPrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'الصلاة القادمة: ${nextPrayer.name}',
                style: AppTypography.textTheme.titleMedium?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            nextPrayer.time,
            style: AppTypography.textTheme.displaySmall?.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'متبقي: $timeRemaining',
              style: AppTypography.textTheme.labelLarge?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _PrayerInfo? _getNextPrayer() {
    final now = DateTime.now();
    final format = DateFormat('HH:mm');

    final prayers = [
      _PrayerInfo('الفجر', prayerTimes.fajr),
      _PrayerInfo('الشروق', prayerTimes.sunrise),
      _PrayerInfo('الظهر', prayerTimes.dhuhr),
      _PrayerInfo('العصر', prayerTimes.asr),
      _PrayerInfo('المغرب', prayerTimes.maghrib),
      _PrayerInfo('العشاء', prayerTimes.isha),
    ];

    for (final prayer in prayers) {
      final prayerTime = format.parse(prayer.time);
      final prayerDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        prayerTime.hour,
        prayerTime.minute,
      );

      if (prayerDateTime.isAfter(now)) {
        return prayer;
      }
    }

    // Return tomorrow's Fajr
    return prayers.first;
  }

  String _calculateTimeRemaining(String prayerTime) {
    final now = DateTime.now();
    final format = DateFormat('HH:mm');
    final time = format.parse(prayerTime);
    
    var targetDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (targetDateTime.isBefore(now)) {
      targetDateTime = targetDateTime.add(const Duration(days: 1));
    }

    final difference = targetDateTime.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return '$hours ساعة و $minutes دقيقة';
    } else {
      return '$minutes دقيقة';
    }
  }
}

class _PrayerInfo {
  final String name;
  final String time;

  _PrayerInfo(this.name, this.time);
}
