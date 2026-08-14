import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/onboard_api.dart';
import '../models/onboard_model.dart';

part 'onboard_repository.g.dart';

class OnboardRepository {
  OnboardRepository(this._api);

  final OnboardApi _api;

  Future<Map<String, dynamic>> submitUser({
    required String name,
    required String email,
    required String phone,
    required String cityId,
  }) async {
    final response = await _api.submitUser({
      'name': name,
      'email': email,
      'phone': phone,
      'city_id': cityId,
    });
    final body = response.data as Map<String, dynamic>;
    return (body['data'] as Map<String, dynamic>?) ?? {};
  }

  Future<Map<String, dynamic>> submitLibrary({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String cityId,
    required String ownerId,
  }) async {
    final response = await _api.submitLibrary({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city_id': cityId,
      'owner_id': ownerId,
    });
    final body = response.data as Map<String, dynamic>;
    return (body['data'] as Map<String, dynamic>?) ?? {};
  }

  Future<Map<String, dynamic>> submitGym({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String cityId,
    required String ownerId,
  }) async {
    final response = await _api.submitGym({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city_id': cityId,
      'owner_id': ownerId,
    });
    final body = response.data as Map<String, dynamic>;
    return (body['data'] as Map<String, dynamic>?) ?? {};
  }

  Future<List<OwnerSearchResult>> searchOwners(String query) async {
    final response = await _api.searchOwners(query);
    final body = response.data as Map<String, dynamic>;
    final data = (body['data'] as Map<String, dynamic>?) ?? {};
    final users = (data['users'] as List<dynamic>?) ?? [];
    return users
        .map((u) => OwnerSearchResult.fromJson(u as Map<String, dynamic>))
        .toList();
  }

  Future<TokenVerificationResult> verifyToken(String token) async {
    final response = await _api.verifyToken(token);
    final body = response.data as Map<String, dynamic>;
    final data = (body['data'] as Map<String, dynamic>?) ?? {};
    return TokenVerificationResult.fromJson(data);
  }

  Future<Map<String, dynamic>> complete(Map<String, dynamic> data) async {
    final response = await _api.complete(data);
    final body = response.data as Map<String, dynamic>;
    return (body['data'] as Map<String, dynamic>?) ?? {};
  }
}

@Riverpod(keepAlive: true)
OnboardRepository onboardRepository(Ref ref) =>
    OnboardRepository(ref.watch(onboardApiProvider));
