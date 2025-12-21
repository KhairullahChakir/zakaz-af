// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Shop {

 int get id;@JsonKey(name: 'owner_id') int get ownerId; String get name; String get type; String? get description; String get address; String get city; String get province; double? get latitude; double? get longitude; List<String>? get photos;@JsonKey(name: 'business_license') String? get businessLicense;@JsonKey(name: 'owner_nid') String? get ownerNid; String get phone; String? get email; String get status;@JsonKey(name: 'rejection_reason') String? get rejectionReason;@JsonKey(name: 'approved_at') DateTime? get approvedAt;@JsonKey(name: 'primary_photo_url') String? get primaryPhotoUrl;@JsonKey(name: 'business_license_url') String? get businessLicenseUrl;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopCopyWith<Shop> get copyWith => _$ShopCopyWithImpl<Shop>(this as Shop, _$identity);

  /// Serializes this Shop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Shop&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.province, province) || other.province == province)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.businessLicense, businessLicense) || other.businessLicense == businessLicense)&&(identical(other.ownerNid, ownerNid) || other.ownerNid == ownerNid)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.primaryPhotoUrl, primaryPhotoUrl) || other.primaryPhotoUrl == primaryPhotoUrl)&&(identical(other.businessLicenseUrl, businessLicenseUrl) || other.businessLicenseUrl == businessLicenseUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,ownerId,name,type,description,address,city,province,latitude,longitude,const DeepCollectionEquality().hash(photos),businessLicense,ownerNid,phone,email,status,rejectionReason,approvedAt,primaryPhotoUrl,businessLicenseUrl,createdAt]);

