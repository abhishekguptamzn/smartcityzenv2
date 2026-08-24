import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/facility_report_skeletons.dart';
import '../widgets/renew_member_modal.dart';

final expiringMembersProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (FacilityKind, String, int)>((ref, args) async {
  final (kind, facilityId, days) = args;
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getExpiringMembersReport(kind, facilityId, days: days);
});

class FacilityExpiringMembersScreen extends ConsumerStatefulWidget {
  const FacilityExpiringMembersScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilityExpiringMembersScreen> createState() => _FacilityExpiringMembersScreenState();
}

class _FacilityExpiringMembersScreenState extends ConsumerState<FacilityExpiringMembersScreen> {
  int _selectedDays = 30;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final reportAsync = ref.watch(expiringMembersProvider((widget.kind, widget.facilityId, _selectedDays)));

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
        title: const Text('Expiring Memberships'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.refresh(expiringMembersProvider((widget.kind, widget.facilityId, _selectedDays))),
          ),
        ],
      ),
      body: AmbientBackground(
        child: Column(
          children: [
            // Filter Pills
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  for (final d in [7, 15, 30, 60])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: _selectedDays == d,
                        label: Text('Next $d Days'),
                        onSelected: (val) {
                          if (val) setState(() => _selectedDays = d);
                        },
                      ),
                    ),
                ],
              ),
            ),

            // Report Content
            Expanded(
              child: reportAsync.when(
                data: (data) {
                  final members = (data['members'] as List? ?? []).cast<Map<String, dynamic>>();

                  if (members.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified_user_rounded,
                                size: 40,
                                color: Color(0xFF059669),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'All Memberships Active',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'No memberships are expiring in the next $_selectedDays days.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: members.length,
                    itemBuilder: (ctx, idx) {
                      final m = members[idx];
                      final name = m['user_name']?.toString() ?? (m['user'] is Map ? m['user']['name']?.toString() : null) ?? 'Citizen Member';
                      final planName = m['plan_name']?.toString() ?? m['membership_type']?.toString() ?? (m['fee_plan'] is Map ? m['fee_plan']['name']?.toString() : null) ?? 'Standard Plan';
                      final phone = m['user_phone']?.toString() ?? (m['user'] is Map ? m['user']['phone']?.toString() : null);
                      final email = m['user_email']?.toString() ?? (m['user'] is Map ? m['user']['email']?.toString() : null);
                      final daysRemaining = (m['days_remaining'] as num?)?.toInt() ?? 0;
                      final isOverdue = daysRemaining < 0;
                      final isUrgent = daysRemaining <= 7;
                      final endDate = m['end_date_formatted']?.toString() ?? m['end_date']?.toString() ?? 'N/A';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: (isOverdue || isUrgent)
                                ? Colors.redAccent.withValues(alpha: 0.3)
                                : scheme.outlineVariant.withValues(alpha: 0.3),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x08000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: scheme.primary.withValues(alpha: 0.12),
                                  child: Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : 'M',
                                    style: TextStyle(color: scheme.primary, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                                      ),
                                      Text(
                                        'Plan: $planName',
                                        style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (isOverdue ? Colors.red : (isUrgent ? Colors.orange : const Color(0xFF0D9488)))
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isOverdue ? 'EXPIRED' : (daysRemaining == 0 ? 'TODAY' : '$daysRemaining DAYS LEFT'),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isOverdue ? Colors.red : (isUrgent ? Colors.deepOrange : const Color(0xFF0D9488)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.event_busy_rounded, size: 14, color: isOverdue ? Colors.red : scheme.onSurfaceVariant),
                                const SizedBox(width: 6),
                                Text(
                                  'Expiry Date: $endDate',
                                  style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                if (phone != null || email != null)
                                  Text(
                                    '${phone ?? email}',
                                    style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant.withValues(alpha: 0.7)),
                                  ),
                              ],
                            ),
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF0D9488),
                                    foregroundColor: Colors.white,
                                    visualDensity: VisualDensity.compact,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  icon: const Icon(Icons.autorenew_rounded, size: 14),
                                  label: const Text('Renew Member', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (ctx) => RenewMemberModal(
                                        kind: widget.kind,
                                        facilityId: widget.facilityId,
                                        facility: widget.facility,
                                        member: m,
                                        onSuccess: () => ref.refresh(expiringMembersProvider((widget.kind, widget.facilityId, _selectedDays))),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const MembersReportListSkeleton(),
                error: (err, _) => Center(
                  child: Text('Error loading report: $err', style: TextStyle(color: scheme.error)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
