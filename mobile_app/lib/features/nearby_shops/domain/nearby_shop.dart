import 'package:freezed_annotation/freezed_annotation.dart';

part 'nearby_shop.freezed.dart';
part 'nearby_shop.g.dart';

@freezed
abstract class NearbyShop with _$NearbyShop {
  const factory NearbyShop({
    required int id,
    @JsonKey(name: 'owner_id') required int ownerId,
    required String name,
    required String type,
    String? description,
    required String address,
    required String city,
    required String province,
    double? latitude,
    double? longitude,
    List<String>? photos,
    required String phone,
    String? email,
    @Default('approved') String status,
    @JsonKey(name: 'primary_photo_url') String? primaryPhotoUrl,
    @JsonKey(name: 'products_count') @Default(0) int productsCount,
    @JsonKey(name: 'distance') double? distance, // Distance in km from user
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _NearbyShop;


  const NearbyShop._();

  factory NearbyShop.fromJson(Map<String, dynamic> json) => _$NearbyShopFromJson(json);
}

@freezed
abstract class NearbyShopsResponse with _$NearbyShopsResponse {
  const factory NearbyShopsResponse({
    required List<NearbyShop> shops,
    required int total,
    @JsonKey(name: 'search_radius_km') required double searchRadiusKm,
    @JsonKey(name: 'user_location') required UserLocation userLocation,
  }) = _NearbyShopsResponse;

  factory NearbyShopsResponse.fromJson(Map<String, dynamic> json) =>
      _$NearbyShopsResponseFromJson(json);
}

@freezed
abstract class UserLocation with _$UserLocation {
  const factory UserLocation({
    required double latitude,
    required double longitude,
  }) = _UserLocation;

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);
}
