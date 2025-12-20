import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/features/products/data/product_repository.dart';
import 'package:mobile_app/features/products/domain/category.dart';
import 'package:mobile_app/features/products/domain/product.dart';

part 'providers.g.dart';

@riverpod
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
  return ref.watch(productRepositoryProvider).getProducts(
    categoryId: categoryId,
    search: search,
    sortBy: sortBy,
    sortOrder: sortOrder,
  );
}

@riverpod
Future<Product> productDetails(Ref ref, int id) {
  return ref.watch(productRepositoryProvider).getProduct(id);
}
