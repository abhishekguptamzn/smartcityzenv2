import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinKeyboard extends StatelessWidget {
  const PinKeyboard({
    super.key,
    required this.onDigitTap,
    required this.onBackspace,
    this.onBiometricTap,
    this.showBiometricButton = false,
    this.disabled = false,
  });

  final ValueChanged<String> onDigitTap;
  final VoidCallback onBackspace;
  final VoidCallback? onBiometricTap;
  final bool showBiometricButton;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(context, ['1', '2', '3']),
        const SizedBox(height: 16),
        _buildRow(context, ['4', '5', '6']),
        const SizedBox(height: 16),
        _buildRow(context, ['7', '8', '9']),
        const SizedBox(height: 16),
        _buildBottomRow(context),
      ],
    );
  }

  Widget _buildRow(BuildContext context, List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((d) => _KeyButton(
        text: d,
        onTap: disabled ? null : () => onDigitTap(d),
      )).toList(),
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Biometric / Extra action on left
        if (showBiometricButton && onBiometricTap != null)
          _IconButton(
            icon: Icons.fingerprint_rounded,
            iconColor: const Color(0xFF0F766E),
            onTap: disabled ? null : onBiometricTap,
          )
        else
          const SizedBox(width: 72, height: 72),

        // '0' in middle
        _KeyButton(
          text: '0',
          onTap: disabled ? null : () => onDigitTap('0'),
        ),

        // Backspace on right
        _IconButton(
          icon: Icons.backspace_outlined,
          onTap: disabled ? null : onBackspace,
        ),
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap != null ? () {
          HapticFeedback.lightImpact();
          onTap!();
        } : null,
        borderRadius: BorderRadius.circular(36),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.8),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = iconColor ?? (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap != null ? () {
          HapticFeedback.lightImpact();
          onTap!();
        } : null,
        borderRadius: BorderRadius.circular(36),
        child: Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 28,
            color: color,
          ),
        ),
      ),
    );
  }
}
