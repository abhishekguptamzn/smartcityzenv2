import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/users_api.dart';
import '../models/user_model.dart';

part 'users_repository.g.dart';

class UsersRepository {
  UsersRepository(this._api);

  final UsersApi _api;

  Future<UserModel> getById(String id) async {
    final response = await _api.getById(id);
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  Future<UserModel> update(
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
  }) async {
    final response = await _api.update(
      id,
      name: name,
      email: email,
      phone: phone,
      dob: dob,
      gender: gender,
      cityId: cityId,
      locality: locality,
      address: address,
      pincode: pincode,
      landmark: landmark,
      profession: profession,
      company: company,
      workExperience: workExperience,
      education: education,
      skills: skills,
      languages: languages,
      interests: interests,
      bio: bio,
      hobbies: hobbies,
      profileVisibility: profileVisibility,
      password: password,
    );
    final data =
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  Future<void> uploadPhoto(
    String id, {
    required List<int> bytes,
    required String filename,
  }) async {
    await _api.uploadPhoto(id, bytes: bytes, filename: filename);
  }

  Future<void> deletePhoto(String id) async {
    await _api.deletePhoto(id);
  }
}

@Riverpod(keepAlive: true)
UsersRepository usersRepository(Ref ref) =>
    UsersRepository(ref.watch(usersApiProvider));
