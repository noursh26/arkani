import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class TodayNotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;

  const TodayNotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final title = notification['title'] ?? 'تذكير يومي';
    final body = notification['body'] ?? '';
    final type = notification['type'] ?? 'general';

    IconData icon;
    Color color;
    String label;

    switch (type) {
      case 'prayer':
        icon = Icons.access_time;
        color = AppColors.primary;
        label = 'تذكير صلاة';
        break;
      case 'dhikr':
        icon = Icons.menu_book;
        color = AppColors.secondary;
        label = 'تذكير أذكار';
        break;
      case 'reminder':
        icon = Icons.notifications_active;
        color = AppColors.warning;
        label = 'تذكير';
        break;
      default:
        icon = Icons.info_outline;
        color = AppColors.info;
        label = 'إشعار اليوم';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.08),
            color.withOpacity(0.03),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTypography.textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      title,
                      style: AppTypography.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (body.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              body,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
