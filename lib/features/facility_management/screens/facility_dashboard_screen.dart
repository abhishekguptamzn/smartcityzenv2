import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../core/utils/image_url_resolver.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/app_network_image.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/add_member_modal.dart';
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

  void _showShortcutsSheet(BuildContext context, FacilityKind kind, FacilityModel facility) {
    HapticFeedback.lightImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Quick Shortcuts',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.person_add_rounded, color: Color(0xFF0D9488)),
              title: const Text('Add Member (Scan Citizen QR)'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.of(ctx).pop();
                showAddMemberModal(
                  context: context,
                  kind: kind,
                  facilityId: facility.id,
                  facility: facility,
                  initialMode: AddMemberMode.scan,
                  onSuccess: () {
                    ref.invalidate(facilityStatsProvider((kind, facility.id)));
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_rounded, color: Color(0xFF0284C7)),
              title: const Text('Edit Facility Details'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () async {
                Navigator.of(ctx).pop();
                await context.push('/client/manage/edit/${kind.pathSegment}/${facility.id}', extra: facility);
                ref.invalidate(myOwnedFacilitiesProvider);
                ref.invalidate(facilityStatsProvider((kind, facility.id)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.payments_rounded, color: Color(0xFF10B981)),
              title: const Text('Manage Fee Plans'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () async {
                Navigator.of(ctx).pop();
                await context.push('/client/manage/plans/${kind.pathSegment}/${facility.id}', extra: facility);
                ref.invalidate(myOwnedFacilitiesProvider);
                ref.invalidate(facilityStatsProvider((kind, facility.id)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart_rounded, color: Color(0xFF8B5CF6)),
              title: const Text('Attendance & Revenue Reports'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () async {
                Navigator.of(ctx).pop();
                await context.push('/client/manage/reports/${kind.pathSegment}/${facility.id}', extra: facility);
                ref.invalidate(myOwnedFacilitiesProvider);
                ref.invalidate(facilityStatsProvider((kind, facility.id)));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scheme = theme.colorScheme;
    final user = ref.watch(authControllerProvider).value;
    final facilitiesAsync = ref.watch(myOwnedFacilitiesProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B132B) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: const Text(
          'Facility Management',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_2_rounded, size: 24),
            tooltip: 'Facility Check-in / Check-out QR Code',
            onPressed: () {
              final facilities = facilitiesAsync.value;
              final gyms = facilities?['gyms'] as List<FacilityModel>? ?? [];
              final libs = facilities?['libraries'] as List<FacilityModel>? ?? [];
              final acts = facilities?['activities'] as List<FacilityModel>? ?? [];
              final all = [
                ...gyms.map((g) => (FacilityKind.gym, g)),
                ...libs.map((l) => (FacilityKind.library, l)),
                ...acts.map((a) => (FacilityKind.activity, a)),
              ];
              if (all.isNotEmpty) {
                final current = all.firstWhere(
                  (p) => p.$2.id == _selectedFacilityId,
                  orElse: () => all.first,
                );
                HapticFeedback.lightImpact();
                showFacilityQrModal(
                  context: context,
                  kind: current.$1,
                  facilityId: current.$2.id,
                  facilityName: current.$2.name,
                );
              }
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, size: 24),
                tooltip: 'Notifications',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All facility operations are normal.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0284C7),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 22),
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
            final activities = data['activities'] as List<FacilityModel>? ?? [];
            final allFacilities = <(FacilityKind, FacilityModel)>[
              ...gyms.map((g) => (FacilityKind.gym, g)),
              ...libraries.map((l) => (FacilityKind.library, l)),
              ...activities.map((a) => (FacilityKind.activity, a)),
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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  // Multi-facility switcher pills if more than 1 facility
                  if (allFacilities.length > 1) ...[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: allFacilities.map((pair) {
                          final isSelected = pair.$2.id == _selectedFacilityId;
                          final pairKind = pair.$1;
                          final chipColor = pairKind == FacilityKind.gym
                              ? const Color(0xFF0D9488)
                              : (pairKind == FacilityKind.activity
                                  ? const Color(0xFF1565D8)
                                  : const Color(0xFF0284C7));
                          final chipIcon = pairKind == FacilityKind.gym
                              ? Icons.fitness_center_rounded
                              : (pairKind == FacilityKind.activity
                                  ? Icons.sports_rounded
                                  : Icons.local_library_rounded);

                          return Padding(
                            padding: const EdgeInsets.only(right: 8, bottom: 10),
                            child: ChoiceChip(
                              avatar: Icon(
                                chipIcon,
                                size: 16,
                                color: isSelected ? Colors.white : chipColor,
                              ),
                              label: Text(pair.$2.name),
                              selected: isSelected,
                              selectedColor: chipColor,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white : const Color(0xFF0F172A)),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
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
                  ],

                  // Top Facility Card matching Screenshot
                  _buildFacilityHeroCard(
                    context: context,
                    facility: activeFacility,
                    kind: activeKind,
                    isGym: isGym,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 22),

                  // Operations & Management Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Operations & Management',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      InkWell(
                        onTap: () => _showShortcutsSheet(context, activeKind, activeFacility),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Row(
                            children: [
                              Text(
                                'Shortcuts',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.tune_rounded, size: 16, color: Colors.grey.shade600),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Operations & Management Grid matching Screenshot
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 550;
                      final crossAxisCount = isWide ? 4 : 3;

                      return GridView.count(
                        crossAxisCount: crossAxisCount,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: isWide ? 1.25 : 1.05,
                        children: [
                          // 1. Members
                          _OperationsCard(
                            icon: Icons.people_alt_rounded,
                            iconColor: const Color(0xFF059669),
                            iconBg: const Color(0xFFECFDF5),
                            title: 'Members',
                            subtitle: 'View and manage all members',
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

                          // 2. Fee Plans
                          _OperationsCard(
                            icon: Icons.payments_rounded,
                            iconColor: const Color(0xFF10B981),
                            iconBg: const Color(0xFFECFDF5),
                            title: 'Fee Plans',
                            subtitle: 'Create and manage membership plans',
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

                          // 3. Manual Check-in
                          _OperationsCard(
                            icon: Icons.how_to_reg_rounded,
                            iconColor: const Color(0xFF0284C7),
                            iconBg: const Color(0xFFEFF6FF),
                            title: 'Manual Check-in',
                            subtitle: 'Check-in members manually',
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

                          // 4. Current Status
                          _OperationsCard(
                            icon: Icons.timelapse_rounded,
                            iconColor: const Color(0xFF0D9488),
                            iconBg: const Color(0xFFF0FDFA),
                            title: 'Current Status',
                            subtitle: 'See real-time facility activity',
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

                          // 5. Reports
                          _OperationsCard(
                            icon: Icons.bar_chart_rounded,
                            iconColor: const Color(0xFF8B5CF6),
                            iconBg: const Color(0xFFF5F3FF),
                            title: 'Reports',
                            subtitle: 'View usage and performance reports',
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

                          // 6. Enquiries
                          _OperationsCard(
                            icon: Icons.chat_bubble_rounded,
                            iconColor: const Color(0xFFEA580C),
                            iconBg: const Color(0xFFFFF7ED),
                            title: 'Enquiries',
                            subtitle: 'Manage and respond to enquiries',
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

                          // 7. Communication
                          _OperationsCard(
                            icon: Icons.send_rounded,
                            iconColor: const Color(0xFF2563EB),
                            iconBg: const Color(0xFFEFF6FF),
                            title: 'Communication',
                            subtitle: 'Send updates and announcements',
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
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Facility Analytics & Earnings Modules (Preserved exactly as requested)
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

  Widget _buildFacilityHeroCard({
    required BuildContext context,
    required FacilityModel facility,
    required FacilityKind kind,
    required bool isGym,
    required bool isDark,
  }) {
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF334155) : const Color(0xFFEDF2F7);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Facility Squircle Icon or Brand Logo
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.white12 : const Color(0xFFDBEAFE),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: (facility.logoUrl != null && facility.logoUrl!.trim().isNotEmpty)
                  ? AppNetworkImage(
                      imageUrl: ImageUrlResolver.resolve(facility.logoUrl!.trim()),
                      fit: BoxFit.cover,
                      width: 48,
                      height: 48,
                    )
                  : Center(
                      child: Icon(
                        isGym ? Icons.fitness_center_rounded : Icons.menu_book_rounded,
                        color: const Color(0xFF2563EB),
                        size: 24,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // Name and Address
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  facility.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15.5,
                    letterSpacing: -0.3,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        facility.address ?? facility.city?.name ?? 'Pantheon Road, Egmore',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // First Action: "Add Member" (Camera scanner to enroll citizen)
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              showAddMemberModal(
                context: context,
                kind: kind,
                facilityId: facility.id,
                facility: facility,
                initialMode: AddMemberMode.scan,
                onSuccess: () {
                  ref.invalidate(facilityStatsProvider((kind, facility.id)));
                },
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFA7F3D0), width: 1.2),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 19,
                      color: Color(0xFF059669),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Add Member',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Second Action: "Edit"
          InkWell(
            onTap: () async {
              HapticFeedback.lightImpact();
              await context.push(
                '/client/manage/edit/${kind.pathSegment}/${facility.id}',
                extra: facility,
              );
              ref.invalidate(myOwnedFacilitiesProvider);
              ref.invalidate(
                facilityStatsProvider(
                  (kind, facility.id),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationsCard extends StatelessWidget {
  const _OperationsCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFEDF2F7),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row: Colored Squircle Icon + Right Arrow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 17),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Title and Subtitle
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  height: 1.25,
                  color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
