import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/addresses/presentation/address_provider.dart';
import 'package:mobile_app/features/addresses/domain/address.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import '../../../core/theme/theme_context.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kDarkOrange = Color(0xFFE55A00);
const Color kSoftOrange = Color(0xFFFFF3E6);

class AddressScreen extends ConsumerWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesProvider);
    final language = ref.watch(languageProvider);
    final isRTL = language.isRTL;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBar(
          title: Text(
            ref.tr('my_addresses'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          backgroundColor: context.appBarColor,
          foregroundColor: context.appBarTextColor,
          elevation: 0,
        ),
        body: addressesAsync.when(
          data: (addresses) {
            if (addresses.isEmpty) {
              return _buildEmptyState(context, ref);
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
                Text('${ref.tr('error')}', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: () => ref.invalidate(addressesProvider),
                    icon: const Icon(Icons.refresh, size: 24),
                    label: Text(ref.tr('retry'), style: const TextStyle(fontSize: 16)),
                    style: FilledButton.styleFrom(
                      backgroundColor: kPrimaryOrange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Big floating button
        floatingActionButton: SizedBox(
          width: 160,
          height: 56,
          child: FloatingActionButton.extended(
            onPressed: () => context.push('/addresses/add'),
            backgroundColor: kPrimaryOrange,
            foregroundColor: Colors.white,
            elevation: 4,
            icon: const Icon(Icons.add, size: 28),
            label: Text(
              ref.tr('add_new'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Big icon
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: kSoftOrange,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off_outlined,
              size: 80,
              color: kPrimaryOrange,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            ref.tr('no_addresses_yet'),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            ref.tr('add_addresses_desc'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: context.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildAddressList(BuildContext context, WidgetRef ref, List<Address> addresses) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Bottom padding for FAB
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        return _buildAddressCard(context, ref, addresses[index]);
      },
    );
  }

  Widget _buildAddressCard(BuildContext context, WidgetRef ref, Address address) {
    // Get display info
    final name = address.recipientName ?? address.label;
    final phone = address.phonePrimary ?? '';
    final location = address.province ?? address.city;
    final addressText = address.street ?? address.addressLine1;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: address.isDefault 
            ? Border.all(color: kPrimaryOrange, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: context.shadowColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.push('/addresses/edit', extra: address),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Name + Default badge
              Row(
                children: [
                  // Person icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: address.isDefault ? kSoftOrange : context.inputFillColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person,
                      color: address.isDefault ? kPrimaryOrange : context.textSecondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  
                  // Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                        ),
                        if (phone.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.phone, size: 14, color: context.textSecondary),
                              const SizedBox(width: 6),
                              Text(
                                phone,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: context.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Default badge
                  if (address.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: kPrimaryOrange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            ref.tr('default_label'),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Location row
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.backgroundColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: kPrimaryOrange, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: context.textPrimary,
                            ),
                          ),
                          if (addressText.isNotEmpty && addressText != 'N/A') ...[
                            const SizedBox(height: 2),
                            Text(
                              addressText,
                              style: TextStyle(
                                fontSize: 13,
                                color: context.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Action buttons
              Row(
                children: [
                  // Edit button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/addresses/edit', extra: address),
                      icon: const Icon(Icons.edit, size: 18),
                      label: Text(ref.tr('edit')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kPrimaryOrange,
                        side: const BorderSide(color: kPrimaryOrange),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Delete button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmDelete(context, ref, address),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: Text(ref.tr('delete')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade400,
                        side: BorderSide(color: Colors.red.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Address address) {
    final name = address.recipientName ?? address.label;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.delete_forever, color: Colors.red.shade400, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                ref.tr('delete_address_title'),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          '${ref.tr('delete')} "$name"?',
          style: TextStyle(color: context.textSecondary, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              ref.tr('cancel'),
              style: TextStyle(color: context.textSecondary, fontSize: 16),
            ),
          ),
          FilledButton(
            onPressed: () {
              ref.read(addressesProvider.notifier).deleteAddress(address.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        ref.tr('address_deleted_msg', args: {'name': name}),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(ref.tr('delete'), style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
