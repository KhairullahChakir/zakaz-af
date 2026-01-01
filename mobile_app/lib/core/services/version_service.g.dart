// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Version check service

@ProviderFor(VersionNotifier)
const versionProvider = VersionNotifierProvider._();

/// Version check service
final class VersionNotifierProvider
    extends $AsyncNotifierProvider<VersionNotifier, AppVersion> {
  /// Version check service
  const VersionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'versionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$versionNotifierHash();

  @$internal
  @override
  VersionNotifier create() => VersionNotifier();
}

String _$versionNotifierHash() => r'50aeaf110daf1c904a32f2da1b1209293427b3c1';

/// Version check service

abstract class _$VersionNotifier extends $AsyncNotifier<AppVersion> {
  FutureOr<AppVersion> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AppVersion>, AppVersion>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppVersion>, AppVersion>,
              AsyncValue<AppVersion>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
