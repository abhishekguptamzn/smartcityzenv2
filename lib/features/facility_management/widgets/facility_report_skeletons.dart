import 'package:flutter/material.dart';

import '../../../shared/widgets/loading/shimmer.dart';
import '../../../shared/widgets/loading/skeleton_card.dart';
import '../../../shared/widgets/loading/skeleton_list_item.dart';
import '../../../shared/widgets/loading/skeleton_primitives.dart';

/// Skeleton for [FacilityReportsScreen] (Hub).
class FacilityReportsHubSkeleton extends StatelessWidget {
  const FacilityReportsHubSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const SkeletonChip(width: 140, height: 32),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: SkeletonMetricCard()),
              SizedBox(width: 12),
              Expanded(child: SkeletonMetricCard()),
            ],
          ),
          const SizedBox(height: 12),
          const SkeletonMetricCard(height: 85),
          const SizedBox(height: 24),
          const SkeletonText(width: 140, height: 16),
          const SizedBox(height: 12),
          ...List.generate(5, (index) {
            return const SkeletonListItem(
              leadingSize: 40,
              lines: 2,
              hasTrailing: true,
            );
          }),
        ],
      ),
    );
  }
}

/// Skeleton for [FacilityDailyCheckinReportScreen].
class DailyCheckinReportSkeleton extends StatelessWidget {
  const DailyCheckinReportSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: const [
              Expanded(child: SkeletonBox(height: 40, borderRadius: BorderRadius.all(Radius.circular(12)))),
              SizedBox(width: 10),
              Expanded(child: SkeletonBox(height: 40, borderRadius: BorderRadius.all(Radius.circular(12)))),
            ],
          ),
          const SizedBox(height: 16),
          const SkeletonCard(height: 70),
          const SizedBox(height: 16),
          ...List.generate(5, (index) {
            return const SkeletonListItem(hasLeading: false, lines: 2, hasTrailing: true);
          }),
        ],
      ),
    );
  }
}

/// Skeleton for [FacilityMonthlyAttendanceReportScreen].
class MonthlyAttendanceReportSkeleton extends StatelessWidget {
  const MonthlyAttendanceReportSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const SkeletonBox(height: 44, borderRadius: BorderRadius.all(Radius.circular(12))),
          const SizedBox(height: 16),
          // Chart bar graph skeleton
          SkeletonCard(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final heights = [60.0, 90.0, 130.0, 80.0, 110.0, 140.0, 95.0];
                return SkeletonBox(
                  width: 24,
                  height: heights[index % heights.length],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(3, (index) {
            return const SkeletonListItem(hasLeading: false, lines: 2, hasTrailing: true);
          }),
        ],
      ),
    );
  }
}

/// Skeleton for [FacilityExpiringMembersScreen] & [FacilityUnpaidMembersScreen].
class MembersReportListSkeleton extends StatelessWidget {
  const MembersReportListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const SkeletonCard(height: 80),
          const SizedBox(height: 14),
          ...List.generate(5, (index) {
            return const SkeletonListItem(
              leadingSize: 44,
              leadingIsCircle: true,
              lines: 2,
              hasTrailing: true,
            );
          }),
        ],
      ),
    );
  }
}

/// Skeleton for [FacilityPlanDistributionScreen].
class PlanDistributionReportSkeleton extends StatelessWidget {
  const PlanDistributionReportSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Donut / circle chart placeholder
          const SkeletonCard(
            height: 200,
            child: Center(
              child: SkeletonCircle(size: 130),
            ),
          ),
          const SizedBox(height: 16),
          const SkeletonText(width: 140, height: 16),
          const SizedBox(height: 12),
          ...List.generate(3, (index) {
            return const SkeletonCard(
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonText(width: 110, height: 14),
                      SkeletonText(width: 60, height: 14),
                    ],
                  ),
                  SizedBox(height: 8),
                  SkeletonBox(height: 6, borderRadius: BorderRadius.all(Radius.circular(99))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Skeleton for [FacilityCollectionReportScreen].
class CollectionReportSkeleton extends StatelessWidget {
  const CollectionReportSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const SkeletonMetricCard(height: 90),
          const SizedBox(height: 16),
          // Trend chart placeholder
          const SkeletonHeroCard(height: 180, imageHeight: 110),
          const SizedBox(height: 16),
          const SkeletonText(width: 140, height: 16),
          const SizedBox(height: 10),
          ...List.generate(4, (index) {
            return const SkeletonListItem(
              hasLeading: true,
              leadingIsCircle: false,
              lines: 2,
              hasTrailing: true,
            );
          }),
        ],
      ),
    );
  }
}
