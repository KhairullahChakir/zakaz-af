// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_limit_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Rate limiting service for login attempts

@ProviderFor(RateLimitNotifier)
const rateLimitProvider = RateLimitNotifierProvider._();

/// Rate limiting service for login attempts
final class RateLimitNotifierProvider
    extends $NotifierProvider<RateLimitNotifier, RateLimitState> {
  /// Rate limiting service for login attempts
  const RateLimitNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rateLimitProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rateLimitNotifierHash();

  @$internal
  @override
  RateLimitNotifier create() => RateLimitNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RateLimitState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RateLimitState>(value),
    );
  }
}

String _$rateLimitNotifierHash() => r'8452de035b0f06270a5204990b2875b8e7a779e8';

/// Rate limiting service for login attempts

abstract class _$RateLimitNotifier extends $Notifier<RateLimitState> {
  RateLimitState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<RateLimitState, RateLimitState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RateLimitState, RateLimitState>,
              RateLimitState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
