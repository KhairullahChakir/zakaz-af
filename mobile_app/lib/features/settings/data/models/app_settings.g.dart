// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  contact: ContactSettings.fromJson(json['contact'] as Map<String, dynamic>),
  social: SocialSettings.fromJson(json['social'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{'contact': instance.contact, 'social': instance.social};

_ContactSettings _$ContactSettingsFromJson(Map<String, dynamic> json) =>
    _ContactSettings(
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      whatsapp: json['whatsapp'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );

Map<String, dynamic> _$ContactSettingsToJson(_ContactSettings instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
      'location': instance.location,
    };

_SocialSettings _$SocialSettingsFromJson(Map<String, dynamic> json) =>
    _SocialSettings(
      facebook: json['facebook'] as String? ?? '',
      instagram: json['instagram'] as String? ?? '',
      tiktok: json['tiktok'] as String? ?? '',
      telegram: json['telegram'] as String? ?? '',
      youtube: json['youtube'] as String? ?? '',
    );

Map<String, dynamic> _$SocialSettingsToJson(_SocialSettings instance) =>
    <String, dynamic>{
      'facebook': instance.facebook,
      'instagram': instance.instagram,
      'tiktok': instance.tiktok,
      'telegram': instance.telegram,
      'youtube': instance.youtube,
    };
