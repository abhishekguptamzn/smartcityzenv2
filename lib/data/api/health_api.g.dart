// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(healthApi)
const healthApiProvider = HealthApiProvider._();

final class HealthApiProvider
    extends $FunctionalProvider<HealthApi, HealthApi, HealthApi>
    with $Provider<HealthApi> {
  const HealthApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthApiHash();

  @$internal
  @override
  $ProviderElement<HealthApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HealthApi create(Ref ref) {
    return healthApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HealthApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HealthApi>(value),
    );
  }
}

String _$healthApiHash() => r'a65734e5b209c204b829a817a1e13168ff3ff518';
