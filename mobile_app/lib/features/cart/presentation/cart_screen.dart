import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/localization/language_provider.dart';
import 'cart_provider.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kDarkOrange = Color(0xFFE55A00);
const Color kSoftOrange = Color(0xFFFFF3E6);

class CartScreen extends ConsumerStatefulWidget {
  final VoidCallback? onNavigateToHome;
  
  const CartScreen({super.key, this.onNavigateToHome});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  void _goToCheckout() {
    context.push('/checkout');
  }

  @override
  Widget build(BuildContext context) {
    final cartItemsAsync = ref.watch(cartProvider);
    
    // Compute total from the current state
    final total = cartItemsAsync.value?.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity)) ?? 0.0;
    final itemCount = cartItemsAsync.value?.fold(0, (sum, item) => sum + item.quantity) ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          ref.tr('cart_title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          if (itemCount > 0)
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$itemCount ${ref.tr('items')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: cartItemsAsync.when(
        data: (cartItems) => cartItems.isEmpty
            ? _buildEmptyCart()
            : _buildCartWithItems(cartItems, total),
        loading: () => const Center(
          child: CircularProgressIndicator(color: kPrimaryOrange),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text('${ref.tr('error')}: $err', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: kSoftOrange,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kPrimaryOrange.withValues(alpha: 0.1),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: kPrimaryOrange,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            ref.tr('cart_empty'),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            ref.tr('discover_products_msg'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: 220,
            height: 56,
            child: FilledButton(
              onPressed: () {
                if (widget.onNavigateToHome != null) {
                  widget.onNavigateToHome!();
                } else {
                  context.go('/');
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: kPrimaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                shadowColor: kPrimaryOrange.withValues(alpha: 0.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined),
                  SizedBox(width: 8),
                  Text(
                    ref.tr('start_shopping'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  Widget _buildCartWithItems(List<dynamic> cartItems, double total) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return _buildCartItemCard(item);
            },
          ),
        ),
        // Premium Total and Checkout Section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, -4),
                blurRadius: 20,
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Order Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kSoftOrange,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ref.tr('subtotal'),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            '${total.toInt()} ${ref.tr('afn')}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ref.tr('delivery_fee'),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            ref.tr('free'),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ref.tr('cart_total'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${total.toInt()} ${ref.tr('afn')}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryOrange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: _goToCheckout,
                    style: FilledButton.styleFrom(
                      backgroundColor: kPrimaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: kPrimaryOrange.withValues(alpha: 0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ref.tr('proceed_to_checkout'),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItemCard(dynamic item) {
    // Use imageUrl first, fallback to image
    final imageUrl = item.product.imageUrl ?? item.product.image;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: kSoftOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: kSoftOrange,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryOrange,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: kSoftOrange,
                        child: const Icon(
                          Icons.image_outlined,
                          color: kPrimaryOrange,
                          size: 32,
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.image_outlined,
                        color: kPrimaryOrange,
                        size: 32,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                    '${item.product.price.toInt()} ${ref.tr('afn')}',
                  style: const TextStyle(
                    color: kPrimaryOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 12),
                // Quantity Controls
                Row(
                  children: [
                    // Decrease Button
                    _buildQuantityButton(
                      icon: Icons.remove,
                      onPressed: () {
                        if (item.quantity > 1) {
                          ref.read(cartProvider.notifier).updateQuantity(
                            item.product.id,
                            item.quantity - 1,
                          );
                        } else {
                          // Show confirmation dialog
                          _showRemoveDialog(item);
                        }
                      },
                    ),
                    // Quantity Display
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: kSoftOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kDarkOrange,
                        ),
                      ),
                    ),
                    // Increase Button
                    _buildQuantityButton(
                      icon: Icons.add,
                      onPressed: () {
                        ref.read(cartProvider.notifier).updateQuantity(
                          item.product.id,
                          item.quantity + 1,
                        );
                      },
                    ),
                    const Spacer(),
                    // Delete Button
                    IconButton(
                      onPressed: () => _showRemoveDialog(item),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red.shade400,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
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

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: kSoftOrange,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kPrimaryOrange.withValues(alpha: 0.2)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        color: kPrimaryOrange,
        padding: EdgeInsets.zero,
      ),
    );
  }

  void _showRemoveDialog(dynamic item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(ref.tr('remove_from_cart')),
        content: Text(
          ref.tr('remove_cart_item_confirm'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              ref.tr('cancel'),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          FilledButton(
            onPressed: () {
              ref.read(cartProvider.notifier).removeFromCart(item.product.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.product.name} ${ref.tr('cart_item_removed')}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(ref.tr('delete')),
          ),
        ],
      ),
    );
  }
}
