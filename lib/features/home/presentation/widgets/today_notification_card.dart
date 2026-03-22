import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: AppTypography.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    body,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      height: 1.4,
                    ),
                    maxLines: 2,
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
