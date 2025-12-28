import 'dart:io';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/conversation.dart';
import '../domain/message.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  final Dio _dio;

  ChatRepository(this._dio);

  /// Get all conversations for the current user
  Future<List<Conversation>> getConversations() async {
    final response = await _dio.get('/chat/conversations');
    return (response.data as List)
        .map((json) => Conversation.fromJson(json))
        .toList();
  }

  /// Start or get existing conversation with a shop
  Future<Conversation> startConversation({
    required int shopId,
    int? productId,
  }) async {
    final response = await _dio.post('/chat/conversations', data: {
      'shop_id': shopId,
      if (productId != null) 'product_id': productId,
    });
    return Conversation.fromJson(response.data);
  }

  /// Get messages for a conversation
  Future<List<Message>> getMessages(int conversationId) async {
    final response = await _dio.get('/chat/conversations/$conversationId/messages');
    return (response.data as List)
        .map((json) => Message.fromJson(json))
        .toList();
  }

  /// Send a message
  Future<Message> sendMessage({
    required int conversationId,
    String? content,
    String type = 'text',
    File? image, // Add image argument
    Map<String, dynamic>? metadata,
  }) async {
    dynamic data;

    if (image != null) {
      data = FormData.fromMap({
        if (content != null) 'content': content,
        'type': 'image', // Force type to image if file is present
        if (metadata != null) 'metadata': metadata,
        'image': await MultipartFile.fromFile(image.path, filename: 'chat_image.jpg'),
      });
    } else {
      data = {
        'content': content,
        'type': type,
        if (metadata != null) 'metadata': metadata,
      };
    }

    final response = await _dio.post(
      '/chat/conversations/$conversationId/messages',
      data: data,
    );
    return Message.fromJson(response.data);
  }

  /// Get unread message count
  Future<int> getUnreadCount() async {
    final response = await _dio.get('/chat/unread-count');
    return response.data['count'] as int;
  }
}

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(ref.watch(dioProvider));
}

@riverpod
Future<List<Conversation>> conversations(Ref ref) async {
  return ref.watch(chatRepositoryProvider).getConversations();
}

@riverpod
Future<List<Message>> conversationMessages(Ref ref, int conversationId) async {
  return ref.watch(chatRepositoryProvider).getMessages(conversationId);
}

@riverpod
Future<int> unreadMessageCount(Ref ref) async {
  return ref.watch(chatRepositoryProvider).getUnreadCount();
}
