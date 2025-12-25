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
    @JsonKey(name: 'reviews_avg_rating', fromJson: _parseRating) double? reviewsAvgRating,
    @JsonKey(name: 'order_count') int? orderCount,
    @JsonKey(name: 'gallery_urls') List<String>? galleryUrls,
    Category? category,
    ProductShop? shop,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

/// Parses rating from either String or num (backend sends it as String)
double? _parseRating(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
