import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
abstract class Address with _$Address {
  const factory Address({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String label,
    @JsonKey(name: 'address_line_1') required String addressLine1,
    @JsonKey(name: 'address_line_2') String? addressLine2,
    required String city,
    String? state,
    @JsonKey(name: 'zip_code') String? zipCode,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}
