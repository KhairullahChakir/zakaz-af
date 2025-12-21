// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_shop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductShop {

 int get id; String get name;@JsonKey(name: 'shop_type') String? get shopType; String? get phone; String? get city; String? get district;@JsonKey(name: 'main_photo_url') String? get mainPhotoUrl; ProductShopOwner? get owner;
/// Create a copy of ProductShop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductShopCopyWith<ProductShop> get copyWith => _$ProductShopCopyWithImpl<ProductShop>(this as ProductShop, _$identity);

  /// Serializes this ProductShop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductShop&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.shopType, shopType) || other.shopType == shopType)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.mainPhotoUrl, mainPhotoUrl) || other.mainPhotoUrl == mainPhotoUrl)&&(identical(other.owner, owner) || other.owner == owner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,shopType,phone,city,district,mainPhotoUrl,owner);

@override
String toString() {
  return 'ProductShop(id: $id, name: $name, shopType: $shopType, phone: $phone, city: $city, district: $district, mainPhotoUrl: $mainPhotoUrl, owner: $owner)';
}


}

/// @nodoc
abstract mixin class $ProductShopCopyWith<$Res>  {
  factory $ProductShopCopyWith(ProductShop value, $Res Function(ProductShop) _then) = _$ProductShopCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'shop_type') String? shopType, String? phone, String? city, String? district,@JsonKey(name: 'main_photo_url') String? mainPhotoUrl, ProductShopOwner? owner
});


$ProductShopOwnerCopyWith<$Res>? get owner;

}
/// @nodoc
class _$ProductShopCopyWithImpl<$Res>
    implements $ProductShopCopyWith<$Res> {
  _$ProductShopCopyWithImpl(this._self, this._then);

  final ProductShop _self;
  final $Res Function(ProductShop) _then;

/// Create a copy of ProductShop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? shopType = freezed,Object? phone = freezed,Object? city = freezed,Object? district = freezed,Object? mainPhotoUrl = freezed,Object? owner = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shopType: freezed == shopType ? _self.shopType : shopType // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,mainPhotoUrl: freezed == mainPhotoUrl ? _self.mainPhotoUrl : mainPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as ProductShopOwner?,
  ));
}
/// Create a copy of ProductShop
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductShopOwnerCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $ProductShopOwnerCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductShop].
extension ProductShopPatterns on ProductShop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductShop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductShop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductShop value)  $default,){
final _that = this;
switch (_that) {
case _ProductShop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductShop value)?  $default,){
final _that = this;
switch (_that) {
case _ProductShop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'shop_type')  String? shopType,  String? phone,  String? city,  String? district, @JsonKey(name: 'main_photo_url')  String? mainPhotoUrl,  ProductShopOwner? owner)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductShop() when $default != null:
return $default(_that.id,_that.name,_that.shopType,_that.phone,_that.city,_that.district,_that.mainPhotoUrl,_that.owner);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'shop_type')  String? shopType,  String? phone,  String? city,  String? district, @JsonKey(name: 'main_photo_url')  String? mainPhotoUrl,  ProductShopOwner? owner)  $default,) {final _that = this;
switch (_that) {
case _ProductShop():
return $default(_that.id,_that.name,_that.shopType,_that.phone,_that.city,_that.district,_that.mainPhotoUrl,_that.owner);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'shop_type')  String? shopType,  String? phone,  String? city,  String? district, @JsonKey(name: 'main_photo_url')  String? mainPhotoUrl,  ProductShopOwner? owner)?  $default,) {final _that = this;
switch (_that) {
case _ProductShop() when $default != null:
return $default(_that.id,_that.name,_that.shopType,_that.phone,_that.city,_that.district,_that.mainPhotoUrl,_that.owner);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductShop implements ProductShop {
  const _ProductShop({required this.id, required this.name, @JsonKey(name: 'shop_type') this.shopType, this.phone, this.city, this.district, @JsonKey(name: 'main_photo_url') this.mainPhotoUrl, this.owner});
  factory _ProductShop.fromJson(Map<String, dynamic> json) => _$ProductShopFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'shop_type') final  String? shopType;
@override final  String? phone;
@override final  String? city;
@override final  String? district;
@override@JsonKey(name: 'main_photo_url') final  String? mainPhotoUrl;
@override final  ProductShopOwner? owner;

/// Create a copy of ProductShop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductShopCopyWith<_ProductShop> get copyWith => __$ProductShopCopyWithImpl<_ProductShop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductShopToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductShop&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.shopType, shopType) || other.shopType == shopType)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.mainPhotoUrl, mainPhotoUrl) || other.mainPhotoUrl == mainPhotoUrl)&&(identical(other.owner, owner) || other.owner == owner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,shopType,phone,city,district,mainPhotoUrl,owner);

@override
String toString() {
  return 'ProductShop(id: $id, name: $name, shopType: $shopType, phone: $phone, city: $city, district: $district, mainPhotoUrl: $mainPhotoUrl, owner: $owner)';
}


}

/// @nodoc
abstract mixin class _$ProductShopCopyWith<$Res> implements $ProductShopCopyWith<$Res> {
  factory _$ProductShopCopyWith(_ProductShop value, $Res Function(_ProductShop) _then) = __$ProductShopCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'shop_type') String? shopType, String? phone, String? city, String? district,@JsonKey(name: 'main_photo_url') String? mainPhotoUrl, ProductShopOwner? owner
});


