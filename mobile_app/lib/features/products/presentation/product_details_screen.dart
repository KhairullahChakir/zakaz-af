import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/widgets/cart_icon_badge.dart';
import 'package:mobile_app/core/widgets/full_screen_image_viewer.dart';
import 'package:mobile_app/core/utils/responsive.dart';
import '../../products/presentation/providers.dart';
import '../../cart/presentation/cart_provider.dart';
import '../../reviews/presentation/reviews_provider.dart';
import '../../reviews/data/review_repository.dart';
import '../../wishlist/presentation/wishlist_provider.dart';
import '../../chat/data/chat_repository.dart';
import 'package:intl/intl.dart';

// Orange Theme Colors
const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kLightOrange = Color(0xFFFF8A33);
const Color kSoftOrange = Color(0xFFFFF3E6);

class ProductDetailsScreen extends ConsumerWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: kPrimaryOrange,
        foregroundColor: Colors.white,
        title: const Text('Product Details'),
        actions: [
          productAsync.when(
            data: (product) {
              final isWishlisted = ref.watch(wishlistProvider).value?.any((p) => p.id == product.id) ?? false;
              return IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  ref.read(wishlistProvider.notifier).toggleWishlist(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isWishlisted ? 'Removed from wishlist' : 'Added to wishlist'),
                      backgroundColor: kPrimaryOrange,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const CartIconBadge(),
        ],
      ),
      body: productAsync.when(
        data: (product) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image - Tappable for full screen
                      GestureDetector(
                        onTap: () {
                          final imageUrl = product.imageUrl ?? product.image;
                          if (imageUrl != null) {
                            openFullScreenImage(
                              context, 
                              imageUrl,
                              heroTag: 'product_image_$productId',
                            );
                          }
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: Responsive.value(context, mobile: 280, tablet: 350),
                              decoration: BoxDecoration(
                                color: kSoftOrange,
                              ),
                              width: double.infinity,
                              child: (product.imageUrl ?? product.image) != null
                                  ? Hero(
                                      tag: 'product_image_$productId',
                                      child: Image.network(
                                        product.imageUrl ?? product.image!, 
                                        fit: BoxFit.cover, 
                                        width: double.infinity,
                                        errorBuilder: (_, __, ___) => const Icon(
                                          Icons.inventory_2_outlined, 
                                          size: 100, 
                                          color: kPrimaryOrange,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.inventory_2_outlined, size: 100, color: kPrimaryOrange),
                            ),
                            // Tap to zoom hint
                            if ((product.imageUrl ?? product.image) != null)
                              Positioned(
                                bottom: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.zoom_in, color: Colors.white, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'Tap to zoom',
                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      Padding(
                        padding: EdgeInsets.all(Responsive.value(context, mobile: 16, tablet: 24)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category chip
                            if (product.category != null)
                              Chip(
                                label: Text(
                                  product.category!.name,
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                                backgroundColor: kPrimaryOrange,
                                padding: EdgeInsets.zero,
                              ),
                            
                            const SizedBox(height: 12),
                            
                            // Product name
                            Text(
                              product.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.value(context, mobile: 24, tablet: 28),
                              ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Price
                            Text(
                              '${product.price.toInt()} AFN',
                              style: TextStyle(
                                color: kPrimaryOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.value(context, mobile: 22, tablet: 26),
                              ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Stock status
                            Row(
                              children: [
                                Icon(
                                  product.stock > 0 ? Icons.check_circle : Icons.cancel,
                                  color: product.stock > 0 ? Colors.green : Colors.red,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  product.stock > 0 ? 'In Stock (${product.stock} available)' : 'Out of Stock',
                                  style: TextStyle(
                                    color: product.stock > 0 ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            
                            const Divider(height: 32),
                            
                            // Shopkeeper Info Section
                            if (product.shop != null) ...[
                              Text(
                                'Sold by',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.value(context, mobile: 16, tablet: 18),
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: EdgeInsets.all(Responsive.value(context, mobile: 12, tablet: 16)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: kPrimaryOrange.withOpacity(0.2)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Shop Photo
                                    Container(
                                      width: Responsive.value(context, mobile: 60, tablet: 80),
                                      height: Responsive.value(context, mobile: 60, tablet: 80),
                                      decoration: BoxDecoration(
                                        color: kSoftOrange,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: product.shop!.mainPhotoUrl != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.network(
                                                product.shop!.mainPhotoUrl!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => const Icon(
                                                  Icons.store,
                                                  color: kPrimaryOrange,
                                                  size: 30,
                                                ),
                                              ),
                                            )
                                          : const Icon(Icons.store, color: kPrimaryOrange, size: 30),
                                    ),
                                    SizedBox(width: Responsive.value(context, mobile: 12, tablet: 16)),
                                    // Shop Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  product.shop!.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Responsive.value(context, mobile: 15, tablet: 17),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: kSoftOrange,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(Icons.verified, color: kPrimaryOrange, size: 14),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'Verified',
                                                      style: TextStyle(
                                                        color: kPrimaryOrange,
                                                        fontSize: Responsive.value(context, mobile: 11, tablet: 13),
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          if (product.shop!.shopType != null)
                                            Text(
                                              product.shop!.shopType!,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: Responsive.value(context, mobile: 12, tablet: 14),
                                              ),
                                            ),
                                          const SizedBox(height: 4),
                                          if (product.shop!.city != null || product.shop!.district != null)
                                            Row(
                                              children: [
                                                Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    [product.shop!.district, product.shop!.city]
                                                        .where((e) => e != null)
                                                        .join(', '),
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: Responsive.value(context, mobile: 12, tablet: 14),
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          // Owner info
                                          if (product.shop!.owner != null) ...[
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor: kSoftOrange,
                                                  backgroundImage: product.shop!.owner!.profileImageUrl != null
                                                      ? NetworkImage(product.shop!.owner!.profileImageUrl!)
                                                      : null,
                                                  child: product.shop!.owner!.profileImageUrl == null
                                                      ? const Icon(Icons.person, size: 14, color: kPrimaryOrange)
                                                      : null,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Owner: ${product.shop!.owner!.name}',
                                                  style: TextStyle(
                                                    fontSize: Responsive.value(context, mobile: 12, tablet: 14),
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Contact buttons
                              if (product.shop!.phone != null) ...[
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    // Call button
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [kPrimaryOrange, kLightOrange],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: kPrimaryOrange.withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Row(
                                                    children: [
                                                      const Icon(Icons.phone, color: Colors.white),
                                                      const SizedBox(width: 12),
                                                      Text('Contact: ${product.shop!.phone}'),
                                                    ],
                                                  ),
                                                  backgroundColor: kPrimaryOrange,
                                                  behavior: SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                              );
                                            },
                                            borderRadius: BorderRadius.circular(12),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: Responsive.value(context, mobile: 14, tablet: 16),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.phone, color: Colors.white, size: 20),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Call Seller',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: Responsive.value(context, mobile: 14, tablet: 16),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Message button
                                    Container(
                                      decoration: BoxDecoration(
                                        color: kSoftOrange,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: kPrimaryOrange.withOpacity(0.3)),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () async {
                                            try {
                                              // Start or get existing conversation
                                              final conversation = await ref
                                                  .read(chatRepositoryProvider)
                                                  .startConversation(
                                                    shopId: product.shop!.id,
                                                    productId: product.id,
                                                  );
                                              
                                              if (context.mounted) {
                                                context.push('/chat/${conversation.id}', extra: conversation);
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Error: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          borderRadius: BorderRadius.circular(12),
                                          child: Padding(
                                            padding: EdgeInsets.all(Responsive.value(context, mobile: 14, tablet: 16)),
                                            child: const Icon(Icons.chat_bubble_outline, color: kPrimaryOrange, size: 22),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const Divider(height: 32),
                            ],
                            
                            // Description
                            Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.value(context, mobile: 16, tablet: 18),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.description ?? 'No description available',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: Responsive.value(context, mobile: 14, tablet: 16),
                                height: 1.5,
                              ),
                            ),
                            
                            const Divider(height: 32),
                            
                            // Reviews Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Reviews',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.value(context, mobile: 16, tablet: 18),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => _showAddReviewDialog(context, ref),
                                  icon: const Icon(Icons.add_comment, color: kPrimaryOrange),
                                  label: const Text('Add Review', style: TextStyle(color: kPrimaryOrange)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ref.watch(productReviewsProvider(productId)).when(
                              data: (reviews) {
                                if (reviews.isEmpty) {
                                  return Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: kSoftOrange,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Column(
                                      children: [
                                        Icon(Icons.rate_review, size: 40, color: kPrimaryOrange),
                                        SizedBox(height: 8),
                                        Text(
                                          'No reviews yet',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text('Be the first to review this product!'),
                                      ],
                                    ),
                                  );
                                }
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: reviews.length,
                                  separatorBuilder: (context, index) => const Divider(),
                                  itemBuilder: (context, index) {
                                    final review = reviews[index];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                              children: List.generate(5, (starIndex) {
                                                return Icon(
                                                  starIndex < review.rating ? Icons.star : Icons.star_border,
                                                  color: kPrimaryOrange,
                                                  size: 16,
                                                );
                                              }),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              review.user?.name ?? 'User',
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const Spacer(),
                                            Text(
                                              DateFormat('MMM dd, yyyy').format(review.createdAt),
                                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        if (review.comment != null && review.comment!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(review.comment!),
                                          ),
                                      ],
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
                              error: (err, _) => Text('Error loading reviews: $err'),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Add to Cart Button
              Container(
                padding: EdgeInsets.all(Responsive.value(context, mobile: 16, tablet: 24)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: FilledButton.icon(
                    onPressed: product.stock > 0 ? () {
                      ref.read(cartProvider.notifier).addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart'),
                          backgroundColor: kPrimaryOrange,
                        ),
                      );
                    } : null,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(product.stock > 0 ? 'Add to Cart' : 'Out of Stock'),
                    style: FilledButton.styleFrom(
                      backgroundColor: kPrimaryOrange,
                      disabledBackgroundColor: Colors.grey,
                      padding: EdgeInsets.all(Responsive.value(context, mobile: 16, tablet: 20)),
                      textStyle: TextStyle(
                        fontSize: Responsive.value(context, mobile: 16, tablet: 18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context, WidgetRef ref) {
    int rating = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: kPrimaryOrange,
                    ),
                    onPressed: () {
                      setDialogState(() => rating = index + 1);
                    },
                  );
                }),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: 'Comment (optional)',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: kPrimaryOrange, width: 2),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(reviewRepositoryProvider).postReview(
                        productId: productId,
                        rating: rating,
                        comment: commentController.text,
                      );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ref.invalidate(productReviewsProvider(productId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Review submitted successfully'),
                        backgroundColor: kPrimaryOrange,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryOrange),
              child: const Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
