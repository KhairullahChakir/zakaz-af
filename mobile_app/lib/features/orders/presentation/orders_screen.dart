import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'orders_provider.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import '../../../core/theme/theme_context.dart';

import '../../../core/widgets/shimmer_loading.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(ref.tr('order_history'), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.appBarColor,
        foregroundColor: context.appBarTextColor,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(ordersProvider),
        child: ordersAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 80,
                            color: context.textSecondary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            ref.tr('no_orders_placed'),
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () => context.go('/'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.primaryOrange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(ref.tr('start_shopping')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final dateStr = DateFormat('MMM dd, yyyy HH:mm').format(order.createdAt);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: context.shadowColor,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.push('/orders/${order.id}'),
                        child: Column(
                          children: [
                            ExpansionTile(
                              shape: const Border(),
                              collapsedShape: const Border(),
                              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              title: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: context.primaryOrange.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.receipt_long, color: context.primaryOrange, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${ref.tr('order_number')}${order.id}', 
                                    style: TextStyle(fontWeight: FontWeight.bold, color: context.textPrimary),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8, left: 32),
                                child: Text(dateStr, style: TextStyle(color: context.textSecondary, fontSize: 13)),
                              ),
                              trailing: _getStatusChip(ref, order.status),
                              children: [
                                const Divider(height: 1),
                                ...order.items.map((item) => ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                      leading: Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: context.isDark ? Colors.grey[800] : Colors.grey[200],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: item.product?.image != null
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.network(item.product!.image!, fit: BoxFit.cover),
                                              )
                                            : Icon(Icons.inventory_2_outlined, color: context.textSecondary, size: 20),
                                      ),
                                      title: Text(
                                        item.product?.name ?? ref.tr('unknown_product'), 
                                        style: TextStyle(color: context.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(
                                        '${ref.tr('qty')}: ${item.quantity} x ${item.price} ${ref.tr('afn')}', 
                                        style: TextStyle(color: context.textSecondary, fontSize: 12),
                                      ),
                                      trailing: Text(
                                        '${item.quantity * item.price} ${ref.tr('afn')}', 
                                        style: TextStyle(fontWeight: FontWeight.bold, color: context.textPrimary),
                                      ),
                                    )),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  color: context.backgroundColor.withValues(alpha: 0.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ref.tr('cart_total'),
                                        style: TextStyle(fontWeight: FontWeight.bold, color: context.textPrimary),
                                      ),
                                      Text(
                                        '${order.totalAmount} ${ref.tr('afn')}',
                                        style: TextStyle(
                                          color: context.primaryOrange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: TextButton(
                                    onPressed: () => context.push('/orders/${order.id}'),
                                    child: Text(ref.tr('view_details')),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const OrdersSkeleton(),
          error: (err, stack) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('${ref.tr('error')}: $err', style: TextStyle(color: context.textPrimary)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(ordersProvider),
                        child: Text(ref.tr('retry')),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getStatusChip(WidgetRef ref, String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'processing':
        color = Colors.blue;
        break;
      case 'completed':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(
        _getStatusLabel(ref, status).toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      backgroundColor: color,
    );
  }

  String _getStatusLabel(WidgetRef ref, String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return ref.tr('status_pending');
      case 'processing':
        return ref.tr('status_processing');
      case 'shipped':
        return ref.tr('status_shipped');
      case 'delivered':
      case 'completed':
        return ref.tr('status_delivered');
      case 'cancelled':
        return ref.tr('status_cancelled');
      default:
        return status;
    }
  }
}
