// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UnreadNotificationCountNotifier)
const unreadNotificationCountProvider =
    UnreadNotificationCountNotifierProvider._();

final class UnreadNotificationCountNotifierProvider
    extends $AsyncNotifierProvider<UnreadNotificationCountNotifier, int> {
  const UnreadNotificationCountNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadNotificationCountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadNotificationCountNotifierHash();

  @$internal
  @override
  UnreadNotificationCountNotifier create() => UnreadNotificationCountNotifier();
}

String _$unreadNotificationCountNotifierHash() =>
    r'd320ee20d00ad42f7b4392b5afd7fc6ae49ec80d';

abstract class _$UnreadNotificationCountNotifier extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(NotificationFilterCategory)
const notificationFilterCategoryProvider =
    NotificationFilterCategoryProvider._();

final class NotificationFilterCategoryProvider
    extends $NotifierProvider<NotificationFilterCategory, String> {
  const NotificationFilterCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationFilterCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationFilterCategoryHash();

  @$internal
  @override
  NotificationFilterCategory create() => NotificationFilterCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$notificationFilterCategoryHash() =>
    r'60733a3da4c7cac6458a1b7aa9b7832ce90b65a4';

abstract class _$NotificationFilterCategory extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(NotificationsListNotifier)
const notificationsListProvider = NotificationsListNotifierProvider._();

final class NotificationsListNotifierProvider
    extends
        $AsyncNotifierProvider<
          NotificationsListNotifier,
          List<NotificationModel>
        > {
  const NotificationsListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsListNotifierHash();

  @$internal
  @override
  NotificationsListNotifier create() => NotificationsListNotifier();
}

String _$notificationsListNotifierHash() =>
    r'7ef21f01b4e57dc5239bf9d7be66a67d1a014f81';

abstract class _$NotificationsListNotifier
    extends $AsyncNotifier<List<NotificationModel>> {
  FutureOr<List<NotificationModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<NotificationModel>>,
              List<NotificationModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<NotificationModel>>,
                List<NotificationModel>
              >,
              AsyncValue<List<NotificationModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
