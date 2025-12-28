import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import '../../../core/theme/theme_context.dart';
import '../data/admin_shop_repository.dart';
import '../../shop/domain/shop.dart';

class AdminShopsScreen extends ConsumerStatefulWidget {
  const AdminShopsScreen({super.key});

  @override
  ConsumerState<AdminShopsScreen> createState() => _AdminShopsScreenState();
}

class _AdminShopsScreenState extends ConsumerState<AdminShopsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(ref.tr('shop_applications'), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.appBarColor,
        foregroundColor: context.appBarTextColor,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: context.primaryOrange,
          unselectedLabelColor: context.textSecondary,
          indicatorColor: context.primaryOrange,
          tabs: [
            Tab(text: ref.tr('status_pending')),
            Tab(text: ref.tr('status_approved')),
            Tab(text: ref.tr('status_rejected')),
            Tab(text: ref.tr('status_suspended')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ShopList(status: 'pending'),
          _ShopList(status: 'approved'),
          _ShopList(status: 'rejected'),
          _ShopList(status: 'suspended'),
        ],
      ),
    );
  }
}

class _ShopList extends ConsumerWidget {
  final String status;

  const _ShopList({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopsAsync = ref.watch(allShopsProvider(status: status));

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(allShopsProvider),
      child: shopsAsync.when(
        data: (shops) {
          if (shops.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.store_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    ref.tr('no_status_applications', args: {'status': ref.tr('status_$status')}),
                    style: TextStyle(color: context.textSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: shops.length,
            itemBuilder: (context, index) {
              final shop = shops[index];
              return _ShopCard(shop: shop);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ShopCard extends ConsumerWidget {
  final Shop shop;

  const _ShopCard({required this.shop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: context.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.push('/admin/shops/${shop.id}', extra: shop),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Shop photo
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: context.isDark ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: shop.primaryPhotoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          shop.primaryPhotoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.store, color: context.textSecondary),
                        ),
                      )
                    : Icon(Icons.store, color: context.textSecondary),
              ),
              const SizedBox(width: 16),
              
              // Shop info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ref.tr('type_${shop.type.toLowerCase()}'),
                      style: TextStyle(color: context.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: context.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${shop.city}, ${shop.province}',
                            style: TextStyle(color: context.textSecondary, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Status & arrow
              Column(
                children: [
                  _buildStatusBadge(ref, shop.status),
                  const SizedBox(height: 8),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(WidgetRef ref, String status) {
    Color color;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      case 'suspended':
        color = Colors.grey;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        ref.tr('status_$status').toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
