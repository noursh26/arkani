import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/settings_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/prayer_times.dart';
import '../providers/home_provider.dart';
import '../providers/home_state.dart';
import '../widgets/azan_nafil_sheet.dart';
import '../widgets/home_skeleton_loading.dart';
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
    HapticFeedback.mediumImpact();
    final currentPrayer = _getCurrentPrayerForMessage();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AzanNafilSheet(prayer: currentPrayer),
    );
  }

  void _showTimezoneDialog() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'اختر المنطقة الزمنية',
          style: AppTypography.textTheme.titleLarge,
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Consumer(
            builder: (context, ref, child) {
              final currentTimezone = ref.watch(timezoneProvider);
              return ListView.builder(
                shrinkWrap: true,
                itemCount: availableTimezones.length,
                itemBuilder: (context, index) {
                  final entry = availableTimezones.entries.elementAt(index);
                  final isSelected = entry.key == currentTimezone;
                  return ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isSelected ? Icons.check : Icons.public,
                        color: isSelected ? AppColors.primary : Colors.grey,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      entry.value,
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: isSelected ? AppColors.primary : null,
                        fontWeight: isSelected ? FontWeight.w600 : null,
                      ),
                    ),
                    trailing: Text(
                      entry.key.split('/').last.replaceAll('_', ' '),
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    selected: isSelected,
                    onTap: () {
                      ref.read(timezoneProvider.notifier).setTimezone(entry.key);
                      Navigator.pop(context);
                      // Refresh prayer times with new timezone
                      ref.read(homeNotifierProvider.notifier).refreshAll();
                    },
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(homeNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
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
                : _buildBody(context, state, l10n),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state, AppLocalizations? l10n) {
    final hijri = HijriCalendar.now();
    final now = DateTime.now();
    final gregorian = DateFormat('EEEE، d MMMM', 'ar').format(now);

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Compact header with next prayer
        SliverToBoxAdapter(
          child: _buildHeader(state, hijri, gregorian),
        ),

        // Prayer times grid
        if (state.prayerTimes != null)
          SliverToBoxAdapter(
            child: _buildPrayerTimesGrid(state.prayerTimes!)
                .animate().fadeIn(duration: 400.ms, delay: 100.ms),
          ),

        // Quick actions
        SliverToBoxAdapter(
          child: _buildQuickActions()
              .animate().fadeIn(duration: 400.ms, delay: 200.ms),
        ),

        // Today's notification
        if (state.todayNotification != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: TodayNotificationCard(notification: state.todayNotification!)
                  .animate().fadeIn(duration: 400.ms, delay: 300.ms),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }

  Widget _buildHeader(HomeState state, HijriCalendar hijri, String gregorian) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 14,
        right: 14,
        bottom: 14,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D5E4A),
            Color(0xFF0A4D3C),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: greeting + date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أركـانـي',
                    style: AppTypography.arabicTitle.copyWith(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    gregorian,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  hijri.toFormat('dd MMMM yyyy'),
                  style: AppTypography.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Next prayer card
          if (_nextPrayerName.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                children: [
                  // Prayer icon
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.access_time_filled,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Prayer info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الصلاة القادمة',
                          style: AppTypography.textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          '$_nextPrayerName  $_nextPrayerTime',
                          style: AppTypography.arabicSubtitle.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Countdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.secondary, Color(0xFFB8962E)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _formatDuration(_timeRemaining),
                      style: AppTypography.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Location info and timezone selector
          if (state.prayerTimes?.city != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 12,
                ),
                const SizedBox(width: 3),
                Text(
                  '${state.prayerTimes!.city}${state.prayerTimes?.country != null ? '، ${state.prayerTimes!.country}' : ''}',
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 8),
                // Timezone selector
                GestureDetector(
                  onTap: _showTimezoneDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.white.withValues(alpha: 0.6),
                          size: 10,
                        ),
                        const SizedBox(width: 3),
                        Consumer(
                          builder: (context, ref, child) {
                            final tz = ref.watch(timezoneProvider);
                            final offset = availableTimezones[tz] ?? 'GMT+3';
                            return Text(
                              offset.split('(').last.replaceAll(')', ''),
                              style: AppTypography.textTheme.labelSmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 9,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.isOffline) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'غير متصل',
                      style: AppTypography.textTheme.labelSmall?.copyWith(
                        color: AppColors.warning,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrayerTimesGrid(PrayerTimes pt) {
    final now = DateTime.now();
    final format = DateFormat('HH:mm');

    final prayers = [
      _PrayerDisplay('الفجر', pt.fajr, Icons.wb_twilight, AppColors.fajrColor),
      _PrayerDisplay('الظهر', pt.dhuhr, Icons.sunny, AppColors.dhuhrColor),
      _PrayerDisplay('العصر', pt.asr, Icons.wb_sunny, AppColors.asrColor),
      _PrayerDisplay('المغرب', pt.maghrib, Icons.wb_twilight, AppColors.maghribColor),
      _PrayerDisplay('العشاء', pt.isha, Icons.nights_stay_outlined, AppColors.ishaColor),
    ];

    // Find active prayer
    int activeIdx = 0;
    for (int i = 0; i < prayers.length; i++) {
      final t = format.parse(prayers[i].time);
      final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
      if (dt.isAfter(now)) {
        activeIdx = i;
        break;
      }
      if (i == prayers.length - 1) activeIdx = 0;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Row(
        children: List.generate(prayers.length, (i) {
          final p = prayers[i];
          final isActive = i == activeIdx;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(left: i > 0 ? 6 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(
                        colors: [p.color, p.color.withValues(alpha: 0.8)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                color: isActive ? null : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: isActive ? null : Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
                boxShadow: isActive
                    ? [BoxShadow(color: p.color.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))]
                    : null,
              ),
              child: Column(
                children: [
                  Icon(p.icon, color: isActive ? Colors.white : p.color, size: 16),
                  const SizedBox(height: 4),
                  Text(
                    p.name,
                    style: AppTypography.textTheme.labelSmall?.copyWith(
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    p.time,
                    style: AppTypography.textTheme.labelLarge?.copyWith(
                      color: isActive ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionCard(
              icon: Icons.notifications_active_outlined,
              label: 'أذان ونفل',
              color: AppColors.primary,
              onTap: _showAzanNafilSheet,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuickActionCard(
              icon: Icons.menu_book_outlined,
              label: 'الأذكار',
              color: AppColors.secondary,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuickActionCard(
              icon: Icons.gavel_outlined,
              label: 'الفتاوى',
              color: AppColors.info,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
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

class _PrayerDisplay {
  final String name;
  final String time;
  final IconData icon;
  final Color color;
  _PrayerDisplay(this.name, this.time, this.icon, this.color);
}
