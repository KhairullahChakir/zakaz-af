// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 int get id; String get name; String? get description; double get price; String? get image;@JsonKey(name: 'image_url') String? get imageUrl; int get stock;@JsonKey(name: 'category_id') int get categoryId;@JsonKey(name: 'shop_id') int? get shopId; Category? get category; ProductShop? get shop;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.image, image) || other.image == image)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.category, category) || other.category == category)&&(identical(other.shop, shop) || other.shop == shop));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,price,image,imageUrl,stock,categoryId,shopId,category,shop);

@override
String toString() {
  return 'Product(id: $id, name: $name, description: $description, price: $price, image: $image, imageUrl: $imageUrl, stock: $stock, categoryId: $categoryId, shopId: $shopId, category: $category, shop: $shop)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? description, double price, String? image,@JsonKey(name: 'image_url') String? imageUrl, int stock,@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'shop_id') int? shopId, Category? category, ProductShop? shop
});


$CategoryCopyWith<$Res>? get category;$ProductShopCopyWith<$Res>? get shop;

}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? price = null,Object? image = freezed,Object? imageUrl = freezed,Object? stock = null,Object? categoryId = null,Object? shopId = freezed,Object? category = freezed,Object? shop = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,shopId: freezed == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as int?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category?,shop: freezed == shop ? _self.shop : shop // ignore: cast_nullable_to_non_nullable
as ProductShop?,
  ));
}
/// Create a copy of Product
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
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductShopCopyWith<$Res>? get shop {
    if (_self.shop == null) {
    return null;
  }

  return $ProductShopCopyWith<$Res>(_self.shop!, (value) {
    return _then(_self.copyWith(shop: value));
  });
}
}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  double price,  String? image, @JsonKey(name: 'image_url')  String? imageUrl,  int stock, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'shop_id')  int? shopId,  Category? category,  ProductShop? shop)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.image,_that.imageUrl,_that.stock,_that.categoryId,_that.shopId,_that.category,_that.shop);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  double price,  String? image, @JsonKey(name: 'image_url')  String? imageUrl,  int stock, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'shop_id')  int? shopId,  Category? category,  ProductShop? shop)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.description,_that.price,_that.image,_that.imageUrl,_that.stock,_that.categoryId,_that.shopId,_that.category,_that.shop);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? description,  double price,  String? image, @JsonKey(name: 'image_url')  String? imageUrl,  int stock, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'shop_id')  int? shopId,  Category? category,  ProductShop? shop)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.image,_that.imageUrl,_that.stock,_that.categoryId,_that.shopId,_that.category,_that.shop);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, required this.name, required this.description, required this.price, this.image, @JsonKey(name: 'image_url') this.imageUrl, required this.stock, @JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'shop_id') this.shopId, this.category, this.shop});
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? description;
@override final  double price;
@override final  String? image;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override final  int stock;
@override@JsonKey(name: 'category_id') final  int categoryId;
@override@JsonKey(name: 'shop_id') final  int? shopId;
@override final  Category? category;
@override final  ProductShop? shop;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.image, image) || other.image == image)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.category, category) || other.category == category)&&(identical(other.shop, shop) || other.shop == shop));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,price,image,imageUrl,stock,categoryId,shopId,category,shop);

@override
String toString() {
  return 'Product(id: $id, name: $name, description: $description, price: $price, image: $image, imageUrl: $imageUrl, stock: $stock, categoryId: $categoryId, shopId: $shopId, category: $category, shop: $shop)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? description, double price, String? image,@JsonKey(name: 'image_url') String? imageUrl, int stock,@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'shop_id') int? shopId, Category? category, ProductShop? shop
});


@override $CategoryCopyWith<$Res>? get category;@override $ProductShopCopyWith<$Res>? get shop;

}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? price = null,Object? image = freezed,Object? imageUrl = freezed,Object? stock = null,Object? categoryId = null,Object? shopId = freezed,Object? category = freezed,Object? shop = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,shopId: freezed == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as int?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category?,shop: freezed == shop ? _self.shop : shop // ignore: cast_nullable_to_non_nullable
as ProductShop?,
  ));
}

/// Create a copy of Product
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
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductShopCopyWith<$Res>? get shop {
    if (_self.shop == null) {
    return null;
  }

  return $ProductShopCopyWith<$Res>(_self.shop!, (value) {
    return _then(_self.copyWith(shop: value));
  });
}
}

// dart format on
