import 'package:flutter/material.dart';

import '../../../shared/widgets/loading/shimmer.dart';
import '../../../shared/widgets/loading/skeleton_card.dart';
import '../../../shared/widgets/loading/skeleton_list_item.dart';
import '../../../shared/widgets/loading/skeleton_primitives.dart';

/// Skeleton for [CityInformationScreen].
class CityInformationSkeleton extends StatelessWidget {
  const CityInformationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Hero Banner
          const SkeletonHeroCard(height: 180, imageHeight: 110),
          const SizedBox(height: 8),

          // City Stats Row (3 boxes)
          Row(
            children: const [
              Expanded(child: SkeletonMetricCard()),
              SizedBox(width: 8),
              Expanded(child: SkeletonMetricCard()),
              SizedBox(width: 8),
              Expanded(child: SkeletonMetricCard()),
            ],
          ),
          const SizedBox(height: 20),

          // Category Cards Grid
          const SkeletonText(width: 130, height: 18),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) => const SkeletonCard(
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SkeletonBox(
                    width: 38,
                    height: 38,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  SizedBox(height: 10),
                  SkeletonText(width: 80, height: 14),
                  SizedBox(height: 4),
                  SkeletonText(width: 100, height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for [CityAboutScreen].
class CityAboutSkeleton extends StatelessWidget {
  const CityAboutSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonHeroCard(height: 190, imageHeight: 120),
          SizedBox(height: 16),
          SkeletonText(width: 160, height: 20),
          SizedBox(height: 12),
          SkeletonText(lines: 4, height: 13, spacing: 8),
          SizedBox(height: 20),
          SkeletonCard(
            height: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText(width: 100, height: 14),
                SizedBox(height: 10),
                SkeletonText(lines: 2, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Timeline skeleton for [CityHistoryScreen].
class CityTimelineSkeleton extends StatelessWidget {
  const CityTimelineSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        children: [
          // Filter pills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: List.generate(5, (index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: SkeletonChip(width: 76, height: 32),
                  );
                }),
              ),
            ),
          ),
          const Divider(height: 1),
          // Vertical timeline list
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: const [
                SkeletonTimelineItem(),
                SkeletonTimelineItem(),
                SkeletonTimelineItem(isLast: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for [CityOriginScreen].
class CityOriginSkeleton extends StatelessWidget {
  const CityOriginSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonCard(
            height: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonText(width: 140, height: 18),
                SizedBox(height: 8),
                SkeletonText(lines: 3, height: 12),
              ],
            ),
          ),
          SizedBox(height: 16),
          SkeletonText(width: 120, height: 16),
          SizedBox(height: 10),
          SkeletonCard(height: 100),
          SizedBox(height: 10),
          SkeletonCard(height: 100),
        ],
      ),
    );
  }
}

/// Skeleton for [CityGeographyScreen].
class CityGeographySkeleton extends StatelessWidget {
  const CityGeographySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const SkeletonHeroCard(height: 170, imageHeight: 110),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: SkeletonMetricCard()),
              SizedBox(width: 10),
              Expanded(child: SkeletonMetricCard()),
            ],
          ),
          const SizedBox(height: 16),
          const SkeletonCard(
            height: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText(width: 120, height: 16),
                SizedBox(height: 10),
                SkeletonText(lines: 3, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for [CityCultureScreen] & [CityHeritageScreen].
class CityGallerySkeleton extends StatelessWidget {
  const CityGallerySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: List.generate(3, (index) {
          return const SkeletonHeroCard(height: 220, imageHeight: 130);
        }),
      ),
    );
  }
}

/// Skeleton for [CityPersonalitiesScreen].
class CityPersonalitiesSkeleton extends StatelessWidget {
  const CityPersonalitiesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: List.generate(4, (index) {
          return const SkeletonListItem(
            leadingSize: 52,
            leadingIsCircle: true,
            lines: 3,
            hasTrailing: false,
          );
        }),
      ),
    );
  }
}

/// Skeleton for [CityNewsScreen].
class CityNewsSkeleton extends StatelessWidget {
  const CityNewsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const SkeletonHeroCard(height: 220, imageHeight: 130),
          const SizedBox(height: 12),
          ...List.generate(3, (index) {
            return const SkeletonListItem(
              leadingSize: 64,
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
