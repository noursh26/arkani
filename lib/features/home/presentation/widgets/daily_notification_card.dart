import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class DailyNotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;

  const DailyNotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final title = notification['title'] ?? 'تذكير يومي';
    final body = notification['body'] ?? '';
    final type = notification['type'] ?? 'general';

    IconData icon;
    Color color;

    switch (type) {
      case 'prayer':
        icon = Icons.access_time;
        color = AppColors.primary;
        break;
      case 'dhikr':
        icon = Icons.menu_book;
        color = AppColors.secondary;
        break;
      case 'reminder':
        icon = Icons.notifications_active;
        color = AppColors.warning;
        break;
      default:
        icon = Icons.info_outline;
        color = AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
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
                  title,
                  style: AppTypography.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
