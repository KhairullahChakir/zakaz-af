import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/features/products/data/product_repository.dart';
import 'package:mobile_app/features/products/domain/category.dart';
import 'package:mobile_app/features/products/domain/product.dart';
import 'dart:async';

part 'providers.g.dart';

// Extensions to handle caching
extension CacheExtension on Ref {
  void cacheFor(Duration duration) {
    final link = keepAlive();
    final timer = Timer(duration, link.close);
    onDispose(timer.cancel);
  }
}

@Riverpod(keepAlive: true)
Future<List<Category>> categories(Ref ref) {
  return ref.watch(productRepositoryProvider).getCategories();
}

@riverpod
Future<List<Product>> products(Ref ref, {
  int? categoryId,
  String? search,
  String? sortBy,
  String? sortOrder,
}) {
  // Cache the list for 5 minutes
  ref.cacheFor(const Duration(minutes: 5));
  
  return ref.watch(productRepositoryProvider).getProducts(
    categoryId: categoryId,
    search: search,
    sortBy: sortBy,
    sortOrder: sortOrder,
  );
}

@riverpod
Future<Product> productDetails(Ref ref, int id) {
  // Cache details for 5 minutes
  ref.cacheFor(const Duration(minutes: 5));
  
  return ref.watch(productRepositoryProvider).getProduct(id);
}
