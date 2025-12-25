// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nearby_shop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NearbyShop {

 int get id;@JsonKey(name: 'owner_id') int get ownerId; String get name; String get type; String? get description; String get address; String get city; String get province; double? get latitude; double? get longitude; List<String>? get photos; String get phone; String? get email; String get status;@JsonKey(name: 'primary_photo_url') String? get primaryPhotoUrl;@JsonKey(name: 'products_count') int get productsCount;@JsonKey(name: 'distance') double? get distance;// Distance in km from user
@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of NearbyShop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NearbyShopCopyWith<NearbyShop> get copyWith => _$NearbyShopCopyWithImpl<NearbyShop>(this as NearbyShop, _$identity);

  /// Serializes this NearbyShop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyShop&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.province, province) || other.province == province)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.primaryPhotoUrl, primaryPhotoUrl) || other.primaryPhotoUrl == primaryPhotoUrl)&&(identical(other.productsCount, productsCount) || other.productsCount == productsCount)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,type,description,address,city,province,latitude,longitude,const DeepCollectionEquality().hash(photos),phone,email,status,primaryPhotoUrl,productsCount,distance,createdAt);

@override
String toString() {
  return 'NearbyShop(id: $id, ownerId: $ownerId, name: $name, type: $type, description: $description, address: $address, city: $city, province: $province, latitude: $latitude, longitude: $longitude, photos: $photos, phone: $phone, email: $email, status: $status, primaryPhotoUrl: $primaryPhotoUrl, productsCount: $productsCount, distance: $distance, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $NearbyShopCopyWith<$Res>  {
  factory $NearbyShopCopyWith(NearbyShop value, $Res Function(NearbyShop) _then) = _$NearbyShopCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'owner_id') int ownerId, String name, String type, String? description, String address, String city, String province, double? latitude, double? longitude, List<String>? photos, String phone, String? email, String status,@JsonKey(name: 'primary_photo_url') String? primaryPhotoUrl,@JsonKey(name: 'products_count') int productsCount,@JsonKey(name: 'distance') double? distance,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$NearbyShopCopyWithImpl<$Res>
    implements $NearbyShopCopyWith<$Res> {
  _$NearbyShopCopyWithImpl(this._self, this._then);

  final NearbyShop _self;
  final $Res Function(NearbyShop) _then;

/// Create a copy of NearbyShop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? type = null,Object? description = freezed,Object? address = null,Object? city = null,Object? province = null,Object? latitude = freezed,Object? longitude = freezed,Object? photos = freezed,Object? phone = null,Object? email = freezed,Object? status = null,Object? primaryPhotoUrl = freezed,Object? productsCount = null,Object? distance = freezed,Object? createdAt = freezed,}) {
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
as List<String>?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,primaryPhotoUrl: freezed == primaryPhotoUrl ? _self.primaryPhotoUrl : primaryPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,productsCount: null == productsCount ? _self.productsCount : productsCount // ignore: cast_nullable_to_non_nullable
as int,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NearbyShop].
extension NearbyShopPatterns on NearbyShop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NearbyShop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NearbyShop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NearbyShop value)  $default,){
final _that = this;
switch (_that) {
case _NearbyShop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NearbyShop value)?  $default,){
final _that = this;
switch (_that) {
case _NearbyShop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'owner_id')  int ownerId,  String name,  String type,  String? description,  String address,  String city,  String province,  double? latitude,  double? longitude,  List<String>? photos,  String phone,  String? email,  String status, @JsonKey(name: 'primary_photo_url')  String? primaryPhotoUrl, @JsonKey(name: 'products_count')  int productsCount, @JsonKey(name: 'distance')  double? distance, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NearbyShop() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.type,_that.description,_that.address,_that.city,_that.province,_that.latitude,_that.longitude,_that.photos,_that.phone,_that.email,_that.status,_that.primaryPhotoUrl,_that.productsCount,_that.distance,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'owner_id')  int ownerId,  String name,  String type,  String? description,  String address,  String city,  String province,  double? latitude,  double? longitude,  List<String>? photos,  String phone,  String? email,  String status, @JsonKey(name: 'primary_photo_url')  String? primaryPhotoUrl, @JsonKey(name: 'products_count')  int productsCount, @JsonKey(name: 'distance')  double? distance, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _NearbyShop():
return $default(_that.id,_that.ownerId,_that.name,_that.type,_that.description,_that.address,_that.city,_that.province,_that.latitude,_that.longitude,_that.photos,_that.phone,_that.email,_that.status,_that.primaryPhotoUrl,_that.productsCount,_that.distance,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'owner_id')  int ownerId,  String name,  String type,  String? description,  String address,  String city,  String province,  double? latitude,  double? longitude,  List<String>? photos,  String phone,  String? email,  String status, @JsonKey(name: 'primary_photo_url')  String? primaryPhotoUrl, @JsonKey(name: 'products_count')  int productsCount, @JsonKey(name: 'distance')  double? distance, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _NearbyShop() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.type,_that.description,_that.address,_that.city,_that.province,_that.latitude,_that.longitude,_that.photos,_that.phone,_that.email,_that.status,_that.primaryPhotoUrl,_that.productsCount,_that.distance,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NearbyShop extends NearbyShop {
  const _NearbyShop({required this.id, @JsonKey(name: 'owner_id') required this.ownerId, required this.name, required this.type, this.description, required this.address, required this.city, required this.province, this.latitude, this.longitude, final  List<String>? photos, required this.phone, this.email, this.status = 'approved', @JsonKey(name: 'primary_photo_url') this.primaryPhotoUrl, @JsonKey(name: 'products_count') this.productsCount = 0, @JsonKey(name: 'distance') this.distance, @JsonKey(name: 'created_at') this.createdAt}): _photos = photos,super._();
  factory _NearbyShop.fromJson(Map<String, dynamic> json) => _$NearbyShopFromJson(json);

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

@override final  String phone;
@override final  String? email;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'primary_photo_url') final  String? primaryPhotoUrl;
@override@JsonKey(name: 'products_count') final  int productsCount;
@override@JsonKey(name: 'distance') final  double? distance;
// Distance in km from user
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of NearbyShop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NearbyShopCopyWith<_NearbyShop> get copyWith => __$NearbyShopCopyWithImpl<_NearbyShop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NearbyShopToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NearbyShop&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.province, province) || other.province == province)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.primaryPhotoUrl, primaryPhotoUrl) || other.primaryPhotoUrl == primaryPhotoUrl)&&(identical(other.productsCount, productsCount) || other.productsCount == productsCount)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,type,description,address,city,province,latitude,longitude,const DeepCollectionEquality().hash(_photos),phone,email,status,primaryPhotoUrl,productsCount,distance,createdAt);

