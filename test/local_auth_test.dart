import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartcityzenv2/core/services/local_auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalAuthService PIN & Salt Tests', () {
    late LocalAuthService authService;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      authService = LocalAuthService();
    });

    test('setting PIN hashes with salt and stores locally', () async {
      final success = await authService.setAppPin('1234');
      expect(success, isTrue);

      final hasPin = await authService.hasConfiguredPin();
      expect(hasPin, isTrue);

      final isLocked = await authService.isAppLockEnabled();
      expect(isLocked, isTrue);
    });

    test('verifying correct PIN returns true and wrong PIN returns false', () async {
      await authService.setAppPin('5678');

      final verifyCorrect = await authService.verifyAppPin('5678');
      expect(verifyCorrect, isTrue);

      final verifyWrong = await authService.verifyAppPin('0000');
      expect(verifyWrong, isFalse);
    });

    test('short PIN rejected', () async {
      final res = await authService.setAppPin('12');
      expect(res, isFalse);
    });

    test('removing PIN clears local credentials', () async {
      await authService.setAppPin('9999');
      expect(await authService.hasConfiguredPin(), isTrue);

      await authService.removeAppPin();
      expect(await authService.hasConfiguredPin(), isFalse);
      expect(await authService.isAppLockEnabled(), isFalse);
    });
  });
}
