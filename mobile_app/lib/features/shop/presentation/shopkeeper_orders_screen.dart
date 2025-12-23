import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import '../data/shopkeeper_repository.dart';
import '../../orders/domain/order.dart';

class ShopkeeperOrdersScreen extends ConsumerStatefulWidget {
  const ShopkeeperOrdersScreen({super.key});

  @override
  ConsumerState<ShopkeeperOrdersScreen> createState() => _ShopkeeperOrdersScreenState();
}

class _ShopkeeperOrdersScreenState extends ConsumerState<ShopkeeperOrdersScreen> {
  bool _isLoading = false;

  Future<void> _updateStatus(OrderModel order, String newStatus) async {
    setState(() => _isLoading = true);
    try {
      await ref.read(shopkeeperRepositoryProvider).updateOrderStatus(order.id, newStatus);
      ref.invalidate(shopkeeperOrdersProvider);
      ref.invalidate(shopkeeperDashboardProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.tr('order_updated_msg', args: {
              'id': order.id.toString(),
              'status': ref.tr('status_$newStatus'),
            })),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showStatusDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ref.tr('update_order_status', args: {'id': order.id.toString()})),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusOption(order, 'pending', ref.tr('status_pending'), Icons.schedule, Colors.orange),
            _buildStatusOption(order, 'processing', ref.tr('status_processing'), Icons.sync, Colors.blue),
            _buildStatusOption(order, 'shipped', ref.tr('status_shipped'), Icons.local_shipping, Colors.purple),
            _buildStatusOption(order, 'delivered', ref.tr('status_delivered'), Icons.check_circle, Colors.green),
            _buildStatusOption(order, 'cancelled', ref.tr('status_cancelled'), Icons.cancel, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption(OrderModel order, String status, String label, IconData icon, Color color) {
    final isSelected = order.status == status;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      trailing: isSelected ? Icon(Icons.check, color: color) : null,
      tileColor: isSelected ? color.withValues(alpha: 0.1) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: isSelected
          ? null
          : () {
              Navigator.pop(context);
              _updateStatus(order, status);
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(shopkeeperOrdersProvider);
    final dateFormat = DateFormat.yMMMd();

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('orders')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(shopkeeperOrdersProvider),
              child: ordersAsync.when(
                data: (orders) {
                  if (orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            ref.tr('no_shop_orders'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ref.tr('no_shop_orders_desc'),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          children: [
                            // Header
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.status).withValues(alpha: 0.1),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _getStatusIcon(order.status),
                                    color: _getStatusColor(order.status),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${ref.tr('order_number')} ${order.id}',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          dateFormat.format(order.createdAt),
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () => _showStatusDialog(order),
                                    child: Text(ref.tr('status_${order.status}').toUpperCase()),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Items
                            ...order.items.map((item) => ListTile(
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: item.product?.imageUrl != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              item.product!.imageUrl!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(Icons.inventory_2, size: 20, color: Colors.grey),
                                  ),
                                  title: Text(item.product?.name ?? 'Product'),
                                  subtitle: Text('${item.price} AFN × ${item.quantity}'),
                                  trailing: Text(
                                    '${(item.price * item.quantity).toStringAsFixed(0)} AFN',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                            
                            // Total
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ref.tr('cart_total'), style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(
                                    '${order.totalAmount} AFN',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule;
      case 'processing':
        return Icons.sync;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}
