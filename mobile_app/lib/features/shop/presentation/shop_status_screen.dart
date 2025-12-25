import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/shop_repository.dart';
import '../../../core/localization/language_provider.dart';

class ShopApplicationStatusScreen extends ConsumerWidget {
  const ShopApplicationStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(shopApplicationStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('application_status_title')),
      ),
      body: statusAsync.when(
        data: (shop) {
          if (shop == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.store_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    ref.tr('no_application_found'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ref.tr('no_application_desc'),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.push('/become-shopkeeper'),
                    icon: const Icon(Icons.add_business),
                    label: Text(ref.tr('apply_now')),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildStatusIcon(shop.status),
                        const SizedBox(height: 16),
                        Text(
                          _getStatusTitle(ref, shop.status),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getStatusMessage(ref, shop.status),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        if (shop.isRejected && shop.rejectionReason != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info, color: Colors.red[700]),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ref.tr('reason_label'),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red[700],
                                        ),
                                      ),
                                      Text(
                                        shop.rejectionReason!,
                                        style: TextStyle(color: Colors.red[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Shop Details
                Text(
                  ref.tr('step_shop_info'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                
                _buildDetailRow(ref, Icons.store, ref.tr('name'), shop.name),
                _buildDetailRow(ref, Icons.category, ref.tr('shop_type_label').replaceAll(' *', ''), shop.type),
                _buildDetailRow(ref, Icons.location_on, ref.tr('address'), shop.address),
                _buildDetailRow(ref, Icons.location_city, ref.tr('city_label').replaceAll(' *', ''), '${shop.city}, ${shop.province}'),
                _buildDetailRow(ref, Icons.phone, ref.tr('phone_contact_label').replaceAll(' *', ''), shop.phone),
                if (shop.email != null) _buildDetailRow(ref, Icons.email, ref.tr('email'), shop.email!),

                if (shop.isRejected) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => context.push('/become-shopkeeper'),
                      icon: const Icon(Icons.refresh),
                      label: Text(ref.tr('apply_again')),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${ref.tr('error')}: $e')),
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    IconData icon;
    Color color;
    Color bgColor;

    switch (status) {
      case 'pending':
        icon = Icons.hourglass_empty;
        color = Colors.orange;
        bgColor = Colors.orange[100]!;
        break;
      case 'approved':
        icon = Icons.check_circle;
        color = Colors.green;
        bgColor = Colors.green[100]!;
        break;
      case 'rejected':
        icon = Icons.cancel;
        color = Colors.red;
        bgColor = Colors.red[100]!;
        break;
      case 'suspended':
        icon = Icons.block;
        color = Colors.grey;
        bgColor = Colors.grey[200]!;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
        bgColor = Colors.grey[200]!;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 50, color: color),
    );
  }

  String _getStatusTitle(WidgetRef ref, String status) {
    switch (status) {
      case 'pending':
        return ref.tr('under_review');
      case 'approved':
        return ref.tr('approved_status');
      case 'rejected':
        return ref.tr('rejected_status');
      case 'suspended':
        return ref.tr('suspended_status');
      default:
        return status;
    }
  }

  String _getStatusMessage(WidgetRef ref, String status) {
    switch (status) {
      case 'pending':
        return ref.tr('review_message');
      case 'approved':
        return ref.tr('approved_message');
      case 'rejected':
        return ref.tr('rejected_message');
      case 'suspended':
        return ref.tr('suspended_message');
      default:
        return '';
    }
  }

  Widget _buildDetailRow(WidgetRef ref, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
