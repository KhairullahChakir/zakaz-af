import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/core/network/dio_provider.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:mobile_app/features/products/domain/category.dart';
import 'package:mobile_app/features/products/domain/product.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/core/storage/shared_prefs_provider.dart';

part 'product_repository.g.dart';

@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductRepository(
    ref.watch(dioProvider),
    ref.watch(sharedPrefsProvider),
  );
}

class ProductRepository {
  final Dio _dio;
  final SharedPreferences _prefs;

  ProductRepository(this._dio, this._prefs);

  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      final categories = (response.data as List).map((json) => Category.fromJson(json)).toSet().toList();
      
      // Deduplicate manually by ID
      final ids = <int>{};
      final uniqueCategories = <Category>[];
      for (var c in categories) {
        if (ids.add(c.id)) {
          uniqueCategories.add(c);
        }
      }

      // Cache the result
      await _prefs.setString('cached_categories', jsonEncode(uniqueCategories.map((e) => e.toJson()).toList()));
      
      return uniqueCategories;
    } catch (e) {
      // Try to load from cache
      final cachedJson = _prefs.getString('cached_categories');
      if (cachedJson != null) {
        final List<dynamic> decoded = jsonDecode(cachedJson);
        return decoded.map((e) => Category.fromJson(e)).toList();
      }
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Product>> getProducts({
    int? categoryId,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) async {
    // Generate a cache key based on params
    final isHomeFeed = categoryId == null && search == null && sortBy == null;
    final cacheKey = 'cached_products_${categoryId ?? 'all'}_${search ?? 'none'}';

    try {
      final query = <String, dynamic>{};
      if (categoryId != null) query['category_id'] = categoryId;
      if (search != null && search.isNotEmpty) query['search'] = search;
      if (sortBy != null) query['sort_by'] = sortBy;
      if (sortOrder != null) query['sort_order'] = sortOrder;
      
      final response = await _dio.get('/products', queryParameters: query);
      final List data = response.data;
      final products = data.map((json) => Product.fromJson(json)).toList();

      // Cache home feed or simple category lists
      if (isHomeFeed || categoryId != null) {
         await _prefs.setString(cacheKey, jsonEncode(products.map((e) => e.toJson()).toList()));
      }

      return products;
    } catch (e) {
      debugPrint('Error loading products: $e');
      
      // Try cache
      if (isHomeFeed || categoryId != null) {
        final cachedJson = _prefs.getString(cacheKey);
        if (cachedJson != null) {
           final List<dynamic> decoded = jsonDecode(cachedJson);
           return decoded.map((e) => Product.fromJson(e)).toList();
        }
      }

      throw Exception('Failed to load products');
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      final product = Product.fromJson(response.data);
      
      // Cache detail
      await _prefs.setString('cached_product_$id', jsonEncode(product.toJson()));
      
      return product;
    } catch (e) {
      final cachedJson = _prefs.getString('cached_product_$id');
      if (cachedJson != null) {
        return Product.fromJson(jsonDecode(cachedJson));
      }
      throw Exception('Failed to load product details');
    }
  }
}
