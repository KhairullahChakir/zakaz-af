import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/cart/presentation/cart_provider.dart';

const Color _kPrimaryOrange = Color(0xFFFF6B00);

class CartIconBadge extends ConsumerWidget {
  final bool showBackground;
  final bool isSelected;
  
  const CartIconBadge({
    super.key, 
    this.showBackground = true,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider).value ?? [];
    final count = cartItems.fold(0, (sum, item) => sum + item.quantity);

    if (showBackground) {
      return Stack(
        children: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: isSelected ? _kPrimaryOrange : null,
            ),
            onPressed: () => context.push('/cart'),
          ),
          if (count > 0)
            Positioned(
              right: 8,
              top: 8,
              child: _buildBadge(count),
            ),
        ],
      );
    }

    // For navigation bar - just icon with badge
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          isSelected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
          color: isSelected ? _kPrimaryOrange : Colors.grey[600],
        ),
        if (count > 0)
          Positioned(
            right: -8,
            top: -4,
            child: _buildBadge(count),
          ),
      ],
    );
  }

  Widget _buildBadge(int count) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(
        minWidth: 16,
        minHeight: 16,
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
