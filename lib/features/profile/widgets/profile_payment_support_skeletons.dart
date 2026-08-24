import 'package:flutter/material.dart';

import '../../../shared/widgets/loading/shimmer.dart';
import '../../../shared/widgets/loading/skeleton_card.dart';
import '../../../shared/widgets/loading/skeleton_list_item.dart';
import '../../../shared/widgets/loading/skeleton_primitives.dart';

/// Skeleton for [ProfileScreen].
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Profile header
          Center(
            child: Column(
              children: const [
                SkeletonCircle(size: 88),
                SizedBox(height: 14),
                SkeletonText(width: 160, height: 20),
                SizedBox(height: 6),
                SkeletonText(width: 120, height: 13),
                SizedBox(height: 10),
                SkeletonChip(width: 90, height: 24),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Membership pass summary
          const SkeletonCard(height: 100),
          const SizedBox(height: 20),

          // Menu rows
          ...List.generate(4, (index) {
            return const SkeletonListItem(
              leadingSize: 36,
              lines: 1,
              hasTrailing: true,
              margin: EdgeInsets.only(bottom: 8),
            );
          }),
        ],
      ),
    );
  }
}

/// Skeleton for [EditProfileScreen].
class EditProfileSkeleton extends StatelessWidget {
  const EditProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          Center(child: SkeletonCircle(size: 96)),
          SizedBox(height: 24),
          SkeletonInput(),
          SizedBox(height: 14),
          SkeletonInput(),
          SizedBox(height: 14),
          SkeletonInput(),
          SizedBox(height: 14),
          SkeletonInput(),
          SizedBox(height: 24),
          SkeletonButton(height: 50),
        ],
      ),
    );
  }
}

/// Skeleton for [SecurityScreen].
class SecuritySkeleton extends StatelessWidget {
  const SecuritySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: List.generate(4, (index) {
          return const SkeletonListItem(
            leadingSize: 36,
            lines: 2,
            hasTrailing: true,
            margin: EdgeInsets.only(bottom: 12),
          );
        }),
      ),
    );
  }
}

/// Skeleton for [PaymentsScreen].
class PaymentsSkeleton extends StatelessWidget {
  const PaymentsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const SkeletonMetricCard(height: 90),
          const SizedBox(height: 16),
          const SkeletonText(width: 140, height: 16),
          const SizedBox(height: 12),
          ...List.generate(5, (index) {
            return const SkeletonListItem(
              leadingSize: 40,
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

/// Skeleton for [PaymentReceiptScreen].
class PaymentReceiptSkeleton extends StatelessWidget {
  const PaymentReceiptSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SkeletonCard(
            height: 440,
            borderRadius: BorderRadius.circular(24),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SkeletonCircle(size: 64),
                const SizedBox(height: 16),
                const SkeletonText(width: 140, height: 18),
                const SizedBox(height: 8),
                const SkeletonText(width: 90, height: 24),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                ...List.generate(3, (index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkeletonText(width: 80, height: 12),
                        SkeletonText(width: 120, height: 12),
                      ],
                    ),
                  );
                }),
                const Spacer(),
                const SkeletonButton(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Skeleton for [SupportTicketsScreen].
class SupportTicketsSkeleton extends StatelessWidget {
  const SupportTicketsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: List.generate(3, (index) {
                return const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: SkeletonChip(width: 80, height: 32),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(4, (index) {
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
