// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dio)
const dioProvider = DioProvider._();

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  const DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'1844db3a2abe3c23eef601267cb10c9057f124b8';

/// The health endpoint lives outside `/api/v1`, so it needs its own client
/// with the version segment stripped from the configured base URL.
/// NOTE: healthDio intentionally omits auth and error mapping interceptors
/// since /health is a public liveness probe that handles raw responses.

@ProviderFor(healthDio)
const healthDioProvider = HealthDioProvider._();

/// The health endpoint lives outside `/api/v1`, so it needs its own client
/// with the version segment stripped from the configured base URL.
/// NOTE: healthDio intentionally omits auth and error mapping interceptors
/// since /health is a public liveness probe that handles raw responses.

final class HealthDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// The health endpoint lives outside `/api/v1`, so it needs its own client
  /// with the version segment stripped from the configured base URL.
  /// NOTE: healthDio intentionally omits auth and error mapping interceptors
  /// since /health is a public liveness probe that handles raw responses.
  const HealthDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return healthDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$healthDioHash() => r'67aff506a2a751b1a5eab33bf0afa1ede157a58a';
