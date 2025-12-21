import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop.freezed.dart';
part 'shop.g.dart';

@freezed
abstract class Shop with _$Shop {
  const factory Shop({
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
    @JsonKey(name: 'business_license') String? businessLicense,
    @JsonKey(name: 'owner_nid') String? ownerNid,
    required String phone,
    String? email,
    @Default('pending') String status,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
    @JsonKey(name: 'approved_at') DateTime? approvedAt,
    @JsonKey(name: 'primary_photo_url') String? primaryPhotoUrl,
    @JsonKey(name: 'business_license_url') String? businessLicenseUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Shop;

  const Shop._();

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isSuspended => status == 'suspended';

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
}
