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
    String? dob,
    String? gender,
    String? cityId,
    String? locality,
    String? address,
    String? pincode,
    String? landmark,
    String? profession,
    String? company,
    String? workExperience,
    String? education,
    List<String>? skills,
    List<String>? languages,
    List<String>? interests,
    String? bio,
    List<String>? hobbies,
    String? profileVisibility,
    String? password,
  }) {
    return _dio.patch(
      '/users/$id',
      data: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (dob != null) 'dob': dob,
        if (gender != null) 'gender': gender,
        if (cityId != null) 'city_id': cityId,
        if (locality != null) 'locality': locality,
        if (address != null) 'address': address,
        if (pincode != null) 'pincode': pincode,
        if (landmark != null) 'landmark': landmark,
        if (profession != null) 'profession': profession,
        if (company != null) 'company': company,
        if (workExperience != null) 'work_experience': workExperience,
        if (education != null) 'education': education,
        if (skills != null) 'skills': skills,
        if (languages != null) 'languages': languages,
        if (interests != null) 'interests': interests,
        if (bio != null) 'bio': bio,
        if (hobbies != null) 'hobbies': hobbies,
        if (profileVisibility != null) 'profile_visibility': profileVisibility,
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
