// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'haptic_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider to track if haptic feedback is enabled

@ProviderFor(HapticEnabled)
const hapticEnabledProvider = HapticEnabledProvider._();

/// Provider to track if haptic feedback is enabled
final class HapticEnabledProvider
    extends $NotifierProvider<HapticEnabled, bool> {
  /// Provider to track if haptic feedback is enabled
  const HapticEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hapticEnabledProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hapticEnabledHash();

  @$internal
  @override
  HapticEnabled create() => HapticEnabled();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hapticEnabledHash() => r'039fc64158c422ffc0ddd13246a2c7d79f3d317a';

/// Provider to track if haptic feedback is enabled

abstract class _$HapticEnabled extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
