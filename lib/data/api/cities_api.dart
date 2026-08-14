import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'cities_api.g.dart';

class CitiesApi {
  CitiesApi(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> list({
    String? search,
    String? state,
    bool? isCapital,
    int perPage = 50,
    int page = 1,
  }) {
    return _dio.get(
      '/cities',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (state != null && state.isNotEmpty) 'state': state,
        if (isCapital != null) 'is_capital': isCapital,
        'per_page': perPage,
        'page': page,
      },
    );
  }

  Future<Response<dynamic>> get(String id) => _dio.get('/cities/$id');

  Future<Response<dynamic>> getInformation(String cityId) =>
      _dio.get('/cities/$cityId/information');
}

@Riverpod(keepAlive: true)
CitiesApi citiesApi(Ref ref) => CitiesApi(ref.watch(dioProvider));
