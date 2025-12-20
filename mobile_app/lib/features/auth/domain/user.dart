import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String? email,
    required String? phone,
    @JsonKey(name: 'profile_image') String? profileImage,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