@override
String toString() {
  return 'NearbyShop(id: $id, ownerId: $ownerId, name: $name, type: $type, description: $description, address: $address, city: $city, province: $province, latitude: $latitude, longitude: $longitude, photos: $photos, phone: $phone, email: $email, status: $status, primaryPhotoUrl: $primaryPhotoUrl, productsCount: $productsCount, distance: $distance, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$NearbyShopCopyWith<$Res> implements $NearbyShopCopyWith<$Res> {
  factory _$NearbyShopCopyWith(_NearbyShop value, $Res Function(_NearbyShop) _then) = __$NearbyShopCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'owner_id') int ownerId, String name, String type, String? description, String address, String city, String province, double? latitude, double? longitude, List<String>? photos, String phone, String? email, String status,@JsonKey(name: 'primary_photo_url') String? primaryPhotoUrl,@JsonKey(name: 'products_count') int productsCount,@JsonKey(name: 'distance') double? distance,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$NearbyShopCopyWithImpl<$Res>
    implements _$NearbyShopCopyWith<$Res> {
  __$NearbyShopCopyWithImpl(this._self, this._then);

  final _NearbyShop _self;
  final $Res Function(_NearbyShop) _then;

/// Create a copy of NearbyShop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? type = null,Object? description = freezed,Object? address = null,Object? city = null,Object? province = null,Object? latitude = freezed,Object? longitude = freezed,Object? photos = freezed,Object? phone = null,Object? email = freezed,Object? status = null,Object? primaryPhotoUrl = freezed,Object? productsCount = null,Object? distance = freezed,Object? createdAt = freezed,}) {
  return _then(_NearbyShop(
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
as List<String>?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,primaryPhotoUrl: freezed == primaryPhotoUrl ? _self.primaryPhotoUrl : primaryPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,productsCount: null == productsCount ? _self.productsCount : productsCount // ignore: cast_nullable_to_non_nullable
as int,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$NearbyShopsResponse {

 List<NearbyShop> get shops; int get total;@JsonKey(name: 'search_radius_km') double get searchRadiusKm;@JsonKey(name: 'user_location') UserLocation get userLocation;
/// Create a copy of NearbyShopsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NearbyShopsResponseCopyWith<NearbyShopsResponse> get copyWith => _$NearbyShopsResponseCopyWithImpl<NearbyShopsResponse>(this as NearbyShopsResponse, _$identity);

  /// Serializes this NearbyShopsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyShopsResponse&&const DeepCollectionEquality().equals(other.shops, shops)&&(identical(other.total, total) || other.total == total)&&(identical(other.searchRadiusKm, searchRadiusKm) || other.searchRadiusKm == searchRadiusKm)&&(identical(other.userLocation, userLocation) || other.userLocation == userLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(shops),total,searchRadiusKm,userLocation);

@override
String toString() {
  return 'NearbyShopsResponse(shops: $shops, total: $total, searchRadiusKm: $searchRadiusKm, userLocation: $userLocation)';
}


}

/// @nodoc
abstract mixin class $NearbyShopsResponseCopyWith<$Res>  {
  factory $NearbyShopsResponseCopyWith(NearbyShopsResponse value, $Res Function(NearbyShopsResponse) _then) = _$NearbyShopsResponseCopyWithImpl;
@useResult
$Res call({
 List<NearbyShop> shops, int total,@JsonKey(name: 'search_radius_km') double searchRadiusKm,@JsonKey(name: 'user_location') UserLocation userLocation
});


$UserLocationCopyWith<$Res> get userLocation;

}
/// @nodoc
class _$NearbyShopsResponseCopyWithImpl<$Res>
    implements $NearbyShopsResponseCopyWith<$Res> {
  _$NearbyShopsResponseCopyWithImpl(this._self, this._then);

  final NearbyShopsResponse _self;
  final $Res Function(NearbyShopsResponse) _then;

/// Create a copy of NearbyShopsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shops = null,Object? total = null,Object? searchRadiusKm = null,Object? userLocation = null,}) {
  return _then(_self.copyWith(
shops: null == shops ? _self.shops : shops // ignore: cast_nullable_to_non_nullable
as List<NearbyShop>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,searchRadiusKm: null == searchRadiusKm ? _self.searchRadiusKm : searchRadiusKm // ignore: cast_nullable_to_non_nullable
as double,userLocation: null == userLocation ? _self.userLocation : userLocation // ignore: cast_nullable_to_non_nullable
as UserLocation,
  ));
}
/// Create a copy of NearbyShopsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserLocationCopyWith<$Res> get userLocation {
  
  return $UserLocationCopyWith<$Res>(_self.userLocation, (value) {
    return _then(_self.copyWith(userLocation: value));
  });
}
}


/// Adds pattern-matching-related methods to [NearbyShopsResponse].
extension NearbyShopsResponsePatterns on NearbyShopsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NearbyShopsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NearbyShopsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NearbyShopsResponse value)  $default,){
final _that = this;
switch (_that) {
case _NearbyShopsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NearbyShopsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NearbyShopsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NearbyShop> shops,  int total, @JsonKey(name: 'search_radius_km')  double searchRadiusKm, @JsonKey(name: 'user_location')  UserLocation userLocation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NearbyShopsResponse() when $default != null:
return $default(_that.shops,_that.total,_that.searchRadiusKm,_that.userLocation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NearbyShop> shops,  int total, @JsonKey(name: 'search_radius_km')  double searchRadiusKm, @JsonKey(name: 'user_location')  UserLocation userLocation)  $default,) {final _that = this;
switch (_that) {
case _NearbyShopsResponse():
return $default(_that.shops,_that.total,_that.searchRadiusKm,_that.userLocation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NearbyShop> shops,  int total, @JsonKey(name: 'search_radius_km')  double searchRadiusKm, @JsonKey(name: 'user_location')  UserLocation userLocation)?  $default,) {final _that = this;
switch (_that) {
case _NearbyShopsResponse() when $default != null:
return $default(_that.shops,_that.total,_that.searchRadiusKm,_that.userLocation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NearbyShopsResponse implements NearbyShopsResponse {
  const _NearbyShopsResponse({required final  List<NearbyShop> shops, required this.total, @JsonKey(name: 'search_radius_km') required this.searchRadiusKm, @JsonKey(name: 'user_location') required this.userLocation}): _shops = shops;
  factory _NearbyShopsResponse.fromJson(Map<String, dynamic> json) => _$NearbyShopsResponseFromJson(json);

 final  List<NearbyShop> _shops;
@override List<NearbyShop> get shops {
  if (_shops is EqualUnmodifiableListView) return _shops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shops);
}

@override final  int total;
@override@JsonKey(name: 'search_radius_km') final  double searchRadiusKm;
@override@JsonKey(name: 'user_location') final  UserLocation userLocation;

/// Create a copy of NearbyShopsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NearbyShopsResponseCopyWith<_NearbyShopsResponse> get copyWith => __$NearbyShopsResponseCopyWithImpl<_NearbyShopsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NearbyShopsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NearbyShopsResponse&&const DeepCollectionEquality().equals(other._shops, _shops)&&(identical(other.total, total) || other.total == total)&&(identical(other.searchRadiusKm, searchRadiusKm) || other.searchRadiusKm == searchRadiusKm)&&(identical(other.userLocation, userLocation) || other.userLocation == userLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_shops),total,searchRadiusKm,userLocation);

@override
String toString() {
  return 'NearbyShopsResponse(shops: $shops, total: $total, searchRadiusKm: $searchRadiusKm, userLocation: $userLocation)';
}


}

/// @nodoc
abstract mixin class _$NearbyShopsResponseCopyWith<$Res> implements $NearbyShopsResponseCopyWith<$Res> {
  factory _$NearbyShopsResponseCopyWith(_NearbyShopsResponse value, $Res Function(_NearbyShopsResponse) _then) = __$NearbyShopsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<NearbyShop> shops, int total,@JsonKey(name: 'search_radius_km') double searchRadiusKm,@JsonKey(name: 'user_location') UserLocation userLocation
});


@override $UserLocationCopyWith<$Res> get userLocation;

}
/// @nodoc
class __$NearbyShopsResponseCopyWithImpl<$Res>
    implements _$NearbyShopsResponseCopyWith<$Res> {
  __$NearbyShopsResponseCopyWithImpl(this._self, this._then);

  final _NearbyShopsResponse _self;
  final $Res Function(_NearbyShopsResponse) _then;

/// Create a copy of NearbyShopsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shops = null,Object? total = null,Object? searchRadiusKm = null,Object? userLocation = null,}) {
  return _then(_NearbyShopsResponse(
shops: null == shops ? _self._shops : shops // ignore: cast_nullable_to_non_nullable
as List<NearbyShop>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,searchRadiusKm: null == searchRadiusKm ? _self.searchRadiusKm : searchRadiusKm // ignore: cast_nullable_to_non_nullable
as double,userLocation: null == userLocation ? _self.userLocation : userLocation // ignore: cast_nullable_to_non_nullable
as UserLocation,
  ));
}

/// Create a copy of NearbyShopsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserLocationCopyWith<$Res> get userLocation {
  
  return $UserLocationCopyWith<$Res>(_self.userLocation, (value) {
    return _then(_self.copyWith(userLocation: value));
  });
}
}


