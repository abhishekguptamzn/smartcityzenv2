import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'onboard_api.g.dart';

class OnboardApi {
  OnboardApi(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> submitUser(Map<String, dynamic> data) {
    return _dio.post('/onboard/user', data: data);
  }

  Future<Response<dynamic>> submitLibrary(Map<String, dynamic> data) {
    return _dio.post('/onboard/library', data: data);
  }

  Future<Response<dynamic>> submitGym(Map<String, dynamic> data) {
    return _dio.post('/onboard/gym', data: data);
  }

  Future<Response<dynamic>> searchOwners(String query) {
    return _dio.get('/onboard/users/search', queryParameters: {'q': query});
  }

  Future<Response<dynamic>> verifyToken(String token) {
    return _dio.get('/onboard/verify-token', queryParameters: {'token': token});
  }

  Future<Response<dynamic>> complete(Map<String, dynamic> data) {
    return _dio.post('/onboard/complete', data: data);
  }
}

@Riverpod(keepAlive: true)
OnboardApi onboardApi(Ref ref) => OnboardApi(ref.watch(dioProvider));
