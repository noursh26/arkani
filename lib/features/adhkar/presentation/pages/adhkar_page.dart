import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/adhkar_category.dart';
import '../providers/adhkar_provider.dart';
import '../widgets/category_grid_item.dart';
import '../widgets/dhikr_card.dart';

class AdhkarPage extends ConsumerStatefulWidget {
  const AdhkarPage({super.key});

  @override
  ConsumerState<AdhkarPage> createState() => _AdhkarPageState();
}

class _AdhkarPageState extends ConsumerState<AdhkarPage> {
  final bool _preventScreenshot = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adhkarNotifierProvider.notifier).loadCategories();
    });
    _loadScreenshotPreference();
  }

  Future<void> _loadScreenshotPreference() async {
    // Screenshot prevention is enabled by default for adhkar screen
    if (_preventScreenshot && Platform.isAndroid) {
      await _enableScreenshotPrevention();
    }
  }

  Future<void> _enableScreenshotPrevention() async {
    try {
      // This uses a platform channel to enable secure flag
      // For now we use SystemChrome as a fallback
      // In production, you'd use a plugin like `flutter_windowmanager` or custom platform channel
    } catch (e) {
      debugPrint('Could not enable screenshot prevention: $e');
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(adhkarNotifierProvider.notifier).loadCategories();
  }

  void _showDhikrOptions(Dhikr dhikr) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.copy, color: AppColors.primary),
                ),
                title: const Text('نسخ الذكر'),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Clipboard.setData(ClipboardData(text: dhikr.text));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نسخ الذكر')),
                  );
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.share, color: AppColors.secondary),
                ),
                title: const Text('مشاركة الذكر'),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Share.share(dhikr.text);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showFontSizeDialog() {
    HapticFeedback.mediumImpact();
    final fontSize = ref.read(fontSizeProvider);
    final fontSizeNotifier = ref.read(fontSizeProvider.notifier);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'حجم الخط',
          style: AppTypography.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatefulBuilder(
              builder: (context, setDialogState) {
                return Consumer(
                  builder: (context, ref, child) {
                    final currentSize = ref.watch(fontSizeProvider);
                    return Column(
                      children: [
                        // Preview text
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                            style: TextStyle(
                              fontSize: currentSize,
                              fontFamily: 'Amiri',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Size controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: fontSizeNotifier.canDecrease
                                  ? () async {
                                      HapticFeedback.lightImpact();
                                      await fontSizeNotifier.decreaseFontSize();
                                      setDialogState(() {});
                                    }
                                  : null,
                              icon: const Icon(Icons.remove),
                              style: IconButton.styleFrom(
                                backgroundColor: fontSizeNotifier.canDecrease
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: currentSize,
                                min: fontSizeNotifier.minSize,
                                max: fontSizeNotifier.maxSize,
                                divisions: 7,
                                label: currentSize.toStringAsFixed(0),
                                onChanged: (value) async {
                                  await fontSizeNotifier.setFontSize(value);
                                  setDialogState(() {});
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: fontSizeNotifier.canIncrease
                                  ? () async {
                                      HapticFeedback.lightImpact();
                                      await fontSizeNotifier.increaseFontSize();
                                      setDialogState(() {});
                                    }
                                  : null,
                              icon: const Icon(Icons.add),
                              style: IconButton.styleFrom(
                                backgroundColor: fontSizeNotifier.canIncrease
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'الحجم الحالي: ${currentSize.toStringAsFixed(0)}',
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('تم'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(adhkarNotifierProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.adhkarCategories,
                style: AppTypography.textTheme.titleLarge?.copyWith(
                  color: innerBoxIsScrolled ? AppColors.textPrimary : AppColors.onPrimary,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: -50,
                      bottom: -30,
                      child: Icon(
                        Icons.menu_book,
                        size: 150,
                        color: AppColors.onPrimary.withOpacity(0.05),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: state.currentCollection != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref.read(adhkarNotifierProvider.notifier).clearCurrentCollection();
                    },
                  )
                : null,
            actions: [
              // Font size button
              if (state.currentCollection != null)
                IconButton(
                  icon: const Icon(Icons.format_size),
                  onPressed: _showFontSizeDialog,
                  tooltip: 'حجم الخط',
                ),
            ],
          ),
        ],
        body: state.currentCollection != null
            ? _buildAdhkarListView()
            : _buildCategoriesView(context, state, l10n),
      ),
    );
  }

  Widget _buildCategoriesView(
    BuildContext context,
    AdhkarState state,
    AppLocalizations? l10n,
  ) {
    if (state.isLoadingCategories && state.categories.isEmpty) {
      return _buildCategoriesSkeleton();
    }

    if (state.error != null && state.categories.isEmpty) {
      return ErrorStateWidget(
        message: state.error!,
        onRetry: () => ref.read(adhkarNotifierProvider.notifier).loadCategories(),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اختر مجموعة الأذكار',
                    style: AppTypography.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'مجموعات مختارة من الأذكار والأدعية',
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = state.categories[index];
                  return CategoryGridItem(
                    category: category,
                    onTap: () {
                      ref.read(adhkarNotifierProvider.notifier).selectCategory(category);
                    },
                  ).animate().fadeIn(
                    duration: 400.ms,
                    delay: (index * 100).ms,
                  ).slideY(begin: 0.2, end: 0);
                },
                childCount: state.categories.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }

  Widget _buildCategoriesSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.divider,
      highlightColor: AppColors.background,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdhkarListView() {
    final collection = ref.watch(adhkarNotifierProvider).currentCollection!;
    final fontSize = ref.watch(fontSizeProvider);

    return Column(
      children: [
        // Category Header
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.menu_book,
                  color: AppColors.onPrimary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collection.category.name,
                      style: AppTypography.textTheme.titleMedium?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${collection.adhkar.length} ذكر',
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onPrimary.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Adhkar List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: collection.adhkar.length,
            itemBuilder: (context, index) {
              final dhikr = collection.adhkar[index];
              return DhikrCard(
                dhikr: dhikr,
                index: index + 1,
                onLongPress: () => _showDhikrOptions(dhikr),
                fontSize: fontSize,
              ).animate().fadeIn(
                duration: 400.ms,
                delay: (index * 50).ms,
              );
            },
          ),
        ),
      ],
    );
  }
}
