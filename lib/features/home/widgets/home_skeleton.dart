import 'package:flutter/material.dart';

import '../../../shared/widgets/loading/shimmer.dart';
import '../../../shared/widgets/loading/skeleton_card.dart';
import '../../../shared/widgets/loading/skeleton_primitives.dart';

/// Full dashboard skeleton matching the structure of [HomeScreen].
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // 1. Quick Actions row (4 round icons with label)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              return Column(
                children: const [
                  SkeletonCircle(size: 52),
                  SizedBox(height: 6),
                  SkeletonBox(width: 50, height: 10),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),

          // 2. Search bar skeleton
          const SkeletonBox(
            height: 48,
            borderRadius: BorderRadius.all(Radius.circular(999)),
          ),
          const SizedBox(height: 24),

          // 3. Service Categories Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SkeletonText(width: 140, height: 18),
              SkeletonText(width: 50, height: 14),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) => const SkeletonCard(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SkeletonBox(
                    width: 36,
                    height: 36,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  SizedBox(height: 8),
                  SkeletonText(width: 55, height: 10),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 4. My Memberships section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SkeletonText(width: 130, height: 18),
              SkeletonText(width: 50, height: 14),
            ],
          ),
          const SizedBox(height: 12),
          const SkeletonCard(
            height: 96,
            child: Row(
              children: [
                SkeletonBox(
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkeletonText(width: 140, height: 14),
                      SizedBox(height: 6),
                      SkeletonText(width: 90, height: 11),
                      SizedBox(height: 6),
                      SkeletonChip(width: 70, height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 5. My City Section
          const SkeletonText(width: 80, height: 18),
          const SizedBox(height: 12),
          const SkeletonHeroCard(height: 160, imageHeight: 95),
        ],
      ),
    );
  }
}

/// Digital Citizen ID Card skeleton.
class IdCardSkeleton extends StatelessWidget {
  const IdCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SkeletonCard(
            height: 480,
            borderRadius: BorderRadius.circular(24),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Card header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SkeletonText(width: 120, height: 16),
                    SkeletonCircle(size: 32),
                  ],
                ),
                const SizedBox(height: 24),

                // Avatar
                const SkeletonCircle(size: 96),
                const SizedBox(height: 16),

                // Name & ID
                const SkeletonText(width: 160, height: 20),
                const SizedBox(height: 8),
                const SkeletonText(width: 110, height: 12),
                const SizedBox(height: 24),

                const Divider(),
                const SizedBox(height: 16),

                // Details grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Column(
                      children: [
                        SkeletonText(width: 60, height: 10),
                        SizedBox(height: 4),
                        SkeletonText(width: 80, height: 14),
                      ],
                    ),
                    Column(
                      children: [
                        SkeletonText(width: 60, height: 10),
                        SizedBox(height: 4),
                        SkeletonText(width: 80, height: 14),
                      ],
                    ),
                  ],
                ),
                const Spacer(),

                // QR code placeholder
                const SkeletonBox(
                  width: 88,
                  height: 88,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                const SizedBox(height: 8),
                const SkeletonText(width: 90, height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
