import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/widgets/custom_cached_image.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../products/presentation/providers.dart';
import '../data/marketplace_repository.dart';
import '../domain/marketplace_item.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  int? _selectedCategoryId;
  String? _searchQuery;
  final TextEditingController _searchController = TextEditingController();
  
  // Debounce timer for search
  DateTime? _lastSearchTime;
  static const _searchDebounce = Duration(milliseconds: 500);

  void _onSearchChanged(String value) {
    _lastSearchTime = DateTime.now();
    
    // Debounce: wait before searching
    Future.delayed(_searchDebounce, () {
      if (_lastSearchTime != null && 
          DateTime.now().difference(_lastSearchTime!) >= _searchDebounce) {
        if (mounted) {
          setState(() => _searchQuery = value.isEmpty ? null : value);
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(marketplaceItemsProvider(
      categoryId: _selectedCategoryId,
      search: _searchQuery,
    ));
    final categoriesAsync = ref.watch(categoriesProvider);

    final padding = Responsive.value<double>(context, mobile: 16, tablet: 24);
    final gridColumns = Responsive.gridColumns(context);

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: RefreshIndicator(
        color: const Color(0xFFFF6B00),
        onRefresh: () async {
          ref.invalidate(marketplaceItemsProvider);
          ref.invalidate(marketplaceItemsCacheProvider);
          // Small delay to ensure the refresh indicator is visible
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Header
          SliverAppBar(
            floating: true,
            backgroundColor: const Color(0xFFFF6B00),
            foregroundColor: Colors.white,
            title: Text(
              ref.tr('marketplace_title'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.list_alt),
                onPressed: () => context.push('/marketplace/my-listings'),
                tooltip: ref.tr('my_listings'),
              ),
            ],
          ),

          // Search & Filter
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(padding),
              color: const Color(0xFFFF6B00),
              child: Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: ref.tr('marketplace_search_hint'),
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: SizedBox(
              height: 60,
              child: categoriesAsync.when(
                data: (categories) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: padding - 8),
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(ref.tr('all')),
                          selected: _selectedCategoryId == null,
                          onSelected: (_) => setState(() => _selectedCategoryId = null),
                        ),
                      );
                    }
                    final category = categories[index - 1];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(ref.tr(category.name.toLowerCase())),
                        selected: _selectedCategoryId == category.id,
                        onSelected: (selected) {
                          setState(() => _selectedCategoryId = selected ? category.id : null);
                        },
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox(),
              ),
            ),
          ),

          // List Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(padding, 16, padding, 8),
              child: Text(
                ref.tr('second_hand_deals'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
            ),
          ),

          // Items Grid
          itemsAsync.when(
            data: (items) => items.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 64, color: context.textSecondary),
                          const SizedBox(height: 16),
                          Text(ref.tr('no_products_found'), style: TextStyle(color: context.textSecondary)),
                        ],
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.all(padding),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridColumns,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => RepaintBoundary(
                          child: _MarketplaceCard(item: items[index]),
                        ),
                        childCount: items.length,
                        addRepaintBoundaries: true,
                        addAutomaticKeepAlives: false, // Don't keep all items alive
                      ),
                    ),
                  ),
            loading: () => SliverPadding(
              padding: EdgeInsets.all(padding),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridColumns,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ShimmerLoading(child: SkeletonBox(height: 200, width: double.infinity)),
                  childCount: 6,
                ),
              ),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Center(child: Text('Error: $e')),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/marketplace/add'),
        backgroundColor: const Color(0xFFFF6B00),
        icon: const Icon(Icons.add_a_photo, color: Colors.white),
        label: Text(ref.tr('sell_something'), style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _MarketplaceCard extends ConsumerWidget {
  final MarketplaceItem item;
  const _MarketplaceCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSold = item.status == 'sold';
    
    return GestureDetector(
      onTap: () => context.push('/marketplace/details/${item.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: item.mainImageUrl != null
                        ? CustomCachedImage(
                            imageUrl: item.mainImageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: context.softOrange,
                            child: const Center(child: Icon(Icons.image, color: Color(0xFFFF6B00))),
                          ),
                  ),
                  
                  // SOLD Overlay
                  if (isSold)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.5),
                          child: Center(
                            child: Transform.rotate(
                              angle: -0.3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Text(
                                  ref.tr('sold'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  // Condition Badge
                  if (!isSold)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ref.tr('condition_${item.condition}'),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  
                  // Boosted Badge
                  if (item.isBoosted && !isSold)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.rocket_launch, size: 10, color: Colors.white),
                            const SizedBox(width: 3),
                            Text(
                              ref.tr('featured'),
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 14,
                      color: isSold ? Colors.grey : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.price.toInt()} ${ref.tr('afn')}',
                    style: TextStyle(
                      color: isSold ? Colors.grey : const Color(0xFFFF6B00),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: isSold ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 12, color: context.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.location ?? 'Afghanistan',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: context.textSecondary, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
