import 'package:freezed_annotation/freezed_annotation.dart';
import '../../products/domain/category.dart';
import '../../auth/domain/user.dart';

part 'marketplace_item.freezed.dart';
part 'marketplace_item.g.dart';

@freezed
abstract class MarketplaceItem with _$MarketplaceItem {
  const factory MarketplaceItem({
    required int id,
    @JsonKey(name: 'user_id', fromJson: _parseInt) required int userId,
    @JsonKey(name: 'category_id', fromJson: _parseIntNullable) int? categoryId,
    @JsonKey(fromJson: _parseString) required String name,
    @JsonKey(fromJson: _parseString) required String description,
    @JsonKey(fromJson: _parseDouble) required double price,
    @JsonKey(fromJson: _parseString) required String condition,
    @JsonKey(fromJson: _parseString) required String phone,
    String? location,
    @JsonKey(fromJson: _parseStringWithDefault) required String status,
    @JsonKey(name: 'main_image_url') String? mainImageUrl,
    @JsonKey(name: 'gallery_urls') List<String>? galleryUrls,
    User? user,
    Category? category,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'is_boosted') @Default(false) bool isBoosted,
    @JsonKey(name: 'boosted_until') String? boostedUntil,
  }) = _MarketplaceItem;

  factory MarketplaceItem.fromJson(Map<String, dynamic> json) => _$MarketplaceItemFromJson(json);
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int? _parseIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

String _parseString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

String _parseStringWithDefault(dynamic value) {
  if (value == null) return 'active';
  return value.toString();
}
