import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/activities_providers.dart';
import '../../../core/utils/icon_helper.dart';
import '../../../data/models/activity_batch_model.dart';
import '../../../data/models/activity_instructor_model.dart';
import '../../../data/models/activity_model.dart';
import '../../../data/models/activity_review_model.dart';
import '../../../data/models/fee_plan_model.dart';
import '../../../shared/widgets/app_network_image.dart';
import '../../../shared/widgets/error_state_view.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../widgets/enroll_activity_sheet.dart';
import '../widgets/write_activity_review_sheet.dart';

class ActivityDetailScreen extends ConsumerStatefulWidget {
  const ActivityDetailScreen({
    super.key,
    required this.id,
  });

  final String id;

  static const Color _primary = Color(0xFF1565D8);

  @override
  ConsumerState<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends ConsumerState<ActivityDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activityAsync = ref.watch(activityDetailsProvider(widget.id));
    final reviewsAsync = ref.watch(activityReviewsProvider(widget.id));

    return activityAsync.when(
      data: (activity) => _buildContent(context, activity, reviewsAsync, isDark),
      loading: () => Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F1117) : const Color(0xFFF8FAFC),
        appBar: AppBar(elevation: 0),
        body: const Center(child: LoadingIndicator()),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F1117) : const Color(0xFFF8FAFC),
        appBar: AppBar(elevation: 0),
        body: ErrorStateView(
          error: error,
          onRetry: () => ref.invalidate(activityDetailsProvider(widget.id)),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ActivityModel activity,
    AsyncValue<List<ActivityReviewModel>> reviewsAsync,
    bool isDark,
  ) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1117) : const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Hero Cover App Bar
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            elevation: 0,
            backgroundColor: isDark ? const Color(0xFF181B26) : Colors.white,
            leading: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.45),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.45),
                child: IconButton(
                  icon: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: 'Check out ${activity.name} on Smart CityZen!'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link copied to clipboard!')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (activity.imageUrl != null && activity.imageUrl!.isNotEmpty)
                    AppNetworkImage(
                      imageUrl: activity.imageUrl,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [const Color(0xFF232736), const Color(0xFF151824)]
                              : [const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.sports_rounded,
                          size: 64,
                          color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  // Bottom Scrim
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                  // Header Overlay Info
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: ActivityDetailScreen._primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconHelper.buildIcon(
                                    activity.category?.icon,
                                    size: 13,
                                    color: Colors.white,
                                    defaultEmoji: '🎯',
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    activity.categoryName ?? 'Activity',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (activity.isVerified)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.verified_rounded, color: Colors.white, size: 12),
                                    SizedBox(width: 4),
                                    Text('Verified', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          activity.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Body Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating & Hours Bar
                  _buildQuickStatsCard(activity, isDark),
                  const SizedBox(height: 16),

                  // Quick Action Buttons
                  _buildActionButtons(activity, isDark),
                  const SizedBox(height: 20),

                  // About Section
                  if (activity.description != null && activity.description!.isNotEmpty) ...[
                    _sectionHeader('About Academy & Studio', Icons.info_outline_rounded),
                    const SizedBox(height: 8),
                    Text(
                      activity.description!,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Batches & Live Schedule Matrix
                  if (activity.batches.isNotEmpty) ...[
                    _sectionHeader('Batches & Class Schedule', Icons.calendar_month_rounded),
                    const SizedBox(height: 10),
                    ...activity.batches.map((b) => _buildBatchCard(activity, b, isDark)),
                    const SizedBox(height: 24),
                  ],

                  // Coaches & Instructors
                  if (activity.instructors.isNotEmpty) ...[
                    _sectionHeader('Expert Coaches & Instructors', Icons.sports_kabaddi_rounded),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: activity.instructors.length,
                        itemBuilder: (_, i) => _buildInstructorCard(activity.instructors[i], isDark),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Fee Plans & Passes
                  if (activity.feePlans.isNotEmpty) ...[
                    _sectionHeader('Passes & Fee Plans', Icons.card_membership_rounded),
                    const SizedBox(height: 10),
                    ...activity.feePlans.map((fp) => _buildFeePlanCard(activity, fp, isDark)),
                    const SizedBox(height: 24),
                  ],

                  // Amenities Chips
                  if (activity.amenities.isNotEmpty) ...[
                    _sectionHeader('Amenities & Features', Icons.check_circle_outline_rounded),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: activity.amenities.map((a) {
                        return Chip(
                          avatar: const Icon(Icons.check_rounded, size: 14, color: ActivityDetailScreen._primary),
                          label: Text(a.name, style: const TextStyle(fontSize: 12)),
                          backgroundColor: isDark ? const Color(0xFF232736) : const Color(0xFFF1F5F9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Citizen Reviews Section
                  _buildReviewsSection(context, activity, reviewsAsync, isDark),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky Bottom Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF181B26) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('MEMBERSHIP / PASS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                  Text(
                    activity.feePlans.isNotEmpty
                        ? '₹${activity.feePlans.first.amount.toStringAsFixed(0)} / ${activity.feePlans.first.interval}'
                        : 'Enroll Today',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: ActivityDetailScreen._primary),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => EnrollActivitySheet.show(context, activity: activity),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ActivityDetailScreen._primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.how_to_reg_rounded, size: 20),
                      SizedBox(width: 8),
                      Text('Enroll & Get Pass', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsCard(ActivityModel activity, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181B26) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2E3D) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statCol(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFF59E0B),
            title: activity.displayRating,
            subtitle: '${activity.reviewCount} Reviews',
          ),
          _divider(isDark),
          _statCol(
            icon: Icons.access_time_rounded,
            iconColor: ActivityDetailScreen._primary,
            title: activity.isOpenNow ? 'Open Now' : 'Closed',
            subtitle: activity.timeFormatted,
          ),
          if (activity.distanceFormatted != null) ...[
            _divider(isDark),
            _statCol(
              icon: Icons.near_me_rounded,
              iconColor: const Color(0xFF10B981),
              title: activity.distanceFormatted!,
              subtitle: 'Distance',
            ),
          ],
        ],
      ),
    );
  }

  Widget _statCol({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 4),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _divider(bool isDark) {
    return Container(
      height: 30,
      width: 1,
      color: isDark ? const Color(0xFF2A2E3D) : const Color(0xFFE2E8F0),
    );
  }

  Widget _buildActionButtons(ActivityModel activity, bool isDark) {
    return Row(
      children: [
        if (activity.contactPhone != null && activity.contactPhone!.isNotEmpty)
          Expanded(
            child: _actionBtn(
              icon: Icons.phone_in_talk_rounded,
              label: 'Call',
              color: const Color(0xFF10B981),
              onTap: () => launchUrl(Uri.parse('tel:${activity.contactPhone}')),
              isDark: isDark,
            ),
          ),
        if (activity.contactPhone != null && activity.contactPhone!.isNotEmpty)
          const SizedBox(width: 8),
        if (activity.contactEmail != null && activity.contactEmail!.isNotEmpty)
          Expanded(
            child: _actionBtn(
              icon: Icons.mail_outline_rounded,
              label: 'Email',
              color: const Color(0xFF0EA5E9),
              onTap: () => launchUrl(Uri.parse('mailto:${activity.contactEmail}')),
              isDark: isDark,
            ),
          ),
        if (activity.contactEmail != null && activity.contactEmail!.isNotEmpty)
          const SizedBox(width: 8),
        Expanded(
          child: _actionBtn(
            icon: Icons.directions_rounded,
            label: 'Navigate',
            color: const Color(0xFF8B5CF6),
            onTap: () {
              final query = activity.latitude != null && activity.longitude != null
                  ? '${activity.latitude},${activity.longitude}'
                  : Uri.encodeComponent('${activity.name}, ${activity.address ?? ''}');
              launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=$query'),
                  mode: LaunchMode.externalApplication);
            },
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: ActivityDetailScreen._primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }

  Widget _buildBatchCard(ActivityModel activity, ActivityBatchModel b, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181B26) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF2A2E3D) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  b.name,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
              if (b.availableSpots != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: b.availableSpots! > 0
                        ? const Color(0xFF10B981).withValues(alpha: 0.15)
                        : Colors.redAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${b.availableSpots} spots left',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: b.availableSpots! > 0 ? const Color(0xFF10B981) : Colors.redAccent,
                    ),
                  ),
                ),
            ],
          ),
          if (b.instructor != null) ...[
            const SizedBox(height: 4),
            Text(
              'Coach: ${b.instructor!.name} (${b.instructor!.title ?? 'Instructor'})',
              style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            ),
          ],
          if (b.schedules.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: b.schedules.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF232736) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule_rounded, size: 12, color: ActivityDetailScreen._primary),
                      const SizedBox(width: 4),
                      Text(
                        '${s.dayName ?? 'Day'}: ${s.formattedTime ?? '${s.startTime}-${s.endTime}'}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInstructorCard(ActivityInstructorModel ins, bool isDark) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181B26) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF2A2E3D) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: ActivityDetailScreen._primary.withValues(alpha: 0.15),
            backgroundImage: ins.photoUrl != null ? NetworkImage(ins.photoUrl!) : null,
            child: ins.photoUrl == null
                ? Text(ins.name.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: ActivityDetailScreen._primary))
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            ins.name,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            ins.title ?? 'Trainer',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeePlanCard(ActivityModel activity, FeePlanModel fp, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181B26) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF2A2E3D) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fp.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 2),
                Text(
                  '${fp.intervalCount} ${fp.interval} access pass',
                  style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Text(
            '₹${fp.amount.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: ActivityDetailScreen._primary),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => EnrollActivitySheet.show(context, activity: activity, initialFeePlan: fp),
            style: ElevatedButton.styleFrom(
              backgroundColor: ActivityDetailScreen._primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('Enroll', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(
    BuildContext context,
    ActivityModel activity,
    AsyncValue<List<ActivityReviewModel>> reviewsAsync,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionHeader('Citizen Reviews', Icons.rate_review_rounded),
            TextButton.icon(
              onPressed: () => WriteActivityReviewSheet.show(
                context,
                activityId: activity.id,
                activityName: activity.name,
              ),
              icon: const Icon(Icons.edit_note_rounded, size: 18),
              label: const Text('Write Review', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        reviewsAsync.when(
          data: (reviews) {
            if (reviews.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF181B26) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? const Color(0xFF2A2E3D) : const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  'No reviews yet. Be the first citizen to leave a review!',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              );
            }

            return Column(
              children: reviews.map((r) => _buildReviewTile(r, isDark)).toList(),
            );
          },
          loading: () => const Center(child: LoadingIndicator()),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildReviewTile(ActivityReviewModel review, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181B26) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF2A2E3D) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: ActivityDetailScreen._primary.withValues(alpha: 0.15),
                child: Text(
                  (review.userName ?? 'Citizen').substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ActivityDetailScreen._primary),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName ?? 'Citizen', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    if (review.timeAgo != null)
                      Text(review.timeAgo!, style: const TextStyle(fontSize: 10.5, color: Colors.grey)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 14,
                    color: const Color(0xFFF59E0B),
                  );
                }),
              ),
            ],
          ),
          if (review.title != null && review.title!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(review.title!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          ],
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              review.comment!,
              style: TextStyle(fontSize: 12.5, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
            ),
          ],
        ],
      ),
    );
  }
}
