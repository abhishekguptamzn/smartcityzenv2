// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cities_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(citiesList)
const citiesListProvider = CitiesListProvider._();

final class CitiesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CityModel>>,
          List<CityModel>,
          FutureOr<List<CityModel>>
        >
    with $FutureModifier<List<CityModel>>, $FutureProvider<List<CityModel>> {
  const CitiesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'citiesListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$citiesListHash();

  @$internal
  @override
  $FutureProviderElement<List<CityModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CityModel>> create(Ref ref) {
    return citiesList(ref);
  }
}

String _$citiesListHash() => r'ff02fd88f0b1de6628155d3ca00bd43280874575';

@ProviderFor(cityInformation)
const cityInformationProvider = CityInformationFamily._();

final class CityInformationProvider
    extends
        $FunctionalProvider<
          AsyncValue<CityInformationModel>,
          CityInformationModel,
          FutureOr<CityInformationModel>
        >
    with
        $FutureModifier<CityInformationModel>,
        $FutureProvider<CityInformationModel> {
  const CityInformationProvider._({
    required CityInformationFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'cityInformationProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cityInformationHash();

  @override
  String toString() {
    return r'cityInformationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CityInformationModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CityInformationModel> create(Ref ref) {
    final argument = this.argument as String?;
    return cityInformation(ref, cityId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CityInformationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cityInformationHash() => r'b34def94f51aa2d7f28b0f75924e1f6cf7da5b97';

final class CityInformationFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CityInformationModel>, String?> {
  const CityInformationFamily._()
    : super(
        retry: null,
        name: r'cityInformationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  CityInformationProvider call({String? cityId}) =>
      CityInformationProvider._(argument: cityId, from: this);

  @override
  String toString() => r'cityInformationProvider';
}

@ProviderFor(SelectedCity)
const selectedCityProvider = SelectedCityProvider._();

final class SelectedCityProvider
    extends $NotifierProvider<SelectedCity, CityModel?> {
  const SelectedCityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCityHash();

  @$internal
  @override
  SelectedCity create() => SelectedCity();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CityModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CityModel?>(value),
    );
  }
}

String _$selectedCityHash() => r'cfdc6598d3769e84679670c3a537df5344b21acb';

abstract class _$SelectedCity extends $Notifier<CityModel?> {
  CityModel? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CityModel?, CityModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CityModel?, CityModel?>,
              CityModel?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
