// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  productId: (json['product_id'] as num).toInt(),
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'product_id': instance.productId,
  'rating': instance.rating,
  'comment': instance.comment,
  'created_at': instance.createdAt.toIso8601String(),
  'user': instance.user,
};
