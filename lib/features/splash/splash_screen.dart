import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/onesignal_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _mosqueController;
  late final AnimationController _textController;
  bool _locationChecked = false;

  @override
  void initState() {
    super.initState();
    _mosqueController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _startAnimation();
  }

  @override
  void dispose() {
    _mosqueController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _startAnimation() async {
    // Start mosque animation
    await _mosqueController.forward();
    
    // Start text animation
    await _textController.forward();
    
    // Check location permission
    await _checkLocationPermission();
    
    // Check notification permission and navigate accordingly
    await _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    final oneSignalService = OneSignalService();
    
    // Check if permission has been requested before
    final hasRequested = await oneSignalService.hasRequestedPermission();
    
    if (!hasRequested && mounted) {
      // First launch - show notification permission screen
      context.go('/notification-permission');
    } else if (mounted) {
      // Already requested or permission denied - go to home
      context.go('/');
    }
  }

  Future<void> _checkLocationPermission() async {
    if (_locationChecked) return;
    _locationChecked = true;

    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Don't block, just continue with default location
      return;
    }

    // Check permission
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.background,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mosque Silhouette Animation
              AnimatedBuilder(
                animation: _mosqueController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _mosqueController.value,
                    child: Transform.scale(
                      scale: 0.8 + (_mosqueController.value * 0.2),
                      child: child,
                    ),
                  );
                },
                child: const _MosqueSilhouette(size: 180),
              ),
              
              const SizedBox(height: 40),
              
              // App Name Animation
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textController.value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - _textController.value)),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      'أركاني',
                      style: AppTypography.arabicTitle.copyWith(
                        fontSize: 48,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'تطبيق إسلامي شامل',
                      style: AppTypography.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Loading indicator
              if (_textController.isCompleted)
                const CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ).animate().fadeIn(duration: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _MosqueSilhouette extends StatelessWidget {
  final double size;

  const _MosqueSilhouette({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 0.9),
      painter: _MosquePainter(),
    );
  }
}

class _MosquePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final path = Path();
    
    final centerX = size.width / 2;
    final baseY = size.height * 0.85;
    final scale = size.width / 200;

    // Main dome
    path.moveTo(centerX - 30 * scale, baseY - 60 * scale);
    path.quadraticBezierTo(
      centerX, baseY - 110 * scale,
      centerX + 30 * scale, baseY - 60 * scale,
    );
    
    // Left minaret
    path.moveTo(centerX - 60 * scale, baseY);
    path.lineTo(centerX - 60 * scale, baseY - 80 * scale);
    path.lineTo(centerX - 50 * scale, baseY - 80 * scale);
    path.lineTo(centerX - 50 * scale, baseY);
    
    // Left minaret top
    path.moveTo(centerX - 65 * scale, baseY - 80 * scale);
    path.lineTo(centerX - 45 * scale, baseY - 80 * scale);
    path.lineTo(centerX - 55 * scale, baseY - 95 * scale);
    path.close();
    
    // Right minaret
    path.moveTo(centerX + 60 * scale, baseY);
    path.lineTo(centerX + 60 * scale, baseY - 80 * scale);
    path.lineTo(centerX + 50 * scale, baseY - 80 * scale);
    path.lineTo(centerX + 50 * scale, baseY);
    
    // Right minaret top
    path.moveTo(centerX + 65 * scale, baseY - 80 * scale);
    path.lineTo(centerX + 45 * scale, baseY - 80 * scale);
    path.lineTo(centerX + 55 * scale, baseY - 95 * scale);
    path.close();
    
    // Main building body
    path.addRect(Rect.fromLTRB(
      centerX - 45 * scale,
      baseY - 60 * scale,
      centerX + 45 * scale,
      baseY,
    ));
    
    // Entrance arch
    path.moveTo(centerX - 15 * scale, baseY);
    path.quadraticBezierTo(
      centerX, baseY - 25 * scale,
      centerX + 15 * scale, baseY,
    );
    path.close();

    // Draw main shape
    canvas.drawPath(path, paint);
    
    // Draw crescent moon
    final moonPaint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;
    
    final moonPath = Path();
    final moonCenter = Offset(centerX, baseY - 75 * scale);
    final moonRadius = 8 * scale;
    
    moonPath.addArc(
      Rect.fromCircle(center: moonCenter, radius: moonRadius),
      -0.5,
      5.5,
    );
    
    canvas.drawPath(moonPath, moonPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
