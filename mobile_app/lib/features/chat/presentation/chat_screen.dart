import 'dart:async';
import '../../../core/widgets/custom_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';
import '../../../core/utils/responsive.dart';
import '../data/chat_repository.dart';
import '../domain/conversation.dart';
import '../domain/message.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/theme/theme_context.dart';

// Orange Theme Colors
const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kLightOrange = Color(0xFFFF8A33);
const Color kSoftOrange = Color(0xFFFFF3E6);

class ChatScreen extends ConsumerStatefulWidget {
  final int conversationId;
  final Conversation? conversation;

  const ChatScreen({
    super.key,
    required this.conversationId,
    this.conversation,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  Timer? _pollingTimer;
  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPolling();
    });
  }

  void _startPolling() {
    // Initial fetch handled by Riverpod provider usually, but we want to refresh it.
    // Poll every 3 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      ref.invalidate(conversationMessagesProvider(widget.conversationId));
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    try {
      final message = await ref.read(chatRepositoryProvider).sendMessage(
            conversationId: widget.conversationId,
            content: content,
          );

      _messageController.clear();
      setState(() {
        _messages.add(message);
      });
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${ref.tr('failed_to_send')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(conversationMessagesProvider(widget.conversationId));
    final currentUser = ref.watch(authControllerProvider).value;
    final conversation = widget.conversation;
    final currentUserId = currentUser?.id;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: kPrimaryOrange,
        titleSpacing: 0,
        title: Row(
          children: [
            // Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildAvatar(conversation, currentUserId),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getDisplayName(conversation, currentUserId),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (conversation?.product != null)
                    Text(
                      conversation!.product!.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: kPrimaryOrange),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${ref.tr('error')}: $error'),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(
                        conversationMessagesProvider(widget.conversationId),
                      ),
                      child: Text(ref.tr('retry')),
                    ),
                  ],
                ),
              ),
              data: (messages) {
                // Merge with local messages
                final allMessages = [...messages];
                for (final msg in _messages) {
                  if (!allMessages.any((m) => m.id == msg.id)) {
                    allMessages.add(msg);
                  }
                }

                if (allMessages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          ref.tr('start_conversation'),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.value(context, mobile: 16.0, tablet: 24.0),
                    vertical: 16,
                  ),
                  itemCount: allMessages.length,
                  itemBuilder: (context, index) {
                    final message = allMessages[index];
                    final isMe = message.senderId == currentUser?.id;
                    final showDate = index == 0 ||
                        !_isSameDay(
                          allMessages[index - 1].createdAt,
                          message.createdAt,
                        );

                    return Column(
                      children: [
                        if (showDate && message.createdAt != null)
                          _DateDivider(date: message.createdAt!),
                        _MessageBubble(
                          message: message,
                          isMe: isMe,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          // Message input
          Container(
            padding: EdgeInsets.all(Responsive.value(context, mobile: 12, tablet: 16)),
            decoration: BoxDecoration(
              color: context.cardColor,
              boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Text field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.inputFillColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(color: context.textPrimary),
                        decoration: InputDecoration(
                          hintText: ref.tr('type_message'),
                          hintStyle: TextStyle(color: context.textSecondary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        maxLines: 4,
                        minLines: 1,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Send button
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kPrimaryOrange, kLightOrange],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryOrange.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isSending ? null : _sendMessage,
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: _isSending
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 24,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildAvatar(Conversation? conversation, int? currentUserId) {
    if (conversation == null) return const Icon(Icons.store, color: kPrimaryOrange);

    final isMeCustomer = currentUserId == conversation.customerId;
    String? displayImage;
    bool isShopImage = false;

    if (isMeCustomer) {
      displayImage = conversation.shop?.mainPhotoUrl;
      isShopImage = true;
    } else {
      displayImage = conversation.otherParticipant?.profileImageUrl;
    }

    if (displayImage != null) {
      return CustomCachedImage(
        imageUrl: displayImage,
        fit: BoxFit.cover,
        borderRadius: 12,
        placeholder: Container(
          color: kSoftOrange,
          child: Icon(
            isShopImage ? Icons.store : Icons.person,
            color: kPrimaryOrange.withValues(alpha: 0.5),
          ),
        ),
        errorWidget: Icon(
          isShopImage ? Icons.store : Icons.person,
          color: kPrimaryOrange,
        ),
      );
    }
    
    return Icon(
      isShopImage ? Icons.store : Icons.person,
      color: kPrimaryOrange,
    );
  }

  String _getDisplayName(Conversation? conversation, int? currentUserId) {
    if (conversation == null) return ref.tr('chat');

    final isMeCustomer = currentUserId == conversation.customerId;

    if (isMeCustomer) {
      return conversation.shop?.name ?? conversation.otherParticipant?.name ?? ref.tr('merchant');
    } else {
      return conversation.otherParticipant?.name ?? ref.tr('customer');
    }
  }
}

class _DateDivider extends ConsumerWidget {
  final DateTime date;

  const _DateDivider({required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Theme.of(context).dividerColor)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _formatDate(ref, date),
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(child: Divider(color: Theme.of(context).dividerColor)),
        ],
      ),
    );
  }

  String _formatDate(WidgetRef ref, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return ref.tr('today');
    } else if (difference.inDays == 1) {
      return ref.tr('yesterday');
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const _MessageBubble({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            // Sender avatar
            CircleAvatar(
              radius: 16,
              backgroundColor: kSoftOrange,
              backgroundImage: message.sender?.profileImageUrl != null
                  ? NetworkImage(message.sender!.profileImageUrl!)
                  : null,
              child: message.sender?.profileImageUrl == null
                  ? const Icon(Icons.person, size: 16, color: kPrimaryOrange)
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? kPrimaryOrange : context.cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.shadowColor,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isMe ? Colors.white : context.textPrimary,
                      fontSize: Responsive.value(context, mobile: 14, tablet: 16),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (message.createdAt != null)
                        Text(
                          DateFormat.jm().format(message.createdAt!),
                          style: TextStyle(
                            color: isMe ? Colors.white.withValues(alpha: 0.7) : context.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 14,
                          color: message.isRead 
                              ? Colors.white 
                              : Colors.white.withValues(alpha: 0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
