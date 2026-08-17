import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/facility_analytics_dashboard_widget.dart';
import '../widgets/facility_qr_modal.dart';

final facilityStatsProvider = FutureProvider.autoDispose.family<FacilityDashboardStats, (FacilityKind, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getDashboardStats(args.$1, args.$2);
});

class FacilityConsoleScreen extends ConsumerWidget {
  const FacilityConsoleScreen({
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
    final isGym = kind == FacilityKind.gym;

    final statsAsync = ref.watch(facilityStatsProvider((kind, facilityId)));

    final facilityName = facility?.name ?? (isGym ? 'Gym Facility' : 'Library Hub');
    final facilityAddress = facility?.address ?? facility?.city?.name ?? 'Smart City';

    return Scaffold(
      appBar: AppBar(
        title: Text(facilityName),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_2_rounded),
            tooltip: 'Facility QR Code',
            onPressed: () => showFacilityQrModal(
              context: context,
              kind: kind,
              facilityId: facilityId,
              facilityName: facilityName,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.refresh(facilityStatsProvider((kind, facilityId))),
          ),
        ],
      ),
      body: AmbientBackground(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(facilityStatsProvider((kind, facilityId)));
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Top Facility Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: scheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: (isGym ? const Color(0xFF0D9488) : const Color(0xFF0284C7)).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        isGym ? Icons.fitness_center_rounded : Icons.local_library_rounded,
                        color: isGym ? const Color(0xFF0D9488) : const Color(0xFF0284C7),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            facilityName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: scheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  facilityAddress,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      tooltip: 'Edit Facility Details',
                      onPressed: () async {
                        await context.push(
                          '/client/manage/edit/${kind.pathSegment}/$facilityId',
                          extra: facility,
                        );
                        ref.invalidate(facilityStatsProvider((kind, facilityId)));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Operations Grid (3 cols on tablet, 2 on phone)
              Text(
                'Operations & Management',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 600 ? 4 : 3;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: constraints.maxWidth > 600 ? 1.0 : 0.9,
                    children: [
                      _ModuleGridItem(
                        icon: Icons.people_alt_rounded,
                        label: 'Members',
                        color: const Color(0xFF0D9488),
                        onTap: () async {
                          await context.push(
                            '/client/manage/members/${kind.pathSegment}/$facilityId',
                            extra: facility,
                          );
                          ref.invalidate(facilityStatsProvider((kind, facilityId)));
                        },
                      ),
                      _ModuleGridItem(
                        icon: Icons.payments_rounded,
                        label: 'Fee Plans',
                        color: const Color(0xFF10B981),
                        onTap: () async {
                          await context.push(
                            '/client/manage/plans/${kind.pathSegment}/$facilityId',
                            extra: facility,
                          );
                          ref.invalidate(facilityStatsProvider((kind, facilityId)));
                        },
                      ),
                      _ModuleGridItem(
                        icon: Icons.how_to_reg_rounded,
                        label: 'Manual\nCheck-in',
                        color: const Color(0xFF0284C7),
                        onTap: () async {
                          await context.push(
                            '/client/manage/checkin/${kind.pathSegment}/$facilityId',
                            extra: facility,
                          );
                          ref.invalidate(facilityStatsProvider((kind, facilityId)));
                        },
                      ),
                      _ModuleGridItem(
                        icon: Icons.timelapse_rounded,
                        label: 'Current\nStatus',
                        color: const Color(0xFF0D9488),
                        onTap: () async {
                          await context.push(
                            '/client/manage/status/${kind.pathSegment}/$facilityId',
                            extra: facility,
                          );
                          ref.invalidate(facilityStatsProvider((kind, facilityId)));
                        },
                      ),
                      _ModuleGridItem(
                        icon: Icons.bar_chart_rounded,
                        label: 'Reports',
                        color: const Color(0xFF10B981),
                        onTap: () async {
                          await context.push(
                            '/client/manage/reports/${kind.pathSegment}/$facilityId',
                            extra: facility,
                          );
                          ref.invalidate(facilityStatsProvider((kind, facilityId)));
                        },
                      ),
                      _ModuleGridItem(
                        icon: Icons.forum_rounded,
                        label: 'Enquiries',
                        color: const Color(0xFF8B5CF6),
                        onTap: () async {
                          await context.push(
                            '/client/manage/enquiries/${kind.pathSegment}/$facilityId',
                            extra: facility,
                          );
                          ref.invalidate(facilityStatsProvider((kind, facilityId)));
                        },
                      ),
                      _ModuleGridItem(
                        icon: Icons.send_rounded,
                        label: 'Communication',
                        color: const Color(0xFF2563EB),
                        onTap: () async {
                          await context.push(
                            '/client/manage/communication/${kind.pathSegment}/$facilityId',
                            extra: facility,
                          );
                          ref.invalidate(facilityStatsProvider((kind, facilityId)));
                        },
                      ),
                      _ModuleGridItem(
                        icon: Icons.qr_code_2_rounded,
                        label: 'Facility QR',
                        color: const Color(0xFF0F766E),
                        onTap: () => showFacilityQrModal(
                          context: context,
                          kind: kind,
                          facilityId: facilityId,
                          facilityName: facilityName,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // Full Facility Analytics & Earnings Dashboard
              statsAsync.when(
                data: (stats) => FacilityAnalyticsDashboardWidget(
                  kind: kind,
                  facilityId: facilityId,
                  facility: facility,
                  stats: stats,
                ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Failed to load analytics: $err',
                      style: TextStyle(color: scheme.error, fontSize: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

                  // Quick Actions Section
                  Text(
                    'Quick Actions',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        _QuickActionTile(
                          icon: Icons.qr_code_scanner_rounded,
                          color: const Color(0xFF0284C7),
                          title: 'Scan Member QR',
                          onTap: () => context.push(
                            '/client/manage/attendance/${kind.pathSegment}/$facilityId',
                            extra: facility,
                          ),
                        ),
                        const Divider(height: 1, indent: 56),
                        _QuickActionTile(
                          icon: Icons.person_add_outlined,
                          color: const Color(0xFF0D9488),
                          title: 'Add New Member',
                          onTap: () => context.push(
                            '/client/manage/members/${kind.pathSegment}/$facilityId',
                            extra: facility,
                          ),
                        ),
                        const Divider(height: 1, indent: 56),
                        _QuickActionTile(
                          icon: Icons.send_rounded,
                          color: const Color(0xFF2563EB),
                          title: 'Send Communication',
                          onTap: () => context.push(
                            '/client/manage/communication/${kind.pathSegment}/$facilityId',
                            extra: facility,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
  }
}

class _ModuleGridItem extends StatelessWidget {
  const _ModuleGridItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.25),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }
}
