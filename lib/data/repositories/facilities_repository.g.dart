// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facilities_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(facilitiesRepository)
const facilitiesRepositoryProvider = FacilitiesRepositoryProvider._();

final class FacilitiesRepositoryProvider
    extends
        $FunctionalProvider<
          FacilitiesRepository,
          FacilitiesRepository,
          FacilitiesRepository
        >
    with $Provider<FacilitiesRepository> {
  const FacilitiesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'facilitiesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$facilitiesRepositoryHash();

  @$internal
  @override
  $ProviderElement<FacilitiesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FacilitiesRepository create(Ref ref) {
    return facilitiesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FacilitiesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FacilitiesRepository>(value),
    );
  }
}

String _$facilitiesRepositoryHash() =>
    r'a5961c7908c8bdcfea31191354b4915a8ada4ca2';
