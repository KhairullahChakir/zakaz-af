import 'package:freezed_annotation/freezed_annotation.dart';
import 'category.dart';
import 'product_shop.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required int id,
    required String name,
    required String? description,
    required double price,
    String? image,
    @JsonKey(name: 'image_url') String? imageUrl,
    required int stock,
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'shop_id') int? shopId,
    Category? category,
    ProductShop? shop,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
