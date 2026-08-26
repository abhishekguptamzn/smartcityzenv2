import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/facilities_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/models/my_membership_summary.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/membership_skeletons.dart';

class MyMembershipsScreen extends ConsumerStatefulWidget {
  const MyMembershipsScreen({super.key});

  @override
  ConsumerState<MyMembershipsScreen> createState() =>
      _MyMembershipsScreenState();
}

class _MyMembershipsScreenState extends ConsumerState<MyMembershipsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final membershipsAsync = ref.watch(myMembershipSummariesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'My Memberships',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
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
      ),
      body: membershipsAsync.when(
        loading: () => const MembershipDetailsSkeleton(),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: EmptyStateView(
              icon: Icons.error_outline_rounded,
              message: 'Failed to load memberships. Please try again.',
              action: FilledButton(
                onPressed: () => ref.invalidate(myMembershipSummariesProvider),
                child: const Text('Retry'),
              ),
            ),
          ),
        ),
        data: (allMemberships) {
          final activeList =
              allMemberships.where((m) => m.isActuallyActive).toList();
          final expiredList =
              allMemberships.where((m) => m.isExpired).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: isDark ? const Color(0xFF3B82F6) : theme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: (isDark ? const Color(0xFF3B82F6) : theme.primaryColor)
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                    tabs: [
                      Tab(text: 'Active (${activeList.length})'),
                      Tab(text: 'Expired (${expiredList.length})'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _MembershipListView(
                      items: activeList,
                      isActiveTab: true,
                      onRefresh: () async {
                        ref.invalidate(myMembershipSummariesProvider);
                        await ref.read(myMembershipSummariesProvider.future);
                      },
                    ),
                    _MembershipListView(
                      items: expiredList,
                      isActiveTab: false,
                      onRefresh: () async {
                        ref.invalidate(myMembershipSummariesProvider);
                        await ref.read(myMembershipSummariesProvider.future);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MembershipListView extends StatelessWidget {
  const _MembershipListView({
    required this.items,
    required this.isActiveTab,
    required this.onRefresh,
  });

  final List<MyMembershipSummary> items;
  final bool isActiveTab;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 60),
            EmptyStateView(
              icon: isActiveTab
                  ? Icons.card_membership_rounded
                  : Icons.history_rounded,
              message: isActiveTab
                  ? 'You have no active memberships at the moment.'
                  : 'No expired memberships found in your history.',
              action: isActiveTab
                  ? FilledButton(
                      onPressed: () => context.push('/services'),
                      child: const Text('Explore Facilities'),
                    )
                  : null,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return _MembershipCardItem(summary: item, isActive: isActiveTab);
        },
      ),
    );
  }
}

class _MembershipCardItem extends StatelessWidget {
  const _MembershipCardItem({
    required this.summary,
    required this.isActive,
  });

  final MyMembershipSummary summary;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = context.appColors;

    final isLibrary = summary.kind == FacilityKind.library;
    final isGym = summary.kind == FacilityKind.gym;

    final IconData icon = isLibrary
        ? Icons.menu_book_rounded
        : (isGym ? Icons.fitness_center_rounded : Icons.sports_rounded);

    final String title = (summary.facilityName != null && summary.facilityName!.trim().isNotEmpty)
        ? summary.facilityName!
        : (isLibrary ? 'Public Library' : (isGym ? 'Sports Center' : 'Activity Studio'));

    final dateTarget = summary.endDate ?? summary.latestPaidAt;
    final dateStr = dateTarget != null
        ? DateFormat('d MMM yyyy').format(dateTarget)
        : '—';

    final int? daysLeft = summary.endDate != null && isActive
        ? summary.endDate!.difference(DateTime.now()).inDays
        : null;

    final categoryLabel = summary.categoryName ??
        (isLibrary ? 'Library Pass' : (isGym ? 'Gym Membership' : 'Activity Pass'));

    final planType = summary.membershipType != null && summary.membershipType!.isNotEmpty
        ? summary.membershipType!.toUpperCase()
        : null;

    return GlassContainer(
      level: GlassLevel.card,
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(16),
      onTap: () {
        final uri = Uri(
          path: '/membership/${summary.kind.name}/${summary.payableId}',
          queryParameters: {
            if (summary.facilityId != null) 'facilityId': summary.facilityId!,
            if (summary.facilityName != null) 'facilityName': summary.facilityName!,
          },
        );
        context.push(uri.toString());
      },
      gradientOverlay: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isActive
            ? [colors.idCardGradientStart, colors.idCardGradientEnd]
            : [
                isDark ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                isDark ? const Color(0xFF0F172A) : const Color(0xFF475569),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (planType != null) ...[
                      Text(
                        planType,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categoryLabel,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF10B981).withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFF10B981).withValues(alpha: 0.6)
                        : Colors.white24,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isActive ? 'Active' : 'Expired',
                      style: TextStyle(
                        color: isActive ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: Colors.white70,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isActive ? 'Valid Until $dateStr' : 'Expired on $dateStr',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (daysLeft != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: daysLeft <= 7
                          ? const Color(0xFFEF4444).withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      daysLeft > 0 ? '$daysLeft days left' : 'Expires today',
                      style: TextStyle(
                        color: daysLeft <= 7 ? const Color(0xFFFCA5A5) : Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Member ID: ${summary.payableId}',
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'View Pass',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
