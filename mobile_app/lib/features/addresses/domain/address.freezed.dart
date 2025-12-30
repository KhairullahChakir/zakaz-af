// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Address {

 int get id;@JsonKey(name: 'user_id') int get userId; String get label;// Recipient Information
@JsonKey(name: 'recipient_name') String? get recipientName;@JsonKey(name: 'phone_primary') String? get phonePrimary;@JsonKey(name: 'phone_secondary') String? get phoneSecondary;// Legacy fields (backward compatibility)
@JsonKey(name: 'address_line_1') String get addressLine1;@JsonKey(name: 'address_line_2') String? get addressLine2; String get city; String? get state;@JsonKey(name: 'zip_code') String? get zipCode;// Enhanced Location
 String get country; String? get province; String? get district; String? get street;@JsonKey(name: 'house_number') String? get houseNumber;@JsonKey(name: 'apartment_number') String? get apartmentNumber;// Additional
@JsonKey(name: 'delivery_instructions') String? get deliveryInstructions; double? get latitude; double? get longitude;@JsonKey(name: 'is_default') bool get isDefault;
/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressCopyWith<Address> get copyWith => _$AddressCopyWithImpl<Address>(this as Address, _$identity);

  /// Serializes this Address to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Address&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.label, label) || other.label == label)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.phonePrimary, phonePrimary) || other.phonePrimary == phonePrimary)&&(identical(other.phoneSecondary, phoneSecondary) || other.phoneSecondary == phoneSecondary)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.addressLine2, addressLine2) || other.addressLine2 == addressLine2)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.country, country) || other.country == country)&&(identical(other.province, province) || other.province == province)&&(identical(other.district, district) || other.district == district)&&(identical(other.street, street) || other.street == street)&&(identical(other.houseNumber, houseNumber) || other.houseNumber == houseNumber)&&(identical(other.apartmentNumber, apartmentNumber) || other.apartmentNumber == apartmentNumber)&&(identical(other.deliveryInstructions, deliveryInstructions) || other.deliveryInstructions == deliveryInstructions)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,label,recipientName,phonePrimary,phoneSecondary,addressLine1,addressLine2,city,state,zipCode,country,province,district,street,houseNumber,apartmentNumber,deliveryInstructions,latitude,longitude,isDefault]);

