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
import 'package:url_launcher/url_launcher.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/theme/theme_context.dart';

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
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.appBarColor,
        foregroundColor: context.appBarTextColor,
        title: Text(ref.tr('product_details')),
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
                      content: Text(ref.tr(isWishlisted ? 'removed_from_wishlist' : 'added_to_wishlist')),
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
                      // Product Image Carousel
                      SizedBox(
                        height: Responsive.value(context, mobile: 320, tablet: 400),
                        child: _ProductImageCarousel(product: product),
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
                                  ref.tr(product.category!.name.toLowerCase()),
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
                                color: context.textPrimary,
                              ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Price
                            Text(
                              '${product.price.toInt()} ${ref.tr('afn')}',
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
                                  product.stock > 0 
                                    ? '${ref.tr('in_stock')} (${product.stock})' 
                                    : ref.tr('out_of_stock'),
                                  style: TextStyle(
                                    color: product.stock > 0 ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            
                            // Description
                            Text(
                              ref.tr('description'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.value(context, mobile: 16, tablet: 18),
                                color: context.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.description ?? ref.tr('no_description'),
                              style: TextStyle(
                                color: context.textSecondary,
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
                                  ref.tr('reviews'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.value(context, mobile: 16, tablet: 18),
                                    color: context.textPrimary,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => _showAddReviewDialog(context, ref),
                                  icon: const Icon(Icons.add_comment, color: kPrimaryOrange),
                                  label: Text(ref.tr('write_review'), style: const TextStyle(color: kPrimaryOrange)),
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
                                      color: context.softOrange,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.rate_review, size: 40, color: kPrimaryOrange),
                                        const SizedBox(height: 8),
                                        Text(
                                          ref.tr('no_reviews'),
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(ref.tr('be_first_to_review')),
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
                                              review.user?.name ?? ref.tr('nav_account'),
                                              style: TextStyle(fontWeight: FontWeight.bold, color: context.textPrimary),
                                            ),
                                            const Spacer(),
                                            Text(
                                              DateFormat('MMM dd, yyyy').format(review.createdAt),
                                              style: TextStyle(color: context.textSecondary, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        if (review.comment != null && review.comment!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(review.comment!, style: TextStyle(color: context.textPrimary)),
                                          ),
                                      ],
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
                              error: (err, _) => Text('${ref.tr('error_loading_reviews')}: $err'),
                            ),
                            
                            // Shopkeeper Info Section - PREMIUM (after reviews)
                            if (product.shop != null) ...[
                              const Divider(height: 32),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [context.softOrange, context.cardColor],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: kPrimaryOrange.withValues(alpha: 0.2)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kPrimaryOrange.withValues(alpha: 0.1),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header
                                    Row(
                                      children: [
                                        Icon(Icons.store, color: kPrimaryOrange, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          ref.tr('sold_by'),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Responsive.value(context, mobile: 14, tablet: 16),
                                            color: kPrimaryOrange,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade100,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.verified, color: Colors.green.shade700, size: 14),
                                              const SizedBox(width: 4),
                                              Text(
                                                ref.tr('verified_seller'),
                                                style: TextStyle(
                                                  color: Colors.green.shade700,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // Shop Info Row
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Shop Photo
                                        Container(
                                          width: Responsive.value(context, mobile: 80, tablet: 100),
                                          height: Responsive.value(context, mobile: 80, tablet: 100),
                                          decoration: BoxDecoration(
                                            color: context.cardColor,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(color: kPrimaryOrange.withValues(alpha: 0.3), width: 2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.1),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(14),
                                            child: product.shop!.mainPhotoUrl != null
                                                ? Image.network(
                                                    product.shop!.mainPhotoUrl!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (_, __, ___) => const Icon(
                                                      Icons.store,
                                                      color: kPrimaryOrange,
                                                      size: 40,
                                                    ),
                                                  )
                                                : const Icon(Icons.store, color: kPrimaryOrange, size: 40),
                                          ),
                                        ),
                                        SizedBox(width: Responsive.value(context, mobile: 16, tablet: 20)),
                                        
                                        // Shop Details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Shop Name
                                              Text(
                                                product.shop!.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Responsive.value(context, mobile: 18, tablet: 20),
                                                  color: context.textPrimary,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 6),
                                              
                                              // Shop Type Badge
                                              if (product.shop!.shopType != null)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryOrange.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    ref.tr('type_${product.shop!.shopType!.toLowerCase()}'),
                                                    style: TextStyle(
                                                      color: kPrimaryOrange,
                                                      fontSize: Responsive.value(context, mobile: 12, tablet: 14),
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              
                                              const SizedBox(height: 8),
                                              
                                              // Location
                                              if (product.shop!.city != null || product.shop!.district != null)
                                                Row(
                                                  children: [
                                                    Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        [product.shop!.district, product.shop!.city]
                                                            .where((e) => e != null)
                                                            .join(', '),
                                                        style: TextStyle(
                                                          color: context.textSecondary,
                                                          fontSize: Responsive.value(context, mobile: 13, tablet: 15),
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              
                                              // Phone
                                              if (product.shop!.phone != null) ...[
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(Icons.phone_outlined, size: 16, color: Colors.grey[600]),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      product.shop!.phone!,
                                                      style: TextStyle(
                                                        color: context.textSecondary,
                                                        fontSize: Responsive.value(context, mobile: 13, tablet: 15),
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
                                    
                                    // Owner Info
                                    if (product.shop!.owner != null) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: context.cardColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: context.softOrange,
                                              backgroundImage: product.shop!.owner!.profileImageUrl != null
                                                  ? NetworkImage(product.shop!.owner!.profileImageUrl!)
                                                  : null,
                                              child: product.shop!.owner!.profileImageUrl == null
                                                  ? const Icon(Icons.person, size: 20, color: kPrimaryOrange)
                                                  : null,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    ref.tr('shop_owner'),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                  Text(
                                                    product.shop!.owner!.name,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: context.textPrimary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Quick Call
                                            if (product.shop!.owner!.phone != null)
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade50,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: IconButton(
                                                  icon: Icon(Icons.call, color: Colors.green.shade600, size: 20),
                                                  onPressed: () async {
                                                  final phone = product.shop!.owner!.phone!;
                                                  final uri = Uri.parse('tel:$phone');
                                                  try {
                                                    if (await canLaunchUrl(uri)) {
                                                      await launchUrl(uri);
                                                    }
                                                  } catch (e) {
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text('${ref.tr('error')}: $e')),
                                                      );
                                                    }
                                                  }
                                                  },
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    
                                    // Contact Buttons
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        // WhatsApp button
                                        if (product.shop!.phone != null)
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                                                ),
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(0xFF25D366).withValues(alpha: 0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () async {
                                                    try {
                                                      final phone = product.shop!.phone!.replaceAll(RegExp(r'[^0-9]'), '');
                                                      final message = ref.tr('whatsapp_msg', args: {'name': product.name});
                                                      final whatsappUrl = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
                                                      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                                                    } catch (e) {
                                                      if (context.mounted) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text(ref.tr('could_not_open_whatsapp'))),
                                                        );
                                                      }
                                                    }
                                                  },
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      vertical: Responsive.value(context, mobile: 14, tablet: 16),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/whatsapp.png',
                                                          width: 20,
                                                          height: 20,
                                                          color: Colors.white,
                                                          errorBuilder: (_, __, ___) => const Icon(Icons.chat, color: Colors.white, size: 20),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          ref.tr('whatsapp'),
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
                                        if (product.shop!.phone != null) const SizedBox(width: 12),
                                        
                                        // In-app Chat button
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [kPrimaryOrange, kLightOrange],
                                              ),
                                              borderRadius: BorderRadius.circular(12),
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
                                                onTap: () async {
                                                  try {
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
                                                          content: Text('${ref.tr('error')}: $e'),
                                                          backgroundColor: Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                borderRadius: BorderRadius.circular(12),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: Responsive.value(context, mobile: 14, tablet: 16),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        ref.tr('nav_messages'),
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
                                        
                                        // Call button
                                        if (product.shop!.phone != null) ...[
                                          const SizedBox(width: 12),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: Colors.blue.shade200),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () async {
                                                  final phone = product.shop!.phone!;
                                                  final uri = Uri.parse('tel:$phone');
                                                  if (await canLaunchUrl(uri)) {
                                                    await launchUrl(uri);
                                                  }
                                                },
                                                borderRadius: BorderRadius.circular(12),
                                                child: Padding(
                                                  padding: EdgeInsets.all(Responsive.value(context, mobile: 14, tablet: 16)),
                                                  child: Icon(Icons.call, color: Colors.blue.shade600, size: 22),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                  color: context.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: context.shadowColor,
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
                          content: Text('${product.name} ${ref.tr('added_to_cart_success')}'),
                          backgroundColor: kPrimaryOrange,
                        ),
                      );
                    } : null,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(product.stock > 0 ? ref.tr('add_to_cart') : ref.tr('out_of_stock')),
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
        error: (err, stack) => Center(child: Text('${ref.tr('error')}: $err')),
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
          title: Text(ref.tr('write_review')),
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
                  labelText: ref.tr('comment_optional'),
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
              child: Text(ref.tr('cancel')),
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
                      SnackBar(
                        content: Text(ref.tr('review_submitted')),
                        backgroundColor: kPrimaryOrange,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${ref.tr('error')}: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryOrange),
              child: Text(ref.tr('submit'), style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImageCarousel extends StatefulWidget {
  final dynamic product;

  const _ProductImageCarousel({required this.product});

  @override
  State<_ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<_ProductImageCarousel> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  List<String> get _allImages {
    final List<String> images = [];
    if (widget.product.imageUrl != null) images.add(widget.product.imageUrl);
    if (widget.product.galleryUrls != null) {
      images.addAll(widget.product.galleryUrls!);
    }
    return images.toSet().toList(); // Ensure unique
  }

  @override
  Widget build(BuildContext context) {
    final images = _allImages;

    if (images.isEmpty) {
      return Container(
        color: kSoftOrange,
        child: const Icon(Icons.inventory_2_outlined, size: 100, color: kPrimaryOrange),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: images.length,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => openFullScreenImage(
                context, 
                images[index],
                heroTag: 'product_image_${widget.product.id}_$index',
              ),
              child: Hero(
                tag: 'product_image_${widget.product.id}_$index',
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image, 
                    size: 100, 
                    color: kPrimaryOrange,
                  ),
                ),
              ),
            );
          },
        ),
        
        // Dots Indicator
        if (images.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? kPrimaryOrange : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

        // Zoom Hint (only if images)
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.zoom_in, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  '${_currentPage + 1}/${images.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
