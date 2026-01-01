// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettings {

 ContactSettings get contact; SocialSettings get social;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.social, social) || other.social == social));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contact,social);

@override
String toString() {
  return 'AppSettings(contact: $contact, social: $social)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 ContactSettings contact, SocialSettings social
});


$ContactSettingsCopyWith<$Res> get contact;$SocialSettingsCopyWith<$Res> get social;

}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contact = null,Object? social = null,}) {
  return _then(_self.copyWith(
contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as ContactSettings,social: null == social ? _self.social : social // ignore: cast_nullable_to_non_nullable
as SocialSettings,
  ));
}
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactSettingsCopyWith<$Res> get contact {
  
  return $ContactSettingsCopyWith<$Res>(_self.contact, (value) {
    return _then(_self.copyWith(contact: value));
  });
}/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SocialSettingsCopyWith<$Res> get social {
  
  return $SocialSettingsCopyWith<$Res>(_self.social, (value) {
    return _then(_self.copyWith(social: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ContactSettings contact,  SocialSettings social)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.contact,_that.social);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ContactSettings contact,  SocialSettings social)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.contact,_that.social);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ContactSettings contact,  SocialSettings social)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.contact,_that.social);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettings implements AppSettings {
  const _AppSettings({required this.contact, required this.social});
  factory _AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

@override final  ContactSettings contact;
@override final  SocialSettings social;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.social, social) || other.social == social));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contact,social);

@override
String toString() {
  return 'AppSettings(contact: $contact, social: $social)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 ContactSettings contact, SocialSettings social
});


@override $ContactSettingsCopyWith<$Res> get contact;@override $SocialSettingsCopyWith<$Res> get social;

}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contact = null,Object? social = null,}) {
  return _then(_AppSettings(
contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as ContactSettings,social: null == social ? _self.social : social // ignore: cast_nullable_to_non_nullable
as SocialSettings,
  ));
}

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactSettingsCopyWith<$Res> get contact {
  
  return $ContactSettingsCopyWith<$Res>(_self.contact, (value) {
    return _then(_self.copyWith(contact: value));
  });
}/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SocialSettingsCopyWith<$Res> get social {
  
  return $SocialSettingsCopyWith<$Res>(_self.social, (value) {
    return _then(_self.copyWith(social: value));
  });
}
}


/// @nodoc
mixin _$ContactSettings {

 String get email; String get phone; String get whatsapp; String get location;
/// Create a copy of ContactSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactSettingsCopyWith<ContactSettings> get copyWith => _$ContactSettingsCopyWithImpl<ContactSettings>(this as ContactSettings, _$identity);

  /// Serializes this ContactSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactSettings&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.whatsapp, whatsapp) || other.whatsapp == whatsapp)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,phone,whatsapp,location);

@override
String toString() {
  return 'ContactSettings(email: $email, phone: $phone, whatsapp: $whatsapp, location: $location)';
}


}

