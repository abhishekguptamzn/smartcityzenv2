// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_facility_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clientFacilityApi)
const clientFacilityApiProvider = ClientFacilityApiProvider._();

final class ClientFacilityApiProvider
    extends
        $FunctionalProvider<
          ClientFacilityApi,
          ClientFacilityApi,
          ClientFacilityApi
        >
    with $Provider<ClientFacilityApi> {
  const ClientFacilityApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientFacilityApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientFacilityApiHash();

  @$internal
  @override
  $ProviderElement<ClientFacilityApi> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ClientFacilityApi create(Ref ref) {
    return clientFacilityApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClientFacilityApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClientFacilityApi>(value),
    );
  }
}

String _$clientFacilityApiHash() => r'3a8a9a897a4677ee436f059bf8b9780dc4dd517e';
