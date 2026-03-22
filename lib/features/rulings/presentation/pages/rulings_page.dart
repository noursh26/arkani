import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/islamic_ruling.dart';
import '../providers/rulings_provider.dart';
import '../widgets/ruling_card.dart';
import '../widgets/ruling_detail_sheet.dart';
import '../widgets/topic_filter_chip.dart';

class RulingsPage extends ConsumerStatefulWidget {
  const RulingsPage({super.key});

  @override
  ConsumerState<RulingsPage> createState() => _RulingsPageState();
}

class _RulingsPageState extends ConsumerState<RulingsPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rulingsNotifierProvider.notifier).loadTopics();
      ref.read(rulingsNotifierProvider.notifier).loadRulings();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(rulingsNotifierProvider);
      if (!state.isLoadingMore && state.hasMore) {
        ref.read(rulingsNotifierProvider.notifier).loadRulings();
      }
    }
  }

  void _showRulingDetail(IslamicRuling ruling) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RulingDetailSheet(ruling: ruling),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(rulingsNotifierProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.rulingsTitle,
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
                      left: -30,
                      bottom: -20,
                      child: Icon(
                        Icons.gavel,
                        size: 120,
                        color: AppColors.onPrimary.withValues(alpha:0.05),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: Column(
          children: [
            // Search Bar
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  ref.read(rulingsNotifierProvider.notifier).search(value);
                },
                decoration: InputDecoration(
                  hintText: l10n.searchRulings,
                  hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  suffixIcon: state.searchQuery != null
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(rulingsNotifierProvider.notifier).clearSearch();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.scaffoldBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
            ),

            // Topics Filter
            if (state.topics.isNotEmpty)
              Container(
                height: 60,
                color: AppColors.surface,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.topics.length + 1,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return TopicFilterChip(
                        label: 'الكل',
                        icon: Icons.apps,
                        isSelected: state.selectedTopicId == null,
                        onTap: () {
                          ref.read(rulingsNotifierProvider.notifier).clearTopicFilter();
                        },
                      );
                    }
                    final topic = state.topics[index - 1];
                    return TopicFilterChip(
                      label: topic.name,
                      icon: _getTopicIcon(topic.name),
                      isSelected: state.selectedTopicId == topic.id,
                      onTap: () {
                        ref.read(rulingsNotifierProvider.notifier).selectTopic(topic);
                      },
                    );
                  },
                ),
              ),

            // Rulings List
            Expanded(
              child: state.isLoadingRulings && state.rulings.isEmpty
                  ? _buildSkeleton()
                  : state.error != null && state.rulings.isEmpty
                      ? ErrorStateWidget(
                          message: state.error!,
                          onRetry: () => ref.read(rulingsNotifierProvider.notifier).loadRulings(refresh: true),
                        )
                      : RefreshIndicator(
                          onRefresh: () => ref.read(rulingsNotifierProvider.notifier).loadRulings(refresh: true),
                          color: AppColors.primary,
                          backgroundColor: AppColors.surface,
                          child: state.rulings.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.all(16),
                                  itemCount: state.rulings.length + (state.isLoadingMore ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == state.rulings.length) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    final ruling = state.rulings[index];
                                    return RulingCard(
                                      ruling: ruling,
                                      onTap: () => _showRulingDetail(ruling),
                                    ).animate().fadeIn(
                                      duration: 400.ms,
                                      delay: (index.clamp(0, 10) * 50).ms,
                                    ).slideY(begin: 0.2, end: 0);
                                  },
                                ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTopicIcon(String name) {
    if (name.contains('صلاة')) return Icons.access_time;
    if (name.contains('صوم')) return Icons.nights_stay;
    if (name.contains('زكاة')) return Icons.favorite;
    if (name.contains('حج')) return Icons.mosque;
    if (name.contains('معاملات')) return Icons.handshake;
    if (name.contains('أسرة')) return Icons.family_restroom;
    return Icons.menu_book;
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.divider,
      highlightColor: AppColors.background,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            height: 120,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج',
            style: AppTypography.textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
