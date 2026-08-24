import 'package:flutter/material.dart';

import '../../../shared/widgets/loading/shimmer.dart';
import '../../../shared/widgets/loading/skeleton_card.dart';
import '../../../shared/widgets/loading/skeleton_primitives.dart';

/// Skeleton for [MembershipDetailsScreen].
class MembershipDetailsSkeleton extends StatelessWidget {
  const MembershipDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Digital Membership Pass Card
          SkeletonCard(
            height: 200,
            borderRadius: BorderRadius.circular(24),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SkeletonText(width: 140, height: 16),
                    SkeletonChip(width: 70, height: 24),
                  ],
                ),
                Row(
                  children: const [
                    SkeletonCircle(size: 54),
                    SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonText(width: 150, height: 18),
                        SizedBox(height: 6),
                        SkeletonText(width: 100, height: 12),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SkeletonText(width: 90, height: 12),
                    SkeletonText(width: 110, height: 12),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // QR Code Card
          SkeletonCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: const [
                SkeletonBox(
                  width: 140,
                  height: 140,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                SizedBox(height: 14),
                SkeletonText(width: 120, height: 14),
                SizedBox(height: 6),
                SkeletonText(width: 180, height: 11),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Attendance history section
          const SkeletonText(width: 140, height: 16),
          const SizedBox(height: 10),
          ...List.generate(3, (index) {
            return const SkeletonCard(
              height: 64,
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkeletonText(width: 90, height: 14),
                  SkeletonText(width: 70, height: 12),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
