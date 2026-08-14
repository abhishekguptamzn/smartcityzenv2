// Create/mark-paid/earnings are staff-only server-side and deliberately not
// implemented here — `/payments` (list) and `/payments/{id}` are already
// self-scoped to the caller for the customer role, which is all this client
// needs.
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'payments_api.g.dart';

class PaymentsApi {
  PaymentsApi(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> list({
    String? status,
    String? dateFrom,
    String? dateTo,
    int perPage = 15,
    int page = 1,
  }) {
    return _dio.get(
      '/payments',
      queryParameters: {
        if (status != null) 'status': status,
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
        'per_page': perPage,
        'page': page,
      },
    );
  }

  Future<Response<dynamic>> getById(String id) => _dio.get('/payments/$id');
}

@Riverpod(keepAlive: true)
PaymentsApi paymentsApi(Ref ref) => PaymentsApi(ref.watch(dioProvider));
