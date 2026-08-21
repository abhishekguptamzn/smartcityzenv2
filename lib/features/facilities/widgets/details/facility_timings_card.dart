import 'package:flutter/material.dart';

import '../../../../data/models/facility_model.dart';

class FacilityTimingsCard extends StatelessWidget {
  const FacilityTimingsCard({
    super.key,
    required this.facility,
    required this.isOpen,
  });

  final FacilityModel facility;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final openTime = facility.openingTimeShort ?? facility.openingTime ?? '06:00';
    final closeTime = facility.closingTimeShort ?? facility.closingTime ?? '22:00';
    final timeRange = '$openTime - $closeTime';

    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final currentDayIndex = DateTime.now().weekday - 1; // 0 for Monday

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_filled_rounded,
                size: 20,
                color: isOpen ? const Color(0xFF059669) : const Color(0xFFDC2626),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isOpen ? 'Open Now ($timeRange)' : 'Closed Now (Opens at $openTime)',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: isOpen ? const Color(0xFF059669) : const Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...List.generate(days.length, (i) {
            final isToday = i == currentDayIndex;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (isToday)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0F766E),
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        days[i],
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                          color: isToday
                              ? const Color(0xFF0F766E)
                              : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    timeRange,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                      color: isToday
                          ? const Color(0xFF0F766E)
                          : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
