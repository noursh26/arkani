import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/user_location.dart';
import '../providers/location_provider.dart';

class SelectLocationPage extends ConsumerStatefulWidget {
  const SelectLocationPage({super.key});

  @override
  ConsumerState<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends ConsumerState<SelectLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      setState(() => _isSearching = true);
      ref.read(searchLocationsProvider.notifier).search(query);
    }
  }

  void _selectLocation(UserLocation location) async {
    await ref.read(savedLocationProvider.notifier).saveLocation(location);
    await ref.read(currentPrayerTimesProvider.notifier).calculateForLocation(location);

    if (mounted) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تحديد الموقع: ${location.displayName}'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _detectCurrentLocation() async {
    final permissionNotifier = ref.read(locationPermissionProvider.notifier);
    final isGranted = await permissionNotifier.request();

    if (!isGranted) {
      if (mounted) {
        _showPermissionDialog();
      }
      return;
    }

    ref.read(savedLocationProvider.notifier).detectLocation();

    if (mounted) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('جاري تحديد موقعك الحالي...'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إذن الموقع مطلوب'),
        content: const Text('لتحديد موقعك الحالي، نحتاج إلى إذن الوصول إلى موقعك. يمكنك منح هذا الإذن من إعدادات التطبيق.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openAppSettings();
            },
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchLocationsProvider);
    final permissionAsync = ref.watch(locationPermissionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'اختيار الموقع',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search TextField
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() => _isSearching = false);
                      ref.read(searchLocationsProvider.notifier).clear();
                    }
                  },
                  onSubmitted: _performSearch,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن مدينة أو منطقة...',
                    hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search, color: AppColors.primary),
                      onPressed: () => _performSearch(_searchController.text),
                    ),
                    suffixIcon: _isSearching
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _isSearching = false);
                              ref.read(searchLocationsProvider.notifier).clear();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Current Location Button
                permissionAsync.when(
                  data: (isGranted) => _buildCurrentLocationButton(isGranted),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => _buildCurrentLocationButton(false),
                ),
              ],
            ),
          ),

          // Results Section
          Expanded(
            child: _isSearching
                ? _buildSearchResults(searchResults)
                : _buildInitialContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentLocationButton(bool isPermissionGranted) {
    return GestureDetector(
      onTap: _detectCurrentLocation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha:0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.my_location,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'استخدام موقعي الحالي',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'اقتراحات',
            style: AppTypography.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildCitySuggestion('مكة المكرمة', 'المملكة العربية السعودية'),
          _buildCitySuggestion('المدينة المنورة', 'المملكة العربية السعودية'),
          _buildCitySuggestion('القاهرة', 'جمهورية مصر العربية'),
          _buildCitySuggestion('الرياض', 'المملكة العربية السعودية'),
          _buildCitySuggestion('دبي', 'الإمارات العربية المتحدة'),
          _buildCitySuggestion('الدوحة', 'دولة قطر'),
          _buildCitySuggestion('عمان', 'المملكة الأردنية الهاشمية'),
          _buildCitySuggestion('القدس', 'فلسطين'),
        ],
      ),
    );
  }

  Widget _buildCitySuggestion(String city, String country) {
    return GestureDetector(
      onTap: () {
        _searchController.text = city;
        _performSearch(city);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.divider,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: AppColors.primary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    city,
                    style: AppTypography.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    country,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(AsyncValue<List<UserLocation>> searchResults) {
    return searchResults.when(
      data: (locations) {
        if (locations.isEmpty) {
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
                  'لم يتم العثور على نتائج',
                  style: AppTypography.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: locations.length,
          itemBuilder: (context, index) {
            final location = locations[index];
            return _buildLocationResultCard(location);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
      error: (error, _) => Center(
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
              'حدث خطأ في البحث',
              style: AppTypography.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationResultCard(UserLocation location) {
    return GestureDetector(
      onTap: () => _selectLocation(location),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    location.displayName,
                    style: AppTypography.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  if (location.address != null &&
                      location.address != location.displayName) ...[
                    const SizedBox(height: 4),
                    Text(
                      location.address!,
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'اختيار',
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
