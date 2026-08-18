import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';

final dailyCheckinReportProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (FacilityKind, String, String, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getDailyCheckinsReport(args.$1, args.$2, date: args.$3, status: args.$4);
});

class FacilityDailyCheckinReportScreen extends ConsumerStatefulWidget {
  const FacilityDailyCheckinReportScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilityDailyCheckinReportScreen> createState() => _FacilityDailyCheckinReportScreenState();
}

class _FacilityDailyCheckinReportScreenState extends ConsumerState<FacilityDailyCheckinReportScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedStatus = 'all';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dateFormatted = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final displayDate = DateFormat('d MMM yyyy').format(_selectedDate);

    final reportAsync = ref.watch(dailyCheckinReportProvider((widget.kind, widget.facilityId, dateFormatted, _selectedStatus)));

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
        title: const Text('Daily Check-in Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting report as PDF/CSV...'), behavior: SnackBarBehavior.floating),
              );
            },
          ),
        ],
      ),
      body: AmbientBackground(
        child: Column(
          children: [
            // Filters Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Date Picker Pill
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 14, color: scheme.primary),
                          const SizedBox(width: 8),
                          Text(displayDate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Status Filter Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedStatus,
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Status', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: 'inside', child: Text('Currently Inside', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: 'completed', child: Text('Completed', style: TextStyle(fontSize: 12))),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedStatus = val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Stat Summary Cards
            reportAsync.when(
              data: (data) {
                final total = data['total_checkins'] ?? 0;
                final unique = data['unique_users'] ?? 0;
                final avgDurationText = data['avg_duration_text'] ?? '--';

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text('Total Check-ins', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                              const SizedBox(height: 4),
                              Text('$total', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Container(height: 28, width: 1, color: scheme.outlineVariant.withValues(alpha: 0.4)),
                        Expanded(
                          child: Column(
                            children: [
                              Text('Unique Users', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                              const SizedBox(height: 4),
                              Text('$unique', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Container(height: 28, width: 1, color: scheme.outlineVariant.withValues(alpha: 0.4)),
                        Expanded(
                          child: Column(
                            children: [
                              Text('Avg. Duration', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                              const SizedBox(height: 4),
                              Text(avgDurationText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),

            // Tabular Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  const Expanded(flex: 3, child: Text('User', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))),
                  const Expanded(flex: 2, child: Text('Plan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))),
                  const Expanded(flex: 2, child: Text('Check-in', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))),
                  const Expanded(flex: 2, child: Text('Check-out', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))),
                  const Expanded(flex: 2, child: Text('Duration', textAlign: TextAlign.right, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))),
                ],
              ),
            ),
            const Divider(height: 8),

            // Records List
            Expanded(
              child: reportAsync.when(
                data: (data) {
                  final records = data['records'] as List<DailyCheckinRecord>? ?? [];

                  if (records.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.fact_check_outlined, size: 40, color: scheme.onSurfaceVariant),
                          const SizedBox(height: 8),
                          Text('No check-ins on $displayDate', style: TextStyle(color: scheme.onSurfaceVariant)),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: records.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, idx) {
                      final rec = records[idx];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  if (rec.isCurrentlyInside)
                                    Container(
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets.only(right: 6),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  Expanded(
                                    child: Text(
                                      rec.userName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                rec.planName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                rec.checkInTime,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                rec.checkOutTime,
                                style: TextStyle(fontSize: 11, color: rec.isCurrentlyInside ? const Color(0xFF0D9488) : null),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                rec.durationText,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: rec.isCurrentlyInside ? const Color(0xFF10B981) : scheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
