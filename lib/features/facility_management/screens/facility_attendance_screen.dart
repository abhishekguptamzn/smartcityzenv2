import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/facility_management_skeletons.dart';

final gymAttendanceLogsProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, gymId) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getGymAttendance(gymId);
});

class FacilityAttendanceScreen extends ConsumerWidget {
  const FacilityAttendanceScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final logsAsync = ref.watch(gymAttendanceLogsProvider(facilityId));

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
        title: Text('${facility?.name ?? "Gym"} Scan Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.refresh(gymAttendanceLogsProvider(facilityId)),
          ),
        ],
      ),
      body: AmbientBackground(
        child: logsAsync.when(
          data: (logs) {
            if (logs.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 44,
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Scans Logged Yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Check-ins by members at the QR turnstile/desk will appear here.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (ctx, idx) {
                final l = logs[idx];
                final user = l['user'] as Map<String, dynamic>? ?? {};
                final checkInAt = l['check_in_at']?.toString() ?? '—';
                final duration = l['duration_minutes'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: scheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Color(0xFF0D9488),
                        size: 22,
                      ),
                    ),
                    title: Text(
                      user['name']?.toString() ?? 'Citizen Check-in',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Time: $checkInAt',
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: duration != null
                        ? Text(
                            '$duration mins',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: scheme.primary,
                            ),
                          )
                        : const Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                  ),
                );
              },
            );
          },
          loading: () => const FacilityAttendanceSkeleton(),
          error: (err, _) => Center(
            child: Text('Error loading attendance logs: $err', style: TextStyle(color: scheme.error)),
          ),
        ),
      ),
    );
  }
}
