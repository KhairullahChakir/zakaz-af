// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_shops_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(nearbyShopsRepository)
const nearbyShopsRepositoryProvider = NearbyShopsRepositoryProvider._();

final class NearbyShopsRepositoryProvider
    extends
        $FunctionalProvider<
          NearbyShopsRepository,
          NearbyShopsRepository,
          NearbyShopsRepository
        >
    with $Provider<NearbyShopsRepository> {
  const NearbyShopsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nearbyShopsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbyShopsRepositoryHash();

  @$internal
  @override
  $ProviderElement<NearbyShopsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NearbyShopsRepository create(Ref ref) {
    return nearbyShopsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NearbyShopsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NearbyShopsRepository>(value),
    );
  }
}

String _$nearbyShopsRepositoryHash() =>
    r'e93fd604a4aab152d71b7f219c7f9d03dec28aad';

/// Provider for nearby shops based on user's current location

@ProviderFor(NearbyShopsNotifier)
const nearbyShopsProvider = NearbyShopsNotifierProvider._();

/// Provider for nearby shops based on user's current location
final class NearbyShopsNotifierProvider
    extends $AsyncNotifierProvider<NearbyShopsNotifier, NearbyShopsResponse?> {
  /// Provider for nearby shops based on user's current location
  const NearbyShopsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nearbyShopsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbyShopsNotifierHash();

  @$internal
  @override
  NearbyShopsNotifier create() => NearbyShopsNotifier();
}

String _$nearbyShopsNotifierHash() =>
    r'a47489eef513f7dab3d1925a5ff515436d3e4c54';

/// Provider for nearby shops based on user's current location

abstract class _$NearbyShopsNotifier
    extends $AsyncNotifier<NearbyShopsResponse?> {
  FutureOr<NearbyShopsResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<NearbyShopsResponse?>, NearbyShopsResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NearbyShopsResponse?>,
                NearbyShopsResponse?
              >,
              AsyncValue<NearbyShopsResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
