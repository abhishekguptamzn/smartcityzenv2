// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facilities_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(facilitiesApi)
const facilitiesApiProvider = FacilitiesApiProvider._();

final class FacilitiesApiProvider
    extends $FunctionalProvider<FacilitiesApi, FacilitiesApi, FacilitiesApi>
    with $Provider<FacilitiesApi> {
  const FacilitiesApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'facilitiesApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$facilitiesApiHash();

  @$internal
  @override
  $ProviderElement<FacilitiesApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FacilitiesApi create(Ref ref) {
    return facilitiesApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FacilitiesApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FacilitiesApi>(value),
    );
  }
}

String _$facilitiesApiHash() => r'5c430a0305bfadc177bc7923d3c310009d6f7ff6';
