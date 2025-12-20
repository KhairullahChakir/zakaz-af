import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/address_repository.dart';
import '../domain/address.dart';

part 'address_provider.g.dart';

@riverpod
class Addresses extends _$Addresses {
  @override
  FutureOr<List<Address>> build() {
    return ref.watch(addressRepositoryProvider).getAddresses();
  }

  Future<void> addAddress(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(addressRepositoryProvider).addAddress(data);
      return ref.read(addressRepositoryProvider).getAddresses();
    });
  }

  Future<void> updateAddress(int id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(addressRepositoryProvider).updateAddress(id, data);
      return ref.read(addressRepositoryProvider).getAddresses();
    });
  }

  Future<void> deleteAddress(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(addressRepositoryProvider).deleteAddress(id);
      return ref.read(addressRepositoryProvider).getAddresses();
    });
  }
}
