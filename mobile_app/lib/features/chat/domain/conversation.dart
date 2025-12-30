import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    required int id,
    @JsonKey(name: 'customer_id') required int customerId,
    @JsonKey(name: 'shop_id') int? shopId,
    @JsonKey(name: 'seller_id') int? sellerId,
    @JsonKey(name: 'product_id') int? productId,
    @JsonKey(name: 'marketplace_item_id') int? marketplaceItemId,
    @JsonKey(name: 'last_message_at') DateTime? lastMessageAt,
    @JsonKey(name: 'unread_count') @Default(0) int unreadCount,
    @JsonKey(name: 'other_participant') ConversationParticipant? otherParticipant,
    ConversationShop? shop,
    ConversationProduct? product,
    @JsonKey(name: 'marketplace_item') ConversationMarketplaceItem? marketplaceItem,
    @JsonKey(name: 'latest_message') LatestMessage? latestMessage,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);
}

@freezed
abstract class ConversationParticipant with _$ConversationParticipant {
  const factory ConversationParticipant({
    required int id,
    required String name,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
  }) = _ConversationParticipant;

  factory ConversationParticipant.fromJson(Map<String, dynamic> json) => _$ConversationParticipantFromJson(json);
}

@freezed
abstract class ConversationShop with _$ConversationShop {
  const factory ConversationShop({
    required int id,
    required String name,
    @JsonKey(name: 'main_photo_url') String? mainPhotoUrl,
  }) = _ConversationShop;

  factory ConversationShop.fromJson(Map<String, dynamic> json) => _$ConversationShopFromJson(json);
}

@freezed
abstract class ConversationProduct with _$ConversationProduct {
  const factory ConversationProduct({
    required int id,
    required String name,
    @JsonKey(name: 'image_url') String? imageUrl,
    required double price,
  }) = _ConversationProduct;

  factory ConversationProduct.fromJson(Map<String, dynamic> json) => _$ConversationProductFromJson(json);
}

@freezed
abstract class ConversationMarketplaceItem with _$ConversationMarketplaceItem {
  const factory ConversationMarketplaceItem({
    required int id,
    required String name,
    @JsonKey(name: 'image_url') String? imageUrl,
    required double price,
  }) = _ConversationMarketplaceItem;

  factory ConversationMarketplaceItem.fromJson(Map<String, dynamic> json) => _$ConversationMarketplaceItemFromJson(json);
}

@freezed
abstract class LatestMessage with _$LatestMessage {
  const factory LatestMessage({
    required String content,
    required String type,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'sender_id') required int senderId,
  }) = _LatestMessage;

  factory LatestMessage.fromJson(Map<String, dynamic> json) => _$LatestMessageFromJson(json);
}
