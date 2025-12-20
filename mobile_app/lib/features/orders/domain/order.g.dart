// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => _OrderModel(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  totalAmount: (json['total_amount'] as num).toDouble(),
  status: json['status'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$OrderModelToJson(_OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'total_amount': instance.totalAmount,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'items': instance.items,
    };
