import 'package:flutter/material.dart';

import '../../../shared/widgets/loading/shimmer.dart';
import '../../../shared/widgets/loading/skeleton_card.dart';
import '../../../shared/widgets/loading/skeleton_primitives.dart';

/// Skeleton for [ServicesExplorerScreen].
class ServicesExplorerSkeleton extends StatelessWidget {
  const ServicesExplorerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Search input skeleton
          const SkeletonBox(
            height: 48,
            borderRadius: BorderRadius.all(Radius.circular(999)),
          ),
          const SizedBox(height: 16),

          // Horizontal category chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: List.generate(5, (index) {
                return const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: SkeletonChip(width: 88, height: 36),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),

          // Facility center cards
          ...List.generate(3, (index) {
            return const SkeletonHeroCard(height: 220, imageHeight: 130);
          }),
        ],
      ),
    );
  }
}

/// Skeleton for [FacilityDetailScreen].
class FacilityDetailSkeleton extends StatelessWidget {
  const FacilityDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          // Hero gallery shimmer
          const SkeletonBox(
            height: 240,
            width: double.infinity,
            borderRadius: BorderRadius.zero,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SkeletonText(width: 180, height: 22),
                    SkeletonChip(width: 60, height: 24),
                  ],
                ),
                const SizedBox(height: 8),
                const SkeletonText(width: 120, height: 14),
                const SizedBox(height: 20),

                // Quick actions row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(4, (index) {
                    return const Column(
                      children: [
                        SkeletonCircle(size: 44),
                        SizedBox(height: 6),
                        SkeletonBox(width: 48, height: 10),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // Timings card skeleton
                const SkeletonCard(
                  height: 80,
                  child: Row(
                    children: [
                      SkeletonCircle(size: 36),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SkeletonText(width: 80, height: 14),
                            SizedBox(height: 4),
                            SkeletonText(width: 160, height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Amenities grid skeleton
                const SkeletonText(width: 100, height: 16),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) => const SkeletonCard(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.all(8),
                    child: Center(child: SkeletonBox(width: 50, height: 10)),
                  ),
                ),
                const SizedBox(height: 20),

                // Fee plans card skeleton
                const SkeletonText(width: 90, height: 16),
                const SizedBox(height: 10),
                const SkeletonCard(height: 90),
                const SizedBox(height: 10),
                const SkeletonCard(height: 90),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for [ActivitiesExplorerScreen].
class ActivitiesExplorerSkeleton extends StatelessWidget {
  const ActivitiesExplorerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Search & Filter
          const SkeletonBox(
            height: 48,
            borderRadius: BorderRadius.all(Radius.circular(999)),
          ),
          const SizedBox(height: 14),

          // Categories row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: List.generate(4, (index) {
                return const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: SkeletonChip(width: 96, height: 36),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Activity cards
          ...List.generate(3, (index) {
            return const SkeletonCard(
              height: 140,
              child: Row(
                children: [
                  SkeletonBox(
                    width: 100,
                    height: double.infinity,
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SkeletonText(width: 140, height: 15),
                        SizedBox(height: 6),
                        SkeletonText(width: 90, height: 12),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            SkeletonChip(width: 50, height: 18),
                            SizedBox(width: 6),
                            SkeletonChip(width: 60, height: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Skeleton for [ActivityDetailScreen].
class ActivityDetailSkeleton extends StatelessWidget {
  const ActivityDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          const SkeletonBox(
            height: 220,
            width: double.infinity,
            borderRadius: BorderRadius.zero,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonText(width: 200, height: 22),
                SizedBox(height: 8),
                SkeletonText(width: 120, height: 14),
                SizedBox(height: 20),
                SkeletonCard(height: 90),
                SizedBox(height: 12),
                SkeletonCard(height: 120),
                SizedBox(height: 24),
                SkeletonButton(height: 52),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for bottom pagination indicator across all list views.
class BottomPaginationSkeleton extends StatelessWidget {
  const BottomPaginationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children: const [
            SkeletonCircle(size: 32),
            SizedBox(width: 12),
            Expanded(child: SkeletonText(lines: 2, height: 10, spacing: 4)),
          ],
        ),
      ),
    );
  }
}
