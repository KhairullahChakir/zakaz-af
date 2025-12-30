import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
abstract class Address with _$Address {
  const factory Address({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String label,
    
    // Recipient Information
    @JsonKey(name: 'recipient_name') String? recipientName,
    @JsonKey(name: 'phone_primary') String? phonePrimary,
    @JsonKey(name: 'phone_secondary') String? phoneSecondary,
    
    // Legacy fields (backward compatibility)
    @JsonKey(name: 'address_line_1') required String addressLine1,
    @JsonKey(name: 'address_line_2') String? addressLine2,
    required String city,
    String? state,
    @JsonKey(name: 'zip_code') String? zipCode,
    
    // Enhanced Location
    @Default('Afghanistan') String country,
    String? province,
    String? district,
    String? street,
    @JsonKey(name: 'house_number') String? houseNumber,
    @JsonKey(name: 'apartment_number') String? apartmentNumber,
    
    // Additional
    @JsonKey(name: 'delivery_instructions') String? deliveryInstructions,
    double? latitude,
    double? longitude,
    
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}

/// Extension to provide formatted address string
extension AddressFormatting on Address {
  /// Get a formatted display address
  String get formattedAddress {
    final parts = <String>[];
    
    if (houseNumber != null && houseNumber!.isNotEmpty) {
      parts.add('House $houseNumber');
    }
    if (apartmentNumber != null && apartmentNumber!.isNotEmpty) {
      parts.add('Apt $apartmentNumber');
    }
    if (street != null && street!.isNotEmpty) {
      parts.add(street!);
    }
    if (district != null && district!.isNotEmpty) {
      parts.add(district!);
    }
    parts.add(city);
    if (province != null && province!.isNotEmpty) {
      parts.add(province!);
    }
    parts.add(country);
    
    return parts.join(', ');
  }
  
  /// Get display name (recipient name or label)
  String get displayName => recipientName ?? label;
  
  /// Get primary contact number
  String get primaryContact => phonePrimary ?? '';
}
