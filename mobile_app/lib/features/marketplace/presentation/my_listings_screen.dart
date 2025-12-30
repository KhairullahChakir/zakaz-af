import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/widgets/custom_cached_image.dart';
import '../data/marketplace_repository.dart';
import '../domain/marketplace_item.dart';

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myItemsAsync = ref.watch(myMarketplaceItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('my_listings')),
        backgroundColor: const Color(0xFFFF6B00),
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
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B00)),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _MyListingCard extends ConsumerWidget {
  final MarketplaceItem item;
  const _MyListingCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.mainImageUrl != null
                  ? CustomCachedImage(imageUrl: item.mainImageUrl!, width: 60, height: 60, fit: BoxFit.cover)
                  : Container(width: 60, height: 60, color: context.softOrange),
            ),
            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${item.price.toInt()} AFN • ${ref.tr('condition_${item.condition}')}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: item.status == 'active' ? Colors.green.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: item.status == 'active' ? Colors.green.shade800 : Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (item.status == 'active')
                  TextButton.icon(
                    onPressed: () async {
                      await ref.read(marketplaceRepositoryProvider).updateListing(item.id, status: 'sold');
                      ref.invalidate(myMarketplaceItemsProvider);
                    },
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Mark as Sold'),
                  ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _confirmDelete(context, ref, item.id),
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
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
        title: const Text('Delete Listing?'),
        content: const Text('Are you sure you want to delete this listing permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await ref.read(marketplaceRepositoryProvider).deleteListing(id);
              ref.invalidate(myMarketplaceItemsProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