@override
String toString() {
  return 'Shop(id: $id, ownerId: $ownerId, name: $name, type: $type, description: $description, address: $address, city: $city, province: $province, latitude: $latitude, longitude: $longitude, photos: $photos, businessLicense: $businessLicense, ownerNid: $ownerNid, phone: $phone, email: $email, status: $status, rejectionReason: $rejectionReason, approvedAt: $approvedAt, primaryPhotoUrl: $primaryPhotoUrl, businessLicenseUrl: $businessLicenseUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ShopCopyWith<$Res>  {
  factory $ShopCopyWith(Shop value, $Res Function(Shop) _then) = _$ShopCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'owner_id') int ownerId, String name, String type, String? description, String address, String city, String province, double? latitude, double? longitude, List<String>? photos,@JsonKey(name: 'business_license') String? businessLicense,@JsonKey(name: 'owner_nid') String? ownerNid, String phone, String? email, String status,@JsonKey(name: 'rejection_reason') String? rejectionReason,@JsonKey(name: 'approved_at') DateTime? approvedAt,@JsonKey(name: 'primary_photo_url') String? primaryPhotoUrl,@JsonKey(name: 'business_license_url') String? businessLicenseUrl,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$ShopCopyWithImpl<$Res>
    implements $ShopCopyWith<$Res> {
  _$ShopCopyWithImpl(this._self, this._then);

  final Shop _self;
  final $Res Function(Shop) _then;

/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? type = null,Object? description = freezed,Object? address = null,Object? city = null,Object? province = null,Object? latitude = freezed,Object? longitude = freezed,Object? photos = freezed,Object? businessLicense = freezed,Object? ownerNid = freezed,Object? phone = null,Object? email = freezed,Object? status = null,Object? rejectionReason = freezed,Object? approvedAt = freezed,Object? primaryPhotoUrl = freezed,Object? businessLicenseUrl = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,province: null == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,photos: freezed == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>?,businessLicense: freezed == businessLicense ? _self.businessLicense : businessLicense // ignore: cast_nullable_to_non_nullable
as String?,ownerNid: freezed == ownerNid ? _self.ownerNid : ownerNid // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,primaryPhotoUrl: freezed == primaryPhotoUrl ? _self.primaryPhotoUrl : primaryPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,businessLicenseUrl: freezed == businessLicenseUrl ? _self.businessLicenseUrl : businessLicenseUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Shop].
extension ShopPatterns on Shop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Shop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Shop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Shop value)  $default,){
final _that = this;
switch (_that) {
case _Shop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Shop value)?  $default,){
final _that = this;
switch (_that) {
case _Shop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'owner_id')  int ownerId,  String name,  String type,  String? description,  String address,  String city,  String province,  double? latitude,  double? longitude,  List<String>? photos, @JsonKey(name: 'business_license')  String? businessLicense, @JsonKey(name: 'owner_nid')  String? ownerNid,  String phone,  String? email,  String status, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'approved_at')  DateTime? approvedAt, @JsonKey(name: 'primary_photo_url')  String? primaryPhotoUrl, @JsonKey(name: 'business_license_url')  String? businessLicenseUrl, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Shop() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.type,_that.description,_that.address,_that.city,_that.province,_that.latitude,_that.longitude,_that.photos,_that.businessLicense,_that.ownerNid,_that.phone,_that.email,_that.status,_that.rejectionReason,_that.approvedAt,_that.primaryPhotoUrl,_that.businessLicenseUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'owner_id')  int ownerId,  String name,  String type,  String? description,  String address,  String city,  String province,  double? latitude,  double? longitude,  List<String>? photos, @JsonKey(name: 'business_license')  String? businessLicense, @JsonKey(name: 'owner_nid')  String? ownerNid,  String phone,  String? email,  String status, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'approved_at')  DateTime? approvedAt, @JsonKey(name: 'primary_photo_url')  String? primaryPhotoUrl, @JsonKey(name: 'business_license_url')  String? businessLicenseUrl, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Shop():
return $default(_that.id,_that.ownerId,_that.name,_that.type,_that.description,_that.address,_that.city,_that.province,_that.latitude,_that.longitude,_that.photos,_that.businessLicense,_that.ownerNid,_that.phone,_that.email,_that.status,_that.rejectionReason,_that.approvedAt,_that.primaryPhotoUrl,_that.businessLicenseUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'owner_id')  int ownerId,  String name,  String type,  String? description,  String address,  String city,  String province,  double? latitude,  double? longitude,  List<String>? photos, @JsonKey(name: 'business_license')  String? businessLicense, @JsonKey(name: 'owner_nid')  String? ownerNid,  String phone,  String? email,  String status, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'approved_at')  DateTime? approvedAt, @JsonKey(name: 'primary_photo_url')  String? primaryPhotoUrl, @JsonKey(name: 'business_license_url')  String? businessLicenseUrl, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Shop() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.type,_that.description,_that.address,_that.city,_that.province,_that.latitude,_that.longitude,_that.photos,_that.businessLicense,_that.ownerNid,_that.phone,_that.email,_that.status,_that.rejectionReason,_that.approvedAt,_that.primaryPhotoUrl,_that.businessLicenseUrl,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Shop extends Shop {
  const _Shop({required this.id, @JsonKey(name: 'owner_id') required this.ownerId, required this.name, required this.type, this.description, required this.address, required this.city, required this.province, this.latitude, this.longitude, final  List<String>? photos, @JsonKey(name: 'business_license') this.businessLicense, @JsonKey(name: 'owner_nid') this.ownerNid, required this.phone, this.email, this.status = 'pending', @JsonKey(name: 'rejection_reason') this.rejectionReason, @JsonKey(name: 'approved_at') this.approvedAt, @JsonKey(name: 'primary_photo_url') this.primaryPhotoUrl, @JsonKey(name: 'business_license_url') this.businessLicenseUrl, @JsonKey(name: 'created_at') this.createdAt}): _photos = photos,super._();
  factory _Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

@override final  int id;
@override@JsonKey(name: 'owner_id') final  int ownerId;
@override final  String name;
@override final  String type;
@override final  String? description;
@override final  String address;
@override final  String city;
@override final  String province;
@override final  double? latitude;
@override final  double? longitude;
 final  List<String>? _photos;
@override List<String>? get photos {
  final value = _photos;
  if (value == null) return null;
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'business_license') final  String? businessLicense;
@override@JsonKey(name: 'owner_nid') final  String? ownerNid;
@override final  String phone;
@override final  String? email;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'rejection_reason') final  String? rejectionReason;
@override@JsonKey(name: 'approved_at') final  DateTime? approvedAt;
@override@JsonKey(name: 'primary_photo_url') final  String? primaryPhotoUrl;
@override@JsonKey(name: 'business_license_url') final  String? businessLicenseUrl;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShopCopyWith<_Shop> get copyWith => __$ShopCopyWithImpl<_Shop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShopToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Shop&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.province, province) || other.province == province)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.businessLicense, businessLicense) || other.businessLicense == businessLicense)&&(identical(other.ownerNid, ownerNid) || other.ownerNid == ownerNid)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.primaryPhotoUrl, primaryPhotoUrl) || other.primaryPhotoUrl == primaryPhotoUrl)&&(identical(other.businessLicenseUrl, businessLicenseUrl) || other.businessLicenseUrl == businessLicenseUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,ownerId,name,type,description,address,city,province,latitude,longitude,const DeepCollectionEquality().hash(_photos),businessLicense,ownerNid,phone,email,status,rejectionReason,approvedAt,primaryPhotoUrl,businessLicenseUrl,createdAt]);

