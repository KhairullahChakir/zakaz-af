// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Conversation _$ConversationFromJson(
  Map<String, dynamic> json,
) => _Conversation(
  id: (json['id'] as num).toInt(),
  customerId: (json['customer_id'] as num).toInt(),
  shopId: (json['shop_id'] as num).toInt(),
  productId: (json['product_id'] as num?)?.toInt(),
  lastMessageAt: json['last_message_at'] == null
      ? null
      : DateTime.parse(json['last_message_at'] as String),
  unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
  otherParticipant: json['other_participant'] == null
      ? null
      : ConversationParticipant.fromJson(
          json['other_participant'] as Map<String, dynamic>,
        ),
  shop: json['shop'] == null
      ? null
      : ConversationShop.fromJson(json['shop'] as Map<String, dynamic>),
  product: json['product'] == null
      ? null
      : ConversationProduct.fromJson(json['product'] as Map<String, dynamic>),
  latestMessage: json['latest_message'] == null
      ? null
      : LatestMessage.fromJson(json['latest_message'] as Map<String, dynamic>),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ConversationToJson(_Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer_id': instance.customerId,
      'shop_id': instance.shopId,
      'product_id': instance.productId,
      'last_message_at': instance.lastMessageAt?.toIso8601String(),
      'unread_count': instance.unreadCount,
      'other_participant': instance.otherParticipant,
      'shop': instance.shop,
      'product': instance.product,
      'latest_message': instance.latestMessage,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_ConversationParticipant _$ConversationParticipantFromJson(
  Map<String, dynamic> json,
) => _ConversationParticipant(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  profileImageUrl: json['profile_image_url'] as String?,
);

Map<String, dynamic> _$ConversationParticipantToJson(
  _ConversationParticipant instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'profile_image_url': instance.profileImageUrl,
};

_ConversationShop _$ConversationShopFromJson(Map<String, dynamic> json) =>
    _ConversationShop(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      mainPhotoUrl: json['main_photo_url'] as String?,
    );

Map<String, dynamic> _$ConversationShopToJson(_ConversationShop instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'main_photo_url': instance.mainPhotoUrl,
    };

_ConversationProduct _$ConversationProductFromJson(Map<String, dynamic> json) =>
    _ConversationProduct(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$ConversationProductToJson(
  _ConversationProduct instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'image_url': instance.imageUrl,
  'price': instance.price,
};

_LatestMessage _$LatestMessageFromJson(Map<String, dynamic> json) =>
    _LatestMessage(
      content: json['content'] as String,
      type: json['type'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      senderId: (json['sender_id'] as num).toInt(),
    );

Map<String, dynamic> _$LatestMessageToJson(_LatestMessage instance) =>
    <String, dynamic>{
      'content': instance.content,
      'type': instance.type,
      'created_at': instance.createdAt?.toIso8601String(),
      'sender_id': instance.senderId,
    };
