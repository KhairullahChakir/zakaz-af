// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Connectivity service for offline mode detection

@ProviderFor(ConnectivityNotifier)
const connectivityProvider = ConnectivityNotifierProvider._();

/// Connectivity service for offline mode detection
final class ConnectivityNotifierProvider
    extends $NotifierProvider<ConnectivityNotifier, ConnectivityStatus> {
  /// Connectivity service for offline mode detection
  const ConnectivityNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityNotifierHash();

  @$internal
  @override
  ConnectivityNotifier create() => ConnectivityNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectivityStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectivityStatus>(value),
    );
  }
}

String _$connectivityNotifierHash() =>
    r'984fbf6cc39b82702d2ca65b435182207d96c948';

/// Connectivity service for offline mode detection

abstract class _$ConnectivityNotifier extends $Notifier<ConnectivityStatus> {
  ConnectivityStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ConnectivityStatus, ConnectivityStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConnectivityStatus, ConnectivityStatus>,
              ConnectivityStatus,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
