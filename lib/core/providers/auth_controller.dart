import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/api/app_exception.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<UserModel?> build() async {
    final repo = ref.watch(authRepositoryProvider);
    try {
      return await repo.me().timeout(const Duration(seconds: 10));
    } catch (e) {
      final appEx = AppException.from(e);
      if (appEx != null &&
          (appEx.code == AppExceptionCode.authentication ||
              appEx.code == AppExceptionCode.authorization)) {
        return null;
      }
      // Re-throw server/network errors so state hasError is true
      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(
      () => repo.login(email: email, password: password),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    String? phone,
    required String cityId,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(
      () => repo.register(
        name: name,
        email: email,
        phone: phone,
        cityId: cityId,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  }

  Future<void> oauthLogin(
    String provider, {
    String? accessToken,
    String? idToken,
    String? email,
    String? name,
    String? avatar,
    String? providerId,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(
      () => repo.oauthLogin(
        provider: provider,
        accessToken: accessToken,
        idToken: idToken,
        email: email,
        name: name,
        avatar: avatar,
        providerId: providerId,
      ),
    );
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AsyncData(null);
  }

  Future<void> logoutAll() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logoutAll();
    state = const AsyncData(null);
  }

  Future<void> refreshMe() async {
    final repo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() => repo.me());
  }
}
