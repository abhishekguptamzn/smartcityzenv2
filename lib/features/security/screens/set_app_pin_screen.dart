import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/local_auth_providers.dart';
import '../widgets/pin_dots_indicator.dart';
import '../widgets/pin_keyboard.dart';

class SetAppPinScreen extends ConsumerStatefulWidget {
  const SetAppPinScreen({
    super.key,
    this.isChanging = false,
  });

  final bool isChanging;

  @override
  ConsumerState<SetAppPinScreen> createState() => _SetAppPinScreenState();
}

class _SetAppPinScreenState extends ConsumerState<SetAppPinScreen> {
  static const int _pinLength = 4;

  String _firstPin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  bool _hasError = false;
  bool _isSuccess = false;
  String _errorMessage = '';

  void _onDigitTap(String digit) {
    if (_hasError) {
      setState(() {
        _hasError = false;
        _errorMessage = '';
      });
    }

    if (!_isConfirming) {
      if (_firstPin.length < _pinLength) {
        setState(() => _firstPin += digit);
        if (_firstPin.length == _pinLength) {
          // Transition to confirmation step
          Future.delayed(const Duration(milliseconds: 250), () {
            if (mounted) {
              setState(() => _isConfirming = true);
            }
          });
        }
      }
    } else {
      if (_confirmPin.length < _pinLength) {
        setState(() => _confirmPin += digit);
        if (_confirmPin.length == _pinLength) {
          _verifyAndSavePin();
        }
      }
    }
  }

  void _onBackspace() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      if (!_isConfirming) {
        if (_firstPin.isNotEmpty) {
          _firstPin = _firstPin.substring(0, _firstPin.length - 1);
        }
      } else {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        } else {
          // Go back to first step
          _isConfirming = false;
          _firstPin = '';
        }
      }
    });
  }

  Future<void> _verifyAndSavePin() async {
    if (_firstPin != _confirmPin) {
      HapticFeedback.heavyImpact();
      setState(() {
        _hasError = true;
        _errorMessage = 'PINs do not match. Please try again.';
        _confirmPin = '';
      });
      return;
    }

    setState(() => _isSuccess = true);
    HapticFeedback.mediumImpact();

    await ref.read(appLockControllerProvider.notifier).setAppPin(_firstPin);

    if (!mounted) return;

    final lockState = ref.read(appLockControllerProvider);
    if (lockState.biometricsAvailable) {
      await _askEnableBiometrics();
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.isChanging ? 'App PIN updated successfully!' : 'App PIN set up successfully!'),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (context.canPop()) {
      context.pop(true);
    } else {
      context.go('/home');
    }
  }

  Future<void> _askEnableBiometrics() async {
    final enable = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.fingerprint_rounded, color: Color(0xFF0F766E), size: 28),
            SizedBox(width: 10),
            Text('Enable Biometrics?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          ],
        ),
        content: const Text(
          'Would you like to use Face ID or Fingerprint for faster, seamless unlock on this device?',
          style: TextStyle(fontSize: 13.5, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('Maybe Later'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F766E)),
            child: const Text('Enable Biometrics'),
          ),
        ],
      ),
    );

    if (enable == true) {
      await ref.read(appLockControllerProvider.notifier).toggleBiometrics(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLength = _isConfirming ? _confirmPin.length : _firstPin.length;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (_isConfirming) {
              setState(() {
                _isConfirming = false;
                _firstPin = '';
                _confirmPin = '';
                _hasError = false;
                _errorMessage = '';
              });
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),

            // Header Icon & Title
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF0F766E).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFF0F766E),
                size: 32,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              _isConfirming ? 'Confirm Your PIN' : (widget.isChanging ? 'Enter New App PIN' : 'Create 4-Digit PIN'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _isConfirming
                  ? 'Re-enter your 4-digit PIN to confirm'
                  : 'This PIN is stored securely on your device only',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 28),

            // PIN Dots Indicator
            PinDotsIndicator(
              pinLength: _pinLength,
              enteredLength: currentLength,
              hasError: _hasError,
              isSuccess: _isSuccess,
            ),

            if (_errorMessage.isNotEmpty) ...[
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: PinKeyboard(
                onDigitTap: _onDigitTap,
                onBackspace: _onBackspace,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
