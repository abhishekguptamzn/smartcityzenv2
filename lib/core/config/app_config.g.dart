// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppConfigController)
const appConfigControllerProvider = AppConfigControllerProvider._();

final class AppConfigControllerProvider
    extends $NotifierProvider<AppConfigController, AppConfig> {
  const AppConfigControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appConfigControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appConfigControllerHash();

  @$internal
  @override
  AppConfigController create() => AppConfigController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppConfig>(value),
    );
  }
}

String _$appConfigControllerHash() =>
    r'd06f77e8c656309e80cf336a511e902f3229bafa';

abstract class _$AppConfigController extends $Notifier<AppConfig> {
  AppConfig build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AppConfig, AppConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppConfig, AppConfig>,
              AppConfig,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
