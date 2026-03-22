import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Screen to request notification permission with Arabic explanation
class NotificationPermissionScreen extends ConsumerStatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  ConsumerState<NotificationPermissionScreen> createState() => _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState extends ConsumerState<NotificationPermissionScreen> {
  bool _isLoading = false;

  Future<void> _requestPermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Request notification permission
      final status = await Permission.notification.request();
      
      final notificationService = NotificationService();
      
      if (status.isGranted) {
        // Request notification permissions
        await notificationService.requestPermissions();
      }

      // Mark as requested regardless of outcome
      await notificationService.markPermissionRequested();

      if (mounted) {
        context.go('/');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _skip() async {
    final notificationService = NotificationService();
    await notificationService.markPermissionRequested();
    
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                
                // Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.onPrimary.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    size: 60,
                    color: AppColors.onPrimary,
                  ),
                ).animate()
                  .scale(duration: 600.ms, curve: Curves.easeOutBack)
                  .fadeIn(duration: 400.ms),
                
                const SizedBox(height: 40),
                
                // Title
                Text(
                  'تنبيهات مهمة',
                  style: AppTypography.textTheme.headlineMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ).animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms)
                  .slideY(begin: 0.3, end: 0, delay: 200.ms, duration: 500.ms),
                
                const SizedBox(height: 16),
                
                // Description
                Text(
                  'نريد إرسال تنبيهات مهمة إليك:',
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha:0.9),
                  ),
                  textAlign: TextAlign.center,
                ).animate()
                  .fadeIn(delay: 300.ms, duration: 500.ms),
                
                const SizedBox(height: 32),
                
                // Benefits list
                _buildBenefitItem(
                  icon: Icons.access_time,
                  text: 'تذكير بمواقيت الصلاة',
                  delay: 400.ms,
                ),
                _buildBenefitItem(
                  icon: Icons.menu_book,
                  text: 'تنبيهات الأذكار اليومية',
                  delay: 500.ms,
                ),
                _buildBenefitItem(
                  icon: Icons.lightbulb_outline,
                  text: 'رسائل تحفيزية وأحاديث',
                  delay: 600.ms,
                ),
                _buildBenefitItem(
                  icon: Icons.nights_stay_outlined,
                  text: 'تذكير بقيام الليل',
                  delay: 700.ms,
                ),
                
                const Spacer(),
                
                // Allow button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _requestPermission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.onPrimary,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          )
                        : Text(
                            'السماح بالتنبيهات',
                            style: AppTypography.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                  ),
                ).animate()
                  .fadeIn(delay: 800.ms, duration: 500.ms)
                  .slideY(begin: 0.3, end: 0, delay: 800.ms, duration: 500.ms),
                
                const SizedBox(height: 16),
                
                // Skip button
                TextButton(
                  onPressed: _isLoading ? null : _skip,
                  child: Text(
                    'لاحقاً',
                    style: AppTypography.textTheme.titleSmall?.copyWith(
                      color: AppColors.onPrimary.withValues(alpha:0.7),
                    ),
                  ),
                ).animate()
                  .fadeIn(delay: 900.ms, duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String text,
    required Duration delay,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withValues(alpha:0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.onPrimary,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            text,
            style: AppTypography.textTheme.bodyLarge?.copyWith(
              color: AppColors.onPrimary.withValues(alpha:0.95),
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: delay, duration: 400.ms)
      .slideX(begin: -0.2, end: 0, delay: delay, duration: 400.ms);
  }
}