@override
String toString() {
  return 'Address(id: $id, userId: $userId, label: $label, recipientName: $recipientName, phonePrimary: $phonePrimary, phoneSecondary: $phoneSecondary, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, zipCode: $zipCode, country: $country, province: $province, district: $district, street: $street, houseNumber: $houseNumber, apartmentNumber: $apartmentNumber, deliveryInstructions: $deliveryInstructions, latitude: $latitude, longitude: $longitude, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $AddressCopyWith<$Res>  {
  factory $AddressCopyWith(Address value, $Res Function(Address) _then) = _$AddressCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId, String label,@JsonKey(name: 'recipient_name') String? recipientName,@JsonKey(name: 'phone_primary') String? phonePrimary,@JsonKey(name: 'phone_secondary') String? phoneSecondary,@JsonKey(name: 'address_line_1') String addressLine1,@JsonKey(name: 'address_line_2') String? addressLine2, String city, String? state,@JsonKey(name: 'zip_code') String? zipCode, String country, String? province, String? district, String? street,@JsonKey(name: 'house_number') String? houseNumber,@JsonKey(name: 'apartment_number') String? apartmentNumber,@JsonKey(name: 'delivery_instructions') String? deliveryInstructions, double? latitude, double? longitude,@JsonKey(name: 'is_default') bool isDefault
});




}
/// @nodoc
class _$AddressCopyWithImpl<$Res>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._self, this._then);

  final Address _self;
  final $Res Function(Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? label = null,Object? recipientName = freezed,Object? phonePrimary = freezed,Object? phoneSecondary = freezed,Object? addressLine1 = null,Object? addressLine2 = freezed,Object? city = null,Object? state = freezed,Object? zipCode = freezed,Object? country = null,Object? province = freezed,Object? district = freezed,Object? street = freezed,Object? houseNumber = freezed,Object? apartmentNumber = freezed,Object? deliveryInstructions = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? isDefault = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,recipientName: freezed == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String?,phonePrimary: freezed == phonePrimary ? _self.phonePrimary : phonePrimary // ignore: cast_nullable_to_non_nullable
as String?,phoneSecondary: freezed == phoneSecondary ? _self.phoneSecondary : phoneSecondary // ignore: cast_nullable_to_non_nullable
as String?,addressLine1: null == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String,addressLine2: freezed == addressLine2 ? _self.addressLine2 : addressLine2 // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,zipCode: freezed == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,street: freezed == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String?,houseNumber: freezed == houseNumber ? _self.houseNumber : houseNumber // ignore: cast_nullable_to_non_nullable
as String?,apartmentNumber: freezed == apartmentNumber ? _self.apartmentNumber : apartmentNumber // ignore: cast_nullable_to_non_nullable
as String?,deliveryInstructions: freezed == deliveryInstructions ? _self.deliveryInstructions : deliveryInstructions // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Address].
extension AddressPatterns on Address {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Address value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Address value)  $default,){
final _that = this;
switch (_that) {
case _Address():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Address value)?  $default,){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId,  String label, @JsonKey(name: 'recipient_name')  String? recipientName, @JsonKey(name: 'phone_primary')  String? phonePrimary, @JsonKey(name: 'phone_secondary')  String? phoneSecondary, @JsonKey(name: 'address_line_1')  String addressLine1, @JsonKey(name: 'address_line_2')  String? addressLine2,  String city,  String? state, @JsonKey(name: 'zip_code')  String? zipCode,  String country,  String? province,  String? district,  String? street, @JsonKey(name: 'house_number')  String? houseNumber, @JsonKey(name: 'apartment_number')  String? apartmentNumber, @JsonKey(name: 'delivery_instructions')  String? deliveryInstructions,  double? latitude,  double? longitude, @JsonKey(name: 'is_default')  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.id,_that.userId,_that.label,_that.recipientName,_that.phonePrimary,_that.phoneSecondary,_that.addressLine1,_that.addressLine2,_that.city,_that.state,_that.zipCode,_that.country,_that.province,_that.district,_that.street,_that.houseNumber,_that.apartmentNumber,_that.deliveryInstructions,_that.latitude,_that.longitude,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId,  String label, @JsonKey(name: 'recipient_name')  String? recipientName, @JsonKey(name: 'phone_primary')  String? phonePrimary, @JsonKey(name: 'phone_secondary')  String? phoneSecondary, @JsonKey(name: 'address_line_1')  String addressLine1, @JsonKey(name: 'address_line_2')  String? addressLine2,  String city,  String? state, @JsonKey(name: 'zip_code')  String? zipCode,  String country,  String? province,  String? district,  String? street, @JsonKey(name: 'house_number')  String? houseNumber, @JsonKey(name: 'apartment_number')  String? apartmentNumber, @JsonKey(name: 'delivery_instructions')  String? deliveryInstructions,  double? latitude,  double? longitude, @JsonKey(name: 'is_default')  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _Address():
return $default(_that.id,_that.userId,_that.label,_that.recipientName,_that.phonePrimary,_that.phoneSecondary,_that.addressLine1,_that.addressLine2,_that.city,_that.state,_that.zipCode,_that.country,_that.province,_that.district,_that.street,_that.houseNumber,_that.apartmentNumber,_that.deliveryInstructions,_that.latitude,_that.longitude,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id')  int userId,  String label, @JsonKey(name: 'recipient_name')  String? recipientName, @JsonKey(name: 'phone_primary')  String? phonePrimary, @JsonKey(name: 'phone_secondary')  String? phoneSecondary, @JsonKey(name: 'address_line_1')  String addressLine1, @JsonKey(name: 'address_line_2')  String? addressLine2,  String city,  String? state, @JsonKey(name: 'zip_code')  String? zipCode,  String country,  String? province,  String? district,  String? street, @JsonKey(name: 'house_number')  String? houseNumber, @JsonKey(name: 'apartment_number')  String? apartmentNumber, @JsonKey(name: 'delivery_instructions')  String? deliveryInstructions,  double? latitude,  double? longitude, @JsonKey(name: 'is_default')  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.id,_that.userId,_that.label,_that.recipientName,_that.phonePrimary,_that.phoneSecondary,_that.addressLine1,_that.addressLine2,_that.city,_that.state,_that.zipCode,_that.country,_that.province,_that.district,_that.street,_that.houseNumber,_that.apartmentNumber,_that.deliveryInstructions,_that.latitude,_that.longitude,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Address implements Address {
  const _Address({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.label, @JsonKey(name: 'recipient_name') this.recipientName, @JsonKey(name: 'phone_primary') this.phonePrimary, @JsonKey(name: 'phone_secondary') this.phoneSecondary, @JsonKey(name: 'address_line_1') required this.addressLine1, @JsonKey(name: 'address_line_2') this.addressLine2, required this.city, this.state, @JsonKey(name: 'zip_code') this.zipCode, this.country = 'Afghanistan', this.province, this.district, this.street, @JsonKey(name: 'house_number') this.houseNumber, @JsonKey(name: 'apartment_number') this.apartmentNumber, @JsonKey(name: 'delivery_instructions') this.deliveryInstructions, this.latitude, this.longitude, @JsonKey(name: 'is_default') this.isDefault = false});
  factory _Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id') final  int userId;
@override final  String label;
// Recipient Information
@override@JsonKey(name: 'recipient_name') final  String? recipientName;
@override@JsonKey(name: 'phone_primary') final  String? phonePrimary;
@override@JsonKey(name: 'phone_secondary') final  String? phoneSecondary;
// Legacy fields (backward compatibility)
@override@JsonKey(name: 'address_line_1') final  String addressLine1;
@override@JsonKey(name: 'address_line_2') final  String? addressLine2;
@override final  String city;
@override final  String? state;
@override@JsonKey(name: 'zip_code') final  String? zipCode;
// Enhanced Location
@override@JsonKey() final  String country;
@override final  String? province;
@override final  String? district;
@override final  String? street;
@override@JsonKey(name: 'house_number') final  String? houseNumber;
@override@JsonKey(name: 'apartment_number') final  String? apartmentNumber;
// Additional
@override@JsonKey(name: 'delivery_instructions') final  String? deliveryInstructions;
@override final  double? latitude;
@override final  double? longitude;
@override@JsonKey(name: 'is_default') final  bool isDefault;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressCopyWith<_Address> get copyWith => __$AddressCopyWithImpl<_Address>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Address&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.label, label) || other.label == label)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.phonePrimary, phonePrimary) || other.phonePrimary == phonePrimary)&&(identical(other.phoneSecondary, phoneSecondary) || other.phoneSecondary == phoneSecondary)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.addressLine2, addressLine2) || other.addressLine2 == addressLine2)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.country, country) || other.country == country)&&(identical(other.province, province) || other.province == province)&&(identical(other.district, district) || other.district == district)&&(identical(other.street, street) || other.street == street)&&(identical(other.houseNumber, houseNumber) || other.houseNumber == houseNumber)&&(identical(other.apartmentNumber, apartmentNumber) || other.apartmentNumber == apartmentNumber)&&(identical(other.deliveryInstructions, deliveryInstructions) || other.deliveryInstructions == deliveryInstructions)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,label,recipientName,phonePrimary,phoneSecondary,addressLine1,addressLine2,city,state,zipCode,country,province,district,street,houseNumber,apartmentNumber,deliveryInstructions,latitude,longitude,isDefault]);

