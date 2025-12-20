import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/addresses/presentation/address_provider.dart';
import 'package:mobile_app/features/addresses/domain/address.dart';
import 'package:mobile_app/features/orders/data/order_repository.dart';
import 'cart_provider.dart';

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
        const SnackBar(content: Text('Please select a delivery address')),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Address Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Delivery Address',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.push('/addresses'),
                                child: const Text('Manage'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          addressesAsync.when(
                            data: (addresses) {
                              if (addresses.isEmpty) {
                                return Column(
                                  children: [
                                    const Text('No addresses saved'),
                                    const SizedBox(height: 8),
                                    FilledButton.tonal(
                                      onPressed: () => context.push('/addresses/add'),
                                      child: const Text('Add Address'),
                                    ),
                                  ],
                                );
                              }
                              return Column(
                                children: addresses.map((addr) {
                                  final isSelected = _selectedAddress?.id == addr.id;
                                  return RadioListTile<Address>(
                                    value: addr,
                                    groupValue: _selectedAddress,
                                    onChanged: (v) => setState(() => _selectedAddress = v),
                                    title: Row(
                                      children: [
                                        Text(
                                          addr.label,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        if (addr.isDefault)
                                          Container(
                                            margin: const EdgeInsets.only(left: 8),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              'Default',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      '${addr.addressLine1}${addr.addressLine2 != null ? ", ${addr.addressLine2}" : ""}, ${addr.city}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    selected: isSelected,
                                    activeColor: Theme.of(context).primaryColor,
                                  );
                                }).toList(),
                              );
                            },
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, _) => Text('Error: $e'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Order Summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          cartItemsAsync.when(
                            data: (items) => Column(
                              children: items.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${item.product.name} x${item.quantity}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '${item.product.price * item.quantity} AFN',
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            loading: () => const CircularProgressIndicator(),
                            error: (e, _) => Text('Error: $e'),
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$total AFN',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: SafeArea(
          child: FilledButton(
            onPressed: _isLoading ? null : _placeOrder,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Place Order', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
