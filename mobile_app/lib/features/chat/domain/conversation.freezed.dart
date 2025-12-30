// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Conversation {

 int get id;@JsonKey(name: 'customer_id') int get customerId;@JsonKey(name: 'shop_id') int? get shopId;@JsonKey(name: 'seller_id') int? get sellerId;@JsonKey(name: 'product_id') int? get productId;@JsonKey(name: 'marketplace_item_id') int? get marketplaceItemId;@JsonKey(name: 'last_message_at') DateTime? get lastMessageAt;@JsonKey(name: 'unread_count') int get unreadCount;@JsonKey(name: 'other_participant') ConversationParticipant? get otherParticipant; ConversationShop? get shop; ConversationProduct? get product;@JsonKey(name: 'marketplace_item') ConversationMarketplaceItem? get marketplaceItem;@JsonKey(name: 'latest_message') LatestMessage? get latestMessage;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationCopyWith<Conversation> get copyWith => _$ConversationCopyWithImpl<Conversation>(this as Conversation, _$identity);

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.marketplaceItemId, marketplaceItemId) || other.marketplaceItemId == marketplaceItemId)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.otherParticipant, otherParticipant) || other.otherParticipant == otherParticipant)&&(identical(other.shop, shop) || other.shop == shop)&&(identical(other.product, product) || other.product == product)&&(identical(other.marketplaceItem, marketplaceItem) || other.marketplaceItem == marketplaceItem)&&(identical(other.latestMessage, latestMessage) || other.latestMessage == latestMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,shopId,sellerId,productId,marketplaceItemId,lastMessageAt,unreadCount,otherParticipant,shop,product,marketplaceItem,latestMessage,createdAt);

@override
String toString() {
  return 'Conversation(id: $id, customerId: $customerId, shopId: $shopId, sellerId: $sellerId, productId: $productId, marketplaceItemId: $marketplaceItemId, lastMessageAt: $lastMessageAt, unreadCount: $unreadCount, otherParticipant: $otherParticipant, shop: $shop, product: $product, marketplaceItem: $marketplaceItem, latestMessage: $latestMessage, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ConversationCopyWith<$Res>  {
  factory $ConversationCopyWith(Conversation value, $Res Function(Conversation) _then) = _$ConversationCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'customer_id') int customerId,@JsonKey(name: 'shop_id') int? shopId,@JsonKey(name: 'seller_id') int? sellerId,@JsonKey(name: 'product_id') int? productId,@JsonKey(name: 'marketplace_item_id') int? marketplaceItemId,@JsonKey(name: 'last_message_at') DateTime? lastMessageAt,@JsonKey(name: 'unread_count') int unreadCount,@JsonKey(name: 'other_participant') ConversationParticipant? otherParticipant, ConversationShop? shop, ConversationProduct? product,@JsonKey(name: 'marketplace_item') ConversationMarketplaceItem? marketplaceItem,@JsonKey(name: 'latest_message') LatestMessage? latestMessage,@JsonKey(name: 'created_at') DateTime? createdAt
});


