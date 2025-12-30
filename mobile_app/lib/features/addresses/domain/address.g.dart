// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Address _$AddressFromJson(Map<String, dynamic> json) => _Address(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  label: json['label'] as String,
  recipientName: json['recipient_name'] as String?,
  phonePrimary: json['phone_primary'] as String?,
  phoneSecondary: json['phone_secondary'] as String?,
  addressLine1: json['address_line_1'] as String,
  addressLine2: json['address_line_2'] as String?,
  city: json['city'] as String,
  state: json['state'] as String?,
  zipCode: json['zip_code'] as String?,
  country: json['country'] as String? ?? 'Afghanistan',
  province: json['province'] as String?,
  district: json['district'] as String?,
  street: json['street'] as String?,
  houseNumber: json['house_number'] as String?,
  apartmentNumber: json['apartment_number'] as String?,
  deliveryInstructions: json['delivery_instructions'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  isDefault: json['is_default'] as bool? ?? false,
);

Map<String, dynamic> _$AddressToJson(_Address instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'label': instance.label,
  'recipient_name': instance.recipientName,
  'phone_primary': instance.phonePrimary,
  'phone_secondary': instance.phoneSecondary,
  'address_line_1': instance.addressLine1,
  'address_line_2': instance.addressLine2,
  'city': instance.city,
  'state': instance.state,
  'zip_code': instance.zipCode,
  'country': instance.country,
  'province': instance.province,
  'district': instance.district,
  'street': instance.street,
  'house_number': instance.houseNumber,
  'apartment_number': instance.apartmentNumber,
  'delivery_instructions': instance.deliveryInstructions,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'is_default': instance.isDefault,
};
