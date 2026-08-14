// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facilities_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FacilityList)
const facilityListProvider = FacilityListFamily._();

final class FacilityListProvider
    extends $AsyncNotifierProvider<FacilityList, List<FacilityModel>> {
  const FacilityListProvider._({
    required FacilityListFamily super.from,
    required FacilityListParams super.argument,
  }) : super(
         retry: null,
         name: r'facilityListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$facilityListHash();

  @override
  String toString() {
    return r'facilityListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FacilityList create() => FacilityList();

  @override
  bool operator ==(Object other) {
    return other is FacilityListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$facilityListHash() => r'3f841dd4f93cefe59ada2ceb8866ccc9c24635df';

final class FacilityListFamily extends $Family
    with
        $ClassFamilyOverride<
          FacilityList,
          AsyncValue<List<FacilityModel>>,
          List<FacilityModel>,
          FutureOr<List<FacilityModel>>,
          FacilityListParams
        > {
  const FacilityListFamily._()
    : super(
        retry: null,
        name: r'facilityListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FacilityListProvider call(FacilityListParams params) =>
      FacilityListProvider._(argument: params, from: this);

  @override
  String toString() => r'facilityListProvider';
}

abstract class _$FacilityList extends $AsyncNotifier<List<FacilityModel>> {
  late final _$args = ref.$arg as FacilityListParams;
  FacilityListParams get params => _$args;

  FutureOr<List<FacilityModel>> build(FacilityListParams params);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<FacilityModel>>, List<FacilityModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<FacilityModel>>, List<FacilityModel>>,
              AsyncValue<List<FacilityModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(NearbyLibraryList)
const nearbyLibraryListProvider = NearbyLibraryListFamily._();

final class NearbyLibraryListProvider
    extends $AsyncNotifierProvider<NearbyLibraryList, List<FacilityModel>> {
  const NearbyLibraryListProvider._({
    required NearbyLibraryListFamily super.from,
    required NearbyLibraryListParams super.argument,
  }) : super(
         retry: null,
         name: r'nearbyLibraryListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$nearbyLibraryListHash();

  @override
  String toString() {
    return r'nearbyLibraryListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NearbyLibraryList create() => NearbyLibraryList();

  @override
  bool operator ==(Object other) {
    return other is NearbyLibraryListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$nearbyLibraryListHash() => r'f5db5ae4eaae9e5e1211eba0fe445bd56235c94e';

final class NearbyLibraryListFamily extends $Family
    with
        $ClassFamilyOverride<
          NearbyLibraryList,
          AsyncValue<List<FacilityModel>>,
          List<FacilityModel>,
          FutureOr<List<FacilityModel>>,
          NearbyLibraryListParams
        > {
  const NearbyLibraryListFamily._()
    : super(
        retry: null,
        name: r'nearbyLibraryListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NearbyLibraryListProvider call(NearbyLibraryListParams params) =>
      NearbyLibraryListProvider._(argument: params, from: this);

  @override
  String toString() => r'nearbyLibraryListProvider';
}

abstract class _$NearbyLibraryList extends $AsyncNotifier<List<FacilityModel>> {
  late final _$args = ref.$arg as NearbyLibraryListParams;
  NearbyLibraryListParams get params => _$args;

  FutureOr<List<FacilityModel>> build(NearbyLibraryListParams params);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<FacilityModel>>, List<FacilityModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<FacilityModel>>, List<FacilityModel>>,
              AsyncValue<List<FacilityModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(facilityDetail)
const facilityDetailProvider = FacilityDetailFamily._();

final class FacilityDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<FacilityModel>,
          FacilityModel,
          FutureOr<FacilityModel>
        >
    with $FutureModifier<FacilityModel>, $FutureProvider<FacilityModel> {
  const FacilityDetailProvider._({
    required FacilityDetailFamily super.from,
    required (FacilityKind, String) super.argument,
  }) : super(
         retry: null,
         name: r'facilityDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$facilityDetailHash();

  @override
  String toString() {
    return r'facilityDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<FacilityModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FacilityModel> create(Ref ref) {
    final argument = this.argument as (FacilityKind, String);
    return facilityDetail(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is FacilityDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$facilityDetailHash() => r'93cfca983d1a22e6bb3f1811160b245b61f44b74';

final class FacilityDetailFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<FacilityModel>,
          (FacilityKind, String)
        > {
  const FacilityDetailFamily._()
    : super(
        retry: null,
        name: r'facilityDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FacilityDetailProvider call(FacilityKind kind, String id) =>
      FacilityDetailProvider._(argument: (kind, id), from: this);

  @override
  String toString() => r'facilityDetailProvider';
}

@ProviderFor(facilityFeePlans)
const facilityFeePlansProvider = FacilityFeePlansFamily._();

final class FacilityFeePlansProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  const FacilityFeePlansProvider._({
    required FacilityFeePlansFamily super.from,
    required (FacilityKind, String) super.argument,
  }) : super(
         retry: null,
         name: r'facilityFeePlansProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$facilityFeePlansHash();

  @override
  String toString() {
    return r'facilityFeePlansProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    final argument = this.argument as (FacilityKind, String);
    return facilityFeePlans(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is FacilityFeePlansProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$facilityFeePlansHash() => r'e36fa8147ca5ac547a5772271c0782c38a6aad77';

final class FacilityFeePlansFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Map<String, dynamic>>>,
          (FacilityKind, String)
        > {
  const FacilityFeePlansFamily._()
    : super(
        retry: null,
        name: r'facilityFeePlansProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FacilityFeePlansProvider call(FacilityKind kind, String facilityId) =>
      FacilityFeePlansProvider._(argument: (kind, facilityId), from: this);

  @override
  String toString() => r'facilityFeePlansProvider';
}

@ProviderFor(myMembershipSummaries)
const myMembershipSummariesProvider = MyMembershipSummariesProvider._();

final class MyMembershipSummariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MyMembershipSummary>>,
          List<MyMembershipSummary>,
          FutureOr<List<MyMembershipSummary>>
        >
    with
        $FutureModifier<List<MyMembershipSummary>>,
        $FutureProvider<List<MyMembershipSummary>> {
  const MyMembershipSummariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myMembershipSummariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myMembershipSummariesHash();

  @$internal
  @override
  $FutureProviderElement<List<MyMembershipSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MyMembershipSummary>> create(Ref ref) {
    return myMembershipSummaries(ref);
  }
}

String _$myMembershipSummariesHash() =>
    r'7738a0e56ee6dda54cc124cfe7c9d3a361b92d2c';
