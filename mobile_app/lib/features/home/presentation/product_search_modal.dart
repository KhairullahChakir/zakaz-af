import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/theme_context.dart';
import 'package:mobile_app/core/utils/responsive.dart';
import '../../../core/localization/language_provider.dart';
import '../../products/presentation/providers.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);

class ProductSearchModal extends ConsumerStatefulWidget {
  const ProductSearchModal({super.key});

  @override
  ConsumerState<ProductSearchModal> createState() => _ProductSearchModalState();
}

class _ProductSearchModalState extends ConsumerState<ProductSearchModal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _searchQuery = query;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.value<double>(context, mobile: 16, tablet: 24);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: context.backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Responsive.value(context, mobile: 20, tablet: 28)),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                cursorColor: kPrimaryOrange,
                style: TextStyle(
                  fontSize: Responsive.value(context, mobile: 16, tablet: 18), 
                  color: context.textPrimary
                ),
                decoration: InputDecoration(
                  hintText: ref.tr('search_products'),
                  hintStyle: TextStyle(color: context.textSecondary),
                  prefixIcon: const Icon(Icons.search, color: kPrimaryOrange),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Responsive.value(context, mobile: 12, tablet: 16)),
                    borderSide: const BorderSide(color: kPrimaryOrange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Responsive.value(context, mobile: 12, tablet: 16)),
                    borderSide: const BorderSide(color: kPrimaryOrange, width: 2),
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final productsAsync = ref.watch(productsProvider(
                    search: _searchQuery.isEmpty ? null : _searchQuery,
                  ));
                  return productsAsync.when(
                    data: (products) => products.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isEmpty ? ref.tr('start_typing') : ref.tr('no_products_found'),
                                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            padding: EdgeInsets.symmetric(horizontal: padding),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: Responsive.value(context, mobile: 4, tablet: 8),
                                ),
                                leading: Container(
                                  width: Responsive.value(context, mobile: 50, tablet: 60),
                                  height: Responsive.value(context, mobile: 50, tablet: 60),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: context.softOrange,
                                  ),
                                  child: product.imageUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(product.imageUrl!, fit: BoxFit.cover),
                                        )
                                      : const Icon(Icons.image, color: kPrimaryOrange),
                                ),
                                title: Text(
                                  product.name,
                                  style: TextStyle(
                                    fontSize: Responsive.value(context, mobile: 15, tablet: 17),
                                    color: context.textPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  '${product.price.toInt()} ${ref.tr('afn')}',
                                  style: TextStyle(
                                    color: kPrimaryOrange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.value(context, mobile: 14, tablet: 16),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  context.push('/products/${product.id}');
                                },
                              );
                            },
                          ),
                    loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
                    error: (e, _) => Center(child: Text('${ref.tr('error')}: $e')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
