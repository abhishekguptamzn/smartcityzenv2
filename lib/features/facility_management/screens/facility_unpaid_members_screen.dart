import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/renew_member_modal.dart';

final unpaidMembersReportProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (FacilityKind, String, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getUnpaidMembersReport(args.$1, args.$2, month: args.$3);
});

class FacilityUnpaidMembersScreen extends ConsumerStatefulWidget {
  const FacilityUnpaidMembersScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilityUnpaidMembersScreen> createState() => _FacilityUnpaidMembersScreenState();
}

class _FacilityUnpaidMembersScreenState extends ConsumerState<FacilityUnpaidMembersScreen> {
  final String _selectedMonth = DateFormat('yyyy-MM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final unpaidAsync = ref.watch(unpaidMembersReportProvider((widget.kind, widget.facilityId, _selectedMonth)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unpaid Members Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => ref.refresh(unpaidMembersReportProvider((widget.kind, widget.facilityId, _selectedMonth))),
          ),
        ],
      ),
      body: AmbientBackground(
        child: Column(
          children: [
            // Month Picker & Search Bar Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 8),
                        Text(
                          'This Month (${DateFormat('MMM yyyy').format(DateTime.now())})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Unpaid Members Count Header
            unpaidAsync.when(
              data: (data) {
                final unpaidCount = data['unpaid_count'] ?? 0;
                final totalDue = (data['total_unpaid_amount'] as num?)?.toDouble() ?? 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Unpaid Members ($unpaidCount)',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Total Due: ₹${totalDue.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 6),

            // Members List
            Expanded(
              child: unpaidAsync.when(
                data: (data) {
                  final members = data['members'] as List<UnpaidMemberItem>? ?? [];

                  if (members.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, size: 48, color: Color(0xFF10B981)),
                          const SizedBox(height: 12),
                          Text(
                            'All members have cleared dues for this month! 🎉',
                            style: TextStyle(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: members.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, idx) {
                      final item = members[idx];

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.1),
                                  child: Text(
                                    item.userName.isNotEmpty ? item.userName[0].toUpperCase() : 'M',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.userName,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.planName,
                                        style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₹${item.dueAmount.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFDC2626),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Due: ${item.dueDateFormatted}',
                                      style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D9488),
                                  foregroundColor: Colors.white,
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.payment_rounded, size: 14),
                                label: const Text('Record Payment', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (ctx) => RenewMemberModal(
                                      kind: widget.kind,
                                      facilityId: widget.facilityId,
                                      facility: widget.facility,
                                      member: {
                                        'id': item.memberId,
                                        'user': {'name': item.userName, 'id': item.userId},
                                        'end_date': item.dueDate,
                                      },
                                      onSuccess: () => ref.refresh(unpaidMembersReportProvider((widget.kind, widget.facilityId, _selectedMonth))),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error loading report: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
