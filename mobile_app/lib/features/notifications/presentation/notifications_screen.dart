import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'notification_provider.dart';
import '../domain/app_notification.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/widgets/shimmer_loading.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kLightBg = Color(0xFFFBFBFD);
const Color kCardWhite = Colors.white;

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: kLightBg,
      appBar: AppBar(
        title: Text(
          ref.tr('notifications'),
          style: const TextStyle(color: Color(0xFF1D1D1F), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1D1D1F), size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF1D1D1F)),
            onSelected: (value) async {
              if (value == 'read_all') {
                await markAllNotificationsAsRead(ref);
              }
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'read_all',
                child: Row(
                  children: [
                    const Icon(Icons.done_all_rounded, size: 20, color: kPrimaryOrange),
                    const SizedBox(width: 12),
                    Text(ref.tr('mark_all_read')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) => notifications.isEmpty
            ? _buildEmptyState(context, ref)
            : RefreshIndicator(
                color: kPrimaryOrange,
                onRefresh: () async => refreshNotifications(ref),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  itemCount: notifications.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _NotificationCard(notification: notification);
                  },
                ),
              ),
        loading: () => const NotificationsSkeleton(),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 50,
                color: Color(0xFFE0E0E0),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              ref.tr('no_notifications'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1D1F),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              ref.tr('notification_empty_msg'), // Fallback if not exists or generic msg
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
          ],
        ),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kCardWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isUnread 
                ? kPrimaryOrange.withValues(alpha: 0.05) 
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: isUnread 
            ? Border.all(color: kPrimaryOrange.withValues(alpha: 0.1), width: 1) 
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (isUnread) {
              await markNotificationAsRead(ref, notification.id);
            }
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Block
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getIconColor().withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(_getIcon(), color: _getIconColor(), size: 24),
                ),
                const SizedBox(width: 16),
                
                // Content Block
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
                                fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600,
                                fontSize: 16,
                                color: const Color(0xFF1D1D1F),
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
                      const SizedBox(height: 6),
                      Text(
                        notification.body,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(ref, notification.createdAt),
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (!isUnread)
                           Icon(Icons.done_all_rounded, size: 14, color: Colors.grey.shade300),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (notification.type) {
      case 'order':
        return Icons.shopping_bag_rounded;
      case 'promotion':
        return Icons.local_offer_rounded;
      case 'message':
        return Icons.chat_bubble_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getIconColor() {
    switch (notification.type) {
      case 'order':
        return const Color(0xFF2196F3);
      case 'promotion':
        return const Color(0xFF4CAF50);
      case 'message':
        return const Color(0xFF9C27B0);
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

