// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Address _$AddressFromJson(Map<String, dynamic> json) => _Address(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  label: json['label'] as String,
  addressLine1: json['address_line_1'] as String,
  addressLine2: json['address_line_2'] as String?,
  city: json['city'] as String,
  state: json['state'] as String?,
  zipCode: json['zip_code'] as String?,
  isDefault: json['is_default'] as bool? ?? false,
);

Map<String, dynamic> _$AddressToJson(_Address instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'label': instance.label,
  'address_line_1': instance.addressLine1,
  'address_line_2': instance.addressLine2,
  'city': instance.city,
  'state': instance.state,
  'zip_code': instance.zipCode,
  'is_default': instance.isDefault,
};
