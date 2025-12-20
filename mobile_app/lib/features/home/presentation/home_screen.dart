import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';
import 'package:mobile_app/core/widgets/cart_icon_badge.dart';
import 'package:mobile_app/core/theme/theme_provider.dart';
import 'package:mobile_app/features/products/presentation/search_history_provider.dart';
import '../../products/presentation/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  int? _selectedCategoryId;
  bool _isSearching = false;
  final _searchController = TextEditingController();
  String? _sortBy;
  String? _sortOrder;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(productsProvider(
      categoryId: _selectedCategoryId,
      search: _searchController.text.isEmpty ? null : _searchController.text,
      sortBy: _sortBy,
      sortOrder: _sortOrder,
    ));

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black54),
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: (value) {
                  setState(() {}); // Rebuild to fetch with search
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    ref.read(searchHistoryProvider.notifier).addSearch(value);
                  }
                },
                textInputAction: TextInputAction.search,
              )
            : const Text('Zakaz - AF'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortBottomSheet,
          ),
          const CartIconBadge(),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   CircleAvatar(
                     backgroundColor: Colors.white,
                     radius: 30,
                     backgroundImage: ref.watch(authControllerProvider).value?.profileImageUrl != null
                         ? NetworkImage(ref.watch(authControllerProvider).value!.profileImageUrl!)
                         : null,
                     child: ref.watch(authControllerProvider).value?.profileImageUrl == null
                         ? const Icon(Icons.person, size: 40)
                         : null,
                   ),
                   const SizedBox(height: 10),
                   ref.watch(authControllerProvider).when(
                     data: (user) => Text(
                       user?.name ?? 'Guest',
                       style: const TextStyle(color: Colors.white, fontSize: 20),
                     ),
                     loading: () => const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)),
                     error: (_, __) => const Text('Error', style: TextStyle(color: Colors.white)),
                   ),
                   if (ref.watch(authControllerProvider).value?.email != null)
                     Text(
                       ref.watch(authControllerProvider).value!.email!,
                       style: const TextStyle(color: Colors.white70, fontSize: 14),
                     ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
                context.push('/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Order History'),
              onTap: () {
                Navigator.pop(context);
                context.push('/orders');
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('My Addresses'),
              onTap: () {
                Navigator.pop(context);
                context.push('/addresses');
              },
            ),
            if (ref.watch(authControllerProvider).value?.isAdmin ?? false)
              ListTile(
                leading: const Icon(Icons.admin_panel_settings, color: Colors.blue),
                title: const Text('Admin Dashboard', style: TextStyle(color: Colors.blue)),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/analytics');
                },
              ),
            ListTile(
              leading: Icon(
                ref.watch(themeProvider) == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                color: Colors.orange,
              ),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: ref.watch(themeProvider) == ThemeMode.dark,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).setThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                ref.read(authControllerProvider.notifier).logout();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Categories
          categoriesAsync.when(
            data: (categories) => SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: categories.length + 1, // +1 for "All"
                itemBuilder: (context, index) {
                  if (index == 0) {
                     final isSelected = _selectedCategoryId == null;
                     return Padding(
                       padding: const EdgeInsets.only(right: 8),
                       child: ChoiceChip(
                         label: const Text('All'),
                         selected: isSelected,
                         onSelected: (selected) {
                           if (selected) setState(() => _selectedCategoryId = null);
                         },
                       ),
                     );
                  }
                  final category = categories[index - 1];
                  final isSelected = _selectedCategoryId == category.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedCategoryId = category.id);
                      },
                    ),
                  );
                },
              ),
            ),
            loading: () => const SizedBox(height: 60, child: Center(child: LinearProgressIndicator())),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Products Grid
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(categoriesProvider);
                ref.invalidate(productsProvider(
                  categoryId: _selectedCategoryId,
                  search: _searchController.text.isEmpty ? null : _searchController.text,
                  sortBy: _sortBy,
                  sortOrder: _sortOrder,
                ));
              },
              child: _isSearching && _searchController.text.isEmpty
                  ? _buildSearchHistory()
                  : productsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: const Center(child: Text('No products found')),
                        ),
                      ],
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          context.go('/product/${product.id}');
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.grey[200],
                                  alignment: Alignment.center,
                                  child: (product.imageUrl ?? product.image) != null
                                      ? Image.network(product.imageUrl ?? product.image!, fit: BoxFit.cover)
                                      : const Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${product.price} AFN',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 48),
                            const SizedBox(height: 16),
                            Text('Error: $err', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => ref.refresh(productsProvider(
                                categoryId: _selectedCategoryId,
                                search: _searchController.text.isEmpty ? null : _searchController.text,
                              )),
                              child: const Text('Retry'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Sort By',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.new_releases),
              title: const Text('Newest'),
              trailing: _sortBy == 'newest' || _sortBy == null ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                setState(() {
                  _sortBy = 'newest';
                  _sortOrder = 'desc';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_upward),
              title: const Text('Price: Low to High'),
              trailing: _sortBy == 'price' && _sortOrder == 'asc' ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                setState(() {
                  _sortBy = 'price';
                  _sortOrder = 'asc';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_downward),
              title: const Text('Price: High to Low'),
              trailing: _sortBy == 'price' && _sortOrder == 'desc' ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                setState(() {
                  _sortBy = 'price';
                  _sortOrder = 'desc';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Highest Rated'),
              trailing: _sortBy == 'rating' ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                setState(() {
                  _sortBy = 'rating';
                  _sortOrder = 'desc';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Most Popular'),
              trailing: _sortBy == 'popularity' ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                setState(() {
                  _sortBy = 'popularity';
                  _sortOrder = 'desc';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    final history = ref.watch(searchHistoryProvider);
    if (history.isEmpty) {
      return const Center(child: Text('Start searching...'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Searches', style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => ref.read(searchHistoryProvider.notifier).clearHistory(),
                child: const Text('Clear All'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final query = history[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(query),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => ref.read(searchHistoryProvider.notifier).removeSearch(query),
                ),
                onTap: () {
                  _searchController.text = query;
                  setState(() {});
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
