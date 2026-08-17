import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/facility_analytics_dashboard_widget.dart';
import '../widgets/facility_qr_modal.dart';

final myOwnedFacilitiesProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getMyFacilities();
});

final facilityStatsProvider = FutureProvider.autoDispose
    .family<FacilityDashboardStats, (FacilityKind, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getDashboardStats(args.$1, args.$2);
});

class FacilityDashboardScreen extends ConsumerStatefulWidget {
  const FacilityDashboardScreen({
    super.key,
    this.initialKind,
    this.initialFacilityId,
  });

  final FacilityKind? initialKind;
  final String? initialFacilityId;

  @override
  ConsumerState<FacilityDashboardScreen> createState() =>
      _FacilityDashboardScreenState();
}

class _FacilityDashboardScreenState
    extends ConsumerState<FacilityDashboardScreen> {
  String? _selectedFacilityId;
  FacilityKind? _selectedKind;

  @override
  void initState() {
    super.initState();
    _selectedFacilityId = widget.initialFacilityId;
    _selectedKind = widget.initialKind;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = ref.watch(authControllerProvider).value;
    final facilitiesAsync = ref.watch(myOwnedFacilitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Facility Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Dashboard',
            onPressed: () {
              ref.invalidate(myOwnedFacilitiesProvider);
              if (_selectedKind != null && _selectedFacilityId != null) {
                ref.invalidate(
                  facilityStatsProvider((_selectedKind!, _selectedFacilityId!)),
                );
              }
            },
          ),
        ],
      ),
      body: AmbientBackground(
        child: facilitiesAsync.when(
          data: (data) {
            final gyms = data['gyms'] as List<FacilityModel>? ?? [];
            final libraries = data['libraries'] as List<FacilityModel>? ?? [];
            final allFacilities = <(FacilityKind, FacilityModel)>[
              ...gyms.map((g) => (FacilityKind.gym, g)),
              ...libraries.map((l) => (FacilityKind.library, l)),
            ];

            if (allFacilities.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.storefront_rounded,
                          size: 48,
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Facilities Assigned',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You are logged in as ${user?.name ?? 'Facility Owner'}, but no Gym or Library is currently linked to your account.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Default to first facility if not set or not found
            var selectedPair = allFacilities.firstWhere(
              (p) =>
                  p.$2.id == _selectedFacilityId &&
                  (_selectedKind == null || p.$1 == _selectedKind),
              orElse: () => allFacilities.first,
            );

            _selectedFacilityId = selectedPair.$2.id;
            _selectedKind = selectedPair.$1;

            final activeKind = selectedPair.$1;
            final activeFacility = selectedPair.$2;
            final isGym = activeKind == FacilityKind.gym;
            final primaryColor =
                isGym ? const Color(0xFF0D9488) : const Color(0xFF0284C7);

            final statsAsync = ref.watch(
              facilityStatsProvider((activeKind, activeFacility.id)),
            );

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(myOwnedFacilitiesProvider);
                ref.invalidate(
                  facilityStatsProvider((activeKind, activeFacility.id)),
                );
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Multi-facility switcher pills if more than 1 facility
                  if (allFacilities.length > 1) ...[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: allFacilities.map((pair) {
                          final isSelected = pair.$2.id == _selectedFacilityId;
                          final pairIsGym = pair.$1 == FacilityKind.gym;
                          final chipColor = pairIsGym
                              ? const Color(0xFF0D9488)
                              : const Color(0xFF0284C7);

                          return Padding(
                            padding: const EdgeInsets.only(right: 8, bottom: 8),
                            child: ChoiceChip(
                              avatar: Icon(
                                pairIsGym
                                    ? Icons.fitness_center_rounded
                                    : Icons.local_library_rounded,
                                size: 16,
                                color: isSelected ? Colors.white : chipColor,
                              ),
                              label: Text(pair.$2.name),
                              selected: isSelected,
                              selectedColor: chipColor,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : theme.textTheme.bodyMedium?.color,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedFacilityId = pair.$2.id;
                                    _selectedKind = pair.$1;
                                  });
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Facility Hero Card
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
                            color: primaryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            isGym
                                ? Icons.fitness_center_rounded
                                : Icons.local_library_rounded,
                            color: primaryColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activeFacility.name,
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
                                      activeFacility.address ??
                                          activeFacility.city?.name ??
                                          'Smart City',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
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
                          icon: const Icon(Icons.qr_code_2_rounded, size: 20),
                          tooltip: 'Facility QR Code',
                          onPressed: () => showFacilityQrModal(
                            context: context,
                            kind: activeKind,
                            facilityId: activeFacility.id,
                            facilityName: activeFacility.name,
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton.filledTonal(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          tooltip: 'Edit Facility Details',
                          onPressed: () async {
                            await context.push(
                              '/client/manage/edit/${activeKind.pathSegment}/${activeFacility.id}',
                              extra: activeFacility,
                            );
                            ref.invalidate(myOwnedFacilitiesProvider);
                            ref.invalidate(
                              facilityStatsProvider(
                                (activeKind, activeFacility.id),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Operations & Management Grid
                  Text(
                    'Operations & Management',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
                        childAspectRatio:
                            constraints.maxWidth > 600 ? 1.0 : 0.9,
                        children: [
                          _ModuleGridItem(
                            icon: Icons.people_alt_rounded,
                            label: 'Members',
                            color: const Color(0xFF0D9488),
                            onTap: () async {
                              await context.push(
                                '/client/manage/members/${activeKind.pathSegment}/${activeFacility.id}',
                                extra: activeFacility,
                              );
                              ref.invalidate(
                                facilityStatsProvider(
                                  (activeKind, activeFacility.id),
                                ),
                              );
                            },
                          ),
                          _ModuleGridItem(
                            icon: Icons.payments_rounded,
                            label: 'Fee Plans',
                            color: const Color(0xFF10B981),
                            onTap: () async {
                              await context.push(
                                '/client/manage/plans/${activeKind.pathSegment}/${activeFacility.id}',
                                extra: activeFacility,
                              );
                              ref.invalidate(
                                facilityStatsProvider(
                                  (activeKind, activeFacility.id),
                                ),
                              );
                            },
                          ),
                          _ModuleGridItem(
                            icon: Icons.how_to_reg_rounded,
                            label: 'Manual\nCheck-in',
                            color: const Color(0xFF0284C7),
                            onTap: () async {
                              await context.push(
                                '/client/manage/checkin/${activeKind.pathSegment}/${activeFacility.id}',
                                extra: activeFacility,
                              );
                              ref.invalidate(
                                facilityStatsProvider(
                                  (activeKind, activeFacility.id),
                                ),
                              );
                            },
                          ),
                          _ModuleGridItem(
                            icon: Icons.timelapse_rounded,
                            label: 'Current\nStatus',
                            color: const Color(0xFF0D9488),
                            onTap: () async {
                              await context.push(
                                '/client/manage/status/${activeKind.pathSegment}/${activeFacility.id}',
                                extra: activeFacility,
                              );
                              ref.invalidate(
                                facilityStatsProvider(
                                  (activeKind, activeFacility.id),
                                ),
                              );
                            },
                          ),
                          _ModuleGridItem(
                            icon: Icons.bar_chart_rounded,
                            label: 'Reports',
                            color: const Color(0xFF10B981),
                            onTap: () async {
                              await context.push(
                                '/client/manage/reports/${activeKind.pathSegment}/${activeFacility.id}',
                                extra: activeFacility,
                              );
                              ref.invalidate(
                                facilityStatsProvider(
                                  (activeKind, activeFacility.id),
                                ),
                              );
                            },
                          ),
                          _ModuleGridItem(
                            icon: Icons.forum_rounded,
                            label: 'Enquiries',
                            color: const Color(0xFF8B5CF6),
                            onTap: () async {
                              await context.push(
                                '/client/manage/enquiries/${activeKind.pathSegment}/${activeFacility.id}',
                                extra: activeFacility,
                              );
                              ref.invalidate(
                                facilityStatsProvider(
                                  (activeKind, activeFacility.id),
                                ),
                              );
                            },
                          ),
                          _ModuleGridItem(
                            icon: Icons.send_rounded,
                            label: 'Communication',
                            color: const Color(0xFF2563EB),
                            onTap: () async {
                              await context.push(
                                '/client/manage/communication/${activeKind.pathSegment}/${activeFacility.id}',
                                extra: activeFacility,
                              );
                              ref.invalidate(
                                facilityStatsProvider(
                                  (activeKind, activeFacility.id),
                                ),
                              );
                            },
                          ),
                          _ModuleGridItem(
                            icon: Icons.qr_code_2_rounded,
                            label: 'Facility QR',
                            color: const Color(0xFF0F766E),
                            onTap: () => showFacilityQrModal(
                              context: context,
                              kind: activeKind,
                              facilityId: activeFacility.id,
                              facilityName: activeFacility.name,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Full Facility Analytics & Earnings Dashboard embedded directly
                  statsAsync.when(
                    data: (stats) => FacilityAnalyticsDashboardWidget(
                      kind: activeKind,
                      facilityId: activeFacility.id,
                      facility: activeFacility,
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
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Failed to load facilities: $err',
                style: TextStyle(color: scheme.error),
              ),
            ),
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
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
