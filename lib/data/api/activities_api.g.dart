// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activities_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activitiesApi)
const activitiesApiProvider = ActivitiesApiProvider._();

final class ActivitiesApiProvider
    extends $FunctionalProvider<ActivitiesApi, ActivitiesApi, ActivitiesApi>
    with $Provider<ActivitiesApi> {
  const ActivitiesApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activitiesApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activitiesApiHash();

  @$internal
  @override
  $ProviderElement<ActivitiesApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ActivitiesApi create(Ref ref) {
    return activitiesApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivitiesApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivitiesApi>(value),
    );
  }
}

String _$activitiesApiHash() => r'f98b79b758b304d491c531f197f844403e99e742';
