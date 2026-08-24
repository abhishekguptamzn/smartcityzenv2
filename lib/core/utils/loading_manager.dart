import 'package:flutter/foundation.dart';

/// Centralized reference-counted loading state coordinator.
/// Ensures multiple concurrent background operations (e.g. image upload + token refresh)
/// do not prematurely dismiss a blocking loader until all operations have finished.
class LoadingManager extends ChangeNotifier {
  LoadingManager._();
  static final LoadingManager instance = LoadingManager._();

  int _activeOperations = 0;
  String? _currentMessage;

  bool get isLoading => _activeOperations > 0;
  String? get message => _currentMessage;

  /// Show a global blocking loader or increment active operation count.
  void show([String? message]) {
    _activeOperations++;
    if (message != null && message.isNotEmpty) {
      _currentMessage = message;
    }
    notifyListeners();
  }

  /// Hide or decrement active operation count.
  /// Overlay only dismisses when reference count reaches 0.
  void hide() {
    if (_activeOperations > 0) {
      _activeOperations--;
      if (_activeOperations == 0) {
        _currentMessage = null;
      }
      notifyListeners();
    }
  }

  /// Helper to wrap any async operation with safe increment/decrement.
  Future<T> wrap<T>(Future<T> Function() operation, [String? message]) async {
    show(message);
    try {
      return await operation();
    } finally {
      hide();
    }
  }

  /// Reset all loading counters in case of navigation reset or errors.
  void reset() {
    _activeOperations = 0;
    _currentMessage = null;
    notifyListeners();
  }
}
