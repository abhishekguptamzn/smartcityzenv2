import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FacilityQuickActionsRow extends StatelessWidget {
  const FacilityQuickActionsRow({
    super.key,
    required this.onCall,
    required this.onDirections,
    required this.onShare,
    required this.onSendEnquiry,
    this.phone,
  });

  final VoidCallback? onCall;
  final VoidCallback onDirections;
  final VoidCallback onShare;
  final VoidCallback onSendEnquiry;
  final String? phone;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ActionButton(
            icon: Icons.phone_rounded,
            label: 'Call',
            color: const Color(0xFF059669),
            onTap: onCall,
            enabled: phone != null && phone!.isNotEmpty,
          ),
          _ActionButton(
            icon: Icons.directions_rounded,
            label: 'Directions',
            color: const Color(0xFF0284C7),
            onTap: onDirections,
          ),
          _ActionButton(
            icon: Icons.contact_mail_outlined,
            label: 'Enquire',
            color: const Color(0xFFD97706),
            onTap: onSendEnquiry,
          ),
          _ActionButton(
            icon: Icons.share_rounded,
            label: 'Share',
            color: const Color(0xFF7C3AED),
            onTap: onShare,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = enabled ? color : (isDark ? Colors.grey.shade700 : Colors.grey.shade400);

    return InkWell(
      onTap: enabled ? () {
        HapticFeedback.lightImpact();
        onTap?.call();
      } : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: effectiveColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: effectiveColor, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: enabled
                    ? (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155))
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
