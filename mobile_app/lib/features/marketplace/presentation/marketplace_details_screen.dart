import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/widgets/custom_cached_image.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../chat/data/chat_repository.dart';
import '../data/marketplace_repository.dart';
import '../domain/marketplace_item.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);

class MarketplaceDetailsScreen extends ConsumerWidget {
  final int itemId;
  const MarketplaceDetailsScreen({super.key, required this.itemId});

  Future<void> _makeCall(String phone) async {
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _shareListing(BuildContext context, WidgetRef ref, MarketplaceItem item) {
    final shareText = ref.tr('share_listing_text')
        .replaceAll('{name}', item.name)
        .replaceAll('{price}', item.price.toStringAsFixed(0));
    // ignore: deprecated_member_use
    Share.share(shareText);
  }

  void _showReportDialog(BuildContext context, WidgetRef ref, MarketplaceItem item) {
    String? selectedReason;
    final reasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.flag_outlined, color: Colors.red),
                  const SizedBox(width: 12),
                  Text(
                    ref.tr('report_listing'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                ref.tr('report_reason'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              
              // Reason options
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildReasonChip(
                    context, ref, 'inappropriate', ref.tr('report_inappropriate'),
                    selectedReason, (v) => setState(() => selectedReason = v),
                  ),
                  _buildReasonChip(
                    context, ref, 'scam', ref.tr('report_scam'),
                    selectedReason, (v) => setState(() => selectedReason = v),
                  ),
                  _buildReasonChip(
                    context, ref, 'wrong_category', ref.tr('report_wrong_category'),
                    selectedReason, (v) => setState(() => selectedReason = v),
                  ),
                  _buildReasonChip(
                    context, ref, 'duplicate', ref.tr('report_duplicate'),
                    selectedReason, (v) => setState(() => selectedReason = v),
                  ),
                  _buildReasonChip(
                    context, ref, 'other', ref.tr('report_other'),
                    selectedReason, (v) => setState(() => selectedReason = v),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Additional details
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: ref.tr('report_details'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: context.inputFillColor,
                ),
              ),
              const SizedBox(height: 20),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: selectedReason == null ? null : () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ref.tr('report_submitted'), style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(ref.tr('report_thanks'), style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(ref.tr('report_listing')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReasonChip(
    BuildContext context, WidgetRef ref, 
    String value, String label, 
    String? selected, Function(String) onSelect
  ) {
    final isSelected = selected == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelect(value),
      selectedColor: Colors.red.shade100,
      checkmarkColor: Colors.red,
      labelStyle: TextStyle(
        color: isSelected ? Colors.red : context.textPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(marketplaceItemDetailsProvider(itemId));
    final language = ref.watch(languageProvider);
    final isRTL = language.isRTL;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: itemAsync.when(
          data: (item) => _buildContent(context, ref, item),
          loading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: kPrimaryOrange),
                SizedBox(height: 16),
                Text('Loading item details...'),
              ],
            ),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Failed to load item', style: TextStyle(color: context.textSecondary)),
                const SizedBox(height: 8),
                Text('$e', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(marketplaceItemDetailsProvider(itemId)),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(backgroundColor: kPrimaryOrange),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: itemAsync.maybeWhen(
          data: (item) => _buildBottomAction(context, ref, item),
          orElse: () => null,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, MarketplaceItem item) {
    final currentUser = ref.watch(authControllerProvider).value;
    final isSold = item.status == 'sold';
    
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          actions: [
            // Share Button
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareListing(context, ref, item),
              tooltip: ref.tr('share_listing'),
            ),
            // Report Button (only for non-owners)
            if (currentUser?.id != item.userId)
              IconButton(
                icon: const Icon(Icons.flag_outlined),
                onPressed: () => _showReportDialog(context, ref, item),
                tooltip: ref.tr('report_listing'),
              ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Image Gallery
                if (item.galleryUrls != null && item.galleryUrls!.isNotEmpty)
                  PageView.builder(
                    itemCount: item.galleryUrls!.length,
                    itemBuilder: (context, index) => CustomCachedImage(
                      imageUrl: item.galleryUrls![index],
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(color: context.softOrange),
                
                // SOLD Overlay
                if (isSold)
                  Container(
                    color: Colors.black.withValues(alpha: 0.6),
                    child: Center(
                      child: Transform.rotate(
                        angle: -0.3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Text(
                            ref.tr('sold'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 6,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                
                // Boosted Badge
                if (item.isBoosted)
                  Positioned(
                    top: 80,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.deepOrange],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.rocket_launch, size: 16, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            ref.tr('featured'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSold ? Colors.red.shade100 : context.softOrange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isSold ? ref.tr('sold') : ref.tr('condition_${item.condition}'),
                        style: TextStyle(
                          color: isSold ? Colors.red : kPrimaryOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (currentUser?.id == item.userId) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          ref.tr('this_is_your_item'),
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  '${item.price.toInt()} ${ref.tr('afn')}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isSold ? Colors.grey : kPrimaryOrange,
                    decoration: isSold ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  ref.tr('description'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: TextStyle(fontSize: 16, color: context.textSecondary),
                ),
                const SizedBox(height: 24),
                
                // Seller Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.dividerColor),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: context.softOrange,
                        child: const Icon(Icons.person, color: kPrimaryOrange),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.user?.name ?? 'Seller',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              item.location ?? 'Afghanistan',
                              style: TextStyle(color: context.textSecondary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context, WidgetRef ref, MarketplaceItem item) {
    final currentUser = ref.watch(authControllerProvider).value;
    final isOwner = currentUser?.id == item.userId;
    final isSold = item.status == 'sold';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        boxShadow: [
          BoxShadow(color: context.shadowColor, blurRadius: 10, offset: const Offset(0, -2))
        ],
      ),
      child: isSold
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  ref.tr('sold'),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _makeCall(item.phone),
                    icon: const Icon(Icons.phone),
                    label: Text(ref.tr('call')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kPrimaryOrange,
                      side: const BorderSide(color: kPrimaryOrange),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isOwner
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(ref.tr('error_chat_self'))),
                            );
                          }
                        : () async {
                            try {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(child: CircularProgressIndicator()),
                              );

                              final conversation = await ref.read(chatRepositoryProvider).startConversation(
                                    sellerId: item.userId,
                                    marketplaceItemId: item.id,
                                  );

                              if (context.mounted) {
                                Navigator.pop(context);
                                context.push('/chat/${conversation.id}', extra: conversation);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error starting conversation: $e')),
                                );
                              }
                            }
                          },
                    icon: const Icon(Icons.chat),
                    label: Text(ref.tr('chat')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOwner ? Colors.grey : kPrimaryOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
