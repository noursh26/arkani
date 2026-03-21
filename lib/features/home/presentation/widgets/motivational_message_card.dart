import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class MotivationalMessageCard extends StatelessWidget {
  final Map<String, dynamic> message;

  const MotivationalMessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final text = message['text'] ?? '';
    final prayerTime = message['prayer_time'] ?? 'any';

    String subtitle;
    switch (prayerTime) {
      case 'fajr':
        subtitle = 'رسالة لفجر اليوم';
        break;
      case 'dhuhr':
        subtitle = 'رسالة للظهر';
        break;
      case 'asr':
        subtitle = 'رسالة للعصر';
        break;
      case 'maghrib':
        subtitle = 'رسالة للمغرب';
        break;
      case 'isha':
        subtitle = 'رسالة للعشاء';
        break;
      default:
        subtitle = 'رسالة تحفيزية';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondaryContainer,
            AppColors.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.secondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote,
                color: AppColors.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                subtitle,
                style: AppTypography.textTheme.labelLarge?.copyWith(
                  color: AppColors.secondaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: AppTypography.arabicBody.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
