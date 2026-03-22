import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/islamic_ruling.dart';

class RulingDetailSheet extends StatelessWidget {
  final IslamicRuling ruling;

  const RulingDetailSheet({super.key, required this.ruling});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Close button
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.divider,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 20),
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Topic Tag
                  if (ruling.topic != null)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryDark],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            ruling.topic!.name,
                            style: AppTypography.textTheme.labelLarge?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 24),

                  // Question Section
                  _buildSectionHeader(
                    icon: Icons.help_outline,
                    iconColor: AppColors.primary,
                    title: 'السؤال',
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                  
                  const SizedBox(height: 12),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha:0.2),
                      ),
                    ),
                    child: Text(
                      ruling.question,
                      style: AppTypography.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 200.ms),

                  const SizedBox(height: 24),

                  // Answer Section
                  _buildSectionHeader(
                    icon: Icons.check_circle_outline,
                    iconColor: AppColors.success,
                    title: 'الجواب',
                  ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                  
                  const SizedBox(height: 12),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha:0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.success.withValues(alpha:0.2),
                      ),
                    ),
                    child: Text(
                      ruling.answer,
                      style: AppTypography.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.8,
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 400.ms),

                  // Evidence Section
                  if (ruling.evidence != null && ruling.evidence!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    
                    _buildSectionHeader(
                      icon: Icons.menu_book,
                      iconColor: AppColors.secondary,
                      title: 'الدليل',
                    ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
                    
                    const SizedBox(height: 12),
                    
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.secondary.withValues(alpha:0.15),
                            AppColors.secondary.withValues(alpha:0.05),
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.secondary.withValues(alpha:0.3),
                        ),
                      ),
                      child: Text(
                        ruling.evidence!,
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondaryDark,
                          height: 1.8,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms, delay: 600.ms),
                  ],

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                              text: 'السؤال: ${ruling.question}\n\nالجواب: ${ruling.answer}${ruling.evidence != null ? '\n\nالدليل: ${ruling.evidence}' : ''}',
                            ));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم نسخ المحتوى')),
                            );
                          },
                          icon: const Icon(Icons.copy),
                          label: const Text('نسخ'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Share.share(
                              'السؤال: ${ruling.question}\n\nالجواب: ${ruling.answer}${ruling.evidence != null ? '\n\nالدليل: ${ruling.evidence}' : ''}',
                            );
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('مشاركة'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms, delay: 700.ms),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTypography.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
