// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_member_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(facilityMemberDetail)
const facilityMemberDetailProvider = FacilityMemberDetailFamily._();

final class FacilityMemberDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<FacilityMemberModel>,
          FacilityMemberModel,
          FutureOr<FacilityMemberModel>
        >
    with
        $FutureModifier<FacilityMemberModel>,
        $FutureProvider<FacilityMemberModel> {
  const FacilityMemberDetailProvider._({
    required FacilityMemberDetailFamily super.from,
    required (FacilityKind, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'facilityMemberDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$facilityMemberDetailHash();

  @override
  String toString() {
    return r'facilityMemberDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<FacilityMemberModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FacilityMemberModel> create(Ref ref) {
    final argument = this.argument as (FacilityKind, String, String);
    return facilityMemberDetail(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is FacilityMemberDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$facilityMemberDetailHash() =>
    r'03fbad89f9d00a0cc0350c61a4991374a8313bcc';

final class FacilityMemberDetailFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<FacilityMemberModel>,
          (FacilityKind, String, String)
        > {
  const FacilityMemberDetailFamily._()
    : super(
        retry: null,
        name: r'facilityMemberDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FacilityMemberDetailProvider call(
    FacilityKind kind,
    String facilityId,
    String memberId,
  ) => FacilityMemberDetailProvider._(
    argument: (kind, facilityId, memberId),
    from: this,
  );

  @override
  String toString() => r'facilityMemberDetailProvider';
}

@ProviderFor(memberRenewals)
const memberRenewalsProvider = MemberRenewalsFamily._();

final class MemberRenewalsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MembershipRenewalModel>>,
          List<MembershipRenewalModel>,
          FutureOr<List<MembershipRenewalModel>>
        >
    with
        $FutureModifier<List<MembershipRenewalModel>>,
        $FutureProvider<List<MembershipRenewalModel>> {
  const MemberRenewalsProvider._({
    required MemberRenewalsFamily super.from,
    required (FacilityKind, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'memberRenewalsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$memberRenewalsHash();

  @override
  String toString() {
    return r'memberRenewalsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<MembershipRenewalModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MembershipRenewalModel>> create(Ref ref) {
    final argument = this.argument as (FacilityKind, String, String);
    return memberRenewals(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberRenewalsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberRenewalsHash() => r'ad2365c4e14f8933cef3bda0d9161db47fe33692';

final class MemberRenewalsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<MembershipRenewalModel>>,
          (FacilityKind, String, String)
        > {
  const MemberRenewalsFamily._()
    : super(
        retry: null,
        name: r'memberRenewalsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MemberRenewalsProvider call(
    FacilityKind kind,
    String facilityId,
    String memberId,
  ) => MemberRenewalsProvider._(
    argument: (kind, facilityId, memberId),
    from: this,
  );

  @override
  String toString() => r'memberRenewalsProvider';
}
