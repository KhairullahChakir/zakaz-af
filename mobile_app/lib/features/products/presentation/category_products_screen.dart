import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../products/presentation/providers.dart';
import '../../products/domain/product.dart';
import '../../../core/utils/responsive.dart';
import '../../cart/presentation/cart_provider.dart';
import '../../wishlist/presentation/wishlist_provider.dart';
import '../../../core/localization/language_provider.dart';

// Orange Theme Colors
const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kSoftOrange = Color(0xFFFFF3E8);

class CategoryProductsScreen extends ConsumerWidget {
  final int categoryId;
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider(categoryId: categoryId));
    final padding = Responsive.value<double>(context, mobile: 16, tablet: 24, desktop: 32);
    final gridColumns = Responsive.gridColumns(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr(categoryName.toLowerCase())),
        centerTitle: true,
        backgroundColor: kPrimaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: productsAsync.when(
        data: (products) => products.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      ref.tr('no_products'),
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                padding: EdgeInsets.all(padding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridColumns,
                  childAspectRatio: Responsive.productCardRatio(context),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(context, ref, product);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
        error: (e, _) => Center(child: Text('${ref.tr('error')}: $e')),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, WidgetRef ref, Product product) {
    return GestureDetector(
      onTap: () => context.push('/products/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
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
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kSoftOrange,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: product.imageUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.network(
                              product.imageUrl!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(Icons.image, size: 40, color: kPrimaryOrange.withValues(alpha: 0.5)),
                              ),
                            ),
                          )
                        : Center(child: Icon(Icons.image, size: 40, color: kPrimaryOrange.withValues(alpha: 0.5))),
                  ),
                  // Wishlist button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer(
                      builder: (context, ref, _) {
                        final wishlistAsync = ref.watch(wishlistProvider);
                        final isInWishlist = wishlistAsync.value?.any((p) => p.id == product.id) ?? false;
                        
                        return GestureDetector(
                          onTap: () {
                            ref.read(wishlistProvider.notifier).toggleWishlist(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(ref.tr(isInWishlist ? 'removed_from_wishlist' : 'added_to_wishlist')),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isInWishlist ? Icons.favorite : Icons.favorite_border, 
                              size: 18, 
                              color: kPrimaryOrange,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                              '${product.price.toInt()} ${ref.tr('afn')}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: kPrimaryOrange,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ref.read(cartProvider.notifier).addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} ${ref.tr('added_to_cart_success')}'),
                                duration: const Duration(seconds: 1),
                                action: SnackBarAction(
                                  label: ref.tr('view').toUpperCase(),
                                  onPressed: () => context.push('/cart'),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: kPrimaryOrange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
