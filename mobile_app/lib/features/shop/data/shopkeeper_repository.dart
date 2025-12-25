import 'dart:io';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../../products/domain/product.dart';
import '../../orders/domain/order.dart';
import '../domain/shop.dart';

part 'shopkeeper_repository.g.dart';

@riverpod
ShopkeeperRepository shopkeeperRepository(Ref ref) {
  return ShopkeeperRepository(ref.watch(dioProvider));
}

class ShopkeeperDashboard {
  final Shop shop;
  final int totalProducts;
  final int totalOrders;
  final double totalRevenue;
  final int pendingOrders;
  final List<OrderModel> recentOrders;

  ShopkeeperDashboard({
    required this.shop,
    required this.totalProducts,
    required this.totalOrders,
    required this.totalRevenue,
    required this.pendingOrders,
    required this.recentOrders,
  });

  factory ShopkeeperDashboard.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] as Map<String, dynamic>;
    final orders = json['recent_orders'] as List<dynamic>? ?? [];
    
    return ShopkeeperDashboard(
      shop: Shop.fromJson(json['shop']),
      totalProducts: stats['total_products'] ?? 0,
      totalOrders: stats['total_orders'] ?? 0,
      totalRevenue: (stats['total_revenue'] ?? 0).toDouble(),
      pendingOrders: stats['pending_orders'] ?? 0,
      recentOrders: orders.map((o) => OrderModel.fromJson(o)).toList(),
    );
  }
}

class ShopkeeperRepository {
  final Dio _dio;

  ShopkeeperRepository(this._dio);

  Future<ShopkeeperDashboard> getDashboard() async {
    try {
      final response = await _dio.get('/shopkeeper/dashboard');
      return ShopkeeperDashboard.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch dashboard');
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/shopkeeper/products');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch products');
    }
  }

  Future<Product> createProduct({
    required String name,
    String? description,
    required double price,
    required int stock,
    required int categoryId,
    File? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        if (description != null) 'description': description,
        'price': price,
        'stock': stock,
        'category_id': categoryId,
        if (image != null)
          'image': await MultipartFile.fromFile(image.path, filename: 'product.jpg'),
      });

      final response = await _dio.post('/shopkeeper/products', data: formData);
      return Product.fromJson(response.data['product']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create product');
    }
  }

  Future<Product> updateProduct({
    required int id,
    String? name,
    String? description,
    double? price,
    int? stock,
    int? categoryId,
    File? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (price != null) 'price': price,
        if (stock != null) 'stock': stock,
        if (categoryId != null) 'category_id': categoryId,
        if (image != null)
          'image': await MultipartFile.fromFile(image.path, filename: 'product.jpg'),
      });

      final response = await _dio.post('/shopkeeper/products/$id', data: formData);
      return Product.fromJson(response.data['product']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update product');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _dio.delete('/shopkeeper/products/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to delete product');
    }
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _dio.get('/shopkeeper/orders');
      final List<dynamic> data = response.data;
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch orders');
    }
  }

  Future<OrderModel> updateOrderStatus(int orderId, String status) async {
    try {
      final response = await _dio.patch('/shopkeeper/orders/$orderId/status', data: {
        'status': status,
      });
      return OrderModel.fromJson(response.data['order']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update order status');
    }
  }

  Future<Shop> updateSettings({
    String? name,
    String? description,
    String? address,
    String? city,
    String? province,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
  }) async {
    try {
      final response = await _dio.put('/shopkeeper/settings', data: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (address != null) 'address': address,
        if (city != null) 'city': city,
        if (province != null) 'province': province,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
      });
      return Shop.fromJson(response.data['shop']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update shop settings');
    }
  }
}

@riverpod
Future<ShopkeeperDashboard> shopkeeperDashboard(Ref ref) async {
  return ref.watch(shopkeeperRepositoryProvider).getDashboard();
}

@riverpod
Future<List<Product>> shopkeeperProducts(Ref ref) async {
  return ref.watch(shopkeeperRepositoryProvider).getProducts();
}

@riverpod
Future<List<OrderModel>> shopkeeperOrders(Ref ref) async {
  return ref.watch(shopkeeperRepositoryProvider).getOrders();
}
