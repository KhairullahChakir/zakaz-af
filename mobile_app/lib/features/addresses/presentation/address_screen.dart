import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'address_provider.dart';
import '../domain/address.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kDarkOrange = Color(0xFFE55A00);
const Color kSoftOrange = Color(0xFFFFF3E6);

class AddressScreen extends ConsumerWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Addresses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () => context.push('/addresses/add'),
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add, size: 22),
              ),
            ),
          ),
        ],
      ),
      body: addressesAsync.when(
        data: (addresses) {
          if (addresses.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildAddressList(context, ref, addresses);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: kPrimaryOrange),
        ),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text('Error: $e', style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => ref.invalidate(addressesProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: FilledButton.styleFrom(backgroundColor: kPrimaryOrange),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/addresses/add'),
        backgroundColor: kPrimaryOrange,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Add New', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
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
              Icons.location_off_outlined,
              size: 80,
              color: kPrimaryOrange,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'No Addresses Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add your delivery addresses to make\ncheckout faster and easier.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 220,
            height: 56,
            child: FilledButton.icon(
              onPressed: () => context.push('/addresses/add'),
              icon: const Icon(Icons.add_location_alt),
              label: const Text(
                'Add First Address',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: kPrimaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                shadowColor: kPrimaryOrange.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressList(BuildContext context, WidgetRef ref, List<Address> addresses) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: addresses.length + 1, // +1 for bottom spacing
      itemBuilder: (context, index) {
        if (index == addresses.length) {
          return const SizedBox(height: 80); // Space for FAB
        }
        final address = addresses[index];
        return _buildAddressCard(context, ref, address);
      },
    );
  }

  Widget _buildAddressCard(BuildContext context, WidgetRef ref, Address address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: address.isDefault ? kSoftOrange : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _getAddressIcon(address.label),
                    color: address.isDefault ? kPrimaryOrange : Colors.grey.shade600,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Address Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.label,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (address.isDefault) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [kPrimaryOrange, kDarkOrange],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star, size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'DEFAULT',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        address.addressLine1,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      if (address.addressLine2 != null && address.addressLine2!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            address.addressLine2!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        '${address.city}${address.zipCode != null ? ", ${address.zipCode}" : ""}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => context.push('/addresses/edit', extra: address),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(foregroundColor: kPrimaryOrange),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _confirmDelete(context, ref, address),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAddressIcon(String label) {
    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('home')) return Icons.home_outlined;
    if (lowerLabel.contains('work') || lowerLabel.contains('office')) return Icons.work_outline;
    if (lowerLabel.contains('shop') || lowerLabel.contains('store')) return Icons.store_outlined;
    return Icons.location_on_outlined;
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Address address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.delete_forever, color: Colors.red.shade400),
            ),
            const SizedBox(width: 12),
            const Text('Delete Address?'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${address.label}"? This action cannot be undone.',
          style: TextStyle(color: Colors.grey.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
          ),
          FilledButton(
            onPressed: () {
              ref.read(addressesProvider.notifier).deleteAddress(address.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 12),
                      Text('${address.label} deleted'),
                    ],
                  ),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
