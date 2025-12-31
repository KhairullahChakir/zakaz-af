// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MarketplaceItem _$MarketplaceItemFromJson(Map<String, dynamic> json) =>
    _MarketplaceItem(
      id: (json['id'] as num).toInt(),
      userId: _parseInt(json['user_id']),
      categoryId: _parseIntNullable(json['category_id']),
      name: _parseString(json['name']),
      description: _parseString(json['description']),
      price: _parseDouble(json['price']),
      condition: _parseString(json['condition']),
      phone: _parseString(json['phone']),
      location: json['location'] as String?,
      status: _parseStringWithDefault(json['status']),
      mainImageUrl: json['main_image_url'] as String?,
      galleryUrls: (json['gallery_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
      isBoosted: json['is_boosted'] as bool? ?? false,
      boostedUntil: json['boosted_until'] as String?,
    );

Map<String, dynamic> _$MarketplaceItemToJson(_MarketplaceItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'category_id': instance.categoryId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'condition': instance.condition,
      'phone': instance.phone,
      'location': instance.location,
      'status': instance.status,
      'main_image_url': instance.mainImageUrl,
      'gallery_urls': instance.galleryUrls,
      'user': instance.user,
      'category': instance.category,
      'created_at': instance.createdAt,
      'is_boosted': instance.isBoosted,
      'boosted_until': instance.boostedUntil,
    };
