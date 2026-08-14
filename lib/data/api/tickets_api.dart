import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'tickets_api.g.dart';

class TicketsApi {
  TicketsApi(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> list({
    String? status,
    String? category,
    String? search,
    int perPage = 20,
    int page = 1,
  }) {
    return _dio.get(
      '/tickets',
      queryParameters: {
        if (status != null && status != 'all') 'status': status,
        if (category != null && category != 'all') 'category': category,
        if (search != null && search.isNotEmpty) 'search': search,
        'per_page': perPage,
        'page': page,
      },
    );
  }

  Future<Response<dynamic>> create({
    required String subject,
    required String message,
    String category = 'general',
    String priority = 'medium',
  }) {
    return _dio.post(
      '/tickets',
      data: {
        'subject': subject,
        'message': message,
        'category': category,
        'priority': priority,
      },
    );
  }

  Future<Response<dynamic>> getById(int id) => _dio.get('/tickets/$id');

  Future<Response<dynamic>> reply(int id, {required String message}) {
    return _dio.post(
      '/tickets/$id/reply',
      data: {'message': message},
    );
  }
}

@Riverpod(keepAlive: true)
TicketsApi ticketsApi(Ref ref) => TicketsApi(ref.watch(dioProvider));
