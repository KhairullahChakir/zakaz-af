import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'orders_provider.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/language_provider.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('order_history')),
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
                    child: Center(child: Text(ref.tr('no_orders_placed'))),
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
                  child: InkWell(
                    onTap: () => context.push('/orders/${order.id}'),
                    child: ExpansionTile(
                    title: Text('${ref.tr('order_number')}${order.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${ref.tr('date')}: $dateStr'),
                        Text(
                          '${ref.tr('cart_total')}: ${order.totalAmount} ${ref.tr('afn')}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: _getStatusChip(order.status),
                    children: [
                      const Divider(),
                      ...order.items.map((item) => ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey[200],
                              child: item.product?.image != null
                                  ? Image.network(item.product!.image!)
                                  : const Icon(Icons.inventory_2_outlined),
                            ),
                            title: Text(item.product?.name ?? ref.tr('unknown_product')),
                            subtitle: Text('${ref.tr('qty')}: ${item.quantity} x ${item.price} ${ref.tr('afn')}'),
                            trailing: Text('${item.quantity * item.price} ${ref.tr('afn')}'),
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

  Widget _getStatusChip(String status) {
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
