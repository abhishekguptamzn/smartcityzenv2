import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/auth_api.dart';
import '../api/token_storage.dart';
import '../models/login_history_model.dart';
import '../models/pagination_meta.dart';
import '../models/user_model.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._api, this._tokenStorage);

  final AuthApi _api;
  final TokenStorage _tokenStorage;

  Future<UserModel> register({
    required String name,
    required String email,
    String? phone,
    required String cityId,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.register(
      name: name,
      email: email,
      phone: phone,
      cityId: cityId,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    return _persistAndExtractUser(response.data);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.login(email: email, password: password);
    return _persistAndExtractUser(response.data);
  }

  Future<UserModel> oauthLogin({
    required String provider,
    String? accessToken,
    String? idToken,
    String? email,
    String? name,
    String? avatar,
    String? providerId,
  }) async {
    final response = await _api.oauthLogin(
      provider: provider,
      accessToken: accessToken,
      idToken: idToken,
      email: email,
      name: name,
      avatar: avatar,
      providerId: providerId,
    );
    return _persistAndExtractUser(response.data);
  }

  Future<UserModel> _persistAndExtractUser(dynamic responseData) async {
    final data =
        (responseData as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    final token = data['token'] as String;
    await _tokenStorage.saveToken(token);
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<String> forgotPassword({required String email}) async {
    final response = await _api.forgotPassword(email: email);
    final data =
        (response.data as Map<String, dynamic>)['data']
            as Map<String, dynamic>?;
    return data?['reset_token'] as String? ?? '';
  }

  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) {
    return _api.resetPassword(
      email: email,
      token: token,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  Future<void> logout() async {
    try {
      await _api.logout();
    } finally {
      await _tokenStorage.clearToken();
    }
  }

  Future<void> logoutAll() async {
    try {
      await _api.logoutAll();
    } finally {
      await _tokenStorage.clearToken();
    }
  }

  Future<UserModel?> me() async {
    final token = await _tokenStorage.readToken();
    if (token == null || token.isEmpty) return null;
    try {
      final response = await _api.me();
      final data =
          (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return UserModel.fromJson(data['user'] as Map<String, dynamic>? ?? data);
    } catch (e) {
      // If token is invalid / unauthorized / expired, clear it and return null
      await _tokenStorage.clearToken();
      return null;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) {
    return _api.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );
  }

  Future<Paginated<LoginHistoryModel>> loginHistory({
    int perPage = 15,
    int page = 1,
    String? status,
    bool? isSuspicious,
  }) async {
    final response = await _api.loginHistory(
      perPage: perPage,
      page: page,
      status: status,
      isSuspicious: isSuspicious,
    );
    return Paginated.fromEnvelope(
      response.data as Map<String, dynamic>,
      LoginHistoryModel.fromJson,
    );
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    ref.watch(authApiProvider),
    ref.watch(tokenStorageProvider),
  );
}
