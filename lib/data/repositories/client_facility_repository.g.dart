// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_facility_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clientFacilityRepository)
const clientFacilityRepositoryProvider = ClientFacilityRepositoryProvider._();

final class ClientFacilityRepositoryProvider
    extends
        $FunctionalProvider<
          ClientFacilityRepository,
          ClientFacilityRepository,
          ClientFacilityRepository
        >
    with $Provider<ClientFacilityRepository> {
  const ClientFacilityRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientFacilityRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientFacilityRepositoryHash();

  @$internal
  @override
  $ProviderElement<ClientFacilityRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ClientFacilityRepository create(Ref ref) {
    return clientFacilityRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClientFacilityRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClientFacilityRepository>(value),
    );
  }
}

String _$clientFacilityRepositoryHash() =>
    r'4aa6cb1f31d4e40d48bab051fc3ecc1aba705d8b';
