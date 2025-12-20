import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/cart_item.dart';
import '../../products/domain/product.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  @override
  List<CartItem> build() {
    return [];
  }

  void addToCart(Product product) {
    // Check if item already exists
    final index = state.indexWhere((item) => item.product.id == product.id);
    
    if (index != -1) {
      // Increment quantity
      final oldItem = state[index];
      final newItem = oldItem.copyWith(quantity: oldItem.quantity + 1);
      final newState = [...state];
      newState[index] = newItem;
      state = newState;
    } else {
      // Add new item
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  void removeFromCart(int productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    
    state = [
      for (final item in state)
        if (item.product.id == productId)
          item.copyWith(quantity: quantity)
        else
          item
    ];
  }

  void clearCart() {
    state = [];
  }

  double get total => state.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
}
