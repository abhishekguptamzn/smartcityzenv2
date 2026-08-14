// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_members_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(facilityMembersApi)
const facilityMembersApiProvider = FacilityMembersApiProvider._();

final class FacilityMembersApiProvider
    extends
        $FunctionalProvider<
          FacilityMembersApi,
          FacilityMembersApi,
          FacilityMembersApi
        >
    with $Provider<FacilityMembersApi> {
  const FacilityMembersApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'facilityMembersApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$facilityMembersApiHash();

  @$internal
  @override
  $ProviderElement<FacilityMembersApi> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FacilityMembersApi create(Ref ref) {
    return facilityMembersApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FacilityMembersApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FacilityMembersApi>(value),
    );
  }
}

String _$facilityMembersApiHash() =>
    r'33d4fe66a7d53bdb90274e0eafd67fef046bb96a';
