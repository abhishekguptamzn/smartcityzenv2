// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cities_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(citiesApi)
const citiesApiProvider = CitiesApiProvider._();

final class CitiesApiProvider
    extends $FunctionalProvider<CitiesApi, CitiesApi, CitiesApi>
    with $Provider<CitiesApi> {
  const CitiesApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'citiesApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$citiesApiHash();

  @$internal
  @override
  $ProviderElement<CitiesApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CitiesApi create(Ref ref) {
    return citiesApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CitiesApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CitiesApi>(value),
    );
  }
}

String _$citiesApiHash() => r'22bd48bd9df7129ef1e947a6373ed66c3cb3673c';
