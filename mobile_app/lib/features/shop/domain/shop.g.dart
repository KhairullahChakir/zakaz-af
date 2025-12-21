// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Shop _$ShopFromJson(Map<String, dynamic> json) => _Shop(
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
  businessLicense: json['business_license'] as String?,
  ownerNid: json['owner_nid'] as String?,
  phone: json['phone'] as String,
  email: json['email'] as String?,
  status: json['status'] as String? ?? 'pending',
  rejectionReason: json['rejection_reason'] as String?,
  approvedAt: json['approved_at'] == null
      ? null
      : DateTime.parse(json['approved_at'] as String),
  primaryPhotoUrl: json['primary_photo_url'] as String?,
  businessLicenseUrl: json['business_license_url'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ShopToJson(_Shop instance) => <String, dynamic>{
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
  'business_license': instance.businessLicense,
  'owner_nid': instance.ownerNid,
  'phone': instance.phone,
  'email': instance.email,
  'status': instance.status,
  'rejection_reason': instance.rejectionReason,
  'approved_at': instance.approvedAt?.toIso8601String(),
  'primary_photo_url': instance.primaryPhotoUrl,
  'business_license_url': instance.businessLicenseUrl,
  'created_at': instance.createdAt?.toIso8601String(),
};
