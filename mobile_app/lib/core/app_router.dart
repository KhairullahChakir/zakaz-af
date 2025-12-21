import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/profile_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/products/presentation/product_details_screen.dart';
import '../features/cart/presentation/cart_screen.dart';
import '../features/cart/presentation/checkout_screen.dart';
import '../features/orders/presentation/orders_screen.dart';
import '../features/orders/presentation/order_details_screen.dart';
import '../features/addresses/presentation/address_screen.dart';
import '../features/addresses/presentation/add_edit_address_screen.dart';
import '../features/addresses/domain/address.dart';
import '../features/analytics/presentation/analytics_screen.dart';
import '../features/wishlist/presentation/wishlist_screen.dart';
import '../features/admin/presentation/admin_products_screen.dart';
import '../features/admin/presentation/add_edit_product_screen.dart';
import '../features/admin/presentation/admin_categories_screen.dart';
import '../features/admin/presentation/admin_shops_screen.dart';
import '../features/admin/presentation/admin_shop_detail_screen.dart';
import '../features/products/domain/product.dart';
import '../features/shop/domain/shop.dart';
import '../features/shop/presentation/become_shopkeeper_screen.dart';
import '../features/shop/presentation/shop_status_screen.dart';
import '../features/shop/presentation/shopkeeper_dashboard_screen.dart';
import '../features/shop/presentation/shopkeeper_products_screen.dart';
import '../features/shop/presentation/shopkeeper_add_edit_product_screen.dart';
import '../features/shop/presentation/shopkeeper_orders_screen.dart';
import '../features/chat/presentation/conversations_screen.dart';
import '../features/chat/presentation/chat_screen.dart';
import '../features/chat/domain/conversation.dart';

import '../core/widgets/splash_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (authState.isLoading) return '/splash';
      if (authState.hasError) return '/login'; // Redirect to login on error

      final isAuthenticated = authState.value != null;
      final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/register';
      final isSplash = state.uri.path == '/splash';

      if (isSplash && !isAuthenticated) return '/login';
      if (isSplash && isAuthenticated) return '/';

      if (!isAuthenticated) {
         return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return OrderDetailsScreen(orderId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/wishlist',
        builder: (context, state) => const WishlistScreen(),
      ),
      // Chat routes
      GoRoute(
        path: '/conversations',
        builder: (context, state) => const ConversationsScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final conversation = state.extra as Conversation?;
          return ChatScreen(conversationId: id, conversation: conversation);
        },
      ),
      GoRoute(
        path: '/admin/products',
        builder: (context, state) => const AdminProductsScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddEditProductScreen(),
          ),
          GoRoute(
            path: 'edit',
            builder: (context, state) {
              final product = state.extra as Product;
              return AddEditProductScreen(product: product);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/admin/categories',
        builder: (context, state) => const AdminCategoriesScreen(),
      ),
      GoRoute(
        path: '/admin/shops',
        builder: (context, state) => const AdminShopsScreen(),
      ),
      GoRoute(
        path: '/admin/shops/:id',
        builder: (context, state) {
          final shop = state.extra as Shop;
          return AdminShopDetailScreen(shop: shop);
        },
      ),
      GoRoute(
        path: '/become-shopkeeper',
        builder: (context, state) => const BecomeShopkeeperScreen(),
      ),
      GoRoute(
        path: '/shop-status',
        builder: (context, state) => const ShopApplicationStatusScreen(),
      ),
      // Shopkeeper routes
      GoRoute(
        path: '/shopkeeper/dashboard',
        builder: (context, state) => const ShopkeeperDashboardScreen(),
      ),
      GoRoute(
        path: '/shopkeeper/products',
        builder: (context, state) => const ShopkeeperProductsScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const ShopkeeperAddEditProductScreen(),
          ),
          GoRoute(
            path: 'edit',
            builder: (context, state) {
              final product = state.extra as Product;
              return ShopkeeperAddEditProductScreen(product: product);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/shopkeeper/orders',
        builder: (context, state) => const ShopkeeperOrdersScreen(),
      ),
      GoRoute(
        path: '/addresses',
        builder: (context, state) => const AddressScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddEditAddressScreen(),
          ),
          GoRoute(
            path: 'edit',
            builder: (context, state) {
              final address = state.extra as Address;
              return AddEditAddressScreen(address: address);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
           GoRoute(
            path: 'product/:id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return ProductDetailsScreen(productId: id);
            },
          ),
        ]
      ),
      // Products route (plural)
      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductDetailsScreen(productId: id);
        },
      ),
    ],
  );
}
