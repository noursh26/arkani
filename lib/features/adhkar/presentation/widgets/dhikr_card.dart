import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/adhkar_category.dart';

class DhikrCard extends StatefulWidget {
  final Dhikr dhikr;
  final int index;
  final VoidCallback? onLongPress;
  final double fontSize;

  const DhikrCard({
    super.key,
    required this.dhikr,
    required this.index,
    this.onLongPress,
    this.fontSize = 22.0,
  });

  @override
  State<DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<DhikrCard> {
  int currentCount = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onLongPress: widget.onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with index, source, and count badge
              Row(
                children: [
                  // Index badge
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.index}',
                        style: AppTypography.textTheme.labelMedium?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Source
                  if (widget.dhikr.source != null && widget.dhikr.source!.isNotEmpty)
                    Expanded(
                      child: Text(
                        widget.dhikr.source!,
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  
                  // Count badge
                  if (widget.dhikr.count > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.secondary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '×${widget.dhikr.count}',
                        style: AppTypography.textTheme.labelMedium?.copyWith(
                          color: AppColors.secondaryDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Dhikr text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  widget.dhikr.text,
                  style: AppTypography.dhikrText.copyWith(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              // Counter section
              if (widget.dhikr.count > 1)
                _buildCounterSection()
              else
                _buildSingleReadButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounterSection() {
    final isCompleted = currentCount >= widget.dhikr.count;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: isCompleted
            ? LinearGradient(
                colors: [
                  AppColors.success.withOpacity(0.15),
                  AppColors.success.withOpacity(0.05),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              )
            : LinearGradient(
                colors: [
                  AppColors.primaryContainer,
                  AppColors.primary.withOpacity(0.05),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? AppColors.success.withOpacity(0.3)
              : AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Counter display
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success.withOpacity(0.2)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$currentCount / ${widget.dhikr.count}',
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    color: isCompleted ? AppColors.success : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isCompleted) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 24,
                ),
              ],
            ],
          ),

          // Counter buttons
          Row(
            children: [
              if (currentCount > 0)
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentCount = 0;
                    });
                  },
                  icon: const Icon(Icons.replay),
                  color: AppColors.textTertiary,
                  iconSize: 20,
                ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: isCompleted
                    ? null
                    : () {
                        setState(() {
                          currentCount++;
                        });
                      },
                icon: const Icon(Icons.add, size: 18),
                label: Text(
                  isCompleted ? 'تم' : 'تسبيح',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isCompleted ? AppColors.success : AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  disabledBackgroundColor: AppColors.success,
                  disabledForegroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: const Size(80, 40),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSingleReadButton() {
    final isRead = currentCount > 0;

    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          currentCount = isRead ? 0 : 1;
        });
      },
      icon: Icon(
        isRead ? Icons.replay : Icons.check_circle_outline,
        size: 20,
      ),
      label: Text(isRead ? 'إعادة' : 'قراءة'),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isRead ? AppColors.success : AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
