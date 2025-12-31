import 'dart:io';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/marketplace_item.dart';

part 'marketplace_repository.g.dart';

@riverpod
MarketplaceRepository marketplaceRepository(Ref ref) {
  return MarketplaceRepository(ref.watch(dioProvider));
}

class MarketplaceRepository {
  final Dio _dio;

  MarketplaceRepository(this._dio);

  Future<List<MarketplaceItem>> getItems({
    int? categoryId,
    String? condition,
    double? minPrice,
    double? maxPrice,
    String? search,
  }) async {
    try {
      final response = await _dio.get('/marketplace', queryParameters: {
        if (categoryId != null) 'category_id': categoryId,
        if (condition != null) 'condition': condition,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (search != null) 'search': search,
      });

      final List<dynamic> data = response.data['data'];
      return data.map((json) => MarketplaceItem.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load marketplace items');
    }
  }

  Future<MarketplaceItem> getItem(int id) async {
    try {
      print('Fetching marketplace item: $id');
      final response = await _dio.get('/marketplace/$id');
      print('Got response for item $id');
      return MarketplaceItem.fromJson(response.data);
    } catch (e) {
      print('Error fetching marketplace item $id: $e');
      throw Exception('Failed to load marketplace item: $e');
    }
  }

  Future<List<MarketplaceItem>> getMyItems() async {
    try {
      final response = await _dio.get('/marketplace/my-items');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => MarketplaceItem.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load your listings');
    }
  }

  Future<MarketplaceItem> createListing({
    required String name,
    required String description,
    required double price,
    required String condition,
    required String phone,
    int? categoryId,
    String? location,
    required List<File> images,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'description': description,
        'price': price,
        'condition': condition,
        'phone': phone,
        if (categoryId != null) 'category_id': categoryId,
        if (location != null) 'location': location,
      });

      for (var file in images) {
        formData.files.add(MapEntry(
          'images[]',
          await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
        ));
      }

      final response = await _dio.post('/marketplace', data: formData);
      return MarketplaceItem.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create listing');
    }
  }

  Future<MarketplaceItem> updateListing(int id, {
    String? name,
    String? description,
    double? price,
    String? condition,
    String? phone,
    String? status,
    int? categoryId,
    String? location,
    List<File>? newImages,
    List<String>? deletedImages,
  }) async {
    try {
      final mapData = {
        // '_method': 'PUT', // REMOVED: Backend expects POST
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (price != null) 'price': price,
        if (condition != null) 'condition': condition,
        if (phone != null) 'phone': phone,
        if (status != null) 'status': status,
        if (categoryId != null) 'category_id': categoryId,
        if (location != null) 'location': location,
      };

      // Add deleted images
      if (deletedImages != null && deletedImages.isNotEmpty) {
        for (var i = 0; i < deletedImages.length; i++) {
          mapData['deleted_images[$i]'] = deletedImages[i];
        }
      }

      final formData = FormData.fromMap(mapData);

      // Add new images
      if (newImages != null && newImages.isNotEmpty) {
        for (var file in newImages) {
          formData.files.add(MapEntry(
            'images[]',
            await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
          ));
        }
      }

      final response = await _dio.post('/marketplace/$id', data: formData);
      return MarketplaceItem.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update listing');
    }
  }

  Future<void> deleteListing(int id) async {
    try {
      await _dio.delete('/marketplace/$id');
    } catch (e) {
      throw Exception('Failed to delete listing');
    }
  }
}

// Cache marketplace items for 5 minutes to avoid refetching
@Riverpod(keepAlive: true)
class MarketplaceItemsCache extends _$MarketplaceItemsCache {
  @override
  Future<List<MarketplaceItem>> build() async {
    // Auto-refresh after 5 minutes
    ref.keepAlive();
    final timer = Future.delayed(const Duration(minutes: 5), () {
      ref.invalidateSelf();
    });
    ref.onDispose(() {}); // Timer will be garbage collected
    
    return ref.watch(marketplaceRepositoryProvider).getItems();
  }
  
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
Future<List<MarketplaceItem>> marketplaceItems(Ref ref, {
    int? categoryId,
    String? condition,
    double? minPrice,
    double? maxPrice,
    String? search,
}) {
  // Use cached data if no filters applied
  if (categoryId == null && condition == null && minPrice == null && maxPrice == null && search == null) {
    return ref.watch(marketplaceItemsCacheProvider.future);
  }
  
  // Otherwise fetch with filters (no cache)
  return ref.watch(marketplaceRepositoryProvider).getItems(
    categoryId: categoryId,
    condition: condition,
    minPrice: minPrice,
    maxPrice: maxPrice,
    search: search,
  );
}

@Riverpod(keepAlive: true)
Future<List<MarketplaceItem>> myMarketplaceItems(Ref ref) {
  return ref.watch(marketplaceRepositoryProvider).getMyItems();
}

@Riverpod(keepAlive: true) 
Future<MarketplaceItem> marketplaceItemDetails(Ref ref, int id) {
  return ref.watch(marketplaceRepositoryProvider).getItem(id);
}
