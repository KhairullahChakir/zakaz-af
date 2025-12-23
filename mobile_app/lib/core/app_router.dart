import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/otp_verification_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
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
import '../features/products/presentation/categories_screen.dart';
import '../features/products/presentation/category_products_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/notifications/presentation/admin_send_notification_screen.dart';
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

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Use select on the state (AsyncValue) to only trigger rebuilds when auth status changes.
  // This prevents the "weird loading" and app resets during name/avatar updates.
  final isAuthenticated = ref.watch(authControllerProvider.select((s) => s.value != null));
  final isVerified = ref.watch(authControllerProvider.select((s) => s.value?.isVerified ?? false));
  final isInitialLoading = ref.watch(authControllerProvider.select((s) => s.isLoading && !s.hasValue));
  final hasError = ref.watch(authControllerProvider.select((s) => s.hasError));

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (isInitialLoading) return '/splash';
      if (hasError && !isAuthenticated) return '/login';

      final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/register';
      final isVerifying = state.uri.path == '/verify-otp';
      final isForgot = state.uri.path == '/forgot-password';
      final isSplash = state.uri.path == '/splash';

      if (!isAuthenticated) {
        if (isLoggingIn || isVerifying || isForgot || isSplash) return null;
        return '/login';
      }

      if (isAuthenticated && !isVerified) {
        if (isVerifying || isSplash) return null;
        return '/verify-otp';
      }

      if (isAuthenticated && isVerified && (isLoggingIn || isVerifying || isSplash)) {
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
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) {
          final emailOrPhone = state.extra as String? ?? '';
          return OTPVerificationScreen(emailOrPhone: emailOrPhone);
        },
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
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/products/category/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final name = state.uri.queryParameters['name'] ?? 'Products';
          return CategoryProductsScreen(categoryId: id, categoryName: name);
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
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
        path: '/admin/notifications',
        builder: (context, state) => const AdminSendNotificationScreen(),
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
