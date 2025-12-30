// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marketplace_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarketplaceItem {

 int get id;@JsonKey(name: 'user_id', fromJson: _parseInt) int get userId;@JsonKey(name: 'category_id', fromJson: _parseIntNullable) int? get categoryId; String get name; String get description;@JsonKey(fromJson: _parseDouble) double get price; String get condition; String get phone; String? get location; String get status;@JsonKey(name: 'main_image_url') String? get mainImageUrl;@JsonKey(name: 'gallery_urls') List<String>? get galleryUrls; User? get user; Category? get category;@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of MarketplaceItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketplaceItemCopyWith<MarketplaceItem> get copyWith => _$MarketplaceItemCopyWithImpl<MarketplaceItem>(this as MarketplaceItem, _$identity);

  /// Serializes this MarketplaceItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketplaceItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.location, location) || other.location == location)&&(identical(other.status, status) || other.status == status)&&(identical(other.mainImageUrl, mainImageUrl) || other.mainImageUrl == mainImageUrl)&&const DeepCollectionEquality().equals(other.galleryUrls, galleryUrls)&&(identical(other.user, user) || other.user == user)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,categoryId,name,description,price,condition,phone,location,status,mainImageUrl,const DeepCollectionEquality().hash(galleryUrls),user,category,createdAt);

@override
String toString() {
  return 'MarketplaceItem(id: $id, userId: $userId, categoryId: $categoryId, name: $name, description: $description, price: $price, condition: $condition, phone: $phone, location: $location, status: $status, mainImageUrl: $mainImageUrl, galleryUrls: $galleryUrls, user: $user, category: $category, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MarketplaceItemCopyWith<$Res>  {
  factory $MarketplaceItemCopyWith(MarketplaceItem value, $Res Function(MarketplaceItem) _then) = _$MarketplaceItemCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id', fromJson: _parseInt) int userId,@JsonKey(name: 'category_id', fromJson: _parseIntNullable) int? categoryId, String name, String description,@JsonKey(fromJson: _parseDouble) double price, String condition, String phone, String? location, String status,@JsonKey(name: 'main_image_url') String? mainImageUrl,@JsonKey(name: 'gallery_urls') List<String>? galleryUrls, User? user, Category? category,@JsonKey(name: 'created_at') String? createdAt
});


