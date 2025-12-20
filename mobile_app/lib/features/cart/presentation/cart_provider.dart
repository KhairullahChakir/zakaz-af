import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/storage/shared_prefs_provider.dart';
import '../domain/cart_item.dart';
import '../../products/domain/product.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  static const _storageKey = 'cart_items';

  @override
  FutureOr<List<CartItem>> build() async {
    return _loadCart();
  }

  List<CartItem> _loadCart() {
    final prefs = ref.read(sharedPrefsProvider);
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => CartItem.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  void _saveCart(List<CartItem> items) {
    final prefs = ref.read(sharedPrefsProvider);
    final jsonList = items.map((item) => {
      'product': item.product.toJson(),
      'quantity': item.quantity,
    }).toList();
    prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  Future<void> addToCart(Product product) async {
    final currentItems = state.value ?? [];
    final index = currentItems.indexWhere((item) => item.product.id == product.id);
    
    List<CartItem> newItems;
    if (index != -1) {
      final oldItem = currentItems[index];
      final newItem = oldItem.copyWith(quantity: oldItem.quantity + 1);
      newItems = [...currentItems];
      newItems[index] = newItem;
    } else {
      newItems = [...currentItems, CartItem(product: product, quantity: 1)];
    }

    state = AsyncValue.data(newItems);
    _saveCart(newItems);
  }

  Future<void> removeFromCart(int productId) async {
    final currentItems = state.value ?? [];
    final newItems = currentItems.where((item) => item.product.id != productId).toList();
    state = AsyncValue.data(newItems);
    _saveCart(newItems);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }
    
    final currentItems = state.value ?? [];
    final newItems = [
      for (final item in currentItems)
        if (item.product.id == productId)
          item.copyWith(quantity: quantity)
        else
          item
    ];

    state = AsyncValue.data(newItems);
    _saveCart(newItems);
  }

  Future<void> clearCart() async {
    state = const AsyncValue.data([]);
    _saveCart([]);
  }

  double get total => state.value?.fold(0, (sum, item) => sum! + (item.product.price * item.quantity)) ?? 0;

  int get itemCount => state.value?.fold(0, (sum, item) => sum! + item.quantity) ?? 0;
}
