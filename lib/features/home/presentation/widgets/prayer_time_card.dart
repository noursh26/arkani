import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class PrayerTimesCard extends StatelessWidget {
  final dynamic prayerTimes;

  const PrayerTimesCard({super.key, required this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    final prayers = [
      _PrayerData('الفجر', prayerTimes.fajr, AppColors.fajrColor, Icons.wb_twilight),
      _PrayerData('الشروق', prayerTimes.sunrise, AppColors.sunriseColor, Icons.wb_sunny_outlined),
      _PrayerData('الظهر', prayerTimes.dhuhr, AppColors.dhuhrColor, Icons.sunny),
      _PrayerData('العصر', prayerTimes.asr, AppColors.asrColor, Icons.wb_sunny),
      _PrayerData('المغرب', prayerTimes.maghrib, AppColors.maghribColor, Icons.wb_twilight),
      _PrayerData('العشاء', prayerTimes.isha, AppColors.ishaColor, Icons.nights_stay_outlined),
    ];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: prayers.asMap().entries.map((entry) {
            final index = entry.key;
            final prayer = entry.value;
            final isLast = index == prayers.length - 1;

            return Column(
              children: [
                _buildPrayerRow(prayer),
                if (!isLast)
                  const Divider(height: 24, indent: 40, endIndent: 0),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPrayerRow(_PrayerData prayer) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: prayer.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            prayer.icon,
            color: prayer.color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            prayer.name,
            style: AppTypography.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          prayer.time,
          style: AppTypography.textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PrayerData {
  final String name;
  final String time;
  final Color color;
  final IconData icon;

  _PrayerData(this.name, this.time, this.color, this.icon);
}