$ConversationParticipantCopyWith<$Res>? get otherParticipant;$ConversationShopCopyWith<$Res>? get shop;$ConversationProductCopyWith<$Res>? get product;$ConversationMarketplaceItemCopyWith<$Res>? get marketplaceItem;$LatestMessageCopyWith<$Res>? get latestMessage;

}
/// @nodoc
class _$ConversationCopyWithImpl<$Res>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._self, this._then);

  final Conversation _self;
  final $Res Function(Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerId = null,Object? shopId = freezed,Object? sellerId = freezed,Object? productId = freezed,Object? marketplaceItemId = freezed,Object? lastMessageAt = freezed,Object? unreadCount = null,Object? otherParticipant = freezed,Object? shop = freezed,Object? product = freezed,Object? marketplaceItem = freezed,Object? latestMessage = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int,shopId: freezed == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as int?,sellerId: freezed == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as int?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,marketplaceItemId: freezed == marketplaceItemId ? _self.marketplaceItemId : marketplaceItemId // ignore: cast_nullable_to_non_nullable
as int?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,otherParticipant: freezed == otherParticipant ? _self.otherParticipant : otherParticipant // ignore: cast_nullable_to_non_nullable
as ConversationParticipant?,shop: freezed == shop ? _self.shop : shop // ignore: cast_nullable_to_non_nullable
as ConversationShop?,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ConversationProduct?,marketplaceItem: freezed == marketplaceItem ? _self.marketplaceItem : marketplaceItem // ignore: cast_nullable_to_non_nullable
as ConversationMarketplaceItem?,latestMessage: freezed == latestMessage ? _self.latestMessage : latestMessage // ignore: cast_nullable_to_non_nullable
as LatestMessage?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationParticipantCopyWith<$Res>? get otherParticipant {
    if (_self.otherParticipant == null) {
    return null;
  }

  return $ConversationParticipantCopyWith<$Res>(_self.otherParticipant!, (value) {
    return _then(_self.copyWith(otherParticipant: value));
  });
}/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationShopCopyWith<$Res>? get shop {
    if (_self.shop == null) {
    return null;
  }

  return $ConversationShopCopyWith<$Res>(_self.shop!, (value) {
    return _then(_self.copyWith(shop: value));
  });
}/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationProductCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ConversationProductCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationMarketplaceItemCopyWith<$Res>? get marketplaceItem {
    if (_self.marketplaceItem == null) {
    return null;
  }

  return $ConversationMarketplaceItemCopyWith<$Res>(_self.marketplaceItem!, (value) {
    return _then(_self.copyWith(marketplaceItem: value));
  });
}/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LatestMessageCopyWith<$Res>? get latestMessage {
    if (_self.latestMessage == null) {
    return null;
  }

  return $LatestMessageCopyWith<$Res>(_self.latestMessage!, (value) {
    return _then(_self.copyWith(latestMessage: value));
  });
}
}


/// Adds pattern-matching-related methods to [Conversation].
extension ConversationPatterns on Conversation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Conversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Conversation value)  $default,){
final _that = this;
switch (_that) {
case _Conversation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Conversation value)?  $default,){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'customer_id')  int customerId, @JsonKey(name: 'shop_id')  int? shopId, @JsonKey(name: 'seller_id')  int? sellerId, @JsonKey(name: 'product_id')  int? productId, @JsonKey(name: 'marketplace_item_id')  int? marketplaceItemId, @JsonKey(name: 'last_message_at')  DateTime? lastMessageAt, @JsonKey(name: 'unread_count')  int unreadCount, @JsonKey(name: 'other_participant')  ConversationParticipant? otherParticipant,  ConversationShop? shop,  ConversationProduct? product, @JsonKey(name: 'marketplace_item')  ConversationMarketplaceItem? marketplaceItem, @JsonKey(name: 'latest_message')  LatestMessage? latestMessage, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.customerId,_that.shopId,_that.sellerId,_that.productId,_that.marketplaceItemId,_that.lastMessageAt,_that.unreadCount,_that.otherParticipant,_that.shop,_that.product,_that.marketplaceItem,_that.latestMessage,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'customer_id')  int customerId, @JsonKey(name: 'shop_id')  int? shopId, @JsonKey(name: 'seller_id')  int? sellerId, @JsonKey(name: 'product_id')  int? productId, @JsonKey(name: 'marketplace_item_id')  int? marketplaceItemId, @JsonKey(name: 'last_message_at')  DateTime? lastMessageAt, @JsonKey(name: 'unread_count')  int unreadCount, @JsonKey(name: 'other_participant')  ConversationParticipant? otherParticipant,  ConversationShop? shop,  ConversationProduct? product, @JsonKey(name: 'marketplace_item')  ConversationMarketplaceItem? marketplaceItem, @JsonKey(name: 'latest_message')  LatestMessage? latestMessage, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Conversation():
return $default(_that.id,_that.customerId,_that.shopId,_that.sellerId,_that.productId,_that.marketplaceItemId,_that.lastMessageAt,_that.unreadCount,_that.otherParticipant,_that.shop,_that.product,_that.marketplaceItem,_that.latestMessage,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'customer_id')  int customerId, @JsonKey(name: 'shop_id')  int? shopId, @JsonKey(name: 'seller_id')  int? sellerId, @JsonKey(name: 'product_id')  int? productId, @JsonKey(name: 'marketplace_item_id')  int? marketplaceItemId, @JsonKey(name: 'last_message_at')  DateTime? lastMessageAt, @JsonKey(name: 'unread_count')  int unreadCount, @JsonKey(name: 'other_participant')  ConversationParticipant? otherParticipant,  ConversationShop? shop,  ConversationProduct? product, @JsonKey(name: 'marketplace_item')  ConversationMarketplaceItem? marketplaceItem, @JsonKey(name: 'latest_message')  LatestMessage? latestMessage, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.customerId,_that.shopId,_that.sellerId,_that.productId,_that.marketplaceItemId,_that.lastMessageAt,_that.unreadCount,_that.otherParticipant,_that.shop,_that.product,_that.marketplaceItem,_that.latestMessage,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Conversation implements Conversation {
  const _Conversation({required this.id, @JsonKey(name: 'customer_id') required this.customerId, @JsonKey(name: 'shop_id') this.shopId, @JsonKey(name: 'seller_id') this.sellerId, @JsonKey(name: 'product_id') this.productId, @JsonKey(name: 'marketplace_item_id') this.marketplaceItemId, @JsonKey(name: 'last_message_at') this.lastMessageAt, @JsonKey(name: 'unread_count') this.unreadCount = 0, @JsonKey(name: 'other_participant') this.otherParticipant, this.shop, this.product, @JsonKey(name: 'marketplace_item') this.marketplaceItem, @JsonKey(name: 'latest_message') this.latestMessage, @JsonKey(name: 'created_at') this.createdAt});
  factory _Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);

