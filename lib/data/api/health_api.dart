import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'health_api.g.dart';

class HealthApi {
  HealthApi(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> check() => _dio.get('/api/health');
}

@Riverpod(keepAlive: true)
HealthApi healthApi(Ref ref) => HealthApi(ref.watch(healthDioProvider));
