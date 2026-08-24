// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationsApi)
const notificationsApiProvider = NotificationsApiProvider._();

final class NotificationsApiProvider
    extends
        $FunctionalProvider<
          NotificationsApi,
          NotificationsApi,
          NotificationsApi
        >
    with $Provider<NotificationsApi> {
  const NotificationsApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsApiHash();

  @$internal
  @override
  $ProviderElement<NotificationsApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NotificationsApi create(Ref ref) {
    return notificationsApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationsApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationsApi>(value),
    );
  }
}

String _$notificationsApiHash() => r'9387759666d15a0c290143d9ff525a7982316b92';