$CategoryCopyWith<$Res>? get category;

}
/// @nodoc
class _$MarketplaceItemCopyWithImpl<$Res>
    implements $MarketplaceItemCopyWith<$Res> {
  _$MarketplaceItemCopyWithImpl(this._self, this._then);

  final MarketplaceItem _self;
  final $Res Function(MarketplaceItem) _then;

/// Create a copy of MarketplaceItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? categoryId = freezed,Object? name = null,Object? description = null,Object? price = null,Object? condition = null,Object? phone = null,Object? location = freezed,Object? status = null,Object? mainImageUrl = freezed,Object? galleryUrls = freezed,Object? user = freezed,Object? category = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,mainImageUrl: freezed == mainImageUrl ? _self.mainImageUrl : mainImageUrl // ignore: cast_nullable_to_non_nullable
as String?,galleryUrls: freezed == galleryUrls ? _self.galleryUrls : galleryUrls // ignore: cast_nullable_to_non_nullable
as List<String>?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MarketplaceItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [MarketplaceItem].
extension MarketplaceItemPatterns on MarketplaceItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketplaceItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketplaceItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketplaceItem value)  $default,){
final _that = this;
switch (_that) {
case _MarketplaceItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketplaceItem value)?  $default,){
final _that = this;
switch (_that) {
case _MarketplaceItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id', fromJson: _parseInt)  int userId, @JsonKey(name: 'category_id', fromJson: _parseIntNullable)  int? categoryId,  String name,  String description, @JsonKey(fromJson: _parseDouble)  double price,  String condition,  String phone,  String? location,  String status, @JsonKey(name: 'main_image_url')  String? mainImageUrl, @JsonKey(name: 'gallery_urls')  List<String>? galleryUrls,  User? user,  Category? category, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketplaceItem() when $default != null:
return $default(_that.id,_that.userId,_that.categoryId,_that.name,_that.description,_that.price,_that.condition,_that.phone,_that.location,_that.status,_that.mainImageUrl,_that.galleryUrls,_that.user,_that.category,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id', fromJson: _parseInt)  int userId, @JsonKey(name: 'category_id', fromJson: _parseIntNullable)  int? categoryId,  String name,  String description, @JsonKey(fromJson: _parseDouble)  double price,  String condition,  String phone,  String? location,  String status, @JsonKey(name: 'main_image_url')  String? mainImageUrl, @JsonKey(name: 'gallery_urls')  List<String>? galleryUrls,  User? user,  Category? category, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _MarketplaceItem():
return $default(_that.id,_that.userId,_that.categoryId,_that.name,_that.description,_that.price,_that.condition,_that.phone,_that.location,_that.status,_that.mainImageUrl,_that.galleryUrls,_that.user,_that.category,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id', fromJson: _parseInt)  int userId, @JsonKey(name: 'category_id', fromJson: _parseIntNullable)  int? categoryId,  String name,  String description, @JsonKey(fromJson: _parseDouble)  double price,  String condition,  String phone,  String? location,  String status, @JsonKey(name: 'main_image_url')  String? mainImageUrl, @JsonKey(name: 'gallery_urls')  List<String>? galleryUrls,  User? user,  Category? category, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MarketplaceItem() when $default != null:
return $default(_that.id,_that.userId,_that.categoryId,_that.name,_that.description,_that.price,_that.condition,_that.phone,_that.location,_that.status,_that.mainImageUrl,_that.galleryUrls,_that.user,_that.category,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketplaceItem implements MarketplaceItem {
  const _MarketplaceItem({required this.id, @JsonKey(name: 'user_id', fromJson: _parseInt) required this.userId, @JsonKey(name: 'category_id', fromJson: _parseIntNullable) this.categoryId, required this.name, required this.description, @JsonKey(fromJson: _parseDouble) required this.price, required this.condition, required this.phone, this.location, required this.status, @JsonKey(name: 'main_image_url') this.mainImageUrl, @JsonKey(name: 'gallery_urls') final  List<String>? galleryUrls, this.user, this.category, @JsonKey(name: 'created_at') this.createdAt}): _galleryUrls = galleryUrls;
  factory _MarketplaceItem.fromJson(Map<String, dynamic> json) => _$MarketplaceItemFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id', fromJson: _parseInt) final  int userId;
@override@JsonKey(name: 'category_id', fromJson: _parseIntNullable) final  int? categoryId;
@override final  String name;
@override final  String description;
@override@JsonKey(fromJson: _parseDouble) final  double price;
@override final  String condition;
@override final  String phone;
@override final  String? location;
@override final  String status;
@override@JsonKey(name: 'main_image_url') final  String? mainImageUrl;
 final  List<String>? _galleryUrls;
@override@JsonKey(name: 'gallery_urls') List<String>? get galleryUrls {
  final value = _galleryUrls;
  if (value == null) return null;
  if (_galleryUrls is EqualUnmodifiableListView) return _galleryUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  User? user;
@override final  Category? category;
@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of MarketplaceItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketplaceItemCopyWith<_MarketplaceItem> get copyWith => __$MarketplaceItemCopyWithImpl<_MarketplaceItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketplaceItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketplaceItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.location, location) || other.location == location)&&(identical(other.status, status) || other.status == status)&&(identical(other.mainImageUrl, mainImageUrl) || other.mainImageUrl == mainImageUrl)&&const DeepCollectionEquality().equals(other._galleryUrls, _galleryUrls)&&(identical(other.user, user) || other.user == user)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,categoryId,name,description,price,condition,phone,location,status,mainImageUrl,const DeepCollectionEquality().hash(_galleryUrls),user,category,createdAt);

@override
String toString() {
  return 'MarketplaceItem(id: $id, userId: $userId, categoryId: $categoryId, name: $name, description: $description, price: $price, condition: $condition, phone: $phone, location: $location, status: $status, mainImageUrl: $mainImageUrl, galleryUrls: $galleryUrls, user: $user, category: $category, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MarketplaceItemCopyWith<$Res> implements $MarketplaceItemCopyWith<$Res> {
  factory _$MarketplaceItemCopyWith(_MarketplaceItem value, $Res Function(_MarketplaceItem) _then) = __$MarketplaceItemCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id', fromJson: _parseInt) int userId,@JsonKey(name: 'category_id', fromJson: _parseIntNullable) int? categoryId, String name, String description,@JsonKey(fromJson: _parseDouble) double price, String condition, String phone, String? location, String status,@JsonKey(name: 'main_image_url') String? mainImageUrl,@JsonKey(name: 'gallery_urls') List<String>? galleryUrls, User? user, Category? category,@JsonKey(name: 'created_at') String? createdAt
});


@override $CategoryCopyWith<$Res>? get category;

}
/// @nodoc
class __$MarketplaceItemCopyWithImpl<$Res>
    implements _$MarketplaceItemCopyWith<$Res> {
  __$MarketplaceItemCopyWithImpl(this._self, this._then);

  final _MarketplaceItem _self;
  final $Res Function(_MarketplaceItem) _then;

/// Create a copy of MarketplaceItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? categoryId = freezed,Object? name = null,Object? description = null,Object? price = null,Object? condition = null,Object? phone = null,Object? location = freezed,Object? status = null,Object? mainImageUrl = freezed,Object? galleryUrls = freezed,Object? user = freezed,Object? category = freezed,Object? createdAt = freezed,}) {
  return _then(_MarketplaceItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,mainImageUrl: freezed == mainImageUrl ? _self.mainImageUrl : mainImageUrl // ignore: cast_nullable_to_non_nullable
as String?,galleryUrls: freezed == galleryUrls ? _self._galleryUrls : galleryUrls // ignore: cast_nullable_to_non_nullable
as List<String>?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MarketplaceItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

// dart format on
