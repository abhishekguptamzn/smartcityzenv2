// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboard_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(onboardApi)
const onboardApiProvider = OnboardApiProvider._();

final class OnboardApiProvider
    extends $FunctionalProvider<OnboardApi, OnboardApi, OnboardApi>
    with $Provider<OnboardApi> {
  const OnboardApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardApiHash();

  @$internal
  @override
  $ProviderElement<OnboardApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OnboardApi create(Ref ref) {
    return onboardApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardApi>(value),
    );
  }
}

String _$onboardApiHash() => r'5e27ac59915c95177882fdc8cb47da57af438390';
