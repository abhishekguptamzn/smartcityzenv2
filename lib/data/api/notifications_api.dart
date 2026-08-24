import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'notifications_api.g.dart';

class NotificationsApi {
  NotificationsApi(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> list({
    String? status,
    String? type,
    String? category,
    int perPage = 20,
    int page = 1,
  }) {
    return _dio.get(
      '/notifications',
      queryParameters: {
        if (status != null && status != 'all') 'status': status,
        if (type != null && type != 'all') 'type': type,
        if (category != null && category != 'all') 'category': category,
        'per_page': perPage,
        'page': page,
      },
    );
  }

  Future<Response<dynamic>> getUnreadCount() =>
      _dio.get('/notifications/unread-count');

  Future<Response<dynamic>> markAsRead(String id) =>
      _dio.post('/notifications/$id/read');

  Future<Response<dynamic>> markAllAsRead() =>
      _dio.post('/notifications/mark-all-read');

  Future<Response<dynamic>> delete(String id) =>
      _dio.delete('/notifications/$id');

  Future<Response<dynamic>> clearAll() =>
      _dio.delete('/notifications/clear-all');

  Future<Response<dynamic>> executeAction(String id) =>
      _dio.post('/notifications/$id/action');
}

@Riverpod(keepAlive: true)
NotificationsApi notificationsApi(Ref ref) =>
    NotificationsApi(ref.watch(dioProvider));
