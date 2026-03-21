import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/mosques_provider.dart';

class LocationPermissionWidget extends StatelessWidget {
  const LocationPermissionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_off,
                color: AppColors.warning,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'الموقع غير مفعل',
                  style: AppTypography.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'يرجى تفعيل خدمة الموقع للحصول على مساجد قريبة منك. حالياً يتم عرض مساجد الرياض كموقع افتراضي.',
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Request permission through provider
              },
              icon: const Icon(Icons.location_on, size: 18),
              label: const Text('تفعيل الموقع'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: AppColors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
