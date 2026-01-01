import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required ContactSettings contact,
    required SocialSettings social,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
}

@freezed
class ContactSettings with _$ContactSettings {
  const factory ContactSettings({
    @Default('') String email,
    @Default('') String phone,
    @Default('') String whatsapp,
    @Default('') String location,
  }) = _ContactSettings;

  factory ContactSettings.fromJson(Map<String, dynamic> json) => _$ContactSettingsFromJson(json);
}

@freezed
class SocialSettings with _$SocialSettings {
  const factory SocialSettings({
    @Default('') String facebook,
    @Default('') String instagram,
    @Default('') String tiktok,
    @Default('') String telegram,
    @Default('') String youtube,
  }) = _SocialSettings;

  factory SocialSettings.fromJson(Map<String, dynamic> json) => _$SocialSettingsFromJson(json);
}
