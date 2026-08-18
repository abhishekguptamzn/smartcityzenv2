import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';

final monthlyReportProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (FacilityKind, String, String?)>((ref, args) async {
  final (kind, facilityId, month) = args;
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getMonthlyCheckinsReport(kind, facilityId, month: month);
});

class FacilityMonthlyAttendanceReportScreen extends ConsumerStatefulWidget {
  const FacilityMonthlyAttendanceReportScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilityMonthlyAttendanceReportScreen> createState() => _FacilityMonthlyAttendanceReportScreenState();
}

class _FacilityMonthlyAttendanceReportScreenState extends ConsumerState<FacilityMonthlyAttendanceReportScreen> {
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isGym = widget.kind == FacilityKind.gym;
    final primaryColor = isGym ? const Color(0xFF0D9488) : const Color(0xFF0284C7);

    final monthStr = DateFormat('yyyy-MM').format(_selectedMonth);
    final reportAsync = ref.watch(monthlyReportProvider((widget.kind, widget.facilityId, monthStr)));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/client/facilities');
            }
          },
        ),
        title: const Text('Monthly Attendance Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.refresh(monthlyReportProvider((widget.kind, widget.facilityId, monthStr))),
          ),
        ],
      ),
      body: AmbientBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Month Selector Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () {
                      setState(() {
                        _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
                      });
                    },
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_month_rounded, size: 18, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MMMM yyyy').format(_selectedMonth),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () {
                      setState(() {
                        _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            reportAsync.when(
              data: (data) {
                final totalCheckins = (data['total_checkins'] as num?)?.toInt() ?? 0;
                final uniqueUsers = (data['unique_users'] as num?)?.toInt() ?? 0;
                final breakdown = (data['daily_breakdown'] as List? ?? []).cast<Map<String, dynamic>>();

                return Column(
                  children: [
                    // KPI Row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Check-ins', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                                const SizedBox(height: 4),
                                Text('$totalCheckins', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Unique Visitors', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                                const SizedBox(height: 4),
                                Text('$uniqueUsers', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Day by Day Activity
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Daily Attendance Breakdown',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (breakdown.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        child: Center(
                          child: Text(
                            'No attendance activity recorded for this month.',
                            style: TextStyle(color: scheme.onSurfaceVariant),
                          ),
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: breakdown.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (ctx, idx) {
                            final day = breakdown[idx];
                            final date = day['date']?.toString() ?? '';
                            final count = (day['checkins_count'] ?? day['count'] ?? 0) as int;
                            final unique = (day['unique_users'] ?? 0) as int;

                            return ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.event_note_rounded, color: primaryColor, size: 18),
                              ),
                              title: Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                              subtitle: Text('$unique unique visitors', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$count check-ins',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
              loading: () => const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
              error: (err, _) => Center(child: Text('Error loading report: $err', style: TextStyle(color: scheme.error))),
            ),
          ],
        ),
      ),
    );
  }
}