/// @nodoc
mixin _$UserLocation {

 double get latitude; double get longitude;
/// Create a copy of UserLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserLocationCopyWith<UserLocation> get copyWith => _$UserLocationCopyWithImpl<UserLocation>(this as UserLocation, _$identity);

  /// Serializes this UserLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserLocation&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'UserLocation(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $UserLocationCopyWith<$Res>  {
  factory $UserLocationCopyWith(UserLocation value, $Res Function(UserLocation) _then) = _$UserLocationCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class _$UserLocationCopyWithImpl<$Res>
    implements $UserLocationCopyWith<$Res> {
  _$UserLocationCopyWithImpl(this._self, this._then);

  final UserLocation _self;
  final $Res Function(UserLocation) _then;

/// Create a copy of UserLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [UserLocation].
extension UserLocationPatterns on UserLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserLocation value)  $default,){
final _that = this;
switch (_that) {
case _UserLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserLocation value)?  $default,){
final _that = this;
switch (_that) {
case _UserLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserLocation() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _UserLocation():
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _UserLocation() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserLocation implements UserLocation {
  const _UserLocation({required this.latitude, required this.longitude});
  factory _UserLocation.fromJson(Map<String, dynamic> json) => _$UserLocationFromJson(json);

@override final  double latitude;
@override final  double longitude;

/// Create a copy of UserLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserLocationCopyWith<_UserLocation> get copyWith => __$UserLocationCopyWithImpl<_UserLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserLocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserLocation&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'UserLocation(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$UserLocationCopyWith<$Res> implements $UserLocationCopyWith<$Res> {
  factory _$UserLocationCopyWith(_UserLocation value, $Res Function(_UserLocation) _then) = __$UserLocationCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class __$UserLocationCopyWithImpl<$Res>
    implements _$UserLocationCopyWith<$Res> {
  __$UserLocationCopyWithImpl(this._self, this._then);

  final _UserLocation _self;
  final $Res Function(_UserLocation) _then;

/// Create a copy of UserLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_UserLocation(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
