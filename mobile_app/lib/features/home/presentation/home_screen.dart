import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';
import 'package:mobile_app/core/widgets/cart_icon_badge.dart';
import 'package:mobile_app/core/theme/theme_provider.dart';
import 'package:mobile_app/core/utils/responsive.dart';
import '../../products/presentation/providers.dart';
import '../../products/domain/product.dart';
import '../../products/domain/category.dart';
import '../../chat/presentation/conversations_screen.dart';
import '../../wishlist/presentation/wishlist_provider.dart';
import '../../cart/presentation/cart_provider.dart';
import '../../notifications/presentation/notification_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../cart/presentation/cart_screen.dart';
import '../../profile/presentation/help_center_screen.dart';
import '../../profile/presentation/about_screen.dart';
import '../../profile/presentation/privacy_policy_screen.dart';
import '../../profile/presentation/notification_settings_screen.dart';
import '../../profile/presentation/account_security_screen.dart';
import '../../shop/presentation/shopkeeper_dashboard_screen.dart';
import '../../admin/presentation/admin_dashboard_screen.dart';
import '../../profile/presentation/language_selection_screen.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/widgets/custom_cached_image.dart';
import '../../../core/widgets/shimmer_loading.dart';

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
  String? _sortBy;
  String? _sortOrder;
  final _searchController = TextEditingController();
  final _pageController = PageController();
  final _scrollController = ScrollController();
  final _allProductsKey = GlobalKey();
  int _bannerIndex = 0;

  List<Map<String, dynamic>> get _banners => [
    {
      'title': '${ref.tr('welcome_to')} ${ref.tr('app_name')}',
      'subtitle': ref.tr('shop_from_local'),
      'icon': Icons.storefront,
    },
    {
      'title': ref.tr('fresh_groceries'),
      'subtitle': ref.tr('delivered_to_door'),
      'icon': Icons.local_grocery_store,
    },
    {
      'title': ref.tr('fashion_style'),
      'subtitle': ref.tr('traditional_modern'),
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).value;
    final isShopkeeper = user?.isShopkeeper == true;
    final isAdmin = user?.isAdmin == true;
    
    return Scaffold(
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          _buildHomeTab(),
          const ConversationsScreen(),
          if (isShopkeeper) const ShopkeeperDashboardScreen(),
          if (isAdmin) const AdminDashboardScreen(),
          _CartTab(onNavigateToHome: () => setState(() => _currentNavIndex = 0)),
          const _ProfileTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(isShopkeeper: isShopkeeper, isAdmin: isAdmin),
    );
  }

  Widget _buildBottomNav({required bool isShopkeeper, required bool isAdmin}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
            setState(() => _currentNavIndex = index);
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.grey[600]),
              selectedIcon: const Icon(Icons.home, color: kPrimaryOrange),
              label: ref.tr('nav_home'),
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline, color: Colors.grey[600]),
              selectedIcon: const Icon(Icons.chat_bubble, color: kPrimaryOrange),
              label: ref.tr('nav_messages'),
            ),
            if (isShopkeeper)
              NavigationDestination(
                icon: Icon(Icons.store_outlined, color: Colors.grey[600]),
                selectedIcon: const Icon(Icons.store, color: kPrimaryOrange),
                label: ref.tr('nav_my_shop'),
              ),
            if (isAdmin)
              NavigationDestination(
                icon: Icon(Icons.admin_panel_settings_outlined, color: Colors.grey[600]),
                selectedIcon: const Icon(Icons.admin_panel_settings, color: Color(0xFF6366F1)),
                label: ref.tr('nav_admin'),
              ),
            NavigationDestination(
              icon: const CartIconBadge(showBackground: false),
              selectedIcon: const CartIconBadge(showBackground: false, isSelected: true),
              label: ref.tr('nav_cart'),
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.grey[600]),
              selectedIcon: const Icon(Icons.person, color: kPrimaryOrange),
              label: ref.tr('nav_profile'),
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
      sortBy: _sortBy,
      sortOrder: _sortOrder,
    ));

    final padding = Responsive.value<double>(context, mobile: 16, tablet: 24, desktop: 32);
    final bannerHeight = Responsive.bannerHeight(context);
    final gridColumns = Responsive.gridColumns(context);

    return CustomScrollView(
      controller: _scrollController,
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
                    ref.tr('app_name'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.value(context, mobile: 20, tablet: 24),
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    ref.tr('shop_from_local'),
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
              icon: ref.watch(unreadNotificationCountProvider).maybeWhen(
                data: (count) => count > 0 
                  ? Badge(
                      label: Text('$count'),
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.notifications_none, color: Colors.white),
                    )
                  : const Icon(Icons.notifications_none, color: Colors.white),
                orElse: () => const Icon(Icons.notifications_none, color: Colors.white),
              ),
              iconSize: Responsive.value(context, mobile: 24, tablet: 28),
              onPressed: () => context.push('/notifications'),
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
                    color: Colors.black.withValues(alpha: 0.1),
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
                        ref.tr('search_products'),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: Responsive.value(context, mobile: 14, tablet: 16),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showSortModal(),
                        child: Container(
                          padding: EdgeInsets.all(Responsive.value(context, mobile: 8, tablet: 10)),
                          decoration: BoxDecoration(
                            color: kSoftOrange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.tune, 
                            size: Responsive.value(context, mobile: 18, tablet: 22), 
                            color: kPrimaryOrange),
                        ),
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
                        color: kPrimaryOrange.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      // Decorative circles
                      Positioned(
                        right: -30,
                        top: -30,
                        child: Container(
                          width: Responsive.value(context, mobile: 100, tablet: 140),
                          height: Responsive.value(context, mobile: 100, tablet: 140),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        bottom: -40,
                        child: Container(
                          width: Responsive.value(context, mobile: 80, tablet: 120),
                          height: Responsive.value(context, mobile: 80, tablet: 120),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 50,
                        top: 20,
                        child: Container(
                          width: Responsive.value(context, mobile: 40, tablet: 60),
                          height: Responsive.value(context, mobile: 40, tablet: 60),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
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
                                banner['title']?.toString() ?? '',
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
                                banner['subtitle']?.toString() ?? '',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
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
                                  ref.tr('shop_now'),
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
                  ref.tr('categories'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.value(context, mobile: 18, tablet: 22),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/categories'),
                  child: Text(
                    ref.tr('see_all'),
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
              loading: () => CategoriesSkeleton(height: Responsive.value(context, mobile: 100, tablet: 120)),
              error: (e, _) => Center(child: Text('${ref.tr('error')}: $e')),
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
                  ref.tr('featured_products'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.value(context, mobile: 18, tablet: 22),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final context = _allProductsKey.currentContext;
                    if (context != null) {
                      Scrollable.ensureVisible(
                        context,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    ref.tr('see_all'),
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
              loading: () => const FeaturedProductsSkeleton(),
              error: (e, _) => Center(child: Text('${ref.tr('error')}: $e')),
            ),
          ),
        ),

        // All Products Grid
        SliverToBoxAdapter(
          key: _allProductsKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(padding, 16, padding, 8),
            child: Text(
              ref.tr('all_products'),
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
          loading: () => SliverProductGridSkeleton(
            crossAxisCount: gridColumns,
            childAspectRatio: Responsive.productCardRatio(context),
            padding: EdgeInsets.all(padding),
          ),
          error: (e, _) => SliverToBoxAdapter(
            child: Center(child: Text('${ref.tr('error')}: $e')),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: Responsive.value(context, mobile: 80, tablet: 100))),
      ],
    );
  }

  Widget _buildCategoryCard(Category category, bool isSelected) {
    final cardSize = Responsive.categoryCardSize(context);
    final iconSize = Responsive.value<double>(context, mobile: 28, tablet: 34);

    // Check if category has a photo (database or asset)
    final hasPhoto = category.image != null || 
        ['grocer', 'cloth', 'tech'].any((t) => category.name.toLowerCase().contains(t));

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
              padding: hasPhoto ? EdgeInsets.zero : EdgeInsets.all(Responsive.value(context, mobile: 14, tablet: 18)),
              decoration: BoxDecoration(
                color: hasPhoto ? Colors.transparent : (isSelected ? kPrimaryOrange : kSoftOrange),
                borderRadius: BorderRadius.circular(Responsive.value(context, mobile: 16, tablet: 20)),
                border: isSelected ? null : Border.all(color: kPrimaryOrange.withValues(alpha: 0.3)),
              ),
              // Ensure photo fills the container if present
              width: hasPhoto ? cardSize : null,
              height: hasPhoto ? cardSize : null,
              child: hasPhoto 
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(Responsive.value(context, mobile: 16, tablet: 20)),
                    child: _buildCategoryIcon(category, isSelected, iconSize * 2.5), // Larger size for photo
                  )
                : _buildCategoryIcon(category, isSelected, iconSize),
            ),
            SizedBox(height: Responsive.value(context, mobile: 6, tablet: 8)),
            Text(
              ref.tr(category.name.toLowerCase()),
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

  Widget _buildCategoryIcon(Category category, bool isSelected, double size) {
    if (category.image != null) {
      final imageUrl = category.image!.startsWith('http') 
          ? category.image! 
          : 'http://172.20.10.2:8000/storage/${category.image}';

      return CustomCachedImage(
        imageUrl: imageUrl, 
        width: size,
        height: size,
        fit: BoxFit.cover,
        borderRadius: 8,
        errorWidget: Icon(Icons.error, size: size, color: Colors.white),
      );
    }

    String? assetPath;
    final name = category.name.toLowerCase();
    if (name.contains('grocer')) {
      assetPath = 'assets/images/groceries.png';
    } else if (name.contains('cloth')) {
      assetPath = 'assets/images/clothes.png';
    } else if (name.contains('tech')) {
      assetPath = 'assets/images/tech.png';
    }

    if (assetPath != null) {
      return Image.asset(assetPath, width: size, height: size, fit: BoxFit.contain);
    }

    return Icon(
      Icons.category,
      color: isSelected ? Colors.white : kPrimaryOrange,
      size: size,
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
              color: Colors.black.withValues(alpha: 0.08),
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
                              child: Icon(Icons.image, size: 40, color: kPrimaryOrange.withValues(alpha: 0.5)),
                            ),
                          ),
                        )
                      : Center(child: Icon(Icons.image, size: 40, color: kPrimaryOrange.withValues(alpha: 0.5))),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final wishlistAsync = ref.watch(wishlistProvider);
                      final isInWishlist = wishlistAsync.value?.any((p) => p.id == product.id) ?? false;
                      
                      return GestureDetector(
                        onTap: () {
                          ref.read(wishlistProvider.notifier).toggleWishlist(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isInWishlist ? 'Removed from Wishlist' : 'Added to Wishlist!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(Responsive.value(context, mobile: 5, tablet: 7)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            isInWishlist ? Icons.favorite : Icons.favorite_border, 
                            size: Responsive.value(context, mobile: 16, tablet: 20), 
                            color: kPrimaryOrange,
                          ),
                        ),
                      );
                    },
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
                          product.reviewsAvgRating?.toStringAsFixed(1) ?? 'New',
                          style: TextStyle(
                            fontSize: Responsive.value(context, mobile: 11, tablet: 13),
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${product.price.toInt()} ${ref.tr('afn')}',
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
              color: Colors.black.withValues(alpha: 0.06),
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
                                  child: Icon(Icons.image, size: 40, color: kPrimaryOrange.withValues(alpha: 0.5)),
                              ),
                            ),
                          )
                        : Center(child: Icon(Icons.image, size: 40, color: kPrimaryOrange.withValues(alpha: 0.5))),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer(
                      builder: (context, ref, _) {
                        final wishlistAsync = ref.watch(wishlistProvider);
                        final isInWishlist = wishlistAsync.value?.any((p) => p.id == product.id) ?? false;
                        
                        return GestureDetector(
                          onTap: () {
                            ref.read(wishlistProvider.notifier).toggleWishlist(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isInWishlist ? ref.tr('removed_from_wishlist') : ref.tr('added_to_wishlist')),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(Responsive.value(context, mobile: 6, tablet: 8)),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isInWishlist ? Icons.favorite : Icons.favorite_border, 
                              size: Responsive.value(context, mobile: 18, tablet: 22), 
                              color: kPrimaryOrange,
                            ),
                          ),
                        );
                      },
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
                          ref.tr('low_stock'),
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
                            '${product.price.toInt()} ${ref.tr('afn')}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.value(context, mobile: 13, tablet: 15),
                              color: kPrimaryOrange,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ref.read(cartProvider.notifier).addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(ref.tr('added_to_cart_full', args: {'name': product.name})),
                                duration: const Duration(seconds: 1),
                                action: SnackBarAction(
                                  label: ref.tr('view_caps'),
                                  onPressed: () => context.push('/cart'),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(Responsive.value(context, mobile: 6, tablet: 8)),
                            decoration: BoxDecoration(
                              color: kPrimaryOrange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.add, 
                              size: Responsive.value(context, mobile: 16, tablet: 20), 
                              color: Colors.white),
                          ),
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






  void _showSortModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sort By',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSortOption(ref.tr('sort_price_asc'), 'price', 'asc'),
            _buildSortOption(ref.tr('sort_price_desc'), 'price', 'desc'),
            _buildSortOption(ref.tr('sort_newest'), 'created_at', 'desc'),
            _buildSortOption(ref.tr('sort_rating'), 'rating', 'desc'),
            const SizedBox(height: 8),
            if (_sortBy != null)
              TextButton(
                onPressed: () {
                  setState(() {
                    _sortBy = null;
                    _sortOrder = null;
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  ref.tr('clear_sort'),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, String sortBy, String sortOrder) {
    final isSelected = _sortBy == sortBy && _sortOrder == sortOrder;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isSelected ? kPrimaryOrange : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? kPrimaryOrange : null,
        ),
      ),
      onTap: () {
        setState(() {
          _sortBy = sortBy;
          _sortOrder = sortOrder;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showSearchModal() {
    final padding = Responsive.value<double>(context, mobile: 16, tablet: 24);
    String searchQuery = '';
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
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
                    autofocus: true,
                    cursorColor: kPrimaryOrange,
                    style: TextStyle(fontSize: Responsive.value(context, mobile: 16, tablet: 18)),
                    decoration: InputDecoration(
                      hintText: ref.tr('search_products'),
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
                    onChanged: (value) => setModalState(() => searchQuery = value),
                  ),
                ),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final productsAsync = ref.watch(productsProvider(
                        search: searchQuery.isEmpty ? null : searchQuery,
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
                                      searchQuery.isEmpty ? ref.tr('start_typing') : ref.tr('no_products_found'),
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
                                      '${product.price.toInt()} ${ref.tr('afn')}',
                                      style: TextStyle(
                                        color: kPrimaryOrange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Responsive.value(context, mobile: 14, tablet: 16),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      this.context.push('/products/${product.id}');
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
        ),
      ),
    );
  }
}

// ============================================================================
// ISOLATED CART TAB WIDGET
// This prevents HomeScreen from rebuilding when cart changes occur
// ============================================================================
class _CartTab extends StatelessWidget {
  final VoidCallback? onNavigateToHome;
  
  const _CartTab({this.onNavigateToHome});

  @override
  Widget build(BuildContext context) {
    return CartScreen(onNavigateToHome: onNavigateToHome);
  }
}

// ============================================================================
// ISOLATED PROFILE TAB WIDGET
// This prevents HomeScreen from rebuilding when profile updates occur
// ============================================================================
class _ProfileTab extends ConsumerStatefulWidget {
  const _ProfileTab();

  @override
  ConsumerState<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<_ProfileTab> {
  Future<void> _handleImageChange() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final user = ref.read(authControllerProvider).value;
      if (user != null) {
        await ref.read(authControllerProvider.notifier).updateProfile(
          name: user.name,
          email: user.email,
          phone: user.phone,
          imagePath: pickedFile.path,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(ref.tr('profile_updated'))),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).value;
    final isLoading = ref.watch(authControllerProvider).isLoading;
    final padding = Responsive.value<double>(context, mobile: 16, tablet: 24, desktop: 32);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Premium Header with Glassmorphism feel
          SliverAppBar(
            expandedHeight: Responsive.value(context, mobile: 240, tablet: 280),
            pinned: true,
            backgroundColor: kPrimaryOrange,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kPrimaryOrange, kDarkOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Decorative shapes
                  Positioned(
                    top: -50,
                    right: -50,
                    child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withValues(alpha: 0.1)),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: CircleAvatar(radius: 80, backgroundColor: Colors.white.withValues(alpha: 0.05)),
                  ),
                  // Content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Interactive Avatar
                      GestureDetector(
                        onTap: isLoading ? null : () => _handleImageChange(),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: Responsive.value(context, mobile: 50, tablet: 65),
                                backgroundColor: kSoftOrange,
                                child: ClipOval(
                                  child: user?.profileImageUrl != null
                                      ? CustomCachedImage(
                                          imageUrl: user!.profileImageUrl!,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: const CircularProgressIndicator(strokeWidth: 2),
                                          errorWidget: const Icon(Icons.person, size: 50, color: kPrimaryOrange),
                                        )
                                      : const Icon(Icons.person, size: 50, color: kPrimaryOrange),
                                ),
                              ),
                            ),
                            if (isLoading)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  ),
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: kPrimaryOrange, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt, size: 14, color: kPrimaryOrange),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name & Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user?.name ?? ref.tr('guest'),
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified, color: Colors.white, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  ref.tr(user?.isShopkeeper == true ? 'merchant' : 'gold'),
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        user?.email ?? ref.tr('login_subtitle'),
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Become a Seller Promotion (only if not already a seller)
                  if (user?.isShopkeeper == false && user?.isAdmin == false)
                    _buildSellerPromo(context),

                  const SizedBox(height: 16),
                  
                  // Account Section
                  _buildSectionHeader(ref.tr('my_account')),
                  _buildSectionCard([
                    _buildProfileOption(Icons.shopping_bag_outlined, ref.tr('my_orders'), () => context.push('/orders')),
                    _buildProfileOption(Icons.location_on_outlined, ref.tr('addresses'), () => context.push('/addresses')),
                    _buildProfileOption(Icons.security_outlined, ref.tr('account_security'), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountSecurityScreen()))),
                    _buildProfileOption(Icons.person_outline, ref.tr('edit_profile'), () => context.push('/profile')),
                  ]),

                  const SizedBox(height: 24),

                  // Preferences Section
                  _buildSectionHeader(ref.tr('preferences')),
                  _buildSectionCard([
                    _buildProfileOption(
                      Icons.palette_outlined, 
                      ref.tr('appearance'), 
                      () => context.push('/appearance'),
                      subtitle: _getThemeModeName(ref),
                    ),
                    _buildProfileOption(Icons.notifications_none_outlined, ref.tr('notifications'), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()))),
                    _buildProfileOption(Icons.language_outlined, ref.tr('language'), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSelectionScreen())), subtitle: ref.watch(languageProvider).nativeName),
                  ]),

                  const SizedBox(height: 24),

                  // Support Section
                  _buildSectionHeader(ref.tr('support')),
                  _buildSectionCard([
                    _buildProfileOption(Icons.help_outline, ref.tr('help_center'), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpCenterScreen()))),
                    _buildProfileOption(Icons.info_outline, ref.tr('about_app'), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()))),
                    _buildProfileOption(Icons.privacy_tip_outlined, ref.tr('privacy_policy'), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()))),
                  ]),

                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _showLogoutConfirmation(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(ref.tr('logout'), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(ref.tr('logout_confirm_title'), style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(ref.tr('logout_confirmation')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(ref.tr('cancel'), style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              ref.read(authControllerProvider.notifier).logout();
              context.go('/login');
            },
            child: Text(ref.tr('logout'), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _getThemeModeName(WidgetRef ref) {
    final themeMode = ref.watch(themePreferenceProvider);
    if (themeMode == AppThemeMode.system) {
      return ref.tr('theme_system');
    } else if (themeMode == AppThemeMode.light) {
      return ref.tr('theme_light');
    } else {
      return ref.tr('theme_dark');
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSellerPromo(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ref.tr('reach_millions'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  ref.tr('start_shop_promo'),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.push('/shop-status'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(ref.tr('become_seller'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.storefront, color: Colors.white.withValues(alpha: 0.3), size: 80),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
    IconData icon, 
    String title, 
    VoidCallback onTap, {
    Color? color, 
    Widget? trailing,
    String? subtitle,
  }) {
    final displayColor = color ?? kPrimaryOrange;
    
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: displayColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: displayColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black87,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)) : null,
      trailing: trailing ?? Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
    );
  }
}

