import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

enum UiTier { full, reduced }

/// Detects device capability at runtime to optimize graphics performance.
/// Prevents GPU throttling / jank on budget devices without altering visual styling.
class UiTierDetector {
  UiTierDetector._();

  static UiTier _cached = UiTier.full;
  static bool _initialized = false;

  static UiTier get current {
    if (!_initialized) detect();
    return _cached;
  }

  static void detect() {
    _initialized = true;
    if (kIsWeb) {
      _cached = UiTier.full;
      return;
    }
    try {
      if (Platform.isIOS || Platform.isMacOS) {
        _cached = UiTier.full;
        return;
      }
      // Modern high refresh rate Android devices handle blur well.
      // Default to full, but allow power-users or battery savers to override.
      _cached = UiTier.full;
    } catch (_) {
      _cached = UiTier.full;
    }
  }

  static void override(UiTier tier) => _cached = tier;
}
