import 'package:flutter/material.dart';

import '../../../shared/widgets/loading/shimmer.dart';
import '../../../shared/widgets/loading/skeleton_card.dart';
import '../../../shared/widgets/loading/skeleton_list_item.dart';
import '../../../shared/widgets/loading/skeleton_primitives.dart';

/// Skeleton for [FacilityDashboardScreen].
class FacilityDashboardSkeleton extends StatelessWidget {
  const FacilityDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // Multi-facility switcher pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: List.generate(2, (index) {
                return const Padding(
                  padding: EdgeInsets.only(right: 8, bottom: 10),
                  child: SkeletonChip(width: 130, height: 36),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),

          // Facility Hero Card
          const SkeletonCard(
            height: 100,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                SkeletonBox(
                  width: 56,
                  height: 56,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkeletonText(width: 160, height: 16),
                      SizedBox(height: 6),
                      SkeletonText(width: 110, height: 12),
                    ],
                  ),
                ),
                SkeletonChip(width: 50, height: 22),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 7 Operations Cards Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
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
                    width: 36,
                    height: 36,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  SizedBox(height: 10),
                  SkeletonText(width: 80, height: 14),
                  SizedBox(height: 4),
                  SkeletonText(width: 110, height: 10),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Analytics KPI & Chart module skeleton
          const SkeletonCard(
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText(width: 140, height: 16),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: SkeletonMetricCard()),
                    SizedBox(width: 10),
                    Expanded(child: SkeletonMetricCard()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for [EditFacilityDetailsScreen].
class EditFacilitySkeleton extends StatelessWidget {
  const EditFacilitySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonBox(height: 160, borderRadius: BorderRadius.all(Radius.circular(16))),
          SizedBox(height: 20),
          SkeletonInput(),
          SizedBox(height: 14),
          SkeletonInput(),
          SizedBox(height: 14),
          SkeletonInput(height: 90),
          SizedBox(height: 20),
          SkeletonButton(height: 50),
        ],
      ),
    );
  }
}

/// Skeleton for [ManageFeePlansScreen].
class FeePlansSkeleton extends StatelessWidget {
  const FeePlansSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: List.generate(3, (index) {
          return const SkeletonCard(
            height: 130,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonText(width: 140, height: 16),
                    SkeletonChip(width: 70, height: 22),
                  ],
                ),
                SizedBox(height: 8),
                SkeletonText(width: 90, height: 20),
                SizedBox(height: 8),
                SkeletonText(lines: 2, height: 11),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// Skeleton for [FacilityCurrentStatusScreen].
class FacilityStatusSkeleton extends StatelessWidget {
  const FacilityStatusSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Real-time meter card
          const SkeletonCard(
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonCircle(size: 64),
                SizedBox(height: 12),
                SkeletonText(width: 120, height: 16),
                SizedBox(height: 6),
                SkeletonText(width: 80, height: 12),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SkeletonText(width: 140, height: 16),
          const SizedBox(height: 10),
          ...List.generate(3, (index) {
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

/// Skeleton for [FacilityAttendanceScreen].
class FacilityAttendanceSkeleton extends StatelessWidget {
  const FacilityAttendanceSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const SkeletonBox(height: 48, borderRadius: BorderRadius.all(Radius.circular(12))),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: SkeletonMetricCard()),
              SizedBox(width: 10),
              Expanded(child: SkeletonMetricCard()),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(4, (index) {
            return const SkeletonListItem(leadingSize: 40, lines: 2, hasTrailing: true);
          }),
        ],
      ),
    );
  }
}

/// Skeleton for [FacilityManualCheckinScreen].
class FacilityManualCheckinSkeleton extends StatelessWidget {
  const FacilityManualCheckinSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonBox(height: 52, borderRadius: BorderRadius.all(Radius.circular(12))),
          SizedBox(height: 16),
          SkeletonCard(height: 120),
          SizedBox(height: 20),
          SkeletonText(width: 140, height: 16),
          SizedBox(height: 10),
          SkeletonListItem(leadingSize: 40, lines: 2),
          SkeletonListItem(leadingSize: 40, lines: 2),
        ],
      ),
    );
  }
}

/// Skeleton for [FacilityMembersScreen].
class FacilityMembersSkeleton extends StatelessWidget {
  const FacilityMembersSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const SkeletonBox(height: 48, borderRadius: BorderRadius.all(Radius.circular(999))),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: List.generate(4, (index) {
                return const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: SkeletonChip(width: 80, height: 32),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
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

/// Skeleton for [FacilityMemberDetailScreen].
class FacilityMemberDetailSkeleton extends StatelessWidget {
  const FacilityMemberDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const SkeletonCard(
            height: 140,
            child: Row(
              children: [
                SkeletonCircle(size: 64),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkeletonText(width: 150, height: 18),
                      SizedBox(height: 6),
                      SkeletonText(width: 100, height: 12),
                      SizedBox(height: 8),
                      SkeletonChip(width: 70, height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SkeletonCard(height: 110),
          const SizedBox(height: 16),
          const SkeletonText(width: 130, height: 16),
          const SizedBox(height: 10),
          ...List.generate(3, (index) {
            return const SkeletonListItem(hasLeading: false, lines: 2, hasTrailing: true);
          }),
        ],
      ),
    );
  }
}

/// Skeleton for [FacilityEnquiriesScreen].
class FacilityEnquiriesSkeleton extends StatelessWidget {
  const FacilityEnquiriesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: List.generate(4, (index) {
          return const SkeletonListItem(
            leadingSize: 44,
            leadingIsCircle: true,
            lines: 3,
            hasTrailing: true,
          );
        }),
      ),
    );
  }
}

/// Skeleton for [FacilityEnquiryConversationScreen] & [TicketDetailScreen].
class ConversationChatSkeleton extends StatelessWidget {
  const ConversationChatSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: const [
                SkeletonConversationItem(isMe: false, widthRatio: 0.7),
                SkeletonConversationItem(isMe: true, widthRatio: 0.6),
                SkeletonConversationItem(isMe: false, widthRatio: 0.75),
                SkeletonConversationItem(isMe: true, widthRatio: 0.5),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                Expanded(child: SkeletonInput(height: 48)),
                SizedBox(width: 10),
                SkeletonCircle(size: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for [FacilityCommunicationScreen].
class FacilityCommunicationSkeleton extends StatelessWidget {
  const FacilityCommunicationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonCard(
            height: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText(width: 130, height: 16),
                SizedBox(height: 12),
                SkeletonInput(),
                SizedBox(height: 12),
                SkeletonInput(height: 80),
              ],
            ),
          ),
          SizedBox(height: 20),
          SkeletonButton(height: 50),
        ],
      ),
    );
  }
}