/// @nodoc
abstract mixin class $ContactSettingsCopyWith<$Res>  {
  factory $ContactSettingsCopyWith(ContactSettings value, $Res Function(ContactSettings) _then) = _$ContactSettingsCopyWithImpl;
@useResult
$Res call({
 String email, String phone, String whatsapp, String location
});




}
/// @nodoc
class _$ContactSettingsCopyWithImpl<$Res>
    implements $ContactSettingsCopyWith<$Res> {
  _$ContactSettingsCopyWithImpl(this._self, this._then);

  final ContactSettings _self;
  final $Res Function(ContactSettings) _then;

/// Create a copy of ContactSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? phone = null,Object? whatsapp = null,Object? location = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,whatsapp: null == whatsapp ? _self.whatsapp : whatsapp // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactSettings].
extension ContactSettingsPatterns on ContactSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactSettings value)  $default,){
final _that = this;
switch (_that) {
case _ContactSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ContactSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String phone,  String whatsapp,  String location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactSettings() when $default != null:
return $default(_that.email,_that.phone,_that.whatsapp,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String phone,  String whatsapp,  String location)  $default,) {final _that = this;
switch (_that) {
case _ContactSettings():
return $default(_that.email,_that.phone,_that.whatsapp,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String phone,  String whatsapp,  String location)?  $default,) {final _that = this;
switch (_that) {
case _ContactSettings() when $default != null:
return $default(_that.email,_that.phone,_that.whatsapp,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactSettings implements ContactSettings {
  const _ContactSettings({this.email = '', this.phone = '', this.whatsapp = '', this.location = ''});
  factory _ContactSettings.fromJson(Map<String, dynamic> json) => _$ContactSettingsFromJson(json);

@override@JsonKey() final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String whatsapp;
@override@JsonKey() final  String location;

/// Create a copy of ContactSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactSettingsCopyWith<_ContactSettings> get copyWith => __$ContactSettingsCopyWithImpl<_ContactSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactSettings&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.whatsapp, whatsapp) || other.whatsapp == whatsapp)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,phone,whatsapp,location);

@override
String toString() {
  return 'ContactSettings(email: $email, phone: $phone, whatsapp: $whatsapp, location: $location)';
}


}

/// @nodoc
abstract mixin class _$ContactSettingsCopyWith<$Res> implements $ContactSettingsCopyWith<$Res> {
  factory _$ContactSettingsCopyWith(_ContactSettings value, $Res Function(_ContactSettings) _then) = __$ContactSettingsCopyWithImpl;
@override @useResult
$Res call({
 String email, String phone, String whatsapp, String location
});




}
/// @nodoc
class __$ContactSettingsCopyWithImpl<$Res>
    implements _$ContactSettingsCopyWith<$Res> {
  __$ContactSettingsCopyWithImpl(this._self, this._then);

  final _ContactSettings _self;
  final $Res Function(_ContactSettings) _then;

/// Create a copy of ContactSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? phone = null,Object? whatsapp = null,Object? location = null,}) {
  return _then(_ContactSettings(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,whatsapp: null == whatsapp ? _self.whatsapp : whatsapp // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SocialSettings {

 String get facebook; String get instagram; String get tiktok; String get telegram; String get youtube;
/// Create a copy of SocialSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocialSettingsCopyWith<SocialSettings> get copyWith => _$SocialSettingsCopyWithImpl<SocialSettings>(this as SocialSettings, _$identity);

  /// Serializes this SocialSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocialSettings&&(identical(other.facebook, facebook) || other.facebook == facebook)&&(identical(other.instagram, instagram) || other.instagram == instagram)&&(identical(other.tiktok, tiktok) || other.tiktok == tiktok)&&(identical(other.telegram, telegram) || other.telegram == telegram)&&(identical(other.youtube, youtube) || other.youtube == youtube));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,facebook,instagram,tiktok,telegram,youtube);

@override
String toString() {
  return 'SocialSettings(facebook: $facebook, instagram: $instagram, tiktok: $tiktok, telegram: $telegram, youtube: $youtube)';
}


}

/// @nodoc
abstract mixin class $SocialSettingsCopyWith<$Res>  {
  factory $SocialSettingsCopyWith(SocialSettings value, $Res Function(SocialSettings) _then) = _$SocialSettingsCopyWithImpl;
@useResult
$Res call({
 String facebook, String instagram, String tiktok, String telegram, String youtube
});




}
/// @nodoc
class _$SocialSettingsCopyWithImpl<$Res>
    implements $SocialSettingsCopyWith<$Res> {
  _$SocialSettingsCopyWithImpl(this._self, this._then);

  final SocialSettings _self;
  final $Res Function(SocialSettings) _then;

/// Create a copy of SocialSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? facebook = null,Object? instagram = null,Object? tiktok = null,Object? telegram = null,Object? youtube = null,}) {
  return _then(_self.copyWith(
facebook: null == facebook ? _self.facebook : facebook // ignore: cast_nullable_to_non_nullable
as String,instagram: null == instagram ? _self.instagram : instagram // ignore: cast_nullable_to_non_nullable
as String,tiktok: null == tiktok ? _self.tiktok : tiktok // ignore: cast_nullable_to_non_nullable
as String,telegram: null == telegram ? _self.telegram : telegram // ignore: cast_nullable_to_non_nullable
as String,youtube: null == youtube ? _self.youtube : youtube // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SocialSettings].
extension SocialSettingsPatterns on SocialSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SocialSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SocialSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SocialSettings value)  $default,){
final _that = this;
switch (_that) {
case _SocialSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SocialSettings value)?  $default,){
final _that = this;
switch (_that) {
case _SocialSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String facebook,  String instagram,  String tiktok,  String telegram,  String youtube)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SocialSettings() when $default != null:
return $default(_that.facebook,_that.instagram,_that.tiktok,_that.telegram,_that.youtube);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String facebook,  String instagram,  String tiktok,  String telegram,  String youtube)  $default,) {final _that = this;
switch (_that) {
case _SocialSettings():
return $default(_that.facebook,_that.instagram,_that.tiktok,_that.telegram,_that.youtube);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String facebook,  String instagram,  String tiktok,  String telegram,  String youtube)?  $default,) {final _that = this;
switch (_that) {
case _SocialSettings() when $default != null:
return $default(_that.facebook,_that.instagram,_that.tiktok,_that.telegram,_that.youtube);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SocialSettings implements SocialSettings {
  const _SocialSettings({this.facebook = '', this.instagram = '', this.tiktok = '', this.telegram = '', this.youtube = ''});
  factory _SocialSettings.fromJson(Map<String, dynamic> json) => _$SocialSettingsFromJson(json);

@override@JsonKey() final  String facebook;
@override@JsonKey() final  String instagram;
@override@JsonKey() final  String tiktok;
@override@JsonKey() final  String telegram;
@override@JsonKey() final  String youtube;

/// Create a copy of SocialSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SocialSettingsCopyWith<_SocialSettings> get copyWith => __$SocialSettingsCopyWithImpl<_SocialSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SocialSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SocialSettings&&(identical(other.facebook, facebook) || other.facebook == facebook)&&(identical(other.instagram, instagram) || other.instagram == instagram)&&(identical(other.tiktok, tiktok) || other.tiktok == tiktok)&&(identical(other.telegram, telegram) || other.telegram == telegram)&&(identical(other.youtube, youtube) || other.youtube == youtube));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,facebook,instagram,tiktok,telegram,youtube);

@override
String toString() {
  return 'SocialSettings(facebook: $facebook, instagram: $instagram, tiktok: $tiktok, telegram: $telegram, youtube: $youtube)';
}


}

/// @nodoc
abstract mixin class _$SocialSettingsCopyWith<$Res> implements $SocialSettingsCopyWith<$Res> {
  factory _$SocialSettingsCopyWith(_SocialSettings value, $Res Function(_SocialSettings) _then) = __$SocialSettingsCopyWithImpl;
@override @useResult
$Res call({
 String facebook, String instagram, String tiktok, String telegram, String youtube
});




}
/// @nodoc
class __$SocialSettingsCopyWithImpl<$Res>
    implements _$SocialSettingsCopyWith<$Res> {
  __$SocialSettingsCopyWithImpl(this._self, this._then);

  final _SocialSettings _self;
  final $Res Function(_SocialSettings) _then;

/// Create a copy of SocialSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? facebook = null,Object? instagram = null,Object? tiktok = null,Object? telegram = null,Object? youtube = null,}) {
  return _then(_SocialSettings(
facebook: null == facebook ? _self.facebook : facebook // ignore: cast_nullable_to_non_nullable
as String,instagram: null == instagram ? _self.instagram : instagram // ignore: cast_nullable_to_non_nullable
as String,tiktok: null == tiktok ? _self.tiktok : tiktok // ignore: cast_nullable_to_non_nullable
as String,telegram: null == telegram ? _self.telegram : telegram // ignore: cast_nullable_to_non_nullable
as String,youtube: null == youtube ? _self.youtube : youtube // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
