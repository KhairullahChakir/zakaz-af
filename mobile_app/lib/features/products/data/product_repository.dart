import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/core/network/dio_provider.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:mobile_app/features/products/domain/category.dart';
import 'package:mobile_app/features/products/domain/product.dart';

part 'product_repository.g.dart';

@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductRepository(ref.watch(dioProvider));
}

class ProductRepository {
  final Dio _dio;

  ProductRepository(this._dio);

  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      final categories = (response.data as List).map((json) => Category.fromJson(json)).toSet().toList();
      
      // Deduplicate manually by ID if Set doesn't work (requires equates/hashcode)
      final ids = <int>{};
      final uniqueCategories = <Category>[];
      for (var c in categories) {
        if (ids.add(c.id)) {
          uniqueCategories.add(c);
        }
      }
      return uniqueCategories;
    } catch (e) {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Product>> getProducts({
    int? categoryId,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (categoryId != null) query['category_id'] = categoryId;
      if (search != null && search.isNotEmpty) query['search'] = search;
      if (sortBy != null) query['sort_by'] = sortBy;
      if (sortOrder != null) query['sort_order'] = sortOrder;
      
      final response = await _dio.get('/products', queryParameters: query);
      final List data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e, st) {
      debugPrint('Error loading products: $e');
      debugPrint('Stack trace: $st');
      throw Exception('Failed to load products');
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load product details');
    }
  }
}
