// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductShop _$ProductShopFromJson(Map<String, dynamic> json) => _ProductShop(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  shopType: json['shop_type'] as String?,
  phone: json['phone'] as String?,
  city: json['city'] as String?,
  district: json['district'] as String?,
  mainPhotoUrl: json['main_photo_url'] as String?,
  owner: json['owner'] == null
      ? null
      : ProductShopOwner.fromJson(json['owner'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProductShopToJson(_ProductShop instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shop_type': instance.shopType,
      'phone': instance.phone,
      'city': instance.city,
      'district': instance.district,
      'main_photo_url': instance.mainPhotoUrl,
      'owner': instance.owner,
    };

_ProductShopOwner _$ProductShopOwnerFromJson(Map<String, dynamic> json) =>
    _ProductShopOwner(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
    );

Map<String, dynamic> _$ProductShopOwnerToJson(_ProductShopOwner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'profile_image_url': instance.profileImageUrl,
    };
