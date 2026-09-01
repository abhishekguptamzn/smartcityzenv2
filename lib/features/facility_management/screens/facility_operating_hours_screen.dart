import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import 'facility_dashboard_screen.dart';
import 'facility_settings_screen.dart';

class DayScheduleConfig {
  final String key;
  final String label;
  final String shortLabel;
  bool isClosed;
  TimeOfDay openTime;
  TimeOfDay closeTime;

  DayScheduleConfig({
    required this.key,
    required this.label,
    required this.shortLabel,
    this.isClosed = false,
    required this.openTime,
    required this.closeTime,
  });

  DayScheduleConfig copyWith({
    bool? isClosed,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
  }) {
    return DayScheduleConfig(
      key: key,
      label: label,
      shortLabel: shortLabel,
      isClosed: isClosed ?? this.isClosed,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_closed': isClosed,
      'open': _formatTimeOfDay24(openTime),
      'close': _formatTimeOfDay24(closeTime),
    };
  }

  static String _formatTimeOfDay24(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static TimeOfDay _parseTime24(dynamic raw, TimeOfDay fallback) {
    if (raw == null || raw is! String) return fallback;
    try {
      final parts = raw.trim().split(':');
      if (parts.length >= 2) {
        return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    } catch (_) {}
    return fallback;
  }

  factory DayScheduleConfig.fromMap(
    String key,
    String label,
    String shortLabel,
    Map<String, dynamic>? data, {
    required TimeOfDay defaultOpen,
    required TimeOfDay defaultClose,
    bool defaultClosed = false,
  }) {
    if (data == null) {
      return DayScheduleConfig(
        key: key,
        label: label,
        shortLabel: shortLabel,
        isClosed: defaultClosed,
        openTime: defaultOpen,
        closeTime: defaultClose,
      );
    }

    final isClosed = data['is_closed'] == true || data['closed'] == true || data['is_off'] == true;
    final openTime = _parseTime24(data['open'] ?? data['opening_time'] ?? data['start'], defaultOpen);
    final closeTime = _parseTime24(data['close'] ?? data['closing_time'] ?? data['end'], defaultClose);

    return DayScheduleConfig(
      key: key,
      label: label,
      shortLabel: shortLabel,
      isClosed: isClosed,
      openTime: openTime,
      closeTime: closeTime,
    );
  }
}

class FacilityOperatingHoursScreen extends ConsumerStatefulWidget {
  const FacilityOperatingHoursScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilityOperatingHoursScreen> createState() =>
      _FacilityOperatingHoursScreenState();
}

class _FacilityOperatingHoursScreenState
    extends ConsumerState<FacilityOperatingHoursScreen> {
  bool _saving = false;
  late List<DayScheduleConfig> _days;

  @override
  void initState() {
    super.initState();
    _initSchedule(widget.facility);
  }

  void _initSchedule(FacilityModel? fac) {
    final defaultOpen = _parseTimeOfDay(fac?.openingTime) ?? const TimeOfDay(hour: 7, minute: 0);
    final defaultClose = _parseTimeOfDay(fac?.closingTime) ?? const TimeOfDay(hour: 20, minute: 0);

    final opHours = fac?.operatingHoursMap;

    _days = [
      DayScheduleConfig.fromMap(
        'monday',
        'Monday',
        'Mon',
        opHours?['monday'] is Map ? (opHours!['monday'] as Map).cast<String, dynamic>() : null,
        defaultOpen: defaultOpen,
        defaultClose: defaultClose,
      ),
      DayScheduleConfig.fromMap(
        'tuesday',
        'Tuesday',
        'Tue',
        opHours?['tuesday'] is Map ? (opHours!['tuesday'] as Map).cast<String, dynamic>() : null,
        defaultOpen: defaultOpen,
        defaultClose: defaultClose,
      ),
      DayScheduleConfig.fromMap(
        'wednesday',
        'Wednesday',
        'Wed',
        opHours?['wednesday'] is Map ? (opHours!['wednesday'] as Map).cast<String, dynamic>() : null,
        defaultOpen: defaultOpen,
        defaultClose: defaultClose,
      ),
      DayScheduleConfig.fromMap(
        'thursday',
        'Thursday',
        'Thu',
        opHours?['thursday'] is Map ? (opHours!['thursday'] as Map).cast<String, dynamic>() : null,
        defaultOpen: defaultOpen,
        defaultClose: defaultClose,
      ),
      DayScheduleConfig.fromMap(
        'friday',
        'Friday',
        'Fri',
        opHours?['friday'] is Map ? (opHours!['friday'] as Map).cast<String, dynamic>() : null,
        defaultOpen: defaultOpen,
        defaultClose: defaultClose,
      ),
      DayScheduleConfig.fromMap(
        'saturday',
        'Saturday',
        'Sat',
        opHours?['saturday'] is Map ? (opHours!['saturday'] as Map).cast<String, dynamic>() : null,
        defaultOpen: defaultOpen,
        defaultClose: defaultClose,
      ),
      DayScheduleConfig.fromMap(
        'sunday',
        'Sunday',
        'Sun',
        opHours?['sunday'] is Map ? (opHours!['sunday'] as Map).cast<String, dynamic>() : null,
        defaultOpen: defaultOpen,
        defaultClose: defaultClose,
        defaultClosed: opHours?['sunday'] == null ? false : false,
      ),
    ];
  }

  TimeOfDay? _parseTimeOfDay(String? timeStr) {
    if (timeStr == null || timeStr.trim().isEmpty) return null;
    try {
      final parts = timeStr.trim().split(':');
      if (parts.length >= 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (_) {}
    return null;
  }

  String _formatTimeDisplay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  double _calculateHours(TimeOfDay open, TimeOfDay close) {
    final startMinutes = open.hour * 60 + open.minute;
    var endMinutes = close.hour * 60 + close.minute;
    if (endMinutes <= startMinutes) {
      endMinutes += 24 * 60; // Crosses midnight
    }
    return (endMinutes - startMinutes) / 60.0;
  }

  void _applyMondayToAllWeekdays() {
    HapticFeedback.lightImpact();
    final mon = _days[0];
    setState(() {
      for (int i = 1; i < 5; i++) {
        _days[i].isClosed = mon.isClosed;
        _days[i].openTime = mon.openTime;
        _days[i].closeTime = mon.closeTime;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied Monday timing to Tue – Fri!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _applyToAllDays(DayScheduleConfig source) {
    HapticFeedback.lightImpact();
    setState(() {
      for (final d in _days) {
        d.isClosed = source.isClosed;
        d.openTime = source.openTime;
        d.closeTime = source.closeTime;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied ${source.label} timing to all 7 days!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, int dayIndex, bool isStart) async {
    final day = _days[dayIndex];
    final initial = isStart ? day.openTime : day.closeTime;

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: isStart ? 'Select Opening Time for ${day.label}' : 'Select Closing Time for ${day.label}',
    );

    if (picked != null) {
      HapticFeedback.selectionClick();
      setState(() {
        if (isStart) {
          _days[dayIndex].openTime = picked;
        } else {
          _days[dayIndex].closeTime = picked;
        }
      });
    }
  }

  Future<void> _saveOperatingHours() async {
    if (_saving) return;
    setState(() => _saving = true);
    HapticFeedback.mediumImpact();

    try {
      final operatingHoursMap = <String, dynamic>{};
      for (final day in _days) {
        operatingHoursMap[day.key] = day.toJson();
      }

      // Determine general opening and closing time (first open day or Monday)
      final firstOpenDay = _days.firstWhere((d) => !d.isClosed, orElse: () => _days[0]);
      final primaryOpen24 = '${firstOpenDay.openTime.hour.toString().padLeft(2, '0')}:${firstOpenDay.openTime.minute.toString().padLeft(2, '0')}';
      final primaryClose24 = '${firstOpenDay.closeTime.hour.toString().padLeft(2, '0')}:${firstOpenDay.closeTime.minute.toString().padLeft(2, '0')}';

      final payload = {
        'opening_time': primaryOpen24,
        'closing_time': primaryClose24,
        'metadata': {
          'operating_hours': operatingHoursMap,
        },
      };

      await ref.read(clientFacilityRepositoryProvider).updateFacilityDetails(
            widget.kind,
            widget.facilityId,
            payload,
          );

      // Invalidate relevant providers to refresh throughout app
      ref.invalidate(facilityDetailSettingsProvider((widget.kind, widget.facilityId)));
      ref.invalidate(myOwnedFacilitiesProvider);
      ref.invalidate(facilityStatsProvider((widget.kind, widget.facilityId)));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Operating hours updated successfully!'),
          backgroundColor: Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save operating hours: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final openDaysCount = _days.where((d) => !d.isClosed).length;
    final totalWeeklyHours = _days
        .where((d) => !d.isClosed)
        .fold<double>(0.0, (sum, d) => sum + _calculateHours(d.openTime, d.closeTime));

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text(
          'Operating Hours',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.restore_rounded),
            tooltip: 'Reset to Monday',
            onPressed: () {
              HapticFeedback.lightImpact();
              _initSchedule(widget.facility);
              setState(() {});
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border(
            top: BorderSide(
              color: scheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: _saving ? null : _saveOperatingHours,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Save Operating Hours',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // Header summary card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2563EB).withValues(alpha: 0.12),
                  const Color(0xFF3B82F6).withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF2563EB).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.schedule_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.facility?.name ?? 'Weekly Schedule',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Customize timing or mark specific days off (e.g. Sunday)',
                            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildStatPill(
                      icon: Icons.calendar_today_rounded,
                      label: '$openDaysCount / 7 Days Open',
                      color: const Color(0xFF0D9488),
                    ),
                    const SizedBox(width: 8),
                    _buildStatPill(
                      icon: Icons.timer_outlined,
                      label: '~${totalWeeklyHours.toStringAsFixed(totalWeeklyHours.truncateToDouble() == totalWeeklyHours ? 0 : 1)} hrs/week',
                      color: const Color(0xFF2563EB),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Quick Preset Shortcuts
          Row(
            children: [
              Text(
                'QUICK ACTIONS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _applyMondayToAllWeekdays,
                icon: const Icon(Icons.copy_rounded, size: 14),
                label: const Text('Copy Mon to Mon–Fri', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Days List
          ...List.generate(_days.length, (index) {
            final day = _days[index];
            final duration = _calculateHours(day.openTime, day.closeTime);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: day.isClosed
                      ? scheme.outlineVariant.withValues(alpha: 0.3)
                      : const Color(0xFF2563EB).withValues(alpha: 0.25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day title and Open/Closed switch
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: day.isClosed
                                ? scheme.surfaceContainerHighest
                                : const Color(0xFF2563EB).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            day.shortLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: day.isClosed
                                  ? scheme.onSurfaceVariant
                                  : const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                day.label,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: day.isClosed
                                      ? scheme.onSurfaceVariant
                                      : scheme.onSurface,
                                ),
                              ),
                              Text(
                                day.isClosed
                                    ? 'Closed / Holiday'
                                    : '${_formatTimeDisplay(day.openTime)} – ${_formatTimeDisplay(day.closeTime)} (${duration.toStringAsFixed(duration.truncateToDouble() == duration ? 0 : 1)}h)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: day.isClosed
                                      ? const Color(0xFFEF4444)
                                      : scheme.onSurfaceVariant,
                                  fontWeight: day.isClosed ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert_rounded, size: 20, color: scheme.onSurfaceVariant),
                          tooltip: 'Options',
                          onSelected: (val) {
                            if (val == 'copy_all') {
                              _applyToAllDays(day);
                            } else if (val == 'toggle') {
                              setState(() => day.isClosed = !day.isClosed);
                            }
                          },
                          itemBuilder: (ctx) => [
                            PopupMenuItem(
                              value: 'copy_all',
                              child: Row(
                                children: [
                                  const Icon(Icons.copy_all_rounded, size: 18),
                                  const SizedBox(width: 8),
                                  Text('Copy ${day.label} to all 7 days'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'toggle',
                              child: Row(
                                children: [
                                  Icon(day.isClosed ? Icons.check_circle_outline : Icons.block_rounded, size: 18),
                                  const SizedBox(width: 8),
                                  Text(day.isClosed ? 'Mark as Open' : 'Mark as Closed'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Switch.adaptive(
                          value: !day.isClosed,
                          activeTrackColor: const Color(0xFF2563EB),
                          onChanged: (open) {
                            HapticFeedback.lightImpact();
                            setState(() => day.isClosed = !open);
                          },
                        ),
                      ],
                    ),

                    if (!day.isClosed) ...[
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Opening Time Selector
                          Expanded(
                            child: InkWell(
                              onTap: () => _pickTime(context, index, true),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'OPENS AT',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: scheme.onSurfaceVariant,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.wb_sunny_outlined, size: 15, color: Color(0xFFF59E0B)),
                                        const SizedBox(width: 6),
                                        Text(
                                          _formatTimeDisplay(day.openTime),
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Arrow indicator
                          Icon(Icons.arrow_forward_rounded, size: 16, color: scheme.onSurfaceVariant),
                          const SizedBox(width: 10),
                          // Closing Time Selector
                          Expanded(
                            child: InkWell(
                              onTap: () => _pickTime(context, index, false),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CLOSES AT',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: scheme.onSurfaceVariant,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.nightlight_outlined, size: 15, color: Color(0xFF6366F1)),
                                        const SizedBox(width: 6),
                                        Text(
                                          _formatTimeDisplay(day.closeTime),
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatPill({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
