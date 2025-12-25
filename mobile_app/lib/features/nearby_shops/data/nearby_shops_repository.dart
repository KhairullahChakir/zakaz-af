import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/nearby_shop.dart';

part 'nearby_shops_repository.g.dart';

@riverpod
NearbyShopsRepository nearbyShopsRepository(Ref ref) {
  return NearbyShopsRepository(ref.watch(dioProvider));
}

class NearbyShopsRepository {
  final Dio _dio;

  NearbyShopsRepository(this._dio);

  /// Get shops near a location
  Future<NearbyShopsResponse> getNearbyShops({
    required double latitude,
    required double longitude,
    double radius = 10.0, // Default 10km
  }) async {
    try {
      final response = await _dio.get('/shops/nearby', queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      });
      return NearbyShopsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch nearby shops');
    }
  }

  /// Get all shops with optional filters
  Future<List<NearbyShop>> getShops({
    String? type,
    String? city,
    String? province,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (type != null) queryParams['type'] = type;
      if (city != null) queryParams['city'] = city;
      if (province != null) queryParams['province'] = province;
      if (search != null) queryParams['search'] = search;

      final response = await _dio.get('/shops', queryParameters: queryParams);
      final data = response.data['data'] as List;
      return data.map((json) => NearbyShop.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch shops');
    }
  }

  /// Get a single shop by ID
  Future<NearbyShop> getShop(int id) async {
    try {
      final response = await _dio.get('/shops/$id');
      return NearbyShop.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch shop');
    }
  }

  /// Get available shop types
  Future<List<String>> getShopTypes() async {
    try {
      final response = await _dio.get('/shops/types');
      return (response.data as List).cast<String>();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch shop types');
    }
  }
}

/// Provider for nearby shops based on user's current location
@riverpod
class NearbyShopsNotifier extends _$NearbyShopsNotifier {
  double _searchRadius = 10.0;

  @override
  Future<NearbyShopsResponse?> build() async {
    return null; // Initial state, user needs to trigger location fetch
  }

  Future<void> fetchNearbyShops(double latitude, double longitude) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(nearbyShopsRepositoryProvider);
      final response = await repository.getNearbyShops(
        latitude: latitude,
        longitude: longitude,
        radius: _searchRadius,
      );
      state = AsyncData(response);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void setSearchRadius(double radius) {
    _searchRadius = radius;
  }

  double get searchRadius => _searchRadius;
}
