// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OnboardingStatusController)
const onboardingStatusControllerProvider =
    OnboardingStatusControllerProvider._();

final class OnboardingStatusControllerProvider
    extends $AsyncNotifierProvider<OnboardingStatusController, bool> {
  const OnboardingStatusControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingStatusControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingStatusControllerHash();

  @$internal
  @override
  OnboardingStatusController create() => OnboardingStatusController();
}

String _$onboardingStatusControllerHash() =>
    r'f96f909ed5dc3b91e0ba542f5bab6e84dde1b709';

abstract class _$OnboardingStatusController extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
