import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/notification_model.dart';
import '../../data/repositories/notifications_repository.dart';
import '../services/realtime_notification_service.dart';
import 'auth_controller.dart';

part 'notifications_provider.g.dart';

@Riverpod(keepAlive: true)
class UnreadNotificationCountNotifier
    extends _$UnreadNotificationCountNotifier {
  StreamSubscription<int>? _streamSub;

  @override
  FutureOr<int> build() async {
    final authState = ref.watch(authControllerProvider);
    if (authState.value == null) {
      return 0;
    }

    final realtimeService = ref.watch(realtimeNotificationServiceProvider);
    _streamSub?.cancel();
    _streamSub = realtimeService.unreadCountStream.listen((count) {
      state = AsyncData(count);
    });

    ref.onDispose(() => _streamSub?.cancel());

    final repo = ref.watch(notificationsRepositoryProvider);
    return repo.getUnreadCount();
  }

  void setCount(int count) {
    state = AsyncData(count < 0 ? 0 : count);
  }

  void decrement() {
    final current = state.value ?? 0;
    if (current > 0) {
      state = AsyncData(current - 1);
    }
  }

  void increment() {
    final current = state.value ?? 0;
    state = AsyncData(current + 1);
  }
}

@riverpod
class NotificationFilterCategory extends _$NotificationFilterCategory {
  @override
  String build() => 'all'; // 'all', 'unread', 'announcements', 'alerts'

  void setCategory(String category) => state = category;
}

@Riverpod(keepAlive: true)
class NotificationsListNotifier extends _$NotificationsListNotifier {
  StreamSubscription<NotificationModel>? _streamSub;

  @override
  FutureOr<List<NotificationModel>> build() async {
    final authState = ref.watch(authControllerProvider);
    if (authState.value == null) {
      return [];
    }

    final category = ref.watch(notificationFilterCategoryProvider);
    final repo = ref.watch(notificationsRepositoryProvider);
    final realtimeService = ref.watch(realtimeNotificationServiceProvider);

    // Start real-time service connection
    realtimeService.start();

    _streamSub?.cancel();
    _streamSub = realtimeService.notificationStream.listen((notification) {
      _onRealtimeNotificationReceived(notification);
    });

    ref.onDispose(() => _streamSub?.cancel());

    final paginated = await repo.list(
      category: category == 'all' || category == 'unread' ? null : category,
      status: category == 'unread' ? 'unread' : null,
      perPage: 50,
    );

    return paginated.items;
  }

  void _onRealtimeNotificationReceived(NotificationModel notification) {
    final current = state.value ?? [];
    // Prevent duplicate insertion
    if (current.any((item) => item.id == notification.id)) {
      return;
    }

    state = AsyncData([notification, ...current]);
    ref.read(unreadNotificationCountProvider.notifier).increment();
  }

  Future<void> markAsRead(String id) async {
    final current = state.value ?? [];
    final updatedList = current.map((item) {
      if (item.id == id) {
        return item.copyWith(isRead: true, readAt: DateTime.now().toIso8601String());
      }
      return item;
    }).toList();

    state = AsyncData(updatedList);
    ref.read(unreadNotificationCountProvider.notifier).decrement();

    try {
      final repo = ref.read(notificationsRepositoryProvider);
      await repo.markAsRead(id);
    } catch (_) {
      // Revert if failed
    }
  }

  Future<void> markAllAsRead() async {
    final current = state.value ?? [];
    final now = DateTime.now().toIso8601String();
    final updatedList = current.map((item) {
      return item.copyWith(isRead: true, readAt: now);
    }).toList();

    state = AsyncData(updatedList);
    ref.read(unreadNotificationCountProvider.notifier).setCount(0);

    try {
      final repo = ref.read(notificationsRepositoryProvider);
      await repo.markAllAsRead();
    } catch (_) {
      // Revert if failed
    }
  }

  Future<NotificationModel?> deleteNotification(String id) async {
    final current = state.value ?? [];
    final itemToRemove = current.firstWhere(
      (item) => item.id == id,
      orElse: () => current.first,
    );
    final wasUnread = itemToRemove.isUnread;

    final updatedList = current.where((item) => item.id != id).toList();
    state = AsyncData(updatedList);

    if (wasUnread) {
      ref.read(unreadNotificationCountProvider.notifier).decrement();
    }

    try {
      final repo = ref.read(notificationsRepositoryProvider);
      await repo.delete(id);
      return itemToRemove;
    } catch (_) {
      // Rollback on failure
      state = AsyncData(current);
      if (wasUnread) {
        ref.read(unreadNotificationCountProvider.notifier).increment();
      }
      return null;
    }
  }

  void restoreNotification(NotificationModel item) {
    final current = state.value ?? [];
    if (!current.any((n) => n.id == item.id)) {
      state = AsyncData([item, ...current]);
      if (item.isUnread) {
        ref.read(unreadNotificationCountProvider.notifier).increment();
      }
    }
  }

  Future<void> clearAll() async {
    state = const AsyncData([]);
    ref.read(unreadNotificationCountProvider.notifier).setCount(0);

    try {
      final repo = ref.read(notificationsRepositoryProvider);
      await repo.clearAll();
    } catch (_) {
      ref.invalidateSelf();
    }
  }

  Future<void> executeAction(String id) async {
    await markAsRead(id);
    try {
      final repo = ref.read(notificationsRepositoryProvider);
      await repo.executeAction(id);
    } catch (_) {}
  }
}
