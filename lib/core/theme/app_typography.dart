import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextTheme get textTheme {
    final baseTextTheme = GoogleFonts.cairoTextTheme();
    
    return baseTextTheme.copyWith(
      // Display
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: AppColors.textPrimary,
        height: 1.12,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.16,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.22,
      ),

      // Headline
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.25,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.29,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.33,
      ),

      // Title
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.27,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
        height: 1.43,
      ),

      // Body
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.textPrimary,
        height: 1.43,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: AppColors.textSecondary,
        height: 1.33,
      ),

      // Label
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
        height: 1.43,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
        height: 1.33,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textTertiary,
        height: 1.45,
      ),
    );
  }

  // Arabic-specific styles for religious text
  static TextStyle get arabicTitle => GoogleFonts.tajawal(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get arabicSubtitle => GoogleFonts.tajawal(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get arabicBody => GoogleFonts.tajawal(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static TextStyle get arabicCaption => GoogleFonts.tajawal(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle get dhikrText => GoogleFonts.tajawal(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.8,
    letterSpacing: 0.5,
  );

  static TextStyle get prayerTime => GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.2,
  );
}
