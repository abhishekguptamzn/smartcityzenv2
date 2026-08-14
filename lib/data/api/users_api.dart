import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';

part 'users_api.g.dart';

class UsersApi {
  UsersApi(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> getById(String id) => _dio.get('/users/$id');

  /// `role` is deliberately never sent here — customers cannot change their
  /// own role and the server ignores/blocks it for non-admins anyway.
  Future<Response<dynamic>> update(
    String id, {
    String? name,
    String? email,
    String? phone,
    String? cityId,
    String? password,
  }) {
    return _dio.patch(
      '/users/$id',
      data: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (cityId != null) 'city_id': cityId,
        if (password != null && password.isNotEmpty) 'password': password,
      },
    );
  }

  Future<Response<dynamic>> uploadPhoto(
    String id, {
    required List<int> bytes,
    required String filename,
  }) async {
    final formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(
        bytes,
        filename: filename,
      ),
    });
    return _dio.post('/users/$id/photo', data: formData);
  }

  Future<Response<dynamic>> deletePhoto(String id) {
    return _dio.delete('/users/$id/photo');
  }
}

@Riverpod(keepAlive: true)
UsersApi usersApi(Ref ref) => UsersApi(ref.watch(dioProvider));