@override final  int id;
@override@JsonKey(name: 'customer_id') final  int customerId;
@override@JsonKey(name: 'shop_id') final  int? shopId;
@override@JsonKey(name: 'seller_id') final  int? sellerId;
@override@JsonKey(name: 'product_id') final  int? productId;
@override@JsonKey(name: 'marketplace_item_id') final  int? marketplaceItemId;
@override@JsonKey(name: 'last_message_at') final  DateTime? lastMessageAt;
@override@JsonKey(name: 'unread_count') final  int unreadCount;
@override@JsonKey(name: 'other_participant') final  ConversationParticipant? otherParticipant;
@override final  ConversationShop? shop;
@override final  ConversationProduct? product;
@override@JsonKey(name: 'marketplace_item') final  ConversationMarketplaceItem? marketplaceItem;
@override@JsonKey(name: 'latest_message') final  LatestMessage? latestMessage;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationCopyWith<_Conversation> get copyWith => __$ConversationCopyWithImpl<_Conversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.marketplaceItemId, marketplaceItemId) || other.marketplaceItemId == marketplaceItemId)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.otherParticipant, otherParticipant) || other.otherParticipant == otherParticipant)&&(identical(other.shop, shop) || other.shop == shop)&&(identical(other.product, product) || other.product == product)&&(identical(other.marketplaceItem, marketplaceItem) || other.marketplaceItem == marketplaceItem)&&(identical(other.latestMessage, latestMessage) || other.latestMessage == latestMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,shopId,sellerId,productId,marketplaceItemId,lastMessageAt,unreadCount,otherParticipant,shop,product,marketplaceItem,latestMessage,createdAt);

@override
String toString() {
  return 'Conversation(id: $id, customerId: $customerId, shopId: $shopId, sellerId: $sellerId, productId: $productId, marketplaceItemId: $marketplaceItemId, lastMessageAt: $lastMessageAt, unreadCount: $unreadCount, otherParticipant: $otherParticipant, shop: $shop, product: $product, marketplaceItem: $marketplaceItem, latestMessage: $latestMessage, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ConversationCopyWith<$Res> implements $ConversationCopyWith<$Res> {
  factory _$ConversationCopyWith(_Conversation value, $Res Function(_Conversation) _then) = __$ConversationCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'customer_id') int customerId,@JsonKey(name: 'shop_id') int? shopId,@JsonKey(name: 'seller_id') int? sellerId,@JsonKey(name: 'product_id') int? productId,@JsonKey(name: 'marketplace_item_id') int? marketplaceItemId,@JsonKey(name: 'last_message_at') DateTime? lastMessageAt,@JsonKey(name: 'unread_count') int unreadCount,@JsonKey(name: 'other_participant') ConversationParticipant? otherParticipant, ConversationShop? shop, ConversationProduct? product,@JsonKey(name: 'marketplace_item') ConversationMarketplaceItem? marketplaceItem,@JsonKey(name: 'latest_message') LatestMessage? latestMessage,@JsonKey(name: 'created_at') DateTime? createdAt
});


