import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
abstract class Message with _$Message {
  const factory Message({
    required int id,
    @JsonKey(name: 'conversation_id') required int conversationId,
    @JsonKey(name: 'sender_id') required int senderId,
    required String content,
    @Default('text') String type,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    MessageSender? sender,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
}

@freezed
abstract class MessageSender with _$MessageSender {
  const factory MessageSender({
    required int id,
    required String name,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
  }) = _MessageSender;

  factory MessageSender.fromJson(Map<String, dynamic> json) => _$MessageSenderFromJson(json);
}
