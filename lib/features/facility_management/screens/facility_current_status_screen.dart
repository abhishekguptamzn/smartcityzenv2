import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';

final facilityCurrentStatusProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (FacilityKind, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getCurrentStatus(args.$1, args.$2);
});

class FacilityCurrentStatusScreen extends ConsumerStatefulWidget {
  const FacilityCurrentStatusScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilityCurrentStatusScreen> createState() => _FacilityCurrentStatusScreenState();
}

class _FacilityCurrentStatusScreenState extends ConsumerState<FacilityCurrentStatusScreen> {
  bool _isCheckingOutAll = false;

  Future<void> _handleCheckoutSingle(LiveSessionMember member) async {
    try {
      await ref.read(clientFacilityRepositoryProvider).checkOut(
        widget.kind,
        widget.facilityId,
        sessionId: member.sessionId,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Checked out ${member.userName} successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      ref.invalidate(facilityCurrentStatusProvider((widget.kind, widget.facilityId)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Checkout failed: ${e.toString()}'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleCheckoutAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End All Sessions?'),
        content: const Text('This will check out all members currently inside the facility.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('End All'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isCheckingOutAll = true);
    try {
      final count = await ref.read(clientFacilityRepositoryProvider).checkoutAll(
        widget.kind,
        widget.facilityId,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Checked out $count members successfully.'),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
      ref.invalidate(facilityCurrentStatusProvider((widget.kind, widget.facilityId)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _isCheckingOutAll = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final statusAsync = ref.watch(facilityCurrentStatusProvider((widget.kind, widget.facilityId)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.refresh(facilityCurrentStatusProvider((widget.kind, widget.facilityId))),
          ),
        ],
      ),
      body: AmbientBackground(
        child: statusAsync.when(
          data: (data) {
            final currentlyInsideCount = data['currently_inside_count'] as int? ?? 0;
            final todayCheckinsCount = data['today_checkins_count'] as int? ?? 0;
            final todayUniqueCount = data['today_unique_users_count'] as int? ?? 0;
            final lastUpdated = data['last_updated']?.toString() ?? 'Just now';
            final membersInside = data['members_inside'] as List<LiveSessionMember>? ?? [];

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Gradient Hero Occupancy Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0F766E), Color(0xFF134E4A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x200D9488),
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Currently Checked In',
                              style: TextStyle(
                                color: Color(0xFFCCFBF1),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.people_alt_rounded, color: Colors.white, size: 36),
                                const SizedBox(width: 10),
                                Text(
                                  '$currentlyInsideCount',
                                  style: const TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Last updated: $lastUpdated',
                              style: const TextStyle(
                                color: Color(0x99FFFFFF),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Metrics Summary (3 Columns)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text("Today's Check-ins", style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                                  const SizedBox(height: 4),
                                  Text('$todayCheckinsCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Container(height: 32, width: 1, color: scheme.outlineVariant.withValues(alpha: 0.4)),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Currently Inside', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                                  const SizedBox(height: 4),
                                  Text('$currentlyInsideCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Container(height: 32, width: 1, color: scheme.outlineVariant.withValues(alpha: 0.4)),
                            Expanded(
                              child: Column(
                                children: [
                                  Text("Today's Unique Users", style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                                  const SizedBox(height: 4),
                                  Text('$todayUniqueCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Currently Inside List Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Currently Inside ($currentlyInsideCount)',
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('View All', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Inside Members List
                      if (membersInside.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.meeting_room_outlined, size: 40, color: scheme.onSurfaceVariant),
                                const SizedBox(height: 8),
                                Text(
                                  'No members currently checked in',
                                  style: TextStyle(color: scheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: membersInside.length,
                            separatorBuilder: (_, _) => const Divider(height: 1, indent: 56),
                            itemBuilder: (context, idx) {
                              final mem = membersInside[idx];
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: const Color(0xFF0D9488).withValues(alpha: 0.12),
                                  child: Text(
                                    mem.userName.isNotEmpty ? mem.userName[0].toUpperCase() : 'M',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                                  ),
                                ),
                                title: Text(mem.userName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                subtitle: Text(
                                  'Check-in: ${mem.checkInTime} (${mem.elapsedMinutes}m ago)',
                                  style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.logout_rounded, size: 18, color: Color(0xFFEF4444)),
                                      tooltip: 'Check out',
                                      onPressed: () => _handleCheckoutSingle(mem),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),

                // Bottom Checkout All Button
                if (currentlyInsideCount > 0)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isCheckingOutAll ? null : _handleCheckoutAll,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFEF2F2),
                          foregroundColor: const Color(0xFFDC2626),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(color: Color(0xFFFCA5A5)),
                          ),
                        ),
                        child: _isCheckingOutAll
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFDC2626)),
                              )
                            : const Text(
                                'Checkout All (End All Sessions)',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error loading status: $err')),
        ),
      ),
    );
  }
}
