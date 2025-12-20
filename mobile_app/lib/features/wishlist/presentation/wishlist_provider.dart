import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../products/domain/product.dart';
import '../data/wishlist_repository.dart';

part 'wishlist_provider.g.dart';

@riverpod
class Wishlist extends _$Wishlist {
  @override
  Future<List<Product>> build() async {
    return ref.watch(wishlistRepositoryProvider).getWishlist();
  }

  Future<void> addToWishlist(Product product) async {
    await ref.read(wishlistRepositoryProvider).addToWishlist(product.id);
    state = AsyncValue.data([...state.value ?? [], product]);
  }

  Future<void> removeFromWishlist(int productId) async {
    await ref.read(wishlistRepositoryProvider).removeFromWishlist(productId);
    state = AsyncValue.data(
      (state.value ?? []).where((p) => p.id != productId).toList(),
    );
  }

  bool isInWishlist(int productId) {
    return state.value?.any((p) => p.id == productId) ?? false;
  }

  Future<void> toggleWishlist(Product product) async {
    if (isInWishlist(product.id)) {
      await removeFromWishlist(product.id);
    } else {
      await addToWishlist(product);
    }
  }
}
