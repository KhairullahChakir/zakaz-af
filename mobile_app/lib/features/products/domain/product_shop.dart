import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_shop.freezed.dart';
part 'product_shop.g.dart';

/// Simplified shop info for product display
@freezed
abstract class ProductShop with _$ProductShop {
  const factory ProductShop({
    required int id,
    required String name,
    @JsonKey(name: 'shop_type') String? shopType,
    String? phone,
    String? city,
    String? district,
    @JsonKey(name: 'main_photo_url') String? mainPhotoUrl,
    ProductShopOwner? owner,
  }) = _ProductShop;

  factory ProductShop.fromJson(Map<String, dynamic> json) => _$ProductShopFromJson(json);
}

@freezed
abstract class ProductShopOwner with _$ProductShopOwner {
  const factory ProductShopOwner({
    required int id,
    required String name,
    String? email,
    String? phone,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
  }) = _ProductShopOwner;

  factory ProductShopOwner.fromJson(Map<String, dynamic> json) => _$ProductShopOwnerFromJson(json);
}
