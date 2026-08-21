import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../core/providers/local_auth_providers.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../widgets/pin_dots_indicator.dart';
import '../widgets/pin_keyboard.dart';

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  static const int _pinLength = 4;
  String _enteredPin = '';
  bool _hasError = false;
  bool _isSuccess = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Auto-prompt biometrics if ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lockState = ref.read(appLockControllerProvider);
      if (lockState.biometricsAvailable && lockState.isBiometricsEnabled) {
        ref.read(appLockControllerProvider.notifier).authenticateWithBiometrics();
      }
    });
  }

  void _onDigitTap(String digit) {
    final lockState = ref.read(appLockControllerProvider);
    if (lockState.cooldownSeconds > 0) return;

    if (_hasError) {
      setState(() {
        _hasError = false;
        _errorMessage = '';
      });
    }

    if (_enteredPin.length < _pinLength) {
      setState(() => _enteredPin += digit);
      if (_enteredPin.length == _pinLength) {
        _submitPin();
      }
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _hasError = false;
        _errorMessage = '';
      });
    }
  }

  Future<void> _submitPin() async {
    final success = await ref.read(appLockControllerProvider.notifier).verifyPin(_enteredPin);

    if (success) {
      HapticFeedback.mediumImpact();
      setState(() => _isSuccess = true);
    } else {
      HapticFeedback.heavyImpact();
      final state = ref.read(appLockControllerProvider);
      setState(() {
        _hasError = true;
        _enteredPin = '';
        if (state.cooldownSeconds > 0) {
          _errorMessage = 'Too many attempts. Locked for ${state.cooldownSeconds}s';
        } else {
          final remaining = 5 - state.failedAttempts;
          _errorMessage = 'Incorrect PIN. $remaining ${remaining == 1 ? 'attempt' : 'attempts'} left.';
        }
      });
    }
  }

  Future<void> _onForgotPin() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFE11D48), size: 28),
            SizedBox(width: 10),
            Text('Forgot App PIN?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          ],
        ),
        content: const Text(
          'For your security, resetting your local PIN requires logging out and signing in again with your account password.',
          style: TextStyle(fontSize: 13.5, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE11D48)),
            child: const Text('Log Out & Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(appLockControllerProvider.notifier).removePin();
      await ref.read(authControllerProvider.notifier).logout();
      if (!mounted) return;
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authControllerProvider).value;
    final lockState = ref.watch(appLockControllerProvider);

    final showBio = lockState.biometricsAvailable && lockState.isBiometricsEnabled;
    final inCooldown = lockState.cooldownSeconds > 0;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),

              // User Avatar & Security Shield
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  UserAvatar(
                    photoUrl: user?.photoUrl,
                    radius: 40,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F766E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                user != null ? 'Welcome back, ${user.name.split(' ').first}' : 'Smart CityZen Shield',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                inCooldown
                    ? 'Account temporarily locked'
                    : 'Enter your 4-digit PIN to unlock',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: inCooldown ? FontWeight.w700 : FontWeight.w500,
                  color: inCooldown
                      ? const Color(0xFFE11D48)
                      : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
              ),
              const SizedBox(height: 26),

              // PIN Dots
              PinDotsIndicator(
                pinLength: _pinLength,
                enteredLength: _enteredPin.length,
                hasError: _hasError || inCooldown,
                isSuccess: _isSuccess,
              ),

              if (inCooldown) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE11D48).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Try again in ${lockState.cooldownSeconds}s',
                    style: const TextStyle(
                      color: Color(0xFFE11D48),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ] else if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: Color(0xFFE11D48),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],

              const Spacer(flex: 2),

              // Keypad
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: PinKeyboard(
                  onDigitTap: _onDigitTap,
                  onBackspace: _onBackspace,
                  showBiometricButton: showBio,
                  onBiometricTap: showBio
                      ? () => ref.read(appLockControllerProvider.notifier).authenticateWithBiometrics()
                      : null,
                  disabled: inCooldown,
                ),
              ),

              // Forgot PIN / Switch Account
              TextButton(
                onPressed: _onForgotPin,
                style: TextButton.styleFrom(
                  foregroundColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
                child: const Text(
                  'Forgot PIN? Log Out',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
