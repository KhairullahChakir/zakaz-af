// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NearbyShop _$NearbyShopFromJson(Map<String, dynamic> json) => _NearbyShop(
  id: (json['id'] as num).toInt(),
  ownerId: (json['owner_id'] as num).toInt(),
  name: json['name'] as String,
  type: json['type'] as String,
  description: json['description'] as String?,
  address: json['address'] as String,
  city: json['city'] as String,
  province: json['province'] as String,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  photos: (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
  phone: json['phone'] as String,
  email: json['email'] as String?,
  status: json['status'] as String? ?? 'approved',
  primaryPhotoUrl: json['primary_photo_url'] as String?,
  productsCount: (json['products_count'] as num?)?.toInt() ?? 0,
  distance: (json['distance'] as num?)?.toDouble(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$NearbyShopToJson(_NearbyShop instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'province': instance.province,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'photos': instance.photos,
      'phone': instance.phone,
      'email': instance.email,
      'status': instance.status,
      'primary_photo_url': instance.primaryPhotoUrl,
      'products_count': instance.productsCount,
      'distance': instance.distance,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_NearbyShopsResponse _$NearbyShopsResponseFromJson(Map<String, dynamic> json) =>
    _NearbyShopsResponse(
      shops: (json['shops'] as List<dynamic>)
          .map((e) => NearbyShop.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      searchRadiusKm: (json['search_radius_km'] as num).toDouble(),
      userLocation: UserLocation.fromJson(
        json['user_location'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$NearbyShopsResponseToJson(
  _NearbyShopsResponse instance,
) => <String, dynamic>{
  'shops': instance.shops,
  'total': instance.total,
  'search_radius_km': instance.searchRadiusKm,
  'user_location': instance.userLocation,
};

_UserLocation _$UserLocationFromJson(Map<String, dynamic> json) =>
    _UserLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$UserLocationToJson(_UserLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
