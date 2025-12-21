import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../../shop/domain/shop.dart';

part 'admin_shop_repository.g.dart';

@riverpod
AdminShopRepository adminShopRepository(Ref ref) {
  return AdminShopRepository(ref.watch(dioProvider));
}

class AdminShopRepository {
  final Dio _dio;

  AdminShopRepository(this._dio);

  Future<List<Shop>> getAllShops({String? status}) async {
    try {
      final response = await _dio.get('/admin/shops', queryParameters: {
        if (status != null) 'status': status,
      });
      final List<dynamic> data = response.data;
      return data.map((json) => Shop.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch shops');
    }
  }

  Future<List<Shop>> getPendingShops() async {
    try {
      final response = await _dio.get('/admin/shops/pending');
      final List<dynamic> data = response.data;
      return data.map((json) => Shop.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch pending shops');
    }
  }

  Future<Shop> approveShop(int shopId) async {
    try {
      final response = await _dio.post('/admin/shops/$shopId/approve');
      return Shop.fromJson(response.data['shop']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to approve shop');
    }
  }

  Future<Shop> rejectShop(int shopId, String reason) async {
    try {
      final response = await _dio.post('/admin/shops/$shopId/reject', data: {
        'reason': reason,
      });
      return Shop.fromJson(response.data['shop']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to reject shop');
    }
  }

  Future<Shop> suspendShop(int shopId, String reason) async {
    try {
      final response = await _dio.post('/admin/shops/$shopId/suspend', data: {
        'reason': reason,
      });
      return Shop.fromJson(response.data['shop']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to suspend shop');
    }
  }
}

@riverpod
Future<List<Shop>> pendingShops(Ref ref) async {
  return ref.watch(adminShopRepositoryProvider).getPendingShops();
}

@riverpod
Future<List<Shop>> allShops(Ref ref, {String? status}) async {
  return ref.watch(adminShopRepositoryProvider).getAllShops(status: status);
}
