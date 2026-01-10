import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notification_repository.dart';
import '../domain/app_notification.dart';

// Simple provider for notifications
final notificationsProvider = FutureProvider.autoDispose<List<AppNotification>>((ref) async {
  return ref.read(notificationRepositoryProvider).getNotifications();
});

// Unread count (refreshes periodically)
final unreadNotificationCountProvider = FutureProvider.autoDispose<int>((ref) async {
  // Keep alive for 30 seconds then refresh
  final timer = Stream.periodic(const Duration(seconds: 30));
  final subscription = timer.listen((_) {
    ref.invalidateSelf();
  });
  ref.onDispose(() => subscription.cancel());

  try {
    return await ref.read(notificationRepositoryProvider).getUnreadCount();
  } catch (e) {
    // Silently fail and return 0 - don't spam logs
    return 0;
  }
});

// Mark as read
Future<void> markNotificationAsRead(WidgetRef ref, int id) async {
  await ref.read(notificationRepositoryProvider).markAsRead(id);
  ref.invalidate(notificationsProvider);
  ref.invalidate(unreadNotificationCountProvider);
}

// Mark all as read
Future<void> markAllNotificationsAsRead(WidgetRef ref) async {
  await ref.read(notificationRepositoryProvider).markAllAsRead();
  ref.invalidate(notificationsProvider);
  ref.invalidate(unreadNotificationCountProvider);
}

// Refresh notifications
void refreshNotifications(WidgetRef ref) {
  ref.invalidate(notificationsProvider);
  ref.invalidate(unreadNotificationCountProvider);
}
