import 'package:flutter_test/flutter_test.dart';
import 'package:smartcityzenv2/core/utils/duration_formatter.dart';

void main() {
  group('Duration Formatter Tests', () {
    test('formats minutes correctly', () {
      expect(formatMinutes(null), '--');
      expect(formatMinutes(0), '0m');
      expect(formatMinutes(-5), '0m');
      expect(formatMinutes(45), '45m');
      expect(formatMinutes(60), '1h');
      expect(formatMinutes(63), '1h3m');
      expect(formatMinutes(75), '1h15m');
      expect(formatMinutes(87), '1h27m');
      expect(formatMinutes(95), '1h35m');
      expect(formatMinutes(100), '1h40m');
      expect(formatMinutes(106), '1h46m');
      expect(formatMinutes(120), '2h');
      expect(formatMinutes(125), '2h5m');
    });

    test('formats spaced minutes when requested', () {
      expect(formatMinutes(100, spaced: true), '1h 40m');
      expect(formatMinutes(60, spaced: true), '1h');
      expect(formatMinutes(45, spaced: true), '45m');
    });

    test('formats seconds correctly', () {
      expect(formatSeconds(null), null);
      expect(formatSeconds(0), null);
      expect(formatSeconds(2700), '45m');
      expect(formatSeconds(3600), '1h');
      expect(formatSeconds(6000), '1h40m');
    });
  });
}
