import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'notification_provider.dart';
import '../domain/app_notification.dart';
import '../../../core/localization/language_provider.dart';

// Orange Theme Colors
const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kSoftOrange = Color(0xFFFFF3E8);

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('notifications')),
        centerTitle: true,
        backgroundColor: kPrimaryOrange,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'read_all') {
                await markAllNotificationsAsRead(ref);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'read_all',
                child: Text(ref.tr('mark_all_read')),
              ),
            ],
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) => notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      ref.tr('no_notifications'),
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () async => refreshNotifications(ref),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _NotificationCard(notification: notification);
                  },
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  final AppNotification notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUnread = !notification.read;

    return GestureDetector(
      onTap: () async {
        if (isUnread) {
          await markNotificationAsRead(ref, notification.id);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUnread ? kSoftOrange : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnread ? kPrimaryOrange.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2),
          ),
          boxShadow: [
            if (isUnread)
              BoxShadow(
                color: kPrimaryOrange.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getIconColor().withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(_getIcon(), color: _getIconColor(), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: kPrimaryOrange,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(ref, notification.createdAt),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (notification.type) {
      case 'order':
        return Icons.shopping_bag;
      case 'promotion':
        return Icons.local_offer;
      case 'message':
        return Icons.chat_bubble;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor() {
    switch (notification.type) {
      case 'order':
        return Colors.blue;
      case 'promotion':
        return Colors.green;
      case 'message':
        return Colors.purple;
      default:
        return kPrimaryOrange;
    }
  }

  String _formatDate(WidgetRef ref, String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final diff = now.difference(date);
      
      if (diff.inMinutes < 1) {
        return ref.tr('now');
      } else if (diff.inMinutes < 60) {
        return ref.tr('minutes_ago', args: {'m': diff.inMinutes.toString()});
      } else if (diff.inHours < 24) {
        return ref.tr('hours_ago', args: {'h': diff.inHours.toString()});
      } else if (diff.inDays < 7) {
        return ref.tr('days_ago', args: {'d': diff.inDays.toString()});
      } else {
        return DateFormat('MMM d').format(date);
      }
    } catch (e) {
      return '';
    }
  }
}
