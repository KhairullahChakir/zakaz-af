import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../../products/domain/product.dart';

part 'wishlist_repository.g.dart';

@riverpod
WishlistRepository wishlistRepository(Ref ref) {
  return WishlistRepository(ref.watch(dioProvider));
}

class WishlistRepository {
  final Dio _dio;

  WishlistRepository(this._dio);

  Future<List<Product>> getWishlist() async {
    try {
      final response = await _dio.get('/wishlist');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch wishlist');
    }
  }

  Future<void> addToWishlist(int productId) async {
    try {
      await _dio.post('/wishlist', data: {'product_id': productId});
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to add to wishlist');
    }
  }

  Future<void> removeFromWishlist(int productId) async {
    try {
      await _dio.delete('/wishlist/$productId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to remove from wishlist');
    }
  }

  Future<bool> isInWishlist(int productId) async {
    try {
      final response = await _dio.get('/wishlist/check/$productId');
      return response.data['in_wishlist'] == true;
    } on DioException {
      return false;
    }
  }
}
