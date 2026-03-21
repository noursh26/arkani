import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/prayer_times.dart';
import '../providers/home_provider.dart';
import '../providers/home_state.dart';
import '../widgets/azan_nafil_sheet.dart';
import '../widgets/hero_section.dart';
import '../widgets/home_skeleton_loading.dart';
import '../widgets/next_prayer_countdown.dart';
import '../widgets/prayer_times_strip.dart';
import '../widgets/today_notification_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Timer? _countdownTimer;
  Duration _timeRemaining = Duration.zero;
  String _nextPrayerName = '';
  String _nextPrayerTime = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    await ref.read(homeNotifierProvider.notifier).refreshAll();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final state = ref.read(homeNotifierProvider);
    if (state.prayerTimes == null) return;

    final nextPrayer = _getNextPrayer(state.prayerTimes!);
    if (nextPrayer == null) return;

    final now = DateTime.now();
    final format = DateFormat('HH:mm');
    final prayerTime = format.parse(nextPrayer.time);
    
    var targetDateTime = DateTime(
      now.year, now.month, now.day,
      prayerTime.hour, prayerTime.minute,
    );

    if (targetDateTime.isBefore(now)) {
      targetDateTime = targetDateTime.add(const Duration(days: 1));
    }

    final remaining = targetDateTime.difference(now);

    setState(() {
      _timeRemaining = remaining;
      _nextPrayerName = nextPrayer.name;
      _nextPrayerTime = nextPrayer.time;
    });
  }

  _PrayerInfo? _getNextPrayer(PrayerTimes prayerTimes) {
    final now = DateTime.now();
    final format = DateFormat('HH:mm');

    final prayers = [
      _PrayerInfo('الفجر', prayerTimes.fajr),
      _PrayerInfo('الشروق', prayerTimes.sunrise),
      _PrayerInfo('الظهر', prayerTimes.dhuhr),
      _PrayerInfo('العصر', prayerTimes.asr),
      _PrayerInfo('المغرب', prayerTimes.maghrib),
      _PrayerInfo('العشاء', prayerTimes.isha),
    ];

    for (final prayer in prayers) {
      final prayerTime = format.parse(prayer.time);
      final prayerDateTime = DateTime(
        now.year, now.month, now.day,
        prayerTime.hour, prayerTime.minute,
      );

      if (prayerDateTime.isAfter(now)) {
        return prayer;
      }
    }
    return prayers.first;
  }

  String _getCurrentPrayerForMessage() {
    final hour = DateTime.now().hour;
    if (hour < 5) return 'fajr';
    if (hour < 12) return 'dhuhr';
    if (hour < 15) return 'asr';
    if (hour < 18) return 'maghrib';
    return 'isha';
  }

  void _showAzanNafilSheet() {
    // Haptic feedback on button tap
    HapticFeedback.mediumImpact();
    
    final currentPrayer = _getCurrentPrayerForMessage();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AzanNafilSheet(prayer: currentPrayer),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(homeNotifierProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: HeroSection(prayerTimes: state.prayerTimes),
            ),
            title: innerBoxIsScrolled
                ? Text(l10n.appName)
                : null,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  // Navigate to settings
                },
              ),
            ],
          ),
        ],
        body: RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: state.isLoading && state.prayerTimes == null
              ? const HomeSkeletonLoading()
              : state.error != null && state.prayerTimes == null
                  ? ErrorStateWidget(
                      message: state.error!,
                      onRetry: _loadData,
                    )
                  : _buildContent(context, state, l10n),
        ),
      ),
      floatingActionButton: _buildAzanNafilButton(),
    );
  }

  Widget _buildContent(BuildContext context, HomeState state, AppLocalizations? l10n) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Next Prayer Countdown
                if (_nextPrayerName.isNotEmpty)
                  NextPrayerCountdown(
                    prayerName: _nextPrayerName,
                    prayerTime: _nextPrayerTime,
                    timeRemaining: _timeRemaining,
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0),
                
                const SizedBox(height: 20),
                
                // Prayer Times Strip
                if (state.prayerTimes != null)
                  PrayerTimesStrip(prayerTimes: state.prayerTimes!)
                      .animate().fadeIn(duration: 500.ms, delay: 200.ms),
                
                const SizedBox(height: 24),
                
                // Today's Notification
                if (state.todayNotification != null)
                  TodayNotificationCard(notification: state.todayNotification!)
                      .animate().fadeIn(duration: 500.ms, delay: 400.ms),
                
                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAzanNafilButton() {
    return Animate(
      effects: [
        FadeEffect(delay: 800.ms, duration: 500.ms),
        ScaleEffect(delay: 800.ms, duration: 500.ms, begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
      ],
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: _showAzanNafilSheet,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'أذان',
                    style: AppTypography.textTheme.titleMedium?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'ونفل',
                    style: AppTypography.textTheme.titleMedium?.copyWith(
                      color: AppColors.onPrimary.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .scale(
          duration: 1500.ms,
          begin: const Offset(1, 1),
          end: const Offset(1.05, 1.05),
        )
        .then()
        .scale(
          duration: 1500.ms,
          begin: const Offset(1.05, 1.05),
          end: const Offset(1, 1),
        ),
      ),
    );
  }
}

class _PrayerInfo {
  final String name;
  final String time;
  _PrayerInfo(this.name, this.time);
}
