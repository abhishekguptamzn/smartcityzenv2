// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_explorer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(unifiedFacilityCategories)
const unifiedFacilityCategoriesProvider = UnifiedFacilityCategoriesProvider._();

final class UnifiedFacilityCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FacilityCategoryItem>>,
          List<FacilityCategoryItem>,
          FutureOr<List<FacilityCategoryItem>>
        >
    with
        $FutureModifier<List<FacilityCategoryItem>>,
        $FutureProvider<List<FacilityCategoryItem>> {
  const UnifiedFacilityCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unifiedFacilityCategoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unifiedFacilityCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<FacilityCategoryItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FacilityCategoryItem>> create(Ref ref) {
    return unifiedFacilityCategories(ref);
  }
}

String _$unifiedFacilityCategoriesHash() =>
    r'9e19c3a401e31bc3e77c23f2e710aa43ebbb4c27';

@ProviderFor(FacilityExplorerList)
const facilityExplorerListProvider = FacilityExplorerListFamily._();

final class FacilityExplorerListProvider
    extends $AsyncNotifierProvider<FacilityExplorerList, List<FacilityModel>> {
  const FacilityExplorerListProvider._({
    required FacilityExplorerListFamily super.from,
    required FacilityExplorerQuery super.argument,
  }) : super(
         retry: null,
         name: r'facilityExplorerListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$facilityExplorerListHash();

  @override
  String toString() {
    return r'facilityExplorerListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FacilityExplorerList create() => FacilityExplorerList();

  @override
  bool operator ==(Object other) {
    return other is FacilityExplorerListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$facilityExplorerListHash() =>
    r'7d0db5e3df4ec35f605f7497b32fbbb483e58182';

final class FacilityExplorerListFamily extends $Family
    with
        $ClassFamilyOverride<
          FacilityExplorerList,
          AsyncValue<List<FacilityModel>>,
          List<FacilityModel>,
          FutureOr<List<FacilityModel>>,
          FacilityExplorerQuery
        > {
  const FacilityExplorerListFamily._()
    : super(
        retry: null,
        name: r'facilityExplorerListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FacilityExplorerListProvider call(FacilityExplorerQuery query) =>
      FacilityExplorerListProvider._(argument: query, from: this);

  @override
  String toString() => r'facilityExplorerListProvider';
}

abstract class _$FacilityExplorerList
    extends $AsyncNotifier<List<FacilityModel>> {
  late final _$args = ref.$arg as FacilityExplorerQuery;
  FacilityExplorerQuery get query => _$args;

  FutureOr<List<FacilityModel>> build(FacilityExplorerQuery query);
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
