// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_members_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(facilityMembersRepository)
const facilityMembersRepositoryProvider = FacilityMembersRepositoryProvider._();

final class FacilityMembersRepositoryProvider
    extends
        $FunctionalProvider<
          FacilityMembersRepository,
          FacilityMembersRepository,
          FacilityMembersRepository
        >
    with $Provider<FacilityMembersRepository> {
  const FacilityMembersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'facilityMembersRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$facilityMembersRepositoryHash();

  @$internal
  @override
  $ProviderElement<FacilityMembersRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FacilityMembersRepository create(Ref ref) {
    return facilityMembersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FacilityMembersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FacilityMembersRepository>(value),
    );
  }
}

String _$facilityMembersRepositoryHash() =>
    r'5a4fb67ccf2cc1a08e0ffe9d6be0248566991be8';
