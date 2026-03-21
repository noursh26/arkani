import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/prayer_times.dart';

class HeroSection extends StatelessWidget {
  final PrayerTimes? prayerTimes;

  const HeroSection({super.key, this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hijri = HijriCalendar.now();
    final gregorianFormatter = DateFormat('EEEE، d MMMM yyyy', 'ar');

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background gradient with mosque pattern
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
                AppColors.primary.withOpacity(0.95),
              ],
            ),
          ),
          child: CustomPaint(
            painter: _MosquePatternPainter(),
            size: Size.infinite,
          ),
        ),

        // Gradient overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.primaryDark.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Date badges
                Row(
                  children: [
                    _buildDateBadge(
                      hijri.toFormat('dd MMMM yyyy'),
                      Icons.calendar_today,
                    ),
                    const SizedBox(width: 8),
                    _buildDateBadge(
                      gregorianFormatter.format(now),
                      Icons.today,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Location info
                if (prayerTimes?.city != null)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.onPrimary.withOpacity(0.8),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${prayerTimes!.city}${prayerTimes?.country != null ? ', ${prayerTimes!.country}' : ''}',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateBadge(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.onPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.onPrimary.withOpacity(0.8),
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MosquePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.onPrimary.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    const mosqueWidth = 60.0;
    const mosqueHeight = 70.0;
    const spacing = 40.0;

    for (double x = 0; x < size.width + mosqueWidth; x += mosqueWidth + spacing) {
      _drawMosque(canvas, Offset(x, size.height - mosqueHeight - 20), mosqueWidth, mosqueHeight, paint);
    }
  }

  void _drawMosque(Canvas canvas, Offset offset, double width, double height, Paint paint) {
    final path = Path();
    final centerX = offset.dx + width / 2;
    final baseY = offset.dy + height;

    // Main dome
    path.moveTo(centerX - width * 0.25, baseY - height * 0.5);
    path.quadraticBezierTo(
      centerX, baseY - height * 0.85,
      centerX + width * 0.25, baseY - height * 0.5,
    );

    // Building body
    path.lineTo(centerX + width * 0.35, baseY - height * 0.5);
    path.lineTo(centerX + width * 0.35, baseY);
    path.lineTo(centerX - width * 0.35, baseY);
    path.lineTo(centerX - width * 0.35, baseY - height * 0.5);
    path.close();

    // Left minaret
    final leftMinaret = Path();
    leftMinaret.moveTo(centerX - width * 0.45, baseY);
    leftMinaret.lineTo(centerX - width * 0.45, baseY - height * 0.7);
    leftMinaret.lineTo(centerX - width * 0.38, baseY - height * 0.7);
    leftMinaret.lineTo(centerX - width * 0.38, baseY);
    leftMinaret.close();

    // Right minaret
    final rightMinaret = Path();
    rightMinaret.moveTo(centerX + width * 0.38, baseY);
    rightMinaret.lineTo(centerX + width * 0.38, baseY - height * 0.7);
    rightMinaret.lineTo(centerX + width * 0.45, baseY - height * 0.7);
    rightMinaret.lineTo(centerX + width * 0.45, baseY);
    rightMinaret.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(leftMinaret, paint);
    canvas.drawPath(rightMinaret, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