@override
String toString() {
  return 'Shop(id: $id, ownerId: $ownerId, name: $name, type: $type, description: $description, address: $address, city: $city, province: $province, latitude: $latitude, longitude: $longitude, photos: $photos, businessLicense: $businessLicense, ownerNid: $ownerNid, phone: $phone, email: $email, status: $status, rejectionReason: $rejectionReason, approvedAt: $approvedAt, primaryPhotoUrl: $primaryPhotoUrl, businessLicenseUrl: $businessLicenseUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ShopCopyWith<$Res> implements $ShopCopyWith<$Res> {
  factory _$ShopCopyWith(_Shop value, $Res Function(_Shop) _then) = __$ShopCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'owner_id') int ownerId, String name, String type, String? description, String address, String city, String province, double? latitude, double? longitude, List<String>? photos,@JsonKey(name: 'business_license') String? businessLicense,@JsonKey(name: 'owner_nid') String? ownerNid, String phone, String? email, String status,@JsonKey(name: 'rejection_reason') String? rejectionReason,@JsonKey(name: 'approved_at') DateTime? approvedAt,@JsonKey(name: 'primary_photo_url') String? primaryPhotoUrl,@JsonKey(name: 'business_license_url') String? businessLicenseUrl,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$ShopCopyWithImpl<$Res>
    implements _$ShopCopyWith<$Res> {
  __$ShopCopyWithImpl(this._self, this._then);

  final _Shop _self;
  final $Res Function(_Shop) _then;

/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? type = null,Object? description = freezed,Object? address = null,Object? city = null,Object? province = null,Object? latitude = freezed,Object? longitude = freezed,Object? photos = freezed,Object? businessLicense = freezed,Object? ownerNid = freezed,Object? phone = null,Object? email = freezed,Object? status = null,Object? rejectionReason = freezed,Object? approvedAt = freezed,Object? primaryPhotoUrl = freezed,Object? businessLicenseUrl = freezed,Object? createdAt = freezed,}) {
  return _then(_Shop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,province: null == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,photos: freezed == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>?,businessLicense: freezed == businessLicense ? _self.businessLicense : businessLicense // ignore: cast_nullable_to_non_nullable
as String?,ownerNid: freezed == ownerNid ? _self.ownerNid : ownerNid // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,primaryPhotoUrl: freezed == primaryPhotoUrl ? _self.primaryPhotoUrl : primaryPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,businessLicenseUrl: freezed == businessLicenseUrl ? _self.businessLicenseUrl : businessLicenseUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
