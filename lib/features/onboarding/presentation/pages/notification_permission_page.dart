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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D5E4A),
              Color(0xFF0A4D3C),
              Color(0xFF073D2F),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                ).animate()
                    .scale(duration: 500.ms, curve: Curves.easeOutBack)
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: 24),

                // Title
                Text(
                  'تنبيهات مهمة',
                  style: AppTypography.arabicTitle.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ).animate()
                    .fadeIn(delay: 150.ms, duration: 400.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 8),

                Text(
                  'نريد إرسال تنبيهات مهمة إليك:',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ).animate()
                    .fadeIn(delay: 250.ms, duration: 400.ms),

                const SizedBox(height: 24),

                // Benefits list - compact
                _buildBenefitItem(
                  icon: Icons.access_time,
                  text: 'تذكير بمواقيت الصلاة',
                  delay: 300.ms,
                ),
                _buildBenefitItem(
                  icon: Icons.menu_book,
                  text: 'تنبيهات الأذكار اليومية',
                  delay: 380.ms,
                ),
                _buildBenefitItem(
                  icon: Icons.lightbulb_outline,
                  text: 'رسائل تحفيزية وأحاديث',
                  delay: 460.ms,
                ),
                _buildBenefitItem(
                  icon: Icons.nights_stay_outlined,
                  text: 'تذكير بقيام الليل',
                  delay: 540.ms,
                ),

                const Spacer(flex: 3),

                // Allow button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _requestPermission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          )
                        : Text(
                            'السماح بالتنبيهات',
                            style: AppTypography.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                  ),
                ).animate()
                    .fadeIn(delay: 600.ms, duration: 400.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 10),

                // Skip button
                TextButton(
                  onPressed: _isLoading ? null : _skip,
                  child: Text(
                    'لاحقاً',
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                ).animate()
                    .fadeIn(delay: 700.ms, duration: 400.ms),
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(delay: delay, duration: 350.ms)
        .slideX(begin: -0.15, end: 0, delay: delay, duration: 350.ms);
  }
}
