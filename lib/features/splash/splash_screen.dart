import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleUp;
  late final Animation<double> _textFade;
  late final Animation<double> _shimmer;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    _scaleUp = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
    );

    _shimmer = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    );

    _controller.forward();
    _startInitialization();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startInitialization() async {
    // Minimum display time for animations
    await Future.delayed(const Duration(milliseconds: 2500));
    
    // Navigate directly - no async chains that can hang
    _navigateNow();
  }

  void _navigateNow() {
    if (_isNavigating || !mounted) return;
    _isNavigating = true;
    
    // Go directly to home - skip notification permission check that may hang
    // Notification permission will be requested when needed
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: Stack(
          children: [
            // Islamic geometric pattern background
            Positioned.fill(
              child: CustomPaint(
                painter: _IslamicPatternPainter(
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),

            // Radial glow behind logo
            Positioned(
              top: screenSize.height * 0.2,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _fadeIn,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeIn.value * 0.4,
                    child: child,
                  );
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        blurRadius: 120,
                        spreadRadius: 60,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mosque icon with crescent
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeIn.value,
                          child: Transform.scale(
                            scale: _scaleUp.value,
                            child: child,
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: CustomPaint(
                          painter: _MosquePainter(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // App name
                    AnimatedBuilder(
                      animation: _textFade,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textFade.value,
                          child: Transform.translate(
                            offset: Offset(0, 16 * (1 - _textFade.value)),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        'أركـانـي',
                        style: AppTypography.arabicTitle.copyWith(
                          fontSize: 42,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 4,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Decorative divider
                    AnimatedBuilder(
                      animation: _textFade,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textFade.value,
                          child: child,
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 32,
                            height: 1,
                            color: AppColors.secondary.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.star,
                            size: 8,
                            color: AppColors.secondary.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 32,
                            height: 1,
                            color: AppColors.secondary.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    AnimatedBuilder(
                      animation: _textFade,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textFade.value * 0.8,
                          child: child,
                        );
                      },
                      child: Text(
                        'رفيقك في طاعة الله',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Loading indicator
                    AnimatedBuilder(
                      animation: _shimmer,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _shimmer.value,
                          child: child,
                        );
                      },
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.secondary.withValues(alpha: 0.7),
                          backgroundColor:
                              Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Quran verse
            Positioned(
              bottom: 32,
              left: 24,
              right: 24,
              child: AnimatedBuilder(
                animation: _shimmer,
                builder: (context, child) {
                  return Opacity(
                    opacity: _shimmer.value * 0.5,
                    child: child,
                  );
                },
                child: Text(
                  '﴿ وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ ﴾',
                  textAlign: TextAlign.center,
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Islamic geometric pattern painter
class _IslamicPatternPainter extends CustomPainter {
  final Color color;
  _IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    const spacing = 48.0;
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        _drawIslamicStar(canvas, Offset(x, y), spacing * 0.35, paint);
      }
    }
  }

  void _drawIslamicStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) - math.pi / 8;
      final outerX = center.dx + radius * math.cos(angle);
      final outerY = center.dy + radius * math.sin(angle);
      final innerAngle = angle + math.pi / 8;
      final innerX = center.dx + (radius * 0.4) * math.cos(innerAngle);
      final innerY = center.dy + (radius * 0.4) * math.sin(innerAngle);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Mosque silhouette painter
class _MosquePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final baseY = size.height * 0.88;
    final s = size.width / 160;

    // Main dome
    final domePath = Path();
    domePath.moveTo(cx - 28 * s, baseY - 45 * s);
    domePath.quadraticBezierTo(cx, baseY - 88 * s, cx + 28 * s, baseY - 45 * s);
    canvas.drawPath(domePath, paint);

    // Dome finial (crescent)
    final crescentPaint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, baseY - 85 * s), 4 * s, crescentPaint);
    canvas.drawCircle(
      Offset(cx + 2 * s, baseY - 86 * s),
      3 * s,
      Paint()..color = const Color(0xFF0A4D3C),
    );

    // Building body
    canvas.drawRect(
      Rect.fromLTRB(cx - 35 * s, baseY - 45 * s, cx + 35 * s, baseY),
      paint,
    );

    // Left minaret
    canvas.drawRect(
      Rect.fromLTRB(cx - 52 * s, baseY, cx - 44 * s, baseY - 65 * s),
      paint,
    );
    // Left minaret cap
    final leftCap = Path();
    leftCap.moveTo(cx - 56 * s, baseY - 65 * s);
    leftCap.lineTo(cx - 48 * s, baseY - 78 * s);
    leftCap.lineTo(cx - 40 * s, baseY - 65 * s);
    leftCap.close();
    canvas.drawPath(leftCap, paint);

    // Right minaret
    canvas.drawRect(
      Rect.fromLTRB(cx + 44 * s, baseY, cx + 52 * s, baseY - 65 * s),
      paint,
    );
    // Right minaret cap
    final rightCap = Path();
    rightCap.moveTo(cx + 40 * s, baseY - 65 * s);
    rightCap.lineTo(cx + 48 * s, baseY - 78 * s);
    rightCap.lineTo(cx + 56 * s, baseY - 65 * s);
    rightCap.close();
    canvas.drawPath(rightCap, paint);

    // Entrance arch
    final archPaint = Paint()
      ..color = const Color(0xFF0A4D3C)
      ..style = PaintingStyle.fill;
    final archPath = Path();
    archPath.moveTo(cx - 10 * s, baseY);
    archPath.quadraticBezierTo(cx, baseY - 20 * s, cx + 10 * s, baseY);
    archPath.close();
    canvas.drawPath(archPath, archPaint);

    // Small side arches
    for (final offsetX in [-22.0, 22.0]) {
      final smallArch = Path();
      smallArch.moveTo(cx + (offsetX - 5) * s, baseY);
      smallArch.quadraticBezierTo(
        cx + offsetX * s, baseY - 12 * s, cx + (offsetX + 5) * s, baseY);
      smallArch.close();
      canvas.drawPath(smallArch, archPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
