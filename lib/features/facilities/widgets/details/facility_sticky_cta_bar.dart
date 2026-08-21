import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../data/models/facility_model.dart';

class FacilityStickyCtaBar extends StatelessWidget {
  const FacilityStickyCtaBar({
    super.key,
    required this.facility,
    required this.onSendEnquiry,
    this.onPrimaryAction,
    this.primaryActionLabel,
    this.primaryActionIcon,
  });

  final FacilityModel facility;
  final VoidCallback onSendEnquiry;
  final VoidCallback? onPrimaryAction;
  final String? primaryActionLabel;
  final IconData? primaryActionIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isGym = facility.kind == FacilityKind.gym;

    final defaultPrimaryLabel = isGym ? 'Quick QR Check-in' : 'Join / Enroll';
    final defaultPrimaryIcon = isGym ? Icons.qr_code_scanner_rounded : Icons.how_to_reg_rounded;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onSendEnquiry();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  side: const BorderSide(color: Color(0xFF0F766E), width: 1.5),
                  foregroundColor: const Color(0xFF0F766E),
                ),
                icon: const Icon(Icons.contact_mail_outlined, size: 18),
                label: const Text(
                  'Enquire',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (onPrimaryAction != null) ...[
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onPrimaryAction!();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: Icon(primaryActionIcon ?? defaultPrimaryIcon, size: 18),
                  label: Text(
                    primaryActionLabel ?? defaultPrimaryLabel,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
