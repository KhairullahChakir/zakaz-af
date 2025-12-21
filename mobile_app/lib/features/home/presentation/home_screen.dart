import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';
import 'package:mobile_app/core/widgets/cart_icon_badge.dart';
import 'package:mobile_app/core/theme/theme_provider.dart';
import 'package:mobile_app/core/utils/responsive.dart';
import '../../products/presentation/providers.dart';
import '../../products/domain/product.dart';
import '../../products/domain/category.dart';

// Orange Theme Colors
const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kDarkOrange = Color(0xFFE55A00);
const Color kLightOrange = Color(0xFFFF8A33);
const Color kSoftOrange = Color(0xFFFFF3E6);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentNavIndex = 0;
  int? _selectedCategoryId;
  final _searchController = TextEditingController();
  final _pageController = PageController();
  int _bannerIndex = 0;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Welcome to Zakaz-AF',
      'subtitle': 'Shop from local Afghan stores',
      'icon': Icons.storefront,
    },
    {
      'title': 'Fresh Groceries',
      'subtitle': 'Delivered to your door',
      'icon': Icons.local_grocery_store,
    },
    {
      'title': 'Fashion & Style',
      'subtitle': 'Traditional & Modern',
      'icon': Icons.checkroom,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startBannerAutoScroll();
  }

  void _startBannerAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _pageController.hasClients) {
        final nextPage = (_bannerIndex + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startBannerAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          _buildHomeTab(),
          _buildCategoriesTab(),
          _buildCartTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: kSoftOrange,
          height: Responsive.value(context, mobile: 65, tablet: 75),
          selectedIndex: _currentNavIndex,
          onDestinationSelected: (index) {
            if (index == 2) {
              context.push('/cart');
            } else {
              setState(() => _currentNavIndex = index);
            }
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.grey[600]),
              selectedIcon: const Icon(Icons.home, color: kPrimaryOrange),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.category_outlined, color: Colors.grey[600]),
              selectedIcon: const Icon(Icons.category, color: kPrimaryOrange),
              label: 'Categories',
            ),
            NavigationDestination(
              icon: const CartIconBadge(showBackground: false),
              selectedIcon: const CartIconBadge(showBackground: false),
              label: 'Cart',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.grey[600]),
              selectedIcon: const Icon(Icons.person, color: kPrimaryOrange),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(productsProvider(
      categoryId: _selectedCategoryId,
      search: _searchController.text.isEmpty ? null : _searchController.text,
    ));

    final padding = Responsive.value<double>(context, mobile: 16, tablet: 24, desktop: 32);
    final bannerHeight = Responsive.bannerHeight(context);
    final gridColumns = Responsive.gridColumns(context);

    return CustomScrollView(
      slivers: [
        // Orange App Bar
        SliverAppBar(
          floating: true,
          backgroundColor: kPrimaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: Responsive.value(context, mobile: 60, tablet: 70),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.value(context, mobile: 8, tablet: 10)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.store, color: kPrimaryOrange, 
                  size: Responsive.value(context, mobile: 24, tablet: 28)),
              ),
              SizedBox(width: Responsive.value(context, mobile: 12, tablet: 16)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zakaz-AF',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.value(context, mobile: 20, tablet: 24),
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Shop local, support local',
                    style: TextStyle(
                      fontSize: Responsive.value(context, mobile: 12, tablet: 14),
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white),
              iconSize: Responsive.value(context, mobile: 24, tablet: 28),
              onPressed: () => context.push('/wishlist'),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              iconSize: Responsive.value(context, mobile: 24, tablet: 28),
              onPressed: () {},
            ),
          ],
        ),

        // Search Bar
        SliverToBoxAdapter(
          child: Container(
            color: kPrimaryOrange,
            child: Container(
              margin: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Responsive.value(context, mobile: 16, tablet: 20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () => _showSearchModal(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding,
                    vertical: Responsive.value(context, mobile: 14, tablet: 18),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[500], 
                        size: Responsive.value(context, mobile: 24, tablet: 28)),
                      SizedBox(width: Responsive.value(context, mobile: 12, tablet: 16)),
                      Text(
                        'Search products, shops...',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: Responsive.value(context, mobile: 14, tablet: 16),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.all(Responsive.value(context, mobile: 8, tablet: 10)),
                        decoration: BoxDecoration(
                          color: kSoftOrange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.tune, 
                          size: Responsive.value(context, mobile: 18, tablet: 22), 
                          color: kPrimaryOrange),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Hero Banner Carousel
        SliverToBoxAdapter(
          child: SizedBox(
            height: bannerHeight,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _bannerIndex = index),
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                final banner = _banners[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [kPrimaryOrange, kLightOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(Responsive.value(context, mobile: 20, tablet: 24)),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryOrange.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Icon(
                          banner['icon'] as IconData,
                          size: Responsive.value(context, mobile: 120, tablet: 160, desktop: 200),
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.all(Responsive.value(context, mobile: 16, tablet: 24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                banner['title'] as String,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Responsive.value(context, mobile: 18, tablet: 24, desktop: 28),
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                banner['subtitle'] as String,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: Responsive.value(context, mobile: 12, tablet: 16),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Responsive.value(context, mobile: 12, tablet: 16),
                                  vertical: Responsive.value(context, mobile: 6, tablet: 8),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'Shop Now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.value(context, mobile: 12, tablet: 14),
                                    color: kPrimaryOrange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        // Banner dots
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _banners.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _bannerIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _bannerIndex == index ? kPrimaryOrange : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Categories Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(padding, 8, padding, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.value(context, mobile: 18, tablet: 22),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _currentNavIndex = 1),
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: kPrimaryOrange,
                      fontSize: Responsive.value(context, mobile: 14, tablet: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: Responsive.value(context, mobile: 100, tablet: 120),
            child: categoriesAsync.when(
              data: (categories) => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: padding - 4),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = _selectedCategoryId == category.id;
                  return _buildCategoryCard(category, isSelected);
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ),

        // Featured Products Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(padding, 16, padding, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Products',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.value(context, mobile: 18, tablet: 22),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: kPrimaryOrange,
                      fontSize: Responsive.value(context, mobile: 14, tablet: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: Responsive.value(context, mobile: 220, tablet: 260),
            child: productsAsync.when(
              data: (products) => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: padding - 4),
                itemCount: products.take(6).length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildFeaturedProductCard(product);
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ),

        // All Products Grid
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(padding, 16, padding, 8),
            child: Text(
              'All Products',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Responsive.value(context, mobile: 18, tablet: 22),
              ),
            ),
          ),
        ),

        productsAsync.when(
          data: (products) => SliverPadding(
            padding: EdgeInsets.all(padding),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridColumns,
                childAspectRatio: Responsive.productCardRatio(context),
                crossAxisSpacing: Responsive.value(context, mobile: 12, tablet: 16),
                mainAxisSpacing: Responsive.value(context, mobile: 12, tablet: 16),
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildProductCard(products[index]),
                childCount: products.length,
              ),
            ),
          ),
          loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
          ),
          error: (e, _) => SliverToBoxAdapter(
            child: Center(child: Text('Error: $e')),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: Responsive.value(context, mobile: 80, tablet: 100))),
      ],
    );
  }

  Widget _buildCategoryCard(Category category, bool isSelected) {
    final cardSize = Responsive.categoryCardSize(context);
    final iconSize = Responsive.value<double>(context, mobile: 28, tablet: 34);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = isSelected ? null : category.id;
        });
      },
      child: Container(
        width: cardSize,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(Responsive.value(context, mobile: 14, tablet: 18)),
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryOrange : kSoftOrange,
                borderRadius: BorderRadius.circular(Responsive.value(context, mobile: 16, tablet: 20)),
                border: isSelected ? null : Border.all(color: kPrimaryOrange.withOpacity(0.3)),
              ),
              child: Icon(
                Icons.category,
                color: isSelected ? Colors.white : kPrimaryOrange,
                size: iconSize,
              ),
            ),
            SizedBox(height: Responsive.value(context, mobile: 6, tablet: 8)),
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: Responsive.value(context, mobile: 11, tablet: 13),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? kPrimaryOrange : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedProductCard(Product product) {
    final cardWidth = Responsive.featuredCardWidth(context);
    final imageHeight = Responsive.value<double>(context, mobile: 100, tablet: 130);

    return GestureDetector(
      onTap: () => context.push('/products/${product.id}'),
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Responsive.value(context, mobile: 16, tablet: 20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Container(
                  height: imageHeight,
                  decoration: BoxDecoration(
                    color: kSoftOrange,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Responsive.value(context, mobile: 16, tablet: 20)),
                    ),
                  ),
                  child: product.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(Responsive.value(context, mobile: 16, tablet: 20)),
                          ),
                          child: Image.network(
                            product.imageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(Icons.image, size: 40, color: kPrimaryOrange.withOpacity(0.5)),
                            ),
                          ),
                        )
                      : Center(child: Icon(Icons.image, size: 40, color: kPrimaryOrange.withOpacity(0.5))),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(Responsive.value(context, mobile: 5, tablet: 7)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(Icons.favorite_border, 
                      size: Responsive.value(context, mobile: 16, tablet: 20), 
                      color: kPrimaryOrange),
                  ),
                ),
              ],
            ),
            // Info - Use Expanded to fill remaining space
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(Responsive.value(context, mobile: 8, tablet: 12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.value(context, mobile: 13, tablet: 15),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, 
                          size: Responsive.value(context, mobile: 12, tablet: 14), 
                          color: kPrimaryOrange),
                        const SizedBox(width: 2),
                        Text(
                          '4.5',
                          style: TextStyle(
                            fontSize: Responsive.value(context, mobile: 11, tablet: 13),
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${product.price.toInt()} AFN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.value(context, mobile: 14, tablet: 16),
                        color: kPrimaryOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => context.push('/products/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Responsive.value(context, mobile: 16, tablet: 20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kSoftOrange,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Responsive.value(context, mobile: 16, tablet: 20)),
                      ),
                    ),
                    child: product.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(Responsive.value(context, mobile: 16, tablet: 20)),
                            ),
                            child: Image.network(
                              product.imageUrl!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(Icons.image, size: 40, color: kPrimaryOrange.withOpacity(0.5)),
                              ),
                            ),
                          )
                        : Center(child: Icon(Icons.image, size: 40, color: kPrimaryOrange.withOpacity(0.5))),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(Responsive.value(context, mobile: 6, tablet: 8)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.favorite_border, 
                        size: Responsive.value(context, mobile: 18, tablet: 22), 
                        color: kPrimaryOrange),
                    ),
                  ),
                  if (product.stock < 10)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.value(context, mobile: 8, tablet: 10),
                          vertical: Responsive.value(context, mobile: 4, tablet: 6),
                        ),
                        decoration: BoxDecoration(
                          color: kPrimaryOrange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Low Stock',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Responsive.value(context, mobile: 10, tablet: 12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(Responsive.value(context, mobile: 10, tablet: 14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.value(context, mobile: 12, tablet: 14),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '${product.price.toInt()} AFN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.value(context, mobile: 13, tablet: 15),
                              color: kPrimaryOrange,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(Responsive.value(context, mobile: 6, tablet: 8)),
                          decoration: BoxDecoration(
                            color: kPrimaryOrange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.add, 
                            size: Responsive.value(context, mobile: 16, tablet: 20), 
                            color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesTab() {
    final categoriesAsync = ref.watch(categoriesProvider);
    final padding = Responsive.value<double>(context, mobile: 16, tablet: 24, desktop: 32);
    final gridColumns = Responsive.gridColumns(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        backgroundColor: kPrimaryOrange,
        foregroundColor: Colors.white,
      ),
      body: categoriesAsync.when(
        data: (categories) => GridView.builder(
          padding: EdgeInsets.all(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridColumns,
            childAspectRatio: 1.2,
            crossAxisSpacing: Responsive.value(context, mobile: 12, tablet: 16),
            mainAxisSpacing: Responsive.value(context, mobile: 12, tablet: 16),
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryGridCard(category);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildCategoryGridCard(Category category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = category.id;
          _currentNavIndex = 0;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kPrimaryOrange, kLightOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(Responsive.value(context, mobile: 16, tablet: 20)),
          boxShadow: [
            BoxShadow(
              color: kPrimaryOrange.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                Icons.category,
                size: Responsive.value(context, mobile: 80, tablet: 100),
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Responsive.value(context, mobile: 16, tablet: 20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.value(context, mobile: 16, tablet: 20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartTab() {
    return const Center(child: CircularProgressIndicator(color: kPrimaryOrange));
  }

  Widget _buildProfileTab() {
    final user = ref.watch(authControllerProvider).value;
    final padding = Responsive.value<double>(context, mobile: 16, tablet: 24, desktop: 32);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: Responsive.value(context, mobile: 200, tablet: 250),
            pinned: true,
            backgroundColor: kPrimaryOrange,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kPrimaryOrange, kLightOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: Responsive.value(context, mobile: 40, tablet: 50)),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: Responsive.value(context, mobile: 45, tablet: 60),
                          backgroundColor: kSoftOrange,
                          backgroundImage: user?.profileImageUrl != null
                              ? NetworkImage(user!.profileImageUrl!)
                              : null,
                          child: user?.profileImageUrl == null
                              ? Icon(Icons.person, 
                                  size: Responsive.value(context, mobile: 50, tablet: 70), 
                                  color: kPrimaryOrange)
                              : null,
                        ),
                      ),
                      SizedBox(height: Responsive.value(context, mobile: 12, tablet: 16)),
                      Text(
                        user?.name ?? 'Guest',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.value(context, mobile: 20, tablet: 24),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: Responsive.value(context, mobile: 14, tablet: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  _buildProfileOption(Icons.person, 'Edit Profile', () => context.push('/profile')),
                  _buildProfileOption(Icons.shopping_bag, 'My Orders', () => context.push('/orders')),
                  _buildProfileOption(Icons.location_on, 'Addresses', () => context.push('/addresses')),
                  _buildProfileOption(Icons.favorite, 'Wishlist', () => context.push('/wishlist')),
                  const Divider(height: 32),
                  if (user?.isCustomer == true)
                    _buildProfileOption(Icons.store, 'Become a Shopkeeper', () => context.push('/shop-status'), color: kPrimaryOrange),
                  if (user?.isShopkeeper == true)
                    _buildProfileOption(Icons.store, 'My Shop', () => context.push('/shopkeeper/dashboard'), color: kPrimaryOrange),
                  if (user?.isAdmin == true)
                    _buildProfileOption(Icons.admin_panel_settings, 'Admin Dashboard', () => context.push('/analytics'), color: kPrimaryOrange),
                  const Divider(height: 32),
                  _buildProfileOption(
                    ref.watch(themeProvider) == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                    'Dark Mode',
                    () {},
                    trailing: Switch(
                      value: ref.watch(themeProvider) == ThemeMode.dark,
                      activeColor: kPrimaryOrange,
                      onChanged: (value) {
                        ref.read(themeProvider.notifier).setThemeMode(
                              value ? ThemeMode.dark : ThemeMode.light,
                            );
                      },
                    ),
                  ),
                  _buildProfileOption(
                    Icons.logout,
                    'Logout',
                    () {
                      ref.read(authControllerProvider.notifier).logout();
                      context.go('/login');
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap, {Color? color, Widget? trailing}) {
    final displayColor = color ?? kPrimaryOrange;
    final iconSize = Responsive.value<double>(context, mobile: 24, tablet: 28);
    
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        vertical: Responsive.value(context, mobile: 4, tablet: 8),
      ),
      leading: Container(
        padding: EdgeInsets.all(Responsive.value(context, mobile: 8, tablet: 12)),
        decoration: BoxDecoration(
          color: displayColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Responsive.value(context, mobile: 8, tablet: 12)),
        ),
        child: Icon(icon, color: displayColor, size: iconSize),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: Responsive.value(context, mobile: 15, tablet: 17),
        ),
      ),
      trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  void _showSearchModal() {
    final padding = Responsive.value<double>(context, mobile: 16, tablet: 24);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
                  style: TextStyle(fontSize: Responsive.value(context, mobile: 16, tablet: 18)),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search, color: kPrimaryOrange),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        Navigator.pop(context);
                      },
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
                  onChanged: (value) => setState(() {}),
                  onSubmitted: (value) {
                    Navigator.pop(context);
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final productsAsync = ref.watch(productsProvider(
                      search: _searchController.text.isEmpty ? null : _searchController.text,
                    ));
                    return productsAsync.when(
                      data: (products) => products.isEmpty
                          ? const Center(child: Text('No products found'))
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
                                      color: kSoftOrange,
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
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${product.price.toInt()} AFN',
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
                      error: (e, _) => Center(child: Text('Error: $e')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
