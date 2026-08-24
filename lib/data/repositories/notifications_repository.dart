import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/notifications_api.dart';
import '../models/notification_model.dart';
import '../models/pagination_meta.dart';

part 'notifications_repository.g.dart';

class NotificationsRepository {
  NotificationsRepository(this._api);

  final NotificationsApi _api;

  Future<Paginated<NotificationModel>> list({
    String? status,
    String? type,
    String? category,
    int perPage = 20,
    int page = 1,
  }) async {
    final response = await _api.list(
      status: status,
      type: type,
      category: category,
      perPage: perPage,
      page: page,
    );
    return Paginated.fromEnvelope(
      response.data as Map<String, dynamic>,
      NotificationModel.fromJson,
    );
  }

  Future<int> getUnreadCount() async {
    final response = await _api.getUnreadCount();
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return (data['unread_count'] as num?)?.toInt() ?? 0;
  }

  Future<NotificationModel> markAsRead(String id) async {
    final response = await _api.markAsRead(id);
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return NotificationModel.fromJson(data);
  }

  Future<int> markAllAsRead() async {
    final response = await _api.markAllAsRead();
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return (data['marked_count'] as num?)?.toInt() ?? 0;
  }

  Future<bool> delete(String id) async {
    final response = await _api.delete(id);
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return data['deleted'] == true;
  }

  Future<int> clearAll() async {
    final response = await _api.clearAll();
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return (data['cleared_count'] as num?)?.toInt() ?? 0;
  }

  Future<NotificationModel> executeAction(String id) async {
    final response = await _api.executeAction(id);
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return NotificationModel.fromJson(data);
  }
}

@Riverpod(keepAlive: true)
NotificationsRepository notificationsRepository(Ref ref) =>
    NotificationsRepository(ref.watch(notificationsApiProvider));
