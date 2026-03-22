import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/prayer_times.dart';
import '../providers/location_provider.dart';

class PrayerTimesPage extends ConsumerWidget {
  const PrayerTimesPage({super.key});

  String _formatTime(DateTime time) {
    return DateFormat('hh:mm a', 'ar').format(time);
  }

  String _getPrayerName(String key) {
    final names = {
      'fajr': 'الفجر',
      'sunrise': 'الشروق',
      'dhuhr': 'الظهر',
      'asr': 'العصر',
      'maghrib': 'المغرب',
      'isha': 'العشاء',
    };
    return names[key] ?? key;
  }

  IconData _getPrayerIcon(String key) {
    final icons = {
      'fajr': Icons.wb_twilight,
      'sunrise': Icons.wb_sunny_outlined,
      'dhuhr': Icons.sunny,
      'asr': Icons.wb_sunny,
      'maghrib': Icons.brightness_3_outlined,
      'isha': Icons.nightlight_round,
    };
    return icons[key] ?? Icons.access_time;
  }

  Color _getPrayerColor(String key) {
    final colors = {
      'fajr': const Color(0xFF6B7FD7),
      'sunrise': const Color(0xFFFFB74D),
      'dhuhr': const Color(0xFFFFB74D),
      'asr': const Color(0xFF81C784),
      'maghrib': const Color(0xFF9575CD),
      'isha': const Color(0xFF7986CB),
    };
    return colors[key] ?? AppColors.primary;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerTimesAsync = ref.watch(currentPrayerTimesProvider);
    final savedLocationAsync = ref.watch(savedLocationProvider);
    final nextPrayer = ref.watch(nextPrayerProvider);
    final currentPrayer = ref.watch(currentPrayerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 180,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              'مواقيت الصلاة',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () => _showCalculationMethodDialog(context, ref),
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () => _sharePrayerTimes(context, prayerTimesAsync),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Date
                      Text(
                        DateFormat('EEEE، d MMMM yyyy', 'ar').format(DateTime.now()),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Location
                      savedLocationAsync.when(
                        data: (location) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              location?.displayName ?? 'لم يتم تحديد الموقع',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        loading: () => const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                        error: (_, __) => const Text(
                          'خطأ في تحديد الموقع',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: prayerTimesAsync.when(
              data: (prayerTimes) {
                if (prayerTimes == null) {
                  return _buildNoLocationWidget(context, ref);
                }
                return _buildPrayerTimesList(
                  context,
                  ref,
                  prayerTimes,
                  nextPrayer,
                  currentPrayer,
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => _buildErrorWidget(context, ref, error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoLocationWidget(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off_outlined,
              size: 80,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 20),
            Text(
              'لم يتم تحديد موقعك بعد',
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'قم بتحديد موقعك لعرض أوقات الصلاة الصحيحة',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/select-location'),
              icon: const Icon(Icons.location_on),
              label: const Text('تحديد الموقع'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ',
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(currentPrayerTimesProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimesList(
    BuildContext context,
    WidgetRef ref,
    PrayerTimes prayerTimes,
    Map<String, dynamic>? nextPrayer,
    String? currentPrayer,
  ) {
    final prayers = [
      {'key': 'fajr', 'time': prayerTimes.fajr},
      {'key': 'sunrise', 'time': prayerTimes.sunrise},
      {'key': 'dhuhr', 'time': prayerTimes.dhuhr},
      {'key': 'asr', 'time': prayerTimes.asr},
      {'key': 'maghrib', 'time': prayerTimes.maghrib},
      {'key': 'isha', 'time': prayerTimes.isha},
    ];

    return Column(
      children: [
        // Next Prayer Card
        if (nextPrayer != null)
          _buildNextPrayerCard(nextPrayer),

        const SizedBox(height: 16),

        // Prayer Times List
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'أوقات الصلاة',
                style: AppTypography.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...prayers.map((prayer) {
                final isCurrent = currentPrayer == _getPrayerName(prayer['key'] as String);
                final isNext = nextPrayer?['key'] == prayer['key'];

                return _buildPrayerCard(
                  context,
                  prayer['key'] as String,
                  prayer['time'] as DateTime,
                  isCurrent: isCurrent,
                  isNext: isNext,
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Qibla Direction Card
        _buildQiblaCard(context, ref, prayerTimes.qiblaDirection),

        // Sunnah Times
        if (prayerTimes.middleOfTheNight != null ||
            prayerTimes.lastThirdOfTheNight != null)
          _buildSunnahTimesCard(prayerTimes),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildNextPrayerCard(Map<String, dynamic> nextPrayer) {
    final hours = nextPrayer['hours'] as int;
    final minutes = nextPrayer['minutes'] as int;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white.withOpacity(0.9),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'الصلاة القادمة',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            nextPrayer['name'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatTime(nextPrayer['time'] as DateTime),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'متبقي $hours ساعة و $minutes دقيقة',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerCard(
    BuildContext context,
    String key,
    DateTime time, {
    bool isCurrent = false,
    bool isNext = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? AppColors.primary
              : isNext
                ? AppColors.primary.withOpacity(0.5)
                : AppColors.divider,
          width: isCurrent ? 2 : 1,
        ),
        boxShadow: [
          if (isCurrent || isNext)
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getPrayerColor(key).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getPrayerIcon(key),
            color: _getPrayerColor(key),
            size: 24,
          ),
        ),
        title: Text(
          _getPrayerName(key),
          style: AppTypography.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
        subtitle: isCurrent
            ? Text(
                'الصلاة الحالية',
                style: AppTypography.textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isNext)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'التالية',
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Text(
              _formatTime(time),
              style: AppTypography.prayerTime.copyWith(
                color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQiblaCard(BuildContext context, WidgetRef ref, double direction) {
    final qiblaAsync = ref.watch(qiblaDirectionProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'اتجاه القبلة',
                style: AppTypography.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.explore,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    '${direction.toStringAsFixed(1)}°',
                    style: AppTypography.textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'درجة من الشمال',
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.divider,
              ),
              qiblaAsync.when(
                data: (qiblaDirection) {
                  if (qiblaDirection == null) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: () => _showQiblaCompass(context, qiblaDirection),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.compass_calibration,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'البوصلة',
                            style: AppTypography.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSunnahTimesCard(PrayerTimes prayerTimes) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'أوقات السنة',
                style: AppTypography.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.nightlight_round,
                  color: AppColors.secondary,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (prayerTimes.middleOfTheNight != null)
            _buildSunnahTimeRow(
              'منتصف الليل',
              prayerTimes.middleOfTheNight!,
              Icons.schedule,
            ),
          if (prayerTimes.lastThirdOfTheNight != null) ...[
            const SizedBox(height: 12),
            _buildSunnahTimeRow(
              'الثلث الأخير من الليل',
              prayerTimes.lastThirdOfTheNight!,
              Icons.brightness_2,
              isHighlight: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSunnahTimeRow(
    String label,
    DateTime time,
    IconData icon, {
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlight
            ? AppColors.primary.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isHighlight
            ? Border.all(color: AppColors.primary.withOpacity(0.2))
            : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isHighlight ? AppColors.primary : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Text(
            _formatTime(time),
            style: AppTypography.textTheme.titleMedium?.copyWith(
              color: isHighlight ? AppColors.primary : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showCalculationMethodDialog(BuildContext context, WidgetRef ref) {
    final methods = ref.read(calculationMethodsProvider);
    final selectedMethod = ref.read(selectedCalculationMethodProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'طريقة الحساب',
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: methods.length,
                  itemBuilder: (context, index) {
                    final method = methods[index];
                    final isSelected = method.id == selectedMethod;

                    return ListTile(
                      onTap: () {
                        ref
                            .read(selectedCalculationMethodProvider.notifier)
                            .select(method.id);
                        ref
                            .read(currentPrayerTimesProvider.notifier)
                            .calculateWithMethod(method.id);
                        Navigator.pop(context);
                      },
                      title: Text(
                        method.name,
                        style: AppTypography.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      subtitle: method.description != null
                          ? Text(
                              method.description!,
                              style: AppTypography.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.right,
                            )
                          : null,
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQiblaCompass(BuildContext context, double qiblaDirection) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'اتجاه القبلة',
                style: AppTypography.textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Compass dial
                    ...List.generate(4, (index) {
                      final angle = index * 90.0;
                      final isNorth = index == 0;
                      return Transform.rotate(
                        angle: angle * 3.14159 / 180,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              isNorth ? 'N' : ['E', 'S', 'W'][index - 1],
                              style: TextStyle(
                                color: isNorth
                                    ? AppColors.error
                                    : AppColors.textSecondary,
                                fontWeight: isNorth
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    // Qibla indicator
                    Transform.rotate(
                      angle: qiblaDirection * 3.14159 / 180,
                      child: Container(
                        width: 4,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.3),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Center point
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '${qiblaDirection.toStringAsFixed(1)}°',
                style: AppTypography.textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'من الشمال clockwise',
                style: AppTypography.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sharePrayerTimes(
    BuildContext context,
    AsyncValue<PrayerTimes?> prayerTimesAsync,
  ) {
    prayerTimesAsync.when(
      data: (prayerTimes) {
        if (prayerTimes == null) return;

        // Implement share functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم نسخ مواقيت الصلاة'),
          ),
        );
      },
      loading: () {},
      error: (_, __) {},
    );
  }
}
