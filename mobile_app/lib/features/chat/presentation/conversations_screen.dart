import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';
import '../../../core/utils/responsive.dart';
import '../data/chat_repository.dart';
import '../domain/conversation.dart';
import '../../../core/localization/language_provider.dart';

// Orange Theme Colors
const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kLightOrange = Color(0xFFFF8A33);
const Color kSoftOrange = Color(0xFFFFF3E6);

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);
    final currentUser = ref.watch(authControllerProvider).value;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: kPrimaryOrange,
        foregroundColor: Colors.white,
        title: Text(ref.tr('messages')),
        elevation: 0,
      ),
      body: conversationsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: kPrimaryOrange),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text('${ref.tr('error')}: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(conversationsProvider),
                style: ElevatedButton.styleFrom(backgroundColor: kPrimaryOrange),
                child: Text(ref.tr('retry'), style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        data: (conversations) {
          if (conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: kSoftOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: kPrimaryOrange,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    ref.tr('no_conversations_yet'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ref.tr('start_chat_with_seller'),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: kPrimaryOrange,
            onRefresh: () async => ref.invalidate(conversationsProvider),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: Responsive.value(context, mobile: 16.0, tablet: 24.0),
              ),
              itemCount: conversations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return _ConversationTile(
                  conversation: conversation,
                  currentUserId: currentUser?.id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ConversationTile extends ConsumerWidget {
  final Conversation conversation;
  final int? currentUserId;

  const _ConversationTile({
    required this.conversation,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participant = conversation.otherParticipant;
    final shop = conversation.shop;
    final latestMessage = conversation.latestMessage;
    final hasUnread = conversation.unreadCount > 0;
    
    // Determine what to show based on who we are
    final isMeCustomer = currentUserId == conversation.customerId;
    
    // If I am customer, show Shop info. If I am shopkeeper, show Customer (participant) info.
    String displayName = ref.tr('unknown');
    String? displayImage;
    bool isShopImage = false;

    if (isMeCustomer) {
      // Show Shop Info
      displayName = shop?.name ?? participant?.name ?? ref.tr('merchant');
      displayImage = shop?.mainPhotoUrl;
      isShopImage = true;
    } else {
      // Show Customer Info
      displayName = participant?.name ?? ref.tr('customer');
      displayImage = participant?.profileImageUrl;
      isShopImage = false;
    }

    return Container(
      decoration: BoxDecoration(
        color: hasUnread ? kSoftOrange : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push('/chat/${conversation.id}', extra: conversation);
          },
          child: Padding(
            padding: EdgeInsets.all(Responsive.value(context, mobile: 12, tablet: 16)),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: Responsive.value(context, mobile: 56, tablet: 64),
                  height: Responsive.value(context, mobile: 56, tablet: 64),
                  decoration: BoxDecoration(
                    color: kSoftOrange,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: displayImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: displayImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: kSoftOrange,
                              child: Icon(
                                isShopImage ? Icons.store : Icons.person,
                                color: kPrimaryOrange.withValues(alpha: 0.5),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              isShopImage ? Icons.store : Icons.person,
                              color: kPrimaryOrange,
                            ),
                          ),
                        )
                      : Icon(
                          isShopImage ? Icons.store : Icons.person,
                          color: kPrimaryOrange,
                        ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              displayName,
                              style: TextStyle(
                                fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                                fontSize: Responsive.value(context, mobile: 15, tablet: 17),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (latestMessage?.createdAt != null)
                            Text(
                              _formatTime(ref, latestMessage!.createdAt!),
                              style: TextStyle(
                                color: hasUnread ? kPrimaryOrange : Colors.grey[500],
                                fontSize: 12,
                                fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              latestMessage?.content ?? ref.tr('no_messages'),
                              style: TextStyle(
                                color: hasUnread ? Colors.grey[800] : Colors.grey[600],
                                fontSize: Responsive.value(context, mobile: 13, tablet: 14),
                                fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasUnread) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: kPrimaryOrange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${conversation.unreadCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      // Product context
                      if (conversation.product != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.shopping_bag, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  conversation.product!.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  String _formatTime(WidgetRef ref, DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat.jm().format(dateTime);
    } else if (difference.inDays == 1) {
      return ref.tr('yesterday');
    } else if (difference.inDays < 7) {
      return DateFormat.E().format(dateTime);
    } else {
      return DateFormat.MMMd().format(dateTime);
    }
  }
}
