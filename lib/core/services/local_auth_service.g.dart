// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_auth_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localAuthService)
const localAuthServiceProvider = LocalAuthServiceProvider._();

final class LocalAuthServiceProvider
    extends
        $FunctionalProvider<
          LocalAuthService,
          LocalAuthService,
          LocalAuthService
        >
    with $Provider<LocalAuthService> {
  const LocalAuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localAuthServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localAuthServiceHash();

  @$internal
  @override
  $ProviderElement<LocalAuthService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalAuthService create(Ref ref) {
    return localAuthService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalAuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalAuthService>(value),
    );
  }
}

String _$localAuthServiceHash() => r'b66f8ed29eb7e33b168c9cabd2731ef001572179';
