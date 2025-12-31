import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/widgets/custom_cached_image.dart';
import '../data/marketplace_repository.dart';
import '../domain/marketplace_item.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myItemsAsync = ref.watch(myMarketplaceItemsProvider);
    final language = ref.watch(languageProvider);
    final isRTL = language.isRTL;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(ref.tr('my_listings')),
          backgroundColor: kPrimaryOrange,
          foregroundColor: Colors.white,
        ),
        body: myItemsAsync.when(
          data: (items) => items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: context.textSecondary),
                      const SizedBox(height: 16),
                      Text(ref.tr('no_listings_yet')),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => context.push('/marketplace/add'),
                        style: ElevatedButton.styleFrom(backgroundColor: kPrimaryOrange),
                        child: Text(ref.tr('post_an_ad'), style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) => _MyListingCard(item: items[index]),
                ),
          loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/marketplace/add'),
          backgroundColor: kPrimaryOrange,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(ref.tr('post_an_ad'), style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class _MyListingCard extends ConsumerWidget {
  final MarketplaceItem item;
  const _MyListingCard({required this.item});

  void _shareListing(BuildContext context, WidgetRef ref) {
    final shareText = ref.tr('share_listing_text')
        .replaceAll('{name}', item.name)
        .replaceAll('{price}', item.price.toStringAsFixed(0));
    SharePlus.share(shareText);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSold = item.status == 'sold';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Image with SOLD overlay
          Stack(
            children: [
              // Image
              SizedBox(
                height: 180,
                width: double.infinity,
                child: item.mainImageUrl != null
                    ? CustomCachedImage(
                        imageUrl: item.mainImageUrl!,
                        fit: BoxFit.cover,
                      )
                    : Container(color: context.softOrange),
              ),
              
              // SOLD Overlay
              if (isSold)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.6),
                    child: Center(
                      child: Transform.rotate(
                        angle: -0.3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Text(
                            ref.tr('sold'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              
              // Boosted Badge
              if (item.isBoosted == true)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.orange, Colors.deepOrange],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.rocket_launch, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          ref.tr('boosted'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Status Badge
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSold ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isSold ? ref.tr('sold') : 'Active',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.price.toInt()} ${ref.tr('afn')} • ${ref.tr('condition_${item.condition}')}',
                  style: TextStyle(color: context.textSecondary),
                ),
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    // Edit Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isSold ? null : () => context.push('/marketplace/edit', extra: item),
                        icon: const Icon(Icons.edit, size: 18),
                        label: Text(ref.tr('edit')),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kPrimaryOrange,
                          side: BorderSide(color: isSold ? Colors.grey : kPrimaryOrange),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Share Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _shareListing(context, ref),
                        icon: const Icon(Icons.share, size: 18),
                        label: Text(ref.tr('share_listing')),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    // Mark as Sold Button
                    if (!isSold)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await ref.read(marketplaceRepositoryProvider).updateListing(item.id, status: 'sold');
                            ref.invalidate(myMarketplaceItemsProvider);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(ref.tr('marked_as_sold')),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.check_circle, size: 18),
                          label: Text(ref.tr('mark_as_sold')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    if (!isSold) const SizedBox(width: 8),
                    
                    // Delete Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _confirmDelete(context, ref, item.id),
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: Text(ref.tr('delete')),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.delete_forever, color: Colors.red.shade600),
            ),
            const SizedBox(width: 12),
            Text(ref.tr('delete')),
          ],
        ),
        content: Text('Are you sure you want to delete this listing permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(ref.tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(marketplaceRepositoryProvider).deleteListing(id);
              ref.invalidate(myMarketplaceItemsProvider);
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(ref.tr('delete'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
