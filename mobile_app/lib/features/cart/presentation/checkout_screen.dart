import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile_app/features/addresses/presentation/address_provider.dart';
import 'package:mobile_app/features/addresses/domain/address.dart';
import 'package:mobile_app/features/orders/data/order_repository.dart';
import 'cart_provider.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kDarkOrange = Color(0xFFE55A00);
const Color kSoftOrange = Color(0xFFFFF3E6);

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isLoading = false;
  Address? _selectedAddress;

  @override
  void initState() {
    super.initState();
    // Pre-select default address
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addresses = ref.read(addressesProvider).value;
      if (addresses != null && addresses.isNotEmpty) {
        final defaultAddr = addresses.firstWhere(
          (a) => a.isDefault,
          orElse: () => addresses.first,
        );
        setState(() => _selectedAddress = defaultAddr);
      }
    });
  }

  Future<void> _placeOrder() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text('Please select a delivery address'),
            ],
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final cartState = ref.read(cartProvider);
      final items = cartState.value;

      if (items == null || items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cart is empty')),
        );
        return;
      }

      await ref.read(orderRepositoryProvider).placeOrder(
        items,
        addressId: _selectedAddress!.id,
      );

      ref.read(cartProvider.notifier).clearCart();

      if (mounted) {
        // Show success dialog
        _showOrderSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showOrderSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 64,
                  color: Colors.green.shade600,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Placed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your order has been placed successfully.\nYou can track it in My Orders.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: kPrimaryOrange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Continue Shopping'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/orders');
                },
                child: const Text(
                  'View My Orders',
                  style: TextStyle(color: kPrimaryOrange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItemsAsync = ref.watch(cartProvider);
    final addressesAsync = ref.watch(addressesProvider);

    final total = cartItemsAsync.value?.fold(
          0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
        ) ??
        0.0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: kPrimaryOrange),
                  const SizedBox(height: 24),
                  Text(
                    'Placing your order...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Address Section
                  _buildSectionCard(
                    icon: Icons.location_on_outlined,
                    title: 'Delivery Address',
                    trailing: TextButton.icon(
                      onPressed: () => context.push('/addresses'),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Manage'),
                      style: TextButton.styleFrom(foregroundColor: kPrimaryOrange),
                    ),
                    child: addressesAsync.when(
                      data: (addresses) {
                        if (addresses.isEmpty) {
                          return _buildEmptyAddresses();
                        }
                        return Column(
                          children: addresses.map((addr) {
                            return _buildAddressOption(addr);
                          }).toList(),
                        );
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
                      ),
                      error: (e, _) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Order Items Section
                  _buildSectionCard(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Order Items',
                    child: cartItemsAsync.when(
                      data: (items) => Column(
                        children: items.map((item) => _buildOrderItem(item)).toList(),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
                      error: (e, _) => Text('Error: $e'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment Summary Section
                  _buildSectionCard(
                    icon: Icons.receipt_long_outlined,
                    title: 'Payment Summary',
                    child: Column(
                      children: [
                        _buildSummaryRow('Subtotal', '${total.toInt()} AFN'),
                        const SizedBox(height: 8),
                        _buildSummaryRow('Delivery', 'Free', valueColor: Colors.green),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(),
                        ),
                        _buildSummaryRow(
                          'Total',
                          '${total.toInt()} AFN',
                          isBold: true,
                          valueColor: kPrimaryOrange,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
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
          child: SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: _isLoading ? null : _placeOrder,
              style: FilledButton.styleFrom(
                backgroundColor: kPrimaryOrange,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: kPrimaryOrange.withValues(alpha: 0.3),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_checkout),
                        SizedBox(width: 12),
                        Text(
                          'Place Order',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kSoftOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: kPrimaryOrange, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAddresses() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.location_off_outlined, size: 40, color: Colors.orange.shade400),
          const SizedBox(height: 12),
          const Text(
            'No addresses saved',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.push('/addresses/add'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add New Address'),
            style: FilledButton.styleFrom(
              backgroundColor: kPrimaryOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressOption(Address addr) {
    final isSelected = _selectedAddress?.id == addr.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedAddress = addr),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? kSoftOrange : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? kPrimaryOrange : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? kPrimaryOrange : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? kPrimaryOrange : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        addr.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (addr.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${addr.addressLine1}${addr.addressLine2 != null ? ", ${addr.addressLine2}" : ""}, ${addr.city}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(dynamic item) {
    final imageUrl = item.product.imageUrl ?? item.product.image;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 56,
              height: 56,
              color: kSoftOrange,
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const Icon(Icons.image, color: kPrimaryOrange),
                    )
                  : const Icon(Icons.image, color: kPrimaryOrange),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            '${(item.product.price * item.quantity).toInt()} AFN',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: kPrimaryOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 17 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? Colors.black : Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 20 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? (isBold ? kPrimaryOrange : Colors.black),
          ),
        ),
      ],
    );
  }
}
