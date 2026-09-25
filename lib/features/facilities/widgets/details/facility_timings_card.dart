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

  static const _dayKeys = [
    'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday',
  ];

  static const _dayLabels = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  String _formatTime(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '—';
    try {
      final parts = raw.trim().split(':');
      if (parts.length >= 2) {
        final h = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        final period = h >= 12 ? 'PM' : 'AM';
        final hour = h % 12 == 0 ? 12 : h % 12;
        return '$hour:${m.toString().padLeft(2, '0')} $period';
      }
    } catch (_) {}
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final opHours = facility.operatingHoursMap;
    final fallbackOpen = facility.openingTimeShort ?? facility.openingTime ?? '07:00';
    final fallbackClose = facility.closingTimeShort ?? facility.closingTime ?? '20:00';
    final headerOpen = _formatTime(fallbackOpen);
    final headerClose = _formatTime(fallbackClose);
    final currentDayIndex = DateTime.now().weekday - 1;

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
                  isOpen
                      ? 'Open Now ($headerOpen – $headerClose)'
                      : 'Closed Now (Opens at $headerOpen)',
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
          ...List.generate(_dayKeys.length, (i) {
            final key = _dayKeys[i];
            final label = _dayLabels[i];
            final isToday = i == currentDayIndex;

            String dayTimeLabel;
            bool isClosed = false;

            if (opHours != null && opHours[key] is Map) {
              final dayMap = (opHours[key] as Map).cast<String, dynamic>();
              isClosed = dayMap['is_closed'] == true ||
                  dayMap['closed'] == true ||
                  dayMap['is_off'] == true;
              if (!isClosed) {
                final open = _formatTime(
                  dayMap['open']?.toString() ??
                      dayMap['opening_time']?.toString() ??
                      dayMap['start']?.toString(),
                );
                final close = _formatTime(
                  dayMap['close']?.toString() ??
                      dayMap['closing_time']?.toString() ??
                      dayMap['end']?.toString(),
                );
                dayTimeLabel = '$open – $close';
              } else {
                dayTimeLabel = 'Closed';
              }
            } else {
              dayTimeLabel = '$headerOpen – $headerClose';
            }

            final labelColor = isToday
                ? const Color(0xFF0F766E)
                : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569));
            final timeColor = isClosed
                ? const Color(0xFFDC2626)
                : (isToday
                    ? const Color(0xFF0F766E)
                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)));

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
                        label,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                          color: labelColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    dayTimeLabel,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                      color: timeColor,
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
