import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'analytics_provider.dart';
import '../../../core/localization/language_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(analyticsStatsProvider);
    final currencyFormat = NumberFormat.currency(symbol: '${ref.tr('afn')} ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('sales_analytics')),
        actions: [
          IconButton(
            icon: const Icon(Icons.store),
            tooltip: ref.tr('shop_apps_tooltip'),
            onPressed: () => context.push('/admin/shops'),
          ),
          IconButton(
            icon: const Icon(Icons.inventory),
            tooltip: ref.tr('manage_products_tooltip'),
            onPressed: () => context.push('/admin/products'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(analyticsStatsProvider),
          ),
        ],
      ),
      body: statsAsync.when(
        data: (stats) {
          final topProducts = stats['top_products'] as List;
          final recentSales = stats['recent_sales'] as List;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Revenue Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF57C00), Color(0xFFFFB74D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref.tr('total_revenue'),
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currencyFormat.format(double.tryParse(stats['total_revenue'].toString()) ?? 0),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildStatMiniCard(ref.tr('orders'), stats['total_orders'].toString(), Icons.shopping_bag, Colors.blue),
                    _buildStatMiniCard(ref.tr('users'), stats['total_users'].toString(), Icons.people, Colors.green),
                    _buildStatMiniCard(ref.tr('products'), stats['total_products'].toString(), Icons.inventory, Colors.purple),
                  ],
                ),
                const SizedBox(height: 32),

                // Top Products
                Text(
                  ref.tr('top_selling_products'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...topProducts.map((p) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(p['name']),
                    subtitle: Text(ref.tr('sold_units', args: {'n': p['total_sold'].toString()})),
                    trailing: Text(
                      currencyFormat.format(double.parse(p['revenue'].toString())),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                )),
                const SizedBox(height: 32),

                // Recent Sales
                Text(
                  ref.tr('recent_sales'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...recentSales.map((s) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(s['user']['name']),
                    subtitle: Text(DateFormat.yMMMd().add_jm().format(DateTime.parse(s['created_at']))),
                    trailing: Text(
                      currencyFormat.format(double.tryParse(s['total_amount'].toString()) ?? 0),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildStatMiniCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
