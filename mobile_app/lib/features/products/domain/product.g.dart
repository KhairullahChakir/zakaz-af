// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  price: (json['price'] as num).toDouble(),
  image: json['image'] as String?,
  imageUrl: json['image_url'] as String?,
  stock: (json['stock'] as num).toInt(),
  categoryId: (json['category_id'] as num).toInt(),
  shopId: (json['shop_id'] as num?)?.toInt(),
  reviewsAvgRating: _parseRating(json['reviews_avg_rating']),
  orderCount: (json['order_count'] as num?)?.toInt(),
  galleryUrls: (json['gallery_urls'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  category: json['category'] == null
      ? null
      : Category.fromJson(json['category'] as Map<String, dynamic>),
  shop: json['shop'] == null
      ? null
      : ProductShop.fromJson(json['shop'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'image': instance.image,
  'image_url': instance.imageUrl,
  'stock': instance.stock,
  'category_id': instance.categoryId,
  'shop_id': instance.shopId,
  'reviews_avg_rating': instance.reviewsAvgRating,
  'order_count': instance.orderCount,
  'gallery_urls': instance.galleryUrls,
  'category': instance.category,
  'shop': instance.shop,
};
