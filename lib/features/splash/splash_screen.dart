import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/notification_service.dart';
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
  late final AnimationController _logoPulseController;
  bool _isNavigating = false;
  bool _animationsComplete = false;

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
    _logoPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _startInitialization();
  }

  @override
  void dispose() {
    _mosqueController.dispose();
    _textController.dispose();
    _logoPulseController.dispose();
    super.dispose();
  }

  Future<void> _startInitialization() async {
    // Run animations and initialization in parallel
    await Future.wait([
      _runAnimations(),
      _initializeApp(),
    ]);

    // Ensure we don't navigate twice
    if (_animationsComplete && mounted && !_isNavigating) {
      _isNavigating = true;
      _navigateToNextScreen();
    }
  }

  Future<void> _runAnimations() async {
    // Start logo pulse animation
    _logoPulseController.repeat(reverse: true);

    // Start mosque animation
    await _mosqueController.forward();

    // Start text animation
    await _textController.forward();

    // Stop pulse and complete
    await _logoPulseController.forward(from: _logoPulseController.value);
    _logoPulseController.stop();

    _animationsComplete = true;
  }

  Future<void> _initializeApp() async {
    // Minimum splash duration for better UX
    final minDuration = Future.delayed(const Duration(seconds: 3));

    // Run initialization tasks
    final initTasks = Future.wait([
      _checkLocationPermission(),
      _prepareNotificationService(),
    ], eagerError: false);

    // Wait for both minimum duration and init tasks
    await Future.wait([minDuration, initTasks]);
  }

  Future<void> _prepareNotificationService() async {
    try {
      // Just initialize the service, don't request permission yet
      final notificationService = NotificationService();
      await notificationService.initialize();
    } catch (e) {
      debugPrint('Notification service initialization error: $e');
    }
  }

  Future<void> _checkLocationPermission() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services disabled');
        return;
      }

      // Check permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Request permission but don't block
        permission = await Geolocator.requestPermission().timeout(
          const Duration(seconds: 5),
          onTimeout: () => LocationPermission.denied,
        );
      }
    } catch (e) {
      debugPrint('Location permission error: $e');
    }
  }

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;

    try {
      final notificationService = NotificationService();
      final hasRequested = await notificationService.hasRequestedPermission();

      if (!mounted) return;

      if (!hasRequested) {
        // First launch - show notification permission screen
        context.go('/notification-permission');
      } else {
        // Already requested - go to home
        context.go('/');
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
      // Fallback to home screen
      if (mounted) {
        context.go('/');
      }
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
              AppColors.primary.withValues(alpha: 0.15),
              AppColors.background,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with pulse animation
              AnimatedBuilder(
                animation: _logoPulseController,
                builder: (context, child) {
                  final scale = 1.0 + (_logoPulseController.value * 0.05);
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: AnimatedBuilder(
                  animation: _mosqueController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _mosqueController.value,
                      child: Transform.scale(
                        scale: 0.7 + (_mosqueController.value * 0.3),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                    child: const _MosqueSilhouette(size: 150),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // App Name Animation
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textController.value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _textController.value)),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      'أركاني',
                      style: AppTypography.arabicTitle.copyWith(
                        fontSize: 52,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'تطبيق إسلامي شامل',
                      style: AppTypography.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Loading indicator with fade in
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  if (_textController.value < 1.0) {
                    return const SizedBox.shrink();
                  }
                  return child!;
                },
                child: Column(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'جاري التحميل...',
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
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
