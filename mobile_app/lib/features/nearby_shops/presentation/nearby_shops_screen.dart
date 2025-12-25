import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/services/location_service.dart';
import '../data/nearby_shops_repository.dart';
import '../domain/nearby_shop.dart';
import '../../../core/localization/language_provider.dart';

class NearbyShopsScreen extends ConsumerStatefulWidget {
  const NearbyShopsScreen({super.key});

  @override
  ConsumerState<NearbyShopsScreen> createState() => _NearbyShopsScreenState();
}

class _NearbyShopsScreenState extends ConsumerState<NearbyShopsScreen> {
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  String? _locationError;
  double _selectedRadius = 10.0;
  bool _isMapView = false;
  final MapController _mapController = MapController();

  final List<double> _radiusOptions = [5, 10, 25, 50];

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    final locationService = ref.read(locationServiceProvider);
    final position = await locationService.getCurrentPosition();

    if (position != null) {
      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });
      _fetchNearbyShops();
    } else {
      setState(() {
        _isLoadingLocation = false;
        _locationError = 'Unable to get your location. Please enable location services.';
      });
    }
  }

  Future<void> _fetchNearbyShops() async {
    if (_currentPosition == null) return;
    
    ref.read(nearbyShopsProvider.notifier).setSearchRadius(_selectedRadius);
    await ref.read(nearbyShopsProvider.notifier).fetchNearbyShops(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    final nearbyShopsAsync = ref.watch(nearbyShopsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('nearby_shops')),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.list : Icons.map_outlined),
            onPressed: () => setState(() => _isMapView = !_isMapView),
            tooltip: _isMapView ? ref.tr('switch_to_list') : ref.tr('switch_to_map'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _fetchLocation();
              if (_isMapView && _currentPosition != null) {
                _mapController.move(
                  LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                  13.0,
                );
              }
            },
            tooltip: 'Refresh location',
          ),
        ],
      ),
      body: Column(
        children: [
          // Radius selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.radar,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  ref.tr('search_radius'),
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _radiusOptions.map((radius) {
                        final isSelected = _selectedRadius == radius;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text('${radius.toInt()} km'),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedRadius = radius);
                                _fetchNearbyShops();
                              }
                            },
                            selectedColor: theme.colorScheme.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : null,
                              fontWeight: isSelected ? FontWeight.bold : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _buildContent(nearbyShopsAsync, theme, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    AsyncValue<NearbyShopsResponse?> nearbyShopsAsync,
    ThemeData theme,
    bool isDark,
  ) {
    // Loading location
    if (_isLoadingLocation) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              ref.tr('getting_location'),
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    // Location error
    if (_locationError != null) {
      return _buildLocationError(theme);
    }

    // No location
    if (_currentPosition == null) {
      return _buildLocationError(theme);
    }

    // Nearby shops data
    return nearbyShopsAsync.when(
      data: (response) {
        if (response == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (response.shops.isEmpty) {
          return _buildEmptyState(theme);
        }
        return _isMapView 
            ? _buildShopsMap(response.shops, theme, isDark)
            : _buildShopsList(response.shops, theme, isDark);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Error: ${error.toString()}'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchNearbyShops,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationError(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off,
                size: 64,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              ref.tr('location_access_required'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _locationError ?? ref.tr('enable_location_msg'),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(locationServiceProvider).openLocationSettings();
                  },
                  icon: const Icon(Icons.settings),
                  label: Text(ref.tr('open_settings')),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _fetchLocation,
                  icon: const Icon(Icons.refresh),
                  label: Text(ref.tr('retry')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.store_mall_directory_outlined,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              ref.tr('no_shops_nearby'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              ref.tr('no_shops_in_radius').replaceFirst('{radius}', _selectedRadius.toInt().toString()),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopsList(List<NearbyShop> shops, ThemeData theme, bool isDark) {
    return RefreshIndicator(
      onRefresh: _fetchLocation,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: shops.length,
        itemBuilder: (context, index) {
          final shop = shops[index];
          return _NearbyShopCard(
            shop: shop,
            isDark: isDark,
            onTap: () => context.push('/shops/${shop.id}'),
          );
        },
      ),
    );
  }

  Widget _buildShopsMap(List<NearbyShop> shops, ThemeData theme, bool isDark) {
    if (_currentPosition == null) return const SizedBox.shrink();

    final userLatLng = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: userLatLng,
        zoom: 13.0,
        maxZoom: 18.0,
        minZoom: 3.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.zakaz.af',
        ),
        MarkerLayer(
          markers: [
            // User location marker
            Marker(
              point: userLatLng,
              width: 40,
              height: 40,
              builder: (ctx) => Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.my_location,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
              ),
            ),
            // Shop markers
            ...shops.where((s) => s.latitude != null && s.longitude != null).map((shop) {
              return Marker(
                point: LatLng(shop.latitude!, shop.longitude!),
                width: 50,
                height: 50,
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: _NearbyShopCard(
                          shop: shop,
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(context);
                            context.push('/shops/${shop.id}');
                          },
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: theme.colorScheme.primary,
                        size: 40,
                      ),
                      Positioned(
                        top: 5,
                        child: shop.primaryPhotoUrl != null
                            ? Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(shop.primaryPhotoUrl!),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(color: Colors.white, width: 1),
                                ),
                              )
                            : Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.store,
                                  size: 14,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}

class _NearbyShopCard extends ConsumerWidget {
  final NearbyShop shop;
  final bool isDark;
  final VoidCallback onTap;

  const _NearbyShopCard({
    required this.shop,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isDark ? 2 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Image
            SizedBox(
              height: 160,
              width: double.infinity,
              child: shop.primaryPhotoUrl != null
                  ? CachedNetworkImage(
                      imageUrl: shop.primaryPhotoUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => _buildPlaceholder(isDark),
                    )
                  : _buildPlaceholder(isDark),
            ),

            // Shop Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Type
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          shop.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          shop.type,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Address
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${shop.address}, ${shop.city}',
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Distance and Products count
                  Row(
                    children: [
                      // Distance
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.near_me,
                              size: 14,
                              color: theme.colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              shop.distance != null 
                                ? (shop.distance! < 1 
                                    ? ref.tr('m_away').replaceFirst('{distance}', (shop.distance! * 1000).toStringAsFixed(0))
                                    : ref.tr('km_away').replaceFirst('{distance}', shop.distance!.toStringAsFixed(1)))
                                : '',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Products count
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 14,
                              color: theme.colorScheme.tertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              ref.tr('products_count').replaceFirst('{count}', shop.productsCount.toString()),
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.tertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      color: isDark ? Colors.grey[800] : Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.store,
          size: 48,
          color: isDark ? Colors.grey[600] : Colors.grey[400],
        ),
      ),
    );
  }
}
