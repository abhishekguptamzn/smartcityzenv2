import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'auth_api.g.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> register({
    required String name,
    required String email,
    String? phone,
    required String cityId,
    required String password,
    required String passwordConfirmation,
  }) {
    return _dio.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        'city_id': cityId,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  Future<Response<dynamic>> login({
    required String email,
    required String password,
  }) {
    return _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response<dynamic>> oauthLogin({
    required String provider,
    String? accessToken,
    String? idToken,
    String? email,
    String? name,
    String? avatar,
    String? providerId,
  }) {
    return _dio.post(
      '/auth/oauth/$provider',
      data: {
        'provider': provider,
        if (accessToken != null) 'access_token': accessToken,
        if (idToken != null) 'id_token': idToken,
        if (email != null) 'email': email,
        if (name != null) 'name': name,
        if (avatar != null) 'avatar': avatar,
        if (providerId != null) 'provider_id': providerId,
      },
    );
  }

  Future<Response<dynamic>> forgotPassword({required String email}) {
    return _dio.post('/auth/forgot-password', data: {'email': email});
  }

  Future<Response<dynamic>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) {
    return _dio.post(
      '/auth/reset-password',
      data: {
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  Future<Response<dynamic>> logout() => _dio.post('/auth/logout');

  Future<Response<dynamic>> logoutAll() => _dio.post('/auth/logout-all');

  Future<Response<dynamic>> me() => _dio.get('/auth/me');

  Future<Response<dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) {
    return _dio.post(
      '/auth/change-password',
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      },
    );
  }

  Future<Response<dynamic>> loginHistory({
    int perPage = 15,
    int page = 1,
    String? status,
    bool? isSuspicious,
  }) {
    return _dio.get(
      '/auth/login-history',
      queryParameters: {
        'per_page': perPage,
        'page': page,
        if (status != null) 'status': status,
        if (isSuspicious != null) 'is_suspicious': isSuspicious,
      },
    );
  }
}

@Riverpod(keepAlive: true)
AuthApi authApi(Ref ref) => AuthApi(ref.watch(dioProvider));
