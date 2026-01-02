import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/order_repository.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/widgets/shimmer_loading.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailsProvider(orderId));
    final dateFormat = DateFormat.yMMMd().add_jm();

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(ref.tr('order_details'), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.appBarColor,
        foregroundColor: context.appBarTextColor,
        elevation: 0,
      ),
      body: orderAsync.when(
        data: (order) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: context.shadowColor,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${ref.tr('order_number')}${order.id}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dateFormat.format(order.createdAt),
                              style: TextStyle(
                                color: context.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        _buildStatusChip(context, ref, order.status),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Order Timeline
              _buildSectionTitle(context, ref.tr('order_status')),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: context.shadowColor,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: _buildTimeline(context, ref, order.status),
              ),
              const SizedBox(height: 24),

              // Order Items
              _buildSectionTitle(context, ref.tr('items')),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: context.shadowColor,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: context.isDark ? Colors.grey[800] : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: item.product?.imageUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          item.product!.imageUrl!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Icon(Icons.inventory_2_outlined,
                                        color: context.textSecondary),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product?.name ?? ref.tr('product'),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: context.textPrimary),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item.price} ${ref.tr('afn')} x ${item.quantity}',
                                      style: TextStyle(
                                        color: context.textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${item.price * item.quantity} ${ref.tr('afn')}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: context.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        )),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ref.tr('total'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${order.totalAmount} ${ref.tr('afn')}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: context.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        loading: () => ShimmerLoading(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBox(height: 100, borderRadius: 20),
                const SizedBox(height: 24),
                const SkeletonBox(height: 20, width: 120, borderRadius: 10),
                const SizedBox(height: 12),
                const SkeletonBox(height: 200, borderRadius: 20),
                const SizedBox(height: 24),
                const SkeletonBox(height: 20, width: 120, borderRadius: 10),
                const SizedBox(height: 12),
                const SkeletonBox(height: 250, borderRadius: 20),
              ],
            ),
          ),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('${ref.tr('error')}: $e'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ref.refresh(orderDetailsProvider(orderId)),
                child: Text(ref.tr('retry')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, WidgetRef ref, String status) {
    Color color;
    IconData icon;
    String label;
    
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        icon = Icons.schedule;
        label = ref.tr('status_pending');
        break;
      case 'processing':
        color = Colors.blue;
        icon = Icons.sync;
        label = ref.tr('status_processing');
        break;
      case 'shipped':
        color = Colors.purple;
        icon = Icons.local_shipping;
        label = ref.tr('status_shipped');
        break;
      case 'delivered':
        color = Colors.green;
        icon = Icons.check_circle;
        label = ref.tr('status_delivered');
        break;
      case 'cancelled':
        color = Colors.red;
        icon = Icons.cancel;
        label = ref.tr('status_cancelled');
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, WidgetRef ref, String currentStatus) {
    final statuses = ['pending', 'processing', 'shipped', 'delivered'];
    final statusLabels = {
      'pending': ref.tr('status_pending'),
      'processing': ref.tr('status_processing'),
      'shipped': ref.tr('status_shipped'),
      'delivered': ref.tr('status_delivered'),
    };
    final currentIndex = statuses.indexOf(currentStatus.toLowerCase());
    final isCancelled = currentStatus.toLowerCase() == 'cancelled';

    return Column(
      children: List.generate(statuses.length, (index) {
        final status = statuses[index];
        final isCompleted = !isCancelled && index <= currentIndex;
        final isCurrent = !isCancelled && index == currentIndex;

        return Row(
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? Colors.green : (context.isDark ? Colors.grey[800] : Colors.grey[300]),
                    border: isCurrent
                        ? Border.all(color: Colors.green, width: 3)
                        : null,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                if (index < statuses.length - 1)
                  Container(
                    width: 2,
                    height: 30,
                    color: isCompleted ? Colors.green : (context.isDark ? Colors.grey[700] : Colors.grey[300]),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  statusLabels[status] ?? status,
                  style: TextStyle(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted ? (context.isDark ? Colors.white : Colors.black) : context.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
