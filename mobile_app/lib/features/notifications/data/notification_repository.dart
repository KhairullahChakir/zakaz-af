import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/app_notification.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(dioProvider));
});

class NotificationRepository {
  final Dio _dio;
  NotificationRepository(this._dio);

  Future<List<AppNotification>> getNotifications() async {
    final response = await _dio.get('/notifications');
    final List data = response.data['data'] ?? response.data;
    return data.map((json) => AppNotification.fromJson(json)).toList();
  }

  Future<int> getUnreadCount() async {
    final response = await _dio.get('/notifications/unread-count');
    return response.data['count'] ?? 0;
  }

  Future<void> markAsRead(int notificationId) async {
    await _dio.post('/notifications/$notificationId/read');
  }

  Future<void> markAllAsRead() async {
    await _dio.post('/notifications/read-all');
  }

  Future<void> sendNotification({
    required String title,
    required String body,
    String? type,
    List<int>? userIds,
  }) async {
    await _dio.post('/notifications/send', data: {
      'title': title,
      'body': body,
      if (type != null) 'type': type,
      if (userIds != null) 'user_ids': userIds,
    });
  }
}
