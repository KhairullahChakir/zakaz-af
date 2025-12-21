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
import '../features/products/domain/product.dart';
import '../features/shop/presentation/become_shopkeeper_screen.dart';
import '../features/shop/presentation/shop_status_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // If auth state is loading, do nothing (or show splash)
      if (authState.isLoading || authState.hasError) return null;

      final isAuthenticated = authState.value != null;
      final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/register';

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
        path: '/become-shopkeeper',
        builder: (context, state) => const BecomeShopkeeperScreen(),
      ),
      GoRoute(
        path: '/shop-status',
        builder: (context, state) => const ShopApplicationStatusScreen(),
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
    ],
  );
}