@override
String toString() {
  return 'Address(id: $id, userId: $userId, label: $label, recipientName: $recipientName, phonePrimary: $phonePrimary, phoneSecondary: $phoneSecondary, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, zipCode: $zipCode, country: $country, province: $province, district: $district, street: $street, houseNumber: $houseNumber, apartmentNumber: $apartmentNumber, deliveryInstructions: $deliveryInstructions, latitude: $latitude, longitude: $longitude, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$AddressCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$AddressCopyWith(_Address value, $Res Function(_Address) _then) = __$AddressCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId, String label,@JsonKey(name: 'recipient_name') String? recipientName,@JsonKey(name: 'phone_primary') String? phonePrimary,@JsonKey(name: 'phone_secondary') String? phoneSecondary,@JsonKey(name: 'address_line_1') String addressLine1,@JsonKey(name: 'address_line_2') String? addressLine2, String city, String? state,@JsonKey(name: 'zip_code') String? zipCode, String country, String? province, String? district, String? street,@JsonKey(name: 'house_number') String? houseNumber,@JsonKey(name: 'apartment_number') String? apartmentNumber,@JsonKey(name: 'delivery_instructions') String? deliveryInstructions, double? latitude, double? longitude,@JsonKey(name: 'is_default') bool isDefault
});




}
/// @nodoc
class __$AddressCopyWithImpl<$Res>
    implements _$AddressCopyWith<$Res> {
  __$AddressCopyWithImpl(this._self, this._then);

  final _Address _self;
  final $Res Function(_Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? label = null,Object? recipientName = freezed,Object? phonePrimary = freezed,Object? phoneSecondary = freezed,Object? addressLine1 = null,Object? addressLine2 = freezed,Object? city = null,Object? state = freezed,Object? zipCode = freezed,Object? country = null,Object? province = freezed,Object? district = freezed,Object? street = freezed,Object? houseNumber = freezed,Object? apartmentNumber = freezed,Object? deliveryInstructions = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? isDefault = null,}) {
  return _then(_Address(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,recipientName: freezed == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String?,phonePrimary: freezed == phonePrimary ? _self.phonePrimary : phonePrimary // ignore: cast_nullable_to_non_nullable
as String?,phoneSecondary: freezed == phoneSecondary ? _self.phoneSecondary : phoneSecondary // ignore: cast_nullable_to_non_nullable
as String?,addressLine1: null == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String,addressLine2: freezed == addressLine2 ? _self.addressLine2 : addressLine2 // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,zipCode: freezed == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,street: freezed == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String?,houseNumber: freezed == houseNumber ? _self.houseNumber : houseNumber // ignore: cast_nullable_to_non_nullable
as String?,apartmentNumber: freezed == apartmentNumber ? _self.apartmentNumber : apartmentNumber // ignore: cast_nullable_to_non_nullable
as String?,deliveryInstructions: freezed == deliveryInstructions ? _self.deliveryInstructions : deliveryInstructions // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
