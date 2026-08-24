// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_notification_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(realtimeNotificationService)
const realtimeNotificationServiceProvider =
    RealtimeNotificationServiceProvider._();

final class RealtimeNotificationServiceProvider
    extends
        $FunctionalProvider<
          RealtimeNotificationService,
          RealtimeNotificationService,
          RealtimeNotificationService
        >
    with $Provider<RealtimeNotificationService> {
  const RealtimeNotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realtimeNotificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realtimeNotificationServiceHash();

  @$internal
  @override
  $ProviderElement<RealtimeNotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RealtimeNotificationService create(Ref ref) {
    return realtimeNotificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RealtimeNotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RealtimeNotificationService>(value),
    );
  }
}

String _$realtimeNotificationServiceHash() =>
    r'f7e4370ea053104ed8a9b393af8f940213b6d12e';
