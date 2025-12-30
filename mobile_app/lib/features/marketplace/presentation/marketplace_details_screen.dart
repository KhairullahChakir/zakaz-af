import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/widgets/custom_cached_image.dart';
import '../data/marketplace_repository.dart';
import '../domain/marketplace_item.dart';

class MarketplaceDetailsScreen extends ConsumerWidget {
  final int itemId;
  const MarketplaceDetailsScreen({super.key, required this.itemId});

  Future<void> _makeCall(String phone) async {
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(marketplaceItemDetailsProvider(itemId));

    return Scaffold(
      body: itemAsync.when(
        data: (item) => _buildContent(context, ref, item),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: itemAsync.maybeWhen(
        data: (item) => _buildBottomAction(context, ref, item),
        orElse: () => null,
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, MarketplaceItem item) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: item.galleryUrls != null && item.galleryUrls!.isNotEmpty
                ? PageView.builder(
                    itemCount: item.galleryUrls!.length,
                    itemBuilder: (context, index) => CustomCachedImage(
                      imageUrl: item.galleryUrls![index],
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(color: context.softOrange),
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
                        color: context.softOrange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        ref.tr('condition_${item.condition}'),
                        style: const TextStyle(color: Color(0xFFFF6B00), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${item.price.toInt()} ${ref.tr('afn')}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B00),
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
                        child: const Icon(Icons.person, color: Color(0xFFFF6B00)),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        boxShadow: [
          BoxShadow(color: context.shadowColor, blurRadius: 10, offset: const Offset(0, -2))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _makeCall(item.phone),
              icon: const Icon(Icons.phone),
              label: Text(ref.tr('call')),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF6B00),
                side: const BorderSide(color: Color(0xFFFF6B00)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // Future: Integrate with chat system
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat system integration coming soon')),
                );
              },
              icon: const Icon(Icons.chat),
              label: Text(ref.tr('chat')),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
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
