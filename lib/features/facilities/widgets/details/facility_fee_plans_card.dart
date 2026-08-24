import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FacilityFeePlansCard extends StatelessWidget {
  const FacilityFeePlansCard({
    super.key,
    required this.feePlans,
    required this.onSelectPlan,
    this.primaryColor = const Color(0xFF0F766E),
  });

  final List<Map<String, dynamic>> feePlans;
  final ValueChanged<Map<String, dynamic>> onSelectPlan;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    if (feePlans.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.grey, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Contact provider desk for custom membership rates and seasonal passes.',
                style: TextStyle(fontSize: 12.5, color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: feePlans.map((plan) {
        final name = plan['name']?.toString() ?? 'Standard Membership';
        final amount = plan['amount']?.toString() ?? '0';
        final interval = plan['interval']?.toString() ?? 'monthly';
        final desc = plan['description']?.toString();

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.card_membership_rounded,
                  color: primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (desc != null && desc.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        desc,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹$amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    '/$interval',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                color: primaryColor,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onSelectPlan(plan);
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
