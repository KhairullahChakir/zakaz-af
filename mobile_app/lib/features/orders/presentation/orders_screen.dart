import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'orders_provider.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import '../../../core/theme/theme_context.dart';

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
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(child: Text(ref.tr('no_orders_placed'), style: TextStyle(color: context.textPrimary))),
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
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  color: context.cardColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () => context.push('/orders/${order.id}'),
                    child: ExpansionTile(
                    shape: const Border(),
                    collapsedShape: const Border(),
                    title: Text('${ref.tr('order_number')}${order.id}', style: TextStyle(fontWeight: FontWeight.bold, color: context.textPrimary)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${ref.tr('date')}: $dateStr', style: TextStyle(color: context.textSecondary)),
                        Text(
                          '${ref.tr('cart_total')}: ${order.totalAmount} ${ref.tr('afn')}',
                          style: TextStyle(
                            color: context.primaryOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: _getStatusChip(ref, order.status),
                    children: [
                      Divider(color: context.dividerColor),
                      ...order.items.map((item) => ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: context.isDark ? Colors.grey[800] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: item.product?.image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(item.product!.image!, fit: BoxFit.cover),
                                    )
                                  : Icon(Icons.inventory_2_outlined, color: context.textSecondary),
                            ),
                            title: Text(item.product?.name ?? ref.tr('unknown_product'), style: TextStyle(color: context.textPrimary)),
                            subtitle: Text('${ref.tr('qty')}: ${item.quantity} x ${item.price} ${ref.tr('afn')}', style: TextStyle(color: context.textSecondary)),
                            trailing: Text('${item.quantity * item.price} ${ref.tr('afn')}', style: TextStyle(fontWeight: FontWeight.bold, color: context.textPrimary)),
                          )),
                    ],
                  ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: Text('${ref.tr('error')}: $err')),
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
