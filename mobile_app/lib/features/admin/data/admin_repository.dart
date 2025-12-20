import 'dart:io';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../../products/domain/product.dart';
import '../../products/domain/category.dart';

part 'admin_repository.g.dart';

@riverpod
AdminRepository adminRepository(Ref ref) {
  return AdminRepository(ref.watch(dioProvider));
}

class AdminRepository {
  final Dio _dio;

  AdminRepository(this._dio);

  // Products
  Future<List<Product>> getProducts({String? search}) async {
    try {
      final response = await _dio.get('/admin/products', queryParameters: {
        if (search != null) 'search': search,
      });
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch products');
    }
  }

  Future<Product> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    required int categoryId,
    File? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'category_id': categoryId,
        if (image != null)
          'image': await MultipartFile.fromFile(image.path, filename: 'product.jpg'),
      });

      final response = await _dio.post('/admin/products', data: formData);
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

      final response = await _dio.post('/admin/products/$id', data: formData);
      return Product.fromJson(response.data['product']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update product');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _dio.delete('/admin/products/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to delete product');
    }
  }

  // Categories
  Future<Category> createCategory({
    required String name,
    String? type,
    File? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        if (type != null) 'type': type,
        if (image != null)
          'image': await MultipartFile.fromFile(image.path, filename: 'category.jpg'),
      });

      final response = await _dio.post('/admin/categories', data: formData);
      return Category.fromJson(response.data['category']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create category');
    }
  }

  Future<Category> updateCategory({
    required int id,
    String? name,
    String? type,
    File? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (name != null) 'name': name,
        if (type != null) 'type': type,
        if (image != null)
          'image': await MultipartFile.fromFile(image.path, filename: 'category.jpg'),
      });

      final response = await _dio.post('/admin/categories/$id', data: formData);
      return Category.fromJson(response.data['category']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update category');
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _dio.delete('/admin/categories/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to delete category');
    }
  }
}