@override $ProductShopOwnerCopyWith<$Res>? get owner;

}
/// @nodoc
class __$ProductShopCopyWithImpl<$Res>
    implements _$ProductShopCopyWith<$Res> {
  __$ProductShopCopyWithImpl(this._self, this._then);

  final _ProductShop _self;
  final $Res Function(_ProductShop) _then;

/// Create a copy of ProductShop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? shopType = freezed,Object? phone = freezed,Object? city = freezed,Object? district = freezed,Object? mainPhotoUrl = freezed,Object? owner = freezed,}) {
  return _then(_ProductShop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shopType: freezed == shopType ? _self.shopType : shopType // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,mainPhotoUrl: freezed == mainPhotoUrl ? _self.mainPhotoUrl : mainPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as ProductShopOwner?,
  ));
}

/// Create a copy of ProductShop
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductShopOwnerCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $ProductShopOwnerCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// @nodoc
mixin _$ProductShopOwner {

 int get id; String get name; String? get email; String? get phone;@JsonKey(name: 'profile_image_url') String? get profileImageUrl;
/// Create a copy of ProductShopOwner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductShopOwnerCopyWith<ProductShopOwner> get copyWith => _$ProductShopOwnerCopyWithImpl<ProductShopOwner>(this as ProductShopOwner, _$identity);

  /// Serializes this ProductShopOwner to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductShopOwner&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,profileImageUrl);

@override
String toString() {
  return 'ProductShopOwner(id: $id, name: $name, email: $email, phone: $phone, profileImageUrl: $profileImageUrl)';
}


}

/// @nodoc
abstract mixin class $ProductShopOwnerCopyWith<$Res>  {
  factory $ProductShopOwnerCopyWith(ProductShopOwner value, $Res Function(ProductShopOwner) _then) = _$ProductShopOwnerCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? email, String? phone,@JsonKey(name: 'profile_image_url') String? profileImageUrl
});




}
/// @nodoc
class _$ProductShopOwnerCopyWithImpl<$Res>
    implements $ProductShopOwnerCopyWith<$Res> {
  _$ProductShopOwnerCopyWithImpl(this._self, this._then);

  final ProductShopOwner _self;
  final $Res Function(ProductShopOwner) _then;

/// Create a copy of ProductShopOwner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? phone = freezed,Object? profileImageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductShopOwner].
extension ProductShopOwnerPatterns on ProductShopOwner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductShopOwner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductShopOwner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductShopOwner value)  $default,){
final _that = this;
switch (_that) {
case _ProductShopOwner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductShopOwner value)?  $default,){
final _that = this;
switch (_that) {
case _ProductShopOwner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? email,  String? phone, @JsonKey(name: 'profile_image_url')  String? profileImageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductShopOwner() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.profileImageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? email,  String? phone, @JsonKey(name: 'profile_image_url')  String? profileImageUrl)  $default,) {final _that = this;
switch (_that) {
case _ProductShopOwner():
return $default(_that.id,_that.name,_that.email,_that.phone,_that.profileImageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? email,  String? phone, @JsonKey(name: 'profile_image_url')  String? profileImageUrl)?  $default,) {final _that = this;
switch (_that) {
case _ProductShopOwner() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.profileImageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductShopOwner implements ProductShopOwner {
  const _ProductShopOwner({required this.id, required this.name, this.email, this.phone, @JsonKey(name: 'profile_image_url') this.profileImageUrl});
  factory _ProductShopOwner.fromJson(Map<String, dynamic> json) => _$ProductShopOwnerFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? email;
@override final  String? phone;
@override@JsonKey(name: 'profile_image_url') final  String? profileImageUrl;

/// Create a copy of ProductShopOwner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductShopOwnerCopyWith<_ProductShopOwner> get copyWith => __$ProductShopOwnerCopyWithImpl<_ProductShopOwner>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductShopOwnerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductShopOwner&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,profileImageUrl);

@override
String toString() {
  return 'ProductShopOwner(id: $id, name: $name, email: $email, phone: $phone, profileImageUrl: $profileImageUrl)';
}


}

/// @nodoc
abstract mixin class _$ProductShopOwnerCopyWith<$Res> implements $ProductShopOwnerCopyWith<$Res> {
  factory _$ProductShopOwnerCopyWith(_ProductShopOwner value, $Res Function(_ProductShopOwner) _then) = __$ProductShopOwnerCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? email, String? phone,@JsonKey(name: 'profile_image_url') String? profileImageUrl
});




}
/// @nodoc
class __$ProductShopOwnerCopyWithImpl<$Res>
    implements _$ProductShopOwnerCopyWith<$Res> {
  __$ProductShopOwnerCopyWithImpl(this._self, this._then);

  final _ProductShopOwner _self;
  final $Res Function(_ProductShopOwner) _then;

/// Create a copy of ProductShopOwner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? phone = freezed,Object? profileImageUrl = freezed,}) {
  return _then(_ProductShopOwner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