@override $ConversationParticipantCopyWith<$Res>? get otherParticipant;@override $ConversationShopCopyWith<$Res>? get shop;@override $ConversationProductCopyWith<$Res>? get product;@override $ConversationMarketplaceItemCopyWith<$Res>? get marketplaceItem;@override $LatestMessageCopyWith<$Res>? get latestMessage;

}
/// @nodoc
class __$ConversationCopyWithImpl<$Res>
    implements _$ConversationCopyWith<$Res> {
  __$ConversationCopyWithImpl(this._self, this._then);

  final _Conversation _self;
  final $Res Function(_Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerId = null,Object? shopId = freezed,Object? sellerId = freezed,Object? productId = freezed,Object? marketplaceItemId = freezed,Object? lastMessageAt = freezed,Object? unreadCount = null,Object? otherParticipant = freezed,Object? shop = freezed,Object? product = freezed,Object? marketplaceItem = freezed,Object? latestMessage = freezed,Object? createdAt = freezed,}) {
  return _then(_Conversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int,shopId: freezed == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as int?,sellerId: freezed == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as int?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,marketplaceItemId: freezed == marketplaceItemId ? _self.marketplaceItemId : marketplaceItemId // ignore: cast_nullable_to_non_nullable
as int?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,otherParticipant: freezed == otherParticipant ? _self.otherParticipant : otherParticipant // ignore: cast_nullable_to_non_nullable
as ConversationParticipant?,shop: freezed == shop ? _self.shop : shop // ignore: cast_nullable_to_non_nullable
as ConversationShop?,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ConversationProduct?,marketplaceItem: freezed == marketplaceItem ? _self.marketplaceItem : marketplaceItem // ignore: cast_nullable_to_non_nullable
as ConversationMarketplaceItem?,latestMessage: freezed == latestMessage ? _self.latestMessage : latestMessage // ignore: cast_nullable_to_non_nullable
as LatestMessage?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationParticipantCopyWith<$Res>? get otherParticipant {
    if (_self.otherParticipant == null) {
    return null;
  }

  return $ConversationParticipantCopyWith<$Res>(_self.otherParticipant!, (value) {
    return _then(_self.copyWith(otherParticipant: value));
  });
}/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationShopCopyWith<$Res>? get shop {
    if (_self.shop == null) {
    return null;
  }

  return $ConversationShopCopyWith<$Res>(_self.shop!, (value) {
    return _then(_self.copyWith(shop: value));
  });
}/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationProductCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ConversationProductCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationMarketplaceItemCopyWith<$Res>? get marketplaceItem {
    if (_self.marketplaceItem == null) {
    return null;
  }

  return $ConversationMarketplaceItemCopyWith<$Res>(_self.marketplaceItem!, (value) {
    return _then(_self.copyWith(marketplaceItem: value));
  });
}/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LatestMessageCopyWith<$Res>? get latestMessage {
    if (_self.latestMessage == null) {
    return null;
  }

  return $LatestMessageCopyWith<$Res>(_self.latestMessage!, (value) {
    return _then(_self.copyWith(latestMessage: value));
  });
}
}


/// @nodoc
mixin _$ConversationParticipant {

 int get id; String get name;@JsonKey(name: 'profile_image_url') String? get profileImageUrl;
/// Create a copy of ConversationParticipant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationParticipantCopyWith<ConversationParticipant> get copyWith => _$ConversationParticipantCopyWithImpl<ConversationParticipant>(this as ConversationParticipant, _$identity);

  /// Serializes this ConversationParticipant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationParticipant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,profileImageUrl);

@override
String toString() {
  return 'ConversationParticipant(id: $id, name: $name, profileImageUrl: $profileImageUrl)';
}


}

/// @nodoc
abstract mixin class $ConversationParticipantCopyWith<$Res>  {
  factory $ConversationParticipantCopyWith(ConversationParticipant value, $Res Function(ConversationParticipant) _then) = _$ConversationParticipantCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'profile_image_url') String? profileImageUrl
});




}
/// @nodoc
class _$ConversationParticipantCopyWithImpl<$Res>
    implements $ConversationParticipantCopyWith<$Res> {
  _$ConversationParticipantCopyWithImpl(this._self, this._then);

  final ConversationParticipant _self;
  final $Res Function(ConversationParticipant) _then;

/// Create a copy of ConversationParticipant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? profileImageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationParticipant].
extension ConversationParticipantPatterns on ConversationParticipant {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationParticipant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationParticipant() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationParticipant value)  $default,){
final _that = this;
switch (_that) {
case _ConversationParticipant():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationParticipant value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationParticipant() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'profile_image_url')  String? profileImageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationParticipant() when $default != null:
return $default(_that.id,_that.name,_that.profileImageUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'profile_image_url')  String? profileImageUrl)  $default,) {final _that = this;
switch (_that) {
case _ConversationParticipant():
return $default(_that.id,_that.name,_that.profileImageUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'profile_image_url')  String? profileImageUrl)?  $default,) {final _that = this;
switch (_that) {
case _ConversationParticipant() when $default != null:
return $default(_that.id,_that.name,_that.profileImageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationParticipant implements ConversationParticipant {
  const _ConversationParticipant({required this.id, required this.name, @JsonKey(name: 'profile_image_url') this.profileImageUrl});
  factory _ConversationParticipant.fromJson(Map<String, dynamic> json) => _$ConversationParticipantFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'profile_image_url') final  String? profileImageUrl;

/// Create a copy of ConversationParticipant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationParticipantCopyWith<_ConversationParticipant> get copyWith => __$ConversationParticipantCopyWithImpl<_ConversationParticipant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationParticipantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationParticipant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,profileImageUrl);

@override
String toString() {
  return 'ConversationParticipant(id: $id, name: $name, profileImageUrl: $profileImageUrl)';
}


}

/// @nodoc
abstract mixin class _$ConversationParticipantCopyWith<$Res> implements $ConversationParticipantCopyWith<$Res> {
  factory _$ConversationParticipantCopyWith(_ConversationParticipant value, $Res Function(_ConversationParticipant) _then) = __$ConversationParticipantCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'profile_image_url') String? profileImageUrl
});




}
/// @nodoc
class __$ConversationParticipantCopyWithImpl<$Res>
    implements _$ConversationParticipantCopyWith<$Res> {
  __$ConversationParticipantCopyWithImpl(this._self, this._then);

  final _ConversationParticipant _self;
  final $Res Function(_ConversationParticipant) _then;

/// Create a copy of ConversationParticipant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? profileImageUrl = freezed,}) {
  return _then(_ConversationParticipant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ConversationShop {

 int get id; String get name;@JsonKey(name: 'main_photo_url') String? get mainPhotoUrl;
/// Create a copy of ConversationShop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationShopCopyWith<ConversationShop> get copyWith => _$ConversationShopCopyWithImpl<ConversationShop>(this as ConversationShop, _$identity);

  /// Serializes this ConversationShop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationShop&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mainPhotoUrl, mainPhotoUrl) || other.mainPhotoUrl == mainPhotoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mainPhotoUrl);

@override
String toString() {
  return 'ConversationShop(id: $id, name: $name, mainPhotoUrl: $mainPhotoUrl)';
}


}

/// @nodoc
abstract mixin class $ConversationShopCopyWith<$Res>  {
  factory $ConversationShopCopyWith(ConversationShop value, $Res Function(ConversationShop) _then) = _$ConversationShopCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'main_photo_url') String? mainPhotoUrl
});




}
/// @nodoc
class _$ConversationShopCopyWithImpl<$Res>
    implements $ConversationShopCopyWith<$Res> {
  _$ConversationShopCopyWithImpl(this._self, this._then);

  final ConversationShop _self;
  final $Res Function(ConversationShop) _then;

/// Create a copy of ConversationShop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? mainPhotoUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mainPhotoUrl: freezed == mainPhotoUrl ? _self.mainPhotoUrl : mainPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationShop].
extension ConversationShopPatterns on ConversationShop {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationShop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationShop() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationShop value)  $default,){
final _that = this;
switch (_that) {
case _ConversationShop():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationShop value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationShop() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'main_photo_url')  String? mainPhotoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationShop() when $default != null:
return $default(_that.id,_that.name,_that.mainPhotoUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'main_photo_url')  String? mainPhotoUrl)  $default,) {final _that = this;
switch (_that) {
case _ConversationShop():
return $default(_that.id,_that.name,_that.mainPhotoUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'main_photo_url')  String? mainPhotoUrl)?  $default,) {final _that = this;
switch (_that) {
case _ConversationShop() when $default != null:
return $default(_that.id,_that.name,_that.mainPhotoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationShop implements ConversationShop {
  const _ConversationShop({required this.id, required this.name, @JsonKey(name: 'main_photo_url') this.mainPhotoUrl});
  factory _ConversationShop.fromJson(Map<String, dynamic> json) => _$ConversationShopFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'main_photo_url') final  String? mainPhotoUrl;

/// Create a copy of ConversationShop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationShopCopyWith<_ConversationShop> get copyWith => __$ConversationShopCopyWithImpl<_ConversationShop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationShopToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationShop&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mainPhotoUrl, mainPhotoUrl) || other.mainPhotoUrl == mainPhotoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mainPhotoUrl);

@override
String toString() {
  return 'ConversationShop(id: $id, name: $name, mainPhotoUrl: $mainPhotoUrl)';
}


}

/// @nodoc
abstract mixin class _$ConversationShopCopyWith<$Res> implements $ConversationShopCopyWith<$Res> {
  factory _$ConversationShopCopyWith(_ConversationShop value, $Res Function(_ConversationShop) _then) = __$ConversationShopCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'main_photo_url') String? mainPhotoUrl
});




}
/// @nodoc
class __$ConversationShopCopyWithImpl<$Res>
    implements _$ConversationShopCopyWith<$Res> {
  __$ConversationShopCopyWithImpl(this._self, this._then);

  final _ConversationShop _self;
  final $Res Function(_ConversationShop) _then;

/// Create a copy of ConversationShop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? mainPhotoUrl = freezed,}) {
  return _then(_ConversationShop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mainPhotoUrl: freezed == mainPhotoUrl ? _self.mainPhotoUrl : mainPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ConversationProduct {

 int get id; String get name;@JsonKey(name: 'image_url') String? get imageUrl; double get price;
/// Create a copy of ConversationProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationProductCopyWith<ConversationProduct> get copyWith => _$ConversationProductCopyWithImpl<ConversationProduct>(this as ConversationProduct, _$identity);

  /// Serializes this ConversationProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,price);

@override
String toString() {
  return 'ConversationProduct(id: $id, name: $name, imageUrl: $imageUrl, price: $price)';
}


}

/// @nodoc
abstract mixin class $ConversationProductCopyWith<$Res>  {
  factory $ConversationProductCopyWith(ConversationProduct value, $Res Function(ConversationProduct) _then) = _$ConversationProductCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'image_url') String? imageUrl, double price
});




}
/// @nodoc
class _$ConversationProductCopyWithImpl<$Res>
    implements $ConversationProductCopyWith<$Res> {
  _$ConversationProductCopyWithImpl(this._self, this._then);

  final ConversationProduct _self;
  final $Res Function(ConversationProduct) _then;

/// Create a copy of ConversationProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,Object? price = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationProduct].
extension ConversationProductPatterns on ConversationProduct {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationProduct() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationProduct value)  $default,){
final _that = this;
switch (_that) {
case _ConversationProduct():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationProduct value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationProduct() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'image_url')  String? imageUrl,  double price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationProduct() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.price);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'image_url')  String? imageUrl,  double price)  $default,) {final _that = this;
switch (_that) {
case _ConversationProduct():
return $default(_that.id,_that.name,_that.imageUrl,_that.price);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'image_url')  String? imageUrl,  double price)?  $default,) {final _that = this;
switch (_that) {
case _ConversationProduct() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationProduct implements ConversationProduct {
  const _ConversationProduct({required this.id, required this.name, @JsonKey(name: 'image_url') this.imageUrl, required this.price});
  factory _ConversationProduct.fromJson(Map<String, dynamic> json) => _$ConversationProductFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override final  double price;

/// Create a copy of ConversationProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationProductCopyWith<_ConversationProduct> get copyWith => __$ConversationProductCopyWithImpl<_ConversationProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,price);

@override
String toString() {
  return 'ConversationProduct(id: $id, name: $name, imageUrl: $imageUrl, price: $price)';
}


}

/// @nodoc
abstract mixin class _$ConversationProductCopyWith<$Res> implements $ConversationProductCopyWith<$Res> {
  factory _$ConversationProductCopyWith(_ConversationProduct value, $Res Function(_ConversationProduct) _then) = __$ConversationProductCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'image_url') String? imageUrl, double price
});




}
/// @nodoc
class __$ConversationProductCopyWithImpl<$Res>
    implements _$ConversationProductCopyWith<$Res> {
  __$ConversationProductCopyWithImpl(this._self, this._then);

  final _ConversationProduct _self;
  final $Res Function(_ConversationProduct) _then;

/// Create a copy of ConversationProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,Object? price = null,}) {
  return _then(_ConversationProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ConversationMarketplaceItem {

 int get id; String get name;@JsonKey(name: 'image_url') String? get imageUrl; double get price;
/// Create a copy of ConversationMarketplaceItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationMarketplaceItemCopyWith<ConversationMarketplaceItem> get copyWith => _$ConversationMarketplaceItemCopyWithImpl<ConversationMarketplaceItem>(this as ConversationMarketplaceItem, _$identity);

  /// Serializes this ConversationMarketplaceItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationMarketplaceItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,price);

@override
String toString() {
  return 'ConversationMarketplaceItem(id: $id, name: $name, imageUrl: $imageUrl, price: $price)';
}


}

/// @nodoc
abstract mixin class $ConversationMarketplaceItemCopyWith<$Res>  {
  factory $ConversationMarketplaceItemCopyWith(ConversationMarketplaceItem value, $Res Function(ConversationMarketplaceItem) _then) = _$ConversationMarketplaceItemCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'image_url') String? imageUrl, double price
});




}
/// @nodoc
class _$ConversationMarketplaceItemCopyWithImpl<$Res>
    implements $ConversationMarketplaceItemCopyWith<$Res> {
  _$ConversationMarketplaceItemCopyWithImpl(this._self, this._then);

  final ConversationMarketplaceItem _self;
  final $Res Function(ConversationMarketplaceItem) _then;

/// Create a copy of ConversationMarketplaceItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,Object? price = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationMarketplaceItem].
extension ConversationMarketplaceItemPatterns on ConversationMarketplaceItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationMarketplaceItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationMarketplaceItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationMarketplaceItem value)  $default,){
final _that = this;
switch (_that) {
case _ConversationMarketplaceItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationMarketplaceItem value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationMarketplaceItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'image_url')  String? imageUrl,  double price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationMarketplaceItem() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.price);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'image_url')  String? imageUrl,  double price)  $default,) {final _that = this;
switch (_that) {
case _ConversationMarketplaceItem():
return $default(_that.id,_that.name,_that.imageUrl,_that.price);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'image_url')  String? imageUrl,  double price)?  $default,) {final _that = this;
switch (_that) {
case _ConversationMarketplaceItem() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationMarketplaceItem implements ConversationMarketplaceItem {
  const _ConversationMarketplaceItem({required this.id, required this.name, @JsonKey(name: 'image_url') this.imageUrl, required this.price});
  factory _ConversationMarketplaceItem.fromJson(Map<String, dynamic> json) => _$ConversationMarketplaceItemFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override final  double price;

/// Create a copy of ConversationMarketplaceItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationMarketplaceItemCopyWith<_ConversationMarketplaceItem> get copyWith => __$ConversationMarketplaceItemCopyWithImpl<_ConversationMarketplaceItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationMarketplaceItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationMarketplaceItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,price);

@override
String toString() {
  return 'ConversationMarketplaceItem(id: $id, name: $name, imageUrl: $imageUrl, price: $price)';
}


}

/// @nodoc
abstract mixin class _$ConversationMarketplaceItemCopyWith<$Res> implements $ConversationMarketplaceItemCopyWith<$Res> {
  factory _$ConversationMarketplaceItemCopyWith(_ConversationMarketplaceItem value, $Res Function(_ConversationMarketplaceItem) _then) = __$ConversationMarketplaceItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'image_url') String? imageUrl, double price
});




}
/// @nodoc
class __$ConversationMarketplaceItemCopyWithImpl<$Res>
    implements _$ConversationMarketplaceItemCopyWith<$Res> {
  __$ConversationMarketplaceItemCopyWithImpl(this._self, this._then);

  final _ConversationMarketplaceItem _self;
  final $Res Function(_ConversationMarketplaceItem) _then;

/// Create a copy of ConversationMarketplaceItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,Object? price = null,}) {
  return _then(_ConversationMarketplaceItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$LatestMessage {

 String get content; String get type;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'sender_id') int get senderId;
/// Create a copy of LatestMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LatestMessageCopyWith<LatestMessage> get copyWith => _$LatestMessageCopyWithImpl<LatestMessage>(this as LatestMessage, _$identity);

  /// Serializes this LatestMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LatestMessage&&(identical(other.content, content) || other.content == content)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.senderId, senderId) || other.senderId == senderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,type,createdAt,senderId);

@override
String toString() {
  return 'LatestMessage(content: $content, type: $type, createdAt: $createdAt, senderId: $senderId)';
}


}

/// @nodoc
abstract mixin class $LatestMessageCopyWith<$Res>  {
  factory $LatestMessageCopyWith(LatestMessage value, $Res Function(LatestMessage) _then) = _$LatestMessageCopyWithImpl;
@useResult
$Res call({
 String content, String type,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'sender_id') int senderId
});




}
/// @nodoc
class _$LatestMessageCopyWithImpl<$Res>
    implements $LatestMessageCopyWith<$Res> {
  _$LatestMessageCopyWithImpl(this._self, this._then);

  final LatestMessage _self;
  final $Res Function(LatestMessage) _then;

/// Create a copy of LatestMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? type = null,Object? createdAt = freezed,Object? senderId = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LatestMessage].
extension LatestMessagePatterns on LatestMessage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LatestMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LatestMessage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LatestMessage value)  $default,){
final _that = this;
switch (_that) {
case _LatestMessage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LatestMessage value)?  $default,){
final _that = this;
switch (_that) {
case _LatestMessage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content,  String type, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'sender_id')  int senderId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LatestMessage() when $default != null:
return $default(_that.content,_that.type,_that.createdAt,_that.senderId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content,  String type, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'sender_id')  int senderId)  $default,) {final _that = this;
switch (_that) {
case _LatestMessage():
return $default(_that.content,_that.type,_that.createdAt,_that.senderId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content,  String type, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'sender_id')  int senderId)?  $default,) {final _that = this;
switch (_that) {
case _LatestMessage() when $default != null:
return $default(_that.content,_that.type,_that.createdAt,_that.senderId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LatestMessage implements LatestMessage {
  const _LatestMessage({required this.content, required this.type, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'sender_id') required this.senderId});
  factory _LatestMessage.fromJson(Map<String, dynamic> json) => _$LatestMessageFromJson(json);

@override final  String content;
@override final  String type;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'sender_id') final  int senderId;

/// Create a copy of LatestMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LatestMessageCopyWith<_LatestMessage> get copyWith => __$LatestMessageCopyWithImpl<_LatestMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LatestMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LatestMessage&&(identical(other.content, content) || other.content == content)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.senderId, senderId) || other.senderId == senderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,type,createdAt,senderId);

@override
String toString() {
  return 'LatestMessage(content: $content, type: $type, createdAt: $createdAt, senderId: $senderId)';
}


}

/// @nodoc
abstract mixin class _$LatestMessageCopyWith<$Res> implements $LatestMessageCopyWith<$Res> {
  factory _$LatestMessageCopyWith(_LatestMessage value, $Res Function(_LatestMessage) _then) = __$LatestMessageCopyWithImpl;
@override @useResult
$Res call({
 String content, String type,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'sender_id') int senderId
});




}
/// @nodoc
class __$LatestMessageCopyWithImpl<$Res>
    implements _$LatestMessageCopyWith<$Res> {
  __$LatestMessageCopyWithImpl(this._self, this._then);

  final _LatestMessage _self;
  final $Res Function(_LatestMessage) _then;

/// Create a copy of LatestMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? type = null,Object? createdAt = freezed,Object? senderId = null,}) {
  return _then(_LatestMessage(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
