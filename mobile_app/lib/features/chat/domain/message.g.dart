// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: (json['id'] as num).toInt(),
  conversationId: (json['conversation_id'] as num).toInt(),
  senderId: (json['sender_id'] as num).toInt(),
  content: json['content'] as String,
  type: json['type'] as String? ?? 'text',
  metadata: json['metadata'] as Map<String, dynamic>?,
  isRead: json['is_read'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  sender: json['sender'] == null
      ? null
      : MessageSender.fromJson(json['sender'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'conversation_id': instance.conversationId,
  'sender_id': instance.senderId,
  'content': instance.content,
  'type': instance.type,
  'metadata': instance.metadata,
  'is_read': instance.isRead,
  'created_at': instance.createdAt?.toIso8601String(),
  'sender': instance.sender,
};

_MessageSender _$MessageSenderFromJson(Map<String, dynamic> json) =>
    _MessageSender(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
    );

Map<String, dynamic> _$MessageSenderToJson(_MessageSender instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile_image_url': instance.profileImageUrl,
    };
