import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/share_helper.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading/shimmer.dart';
import '../../../shared/widgets/loading/skeleton_card.dart';

final reportsHubStatsProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (FacilityKind, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  final monthly = await repo.getMonthlyCheckinsReport(args.$1, args.$2);
  final collections = await repo.getCollectionsReport(args.$1, args.$2, period: 'month');

  return {
    'total_checkins': monthly['total_checkins'] ?? 0,
    'unique_users': monthly['unique_users'] ?? 0,
    'total_collection': collections['total_collection'] ?? 0.0,
    'date_range': collections['date_range'] ?? 'This Month',
  };
});

class FacilityReportsScreen extends ConsumerWidget {
  const FacilityReportsScreen({
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

    final statsAsync = ref.watch(reportsHubStatsProvider((kind, facilityId)));
    final facilityName = facility?.name ?? (kind == FacilityKind.gym ? 'Gym Facility' : 'Library Hub');

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
        title: const Text('Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              final stats = statsAsync.value;
              final totalCheckins = stats?['total_checkins'] ?? 0;
              final totalCollection = stats?['total_collection'] ?? 0;
              final dateRange = stats?['date_range'] ?? 'This Month';
              AppShareHelper.shareText(
                context: context,
                text: '📊 Monthly Report for $facilityName ($dateRange):\n• Total Check-ins: $totalCheckins\n• Total Revenue: ₹$totalCollection\nShared via Smart CityZen Admin Hub',
                subject: '$facilityName - Performance Report',
              );
            },
          ),
        ],
      ),
      body: AmbientBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Facility Selector Pill
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      kind == FacilityKind.gym ? Icons.fitness_center_rounded : Icons.local_library_rounded,
                      size: 16,
                      color: const Color(0xFF0D9488),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      facilityName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Date Range Pill
            statsAsync.when(
              data: (data) => Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 14, color: scheme.primary),
                      const SizedBox(width: 6),
                      Text(
                        'This Month (${data['date_range']})',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: scheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Stat Cards Row
            statsAsync.when(
              data: (data) {
                final totalCheckins = data['total_checkins'] ?? 0;
                final uniqueUsers = data['unique_users'] ?? 0;
                final totalCollection = (data['total_collection'] as num?)?.toDouble() ?? 0.0;

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _ReportKpiCard(
                            icon: Icons.fact_check_outlined,
                            iconColor: const Color(0xFF0284C7),
                            title: 'Total Check-ins',
                            value: '$totalCheckins',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ReportKpiCard(
                            icon: Icons.person_outline_rounded,
                            iconColor: const Color(0xFF10B981),
                            title: 'Unique Users',
                            value: '$uniqueUsers',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _ReportKpiCard(
                      icon: Icons.account_balance_wallet_outlined,
                      iconColor: const Color(0xFF8B5CF6),
                      title: 'Total Collection',
                      value: '₹${totalCollection.toStringAsFixed(0)}',
                      isFullWidth: true,
                    ),
                  ],
                );
              },
              loading: () => const Shimmer(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: SkeletonMetricCard(height: 90)),
                        SizedBox(width: 12),
                        Expanded(child: SkeletonMetricCard(height: 90)),
                      ],
                    ),
                    SizedBox(height: 12),
                    SkeletonMetricCard(height: 90),
                  ],
                ),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),

            // Reports Navigation Section
            Text(
              'Reports',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  _ReportMenuTile(
                    icon: Icons.calendar_view_day_rounded,
                    iconColor: const Color(0xFF0284C7),
                    title: 'Daily Check-ins',
                    subtitle: 'View daily check-in report',
                    onTap: () => context.push(
                      '/client/manage/reports/daily/${kind.pathSegment}/$facilityId',
                      extra: facility,
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  _ReportMenuTile(
                    icon: Icons.calendar_month_rounded,
                    iconColor: const Color(0xFF0D9488),
                    title: 'Monthly Check-ins',
                    subtitle: 'View monthly check-in report',
                    onTap: () => context.push(
                      '/client/manage/reports/monthly/${kind.pathSegment}/$facilityId',
                      extra: facility,
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  _ReportMenuTile(
                    icon: Icons.warning_amber_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Unpaid Members',
                    subtitle: 'Members who has not paid this month',
                    onTap: () => context.push(
                      '/client/manage/reports/unpaid/${kind.pathSegment}/$facilityId',
                      extra: facility,
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  _ReportMenuTile(
                    icon: Icons.receipt_long_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: 'Collection Report',
                    subtitle: 'View collection and payments',
                    onTap: () => context.push(
                      '/client/manage/reports/collections/${kind.pathSegment}/$facilityId',
                      extra: facility,
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  _ReportMenuTile(
                    icon: Icons.timer_outlined,
                    iconColor: const Color(0xFFDC2626),
                    title: 'Expiring Memberships',
                    subtitle: 'Members expiring in next 7, 15, 30 days',
                    onTap: () => context.push(
                      '/client/manage/reports/expiring/${kind.pathSegment}/$facilityId',
                      extra: facility,
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  _ReportMenuTile(
                    icon: Icons.pie_chart_outline_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'Plan Distribution',
                    subtitle: 'Enrolled members per fee plan',
                    onTap: () => context.push(
                      '/client/manage/reports/plans/${kind.pathSegment}/$facilityId',
                      extra: facility,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportKpiCard extends StatelessWidget {
  const _ReportKpiCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.isFullWidth = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: isFullWidth
          ? Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                    Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(height: 12),
                Text(title, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
    );
  }
}

class _ReportMenuTile extends StatelessWidget {
  const _ReportMenuTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }
}
