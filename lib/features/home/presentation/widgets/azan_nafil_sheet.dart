import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class AzanNafilSheet extends ConsumerStatefulWidget {
  final String prayer;

  const AzanNafilSheet({super.key, required this.prayer});

  @override
  ConsumerState<AzanNafilSheet> createState() => _AzanNafilSheetState();
}

class _AzanNafilSheetState extends ConsumerState<AzanNafilSheet> {
  Map<String, dynamic>? _message;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessage();
  }

  Future<void> _loadMessage() async {
    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.getRandomMessage(prayer: widget.prayer);
      setState(() {
        _message = response['data'] as Map<String, dynamic>?;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryDark],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.notifications_active,
                                color: AppColors.onPrimary,
                                size: 40,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'أذان ${_getPrayerName()}',
                                style: AppTypography.textTheme.titleLarge?.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 24),

                        // Motivational Message Card
                        if (_message != null)
                          _buildMessageCard()
                              .animate().fadeIn(duration: 500.ms, delay: 200.ms),

                        const SizedBox(height: 20),

                        // Adhkar reminder
                        _buildAdhkarCard()
                            .animate().fadeIn(duration: 500.ms, delay: 400.ms),

                        const SizedBox(height: 20),

                        // Nafl reminder
                        _buildNaflCard()
                            .animate().fadeIn(duration: 500.ms, delay: 600.ms),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondaryContainer,
            AppColors.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.secondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote,
                color: AppColors.secondary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'رسالة تحفيزية',
                style: AppTypography.textTheme.labelLarge?.copyWith(
                  color: AppColors.secondaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _message?['text'] ?? 'استغفر الله العظيم',
            style: AppTypography.arabicBody.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAdhkarCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.menu_book,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'أذكار ما بعد الأذان',
                style: AppTypography.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDhikrItem('الله أكبر', 1),
          const SizedBox(height: 8),
          _buildDhikrItem('أشهد أن لا إله إلا الله', 1),
          const SizedBox(height: 8),
          _buildDhikrItem('أشهد أن محمداً رسول الله', 1),
          const SizedBox(height: 8),
          _buildDhikrItem('حي على الصلاة', 1),
          const SizedBox(height: 8),
          _buildDhikrItem('اللهم رب هذه الدعوة التامة...', 1),
        ],
      ),
    );
  }

  Widget _buildDhikrItem(String text, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '$count',
                style: AppTypography.textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNaflCard() {
    final naflNames = {
      'fajr': 'ركعتي الضحى',
      'dhuhr': 'النوافل قبل الظهر',
      'asr': 'النوافل قبل العصر',
      'maghrib': 'النوافل قبل المغرب',
      'isha': 'النوافل قبل العشاء',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withOpacity(0.1),
            AppColors.success.withOpacity(0.05),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.favorite,
                  color: AppColors.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'النوافل المستحبة',
                style: AppTypography.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'لا تنسَ صلاة ${naflNames[widget.prayer] ?? 'النوافل'}',
            style: AppTypography.textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'قال النبي ﷺ: "من صلى قبل الظهر أربعاً وبعدها أربعاً حرمه الله على النار"',
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  String _getPrayerName() {
    final names = {
      'fajr': 'الفجر',
      'dhuhr': 'الظهر',
      'asr': 'العصر',
      'maghrib': 'المغرب',
      'isha': 'العشاء',
    };
    return names[widget.prayer] ?? '';
  }
}
