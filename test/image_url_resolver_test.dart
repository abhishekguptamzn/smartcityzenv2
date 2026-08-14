import 'package:flutter_test/flutter_test.dart';
import 'package:smartcityzenv2/core/utils/image_url_resolver.dart';

void main() {
  group('ImageUrlResolver', () {
    test('resolves null and empty strings to null', () {
      expect(ImageUrlResolver.resolve(null), isNull);
      expect(ImageUrlResolver.resolve(''), isNull);
      expect(ImageUrlResolver.resolve('   '), isNull);
    });

    test('resolves relative storage paths using baseApiUrl', () {
      final resolved = ImageUrlResolver.resolve(
        '/storage/media/libraries/LIB001.jpg',
        baseApiUrl: 'http://192.168.1.50:8000/api/v1',
      );
      expect(
        resolved,
        equals('http://192.168.1.50:8000/storage/media/libraries/LIB001.jpg'),
      );
    });

    test('resolves relative paths without leading slash', () {
      final resolved = ImageUrlResolver.resolve(
        'storage/media/gyms/GYM001.jpg',
        baseApiUrl: 'http://192.168.1.50:8000/api/v1',
      );
      expect(
        resolved,
        equals('http://192.168.1.50:8000/storage/media/gyms/GYM001.jpg'),
      );
    });

    test('rewrites localhost host to target baseApiUrl host and port', () {
      final resolved = ImageUrlResolver.resolve(
        'http://localhost:8000/storage/media/avatars/USR001.jpg',
        baseApiUrl: 'http://192.168.1.100:8000/api/v1',
      );
      expect(
        resolved,
        equals('http://192.168.1.100:8000/storage/media/avatars/USR001.jpg'),
      );
    });

    test('retains external remote https URLs', () {
      const externalUrl = 'https://images.unsplash.com/photo-123456';
      final resolved = ImageUrlResolver.resolve(
        externalUrl,
        baseApiUrl: 'https://smartct.online/api/v1',
      );
      expect(resolved, equals(externalUrl));
    });
  });
}
