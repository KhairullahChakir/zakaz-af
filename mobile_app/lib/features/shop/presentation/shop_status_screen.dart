import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/shop_repository.dart';

class ShopApplicationStatusScreen extends ConsumerWidget {
  const ShopApplicationStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(shopApplicationStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Status'),
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
                    'No Application Found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You haven\'t applied to become a shopkeeper yet.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.push('/become-shopkeeper'),
                    icon: const Icon(Icons.add_business),
                    label: const Text('Apply Now'),
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
                          _getStatusTitle(shop.status),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getStatusMessage(shop.status),
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
                                        'Reason:',
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
                  'Shop Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                
                _buildDetailRow(Icons.store, 'Name', shop.name),
                _buildDetailRow(Icons.category, 'Type', shop.type),
                _buildDetailRow(Icons.location_on, 'Address', shop.address),
                _buildDetailRow(Icons.location_city, 'City', '${shop.city}, ${shop.province}'),
                _buildDetailRow(Icons.phone, 'Phone', shop.phone),
                if (shop.email != null) _buildDetailRow(Icons.email, 'Email', shop.email!),

                if (shop.isRejected) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => context.push('/become-shopkeeper'),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Apply Again'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
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

  String _getStatusTitle(String status) {
    switch (status) {
      case 'pending':
        return 'Under Review';
      case 'approved':
        return 'Approved!';
      case 'rejected':
        return 'Rejected';
      case 'suspended':
        return 'Suspended';
      default:
        return status;
    }
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'pending':
        return 'Your application is being reviewed by our team. This usually takes 1-2 business days.';
      case 'approved':
        return 'Congratulations! Your shop is now active. You can start adding products.';
      case 'rejected':
        return 'Unfortunately, your application was not approved. You can apply again with updated information.';
      case 'suspended':
        return 'Your shop has been temporarily suspended. Please contact support for more information.';
      default:
        return '';
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
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
