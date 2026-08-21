// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appConfigApi)
const appConfigApiProvider = AppConfigApiProvider._();

final class AppConfigApiProvider
    extends $FunctionalProvider<AppConfigApi, AppConfigApi, AppConfigApi>
    with $Provider<AppConfigApi> {
  const AppConfigApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appConfigApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appConfigApiHash();

  @$internal
  @override
  $ProviderElement<AppConfigApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppConfigApi create(Ref ref) {
    return appConfigApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppConfigApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppConfigApi>(value),
    );
  }
}

String _$appConfigApiHash() => r'66b92f1d0f7d4bfde546ee5525aeb70bf73114d8';

@ProviderFor(appConfig)
const appConfigProvider = AppConfigProvider._();

final class AppConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppConfigModel>,
          AppConfigModel,
          FutureOr<AppConfigModel>
        >
    with $FutureModifier<AppConfigModel>, $FutureProvider<AppConfigModel> {
  const AppConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appConfigHash();

  @$internal
  @override
  $FutureProviderElement<AppConfigModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AppConfigModel> create(Ref ref) {
    return appConfig(ref);
  }
}

String _$appConfigHash() => r'4774635062987890a631ad4622e7cab7a8158338';
