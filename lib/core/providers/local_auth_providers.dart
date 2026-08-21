import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/api/app_config_api.dart';
import '../services/local_auth_service.dart';

part 'local_auth_providers.g.dart';

class AppLockState {
  const AppLockState({
    this.isLocked = false,
    this.isConfigured = false,
    this.biometricsAvailable = false,
    this.isBiometricsEnabled = true,
    this.isLockEnabled = false,
    this.isMandatory = false,
    this.failedAttempts = 0,
    this.cooldownSeconds = 0,
    this.isCheckingBiometrics = false,
  });

  final bool isLocked;
  final bool isConfigured;
  final bool biometricsAvailable;
  final bool isBiometricsEnabled;
  final bool isLockEnabled;
  final bool isMandatory;
  final int failedAttempts;
  final int cooldownSeconds;
  final bool isCheckingBiometrics;

  bool get shouldEnforceLock => isLockEnabled || isMandatory;

  AppLockState copyWith({
    bool? isLocked,
    bool? isConfigured,
    bool? biometricsAvailable,
    bool? isBiometricsEnabled,
    bool? isLockEnabled,
    bool? isMandatory,
    int? failedAttempts,
    int? cooldownSeconds,
    bool? isCheckingBiometrics,
  }) {
    return AppLockState(
      isLocked: isLocked ?? this.isLocked,
      isConfigured: isConfigured ?? this.isConfigured,
      biometricsAvailable: biometricsAvailable ?? this.biometricsAvailable,
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
      isLockEnabled: isLockEnabled ?? this.isLockEnabled,
      isMandatory: isMandatory ?? this.isMandatory,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
      isCheckingBiometrics: isCheckingBiometrics ?? this.isCheckingBiometrics,
    );
  }
}

@Riverpod(keepAlive: true)
class AppLockController extends _$AppLockController with WidgetsBindingObserver {
  DateTime? _pausedAt;
  Timer? _cooldownTimer;

  @override
  AppLockState build() {
    if (kIsWeb) {
      return const AppLockState();
    }

    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _cooldownTimer?.cancel();
    });

    // Asynchronously initialize status
    Future.microtask(_init);

    return const AppLockState();
  }

  Future<void> _init() async {
    if (kIsWeb) return;

    final localAuth = ref.read(localAuthServiceProvider);
    final config = await ref.read(appConfigProvider.future).catchError((_) => const AppConfigModel());

    final bioAvailable = await localAuth.isBiometricsSupported();
    final hasPin = await localAuth.hasConfiguredPin();
    final userEnabled = await localAuth.isAppLockEnabled();
    final bioEnabled = await localAuth.isBiometricsEnabled();

    final isMandatory = config.mobileSecurity.lockMandatory;
    final isAllowed = config.mobileSecurity.lockEnabled;

    final shouldLock = isAllowed && (isMandatory || userEnabled);

    state = state.copyWith(
      isLocked: shouldLock && hasPin,
      isConfigured: hasPin,
      biometricsAvailable: bioAvailable && config.mobileSecurity.biometricAllowed,
      isBiometricsEnabled: bioEnabled,
      isLockEnabled: userEnabled,
      isMandatory: isMandatory,
    );

    // If locked and biometrics is active, trigger biometric prompt on boot
    if (state.isLocked && state.biometricsAvailable && state.isBiometricsEnabled) {
      authenticateWithBiometrics();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pausedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      _handleAppResumed();
    }
  }

  Future<void> _handleAppResumed() async {
    if (!state.shouldEnforceLock || !state.isConfigured) return;

    final localAuth = ref.read(localAuthServiceProvider);
    final delaySeconds = await localAuth.getAutoLockDelaySeconds();

    if (_pausedAt != null) {
      final elapsed = DateTime.now().difference(_pausedAt!).inSeconds;
      _pausedAt = null;
      if (elapsed >= delaySeconds) {
        lock();
      }
    }
  }

  void lock() {
    if (!state.shouldEnforceLock || !state.isConfigured) return;
    state = state.copyWith(isLocked: true);
    if (state.biometricsAvailable && state.isBiometricsEnabled) {
      authenticateWithBiometrics();
    }
  }

  void unlock() {
    _cooldownTimer?.cancel();
    state = state.copyWith(
      isLocked: false,
      failedAttempts: 0,
      cooldownSeconds: 0,
      isCheckingBiometrics: false,
    );
  }

  Future<bool> authenticateWithBiometrics() async {
    if (state.isCheckingBiometrics || state.cooldownSeconds > 0) return false;
    state = state.copyWith(isCheckingBiometrics: true);

    try {
      final localAuth = ref.read(localAuthServiceProvider);
      final success = await localAuth.authenticateWithBiometrics();
      if (success) {
        unlock();
        return true;
      }
      return false;
    } finally {
      state = state.copyWith(isCheckingBiometrics: false);
    }
  }

  Future<bool> verifyPin(String pin) async {
    if (state.cooldownSeconds > 0) return false;

    final localAuth = ref.read(localAuthServiceProvider);
    final isValid = await localAuth.verifyAppPin(pin);

    if (isValid) {
      unlock();
      return true;
    }

    final newAttempts = state.failedAttempts + 1;
    if (newAttempts >= 5) {
      _startCooldown(30);
    } else {
      state = state.copyWith(failedAttempts: newAttempts);
    }

    return false;
  }

  void _startCooldown(int seconds) {
    _cooldownTimer?.cancel();
    state = state.copyWith(cooldownSeconds: seconds, failedAttempts: 5);

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = state.cooldownSeconds;
      if (current <= 1) {
        timer.cancel();
        state = state.copyWith(cooldownSeconds: 0, failedAttempts: 0);
      } else {
        state = state.copyWith(cooldownSeconds: current - 1);
      }
    });
  }

  Future<void> setAppPin(String pin) async {
    final localAuth = ref.read(localAuthServiceProvider);
    await localAuth.setAppPin(pin);
    state = state.copyWith(isConfigured: true, isLockEnabled: true);
  }

  Future<void> toggleAppLock(bool enabled) async {
    final localAuth = ref.read(localAuthServiceProvider);
    await localAuth.setAppLockEnabled(enabled);
    state = state.copyWith(isLockEnabled: enabled);
  }

  Future<void> toggleBiometrics(bool enabled) async {
    final localAuth = ref.read(localAuthServiceProvider);
    await localAuth.setBiometricsEnabled(enabled);
    state = state.copyWith(isBiometricsEnabled: enabled);
  }

  Future<void> removePin() async {
    final localAuth = ref.read(localAuthServiceProvider);
    await localAuth.removeAppPin();
    state = state.copyWith(isConfigured: false, isLockEnabled: false, isLocked: false);
  }
}
