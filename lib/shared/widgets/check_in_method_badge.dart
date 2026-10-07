import 'package:flutter/material.dart';

class CheckInMethodBadge extends StatelessWidget {
  const CheckInMethodBadge({
    super.key,
    required this.method,
    this.compact = false,
  });

  final String method;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final norm = method.toLowerCase().trim();
    final IconData icon;
    final String label;
    final Color color;
    final Color bgColor;

    if (norm == 'qr' || norm == 'qr_code' || norm == 'qr_scan') {
      icon = Icons.qr_code_2_rounded;
      label = 'QR Code';
      color = const Color(0xFF0284C7);
      bgColor = const Color(0xFF0284C7).withValues(alpha: 0.12);
    } else if (norm == 'ble' || norm == 'ble_proximity' || norm == 'ble_beacon' || norm == 'ble_radio') {
      icon = Icons.bluetooth_connected_rounded;
      label = 'BLE';
      color = const Color(0xFF7C3AED);
      bgColor = const Color(0xFF7C3AED).withValues(alpha: 0.12);
    } else if (norm == 'nfc') {
      icon = Icons.nfc_rounded;
      label = 'NFC';
      color = const Color(0xFFD97706);
      bgColor = const Color(0xFFD97706).withValues(alpha: 0.12);
    } else if (norm == 'batch_roster') {
      icon = Icons.groups_rounded;
      label = 'Batch';
      color = const Color(0xFF4F46E5);
      bgColor = const Color(0xFF4F46E5).withValues(alpha: 0.12);
    } else {
      icon = Icons.desk_rounded;
      label = 'Manual';
      color = const Color(0xFF059669);
      bgColor = const Color(0xFF059669).withValues(alpha: 0.12);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 7,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 10 : 12, color: color),
          const SizedBox(width: 3.5),
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 9.5 : 10.5,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
