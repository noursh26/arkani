import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/mosque.dart';
import '../providers/mosques_provider.dart';
import '../widgets/location_permission_widget.dart';
import '../widgets/mosque_list_item.dart';

class MosquesPage extends ConsumerStatefulWidget {
  const MosquesPage({super.key});

  @override
  ConsumerState<MosquesPage> createState() => _MosquesPageState();
}

class _MosquesPageState extends ConsumerState<MosquesPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _showMap = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mosquesNotifierProvider.notifier).loadNearbyMosques();
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _updateMarkers(List<Mosque> mosques) {
    final markers = mosques.map((mosque) {
      return Marker(
        markerId: MarkerId(mosque.placeId),
        position: LatLng(mosque.latitude, mosque.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: mosque.name,
          snippet: mosque.address,
          onTap: () => _showMosqueDetail(mosque),
        ),
      );
    }).toSet();

    setState(() {
      _markers = markers;
    });
  }

  void _showMosqueDetail(Mosque mosque) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MosqueDetailSheet(mosque: mosque),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(mosquesNotifierProvider);

    if (state.mosques.isNotEmpty && _markers.isEmpty) {
      _updateMarkers(state.mosques);
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.mosquesTitle,
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
                        Icons.mosque,
                        size: 120,
                        color: AppColors.onPrimary.withValues(alpha:0.05),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_showMap ? Icons.list : Icons.map),
                onPressed: () {
                  setState(() {
                    _showMap = !_showMap;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  ref.read(mosquesNotifierProvider.notifier).loadNearbyMosques();
                },
              ),
            ],
          ),
        ],
        body: state.isLoading && state.mosques.isEmpty
            ? _buildSkeleton()
            : state.error != null && state.mosques.isEmpty
                ? ErrorStateWidget(
                    message: state.error!,
                    onRetry: () => ref.read(mosquesNotifierProvider.notifier).loadNearbyMosques(),
                  )
                : Column(
                    children: [
                      // Location warning if using default
                      if (state.isUsingDefaultLocation)
                        const LocationPermissionWidget(),

                      // Map View
                      if (_showMap && state.currentLocation != null)
                        Expanded(
                          flex: 2,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(24),
                            ),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  state.currentLocation!.latitude,
                                  state.currentLocation!.longitude,
                                ),
                                zoom: 14,
                              ),
                              markers: _markers,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              mapToolbarEnabled: false,
                              zoomControlsEnabled: false,
                              onMapCreated: (controller) {
                                _mapController = controller;
                                _updateMarkers(state.mosques);
                              },
                            ),
                          ),
                        ),

                      // List View
                      Expanded(
                        flex: _showMap ? 3 : 1,
                        child: RefreshIndicator(
                          onRefresh: () => ref.read(mosquesNotifierProvider.notifier).loadNearbyMosques(),
                          color: AppColors.primary,
                          backgroundColor: AppColors.surface,
                          child: state.mosques.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: state.mosques.length,
                                  itemBuilder: (context, index) {
                                    final mosque = state.mosques[index];
                                    return MosqueListItem(
                                      mosque: mosque,
                                      isSelected: state.selectedMosque?.placeId == mosque.placeId,
                                      onTap: () {
                                        ref.read(mosquesNotifierProvider.notifier).selectMosque(mosque);
                                        _showMosqueDetail(mosque);
                                      },
                                    ).animate().fadeIn(
                                      duration: 400.ms,
                                      delay: (index * 50).ms,
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

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.divider,
      highlightColor: AppColors.background,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
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
            Icons.mosque_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد مساجد قريبة',
            style: AppTypography.textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'حاول البحث في نطاق أوسع',
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MosqueDetailSheet extends StatelessWidget {
  final Mosque mosque;

  const _MosqueDetailSheet({required this.mosque});

  Future<void> _openDirections(BuildContext context) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${mosque.latitude},${mosque.longitude}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatDistance(int meters) {
    if (meters >= 1000) {
      final km = meters / 1000;
      return '${km.toStringAsFixed(1)} كم';
    }
    return '$meters م';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),

            // Mosque header row
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.mosque, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mosque.name,
                        style: AppTypography.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _formatDistance(mosque.distanceMeters),
                              style: AppTypography.textTheme.labelSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          if (mosque.rating != null) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.star, color: AppColors.secondary, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              mosque.rating!.toStringAsFixed(1),
                              style: AppTypography.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Address
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: AppColors.textTertiary, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    mosque.address,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Directions Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => _openDirections(context),
                icon: const Icon(Icons.directions, size: 18),
                label: Text(
                  'الاتجاهات',
                  style: AppTypography.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),
            ),

            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
