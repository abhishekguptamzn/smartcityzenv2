import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/providers/facilities_providers.dart';
import '../../../core/providers/facility_member_providers.dart';
import '../../../core/providers/gym_attendance_providers.dart';
import '../../../core/providers/payments_providers.dart';

import '../../../data/models/facility_member_model.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/models/payment_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../data/repositories/gym_attendance_repository.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_state_view.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../checkin/gym_checkin_qr_payload.dart';

final memberCheckInHistoryProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, (FacilityKind, String, String)>((ref, args) async {
  final (kind, facilityId, memberId) = args;
  final repo = ref.watch(clientFacilityRepositoryProvider);
  final report = await repo.getMemberAttendanceReport(kind, facilityId, memberId, period: 'all');
  final rawRecords = report['records'] ?? report['sessions'] ?? report['attendance'] ?? [];
  if (rawRecords is List) {
    return rawRecords.cast<Map<String, dynamic>>();
  }
  return [];
});

// ────────────────────────────────────────────────────────────────────────────
// Screen
// ────────────────────────────────────────────────────────────────────────────

class MembershipDetailsScreen extends ConsumerStatefulWidget {
  const MembershipDetailsScreen({
    super.key,
    required this.kind,
    required this.memberId,
    this.facilityId,
    this.facilityName,
  });

  final FacilityKind kind;
  final String memberId;
  final String? facilityId;
  final String? facilityName;

  @override
  ConsumerState<MembershipDetailsScreen> createState() =>
      _MembershipDetailsScreenState();
}

class _MembershipDetailsScreenState
    extends ConsumerState<MembershipDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasFacilityId = widget.facilityId != null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/services');
            }
          },
        ),
        title: Text(
          widget.facilityName ?? l10n.membershipDetails,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: !hasFacilityId
          ? const Center(child: Text('Facility details unavailable'))
          : Consumer(
              builder: (context, ref, _) {
                final memberAsync = ref.watch(
                  facilityMemberDetailProvider(
                    widget.kind,
                    widget.facilityId!,
                    widget.memberId,
                  ),
                );
                return memberAsync.when(
                  loading: () => const LoadingIndicator(),
                  error: (err, _) => ErrorStateView(
                    error: err,
                    onRetry: () => ref.invalidate(
                      facilityMemberDetailProvider(
                        widget.kind,
                        widget.facilityId!,
                        widget.memberId,
                      ),
                    ),
                  ),
                  data: (member) => _MembershipBody(
                    member: member,
                    kind: widget.kind,
                    facilityId: widget.facilityId!,
                    tabController: _tabController,
                  ),
                );
              },
            ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Body
// ────────────────────────────────────────────────────────────────────────────

class _MembershipBody extends StatelessWidget {
  const _MembershipBody({
    required this.member,
    required this.kind,
    required this.facilityId,
    required this.tabController,
  });

  final FacilityMemberModel member;
  final FacilityKind kind;
  final String facilityId;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeroCard(member: member, kind: kind),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            tabs: const [
              _Tab(icon: Icons.dashboard_rounded, label: 'Overview'),
              _Tab(icon: Icons.access_time_rounded, label: 'Check-ins'),
              _Tab(icon: Icons.receipt_long_rounded, label: 'Payments'),
              _Tab(icon: Icons.autorenew_rounded, label: 'Renewals'),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _OverviewTab(
                member: member,
                kind: kind,
                facilityId: facilityId,
              ),
              _CheckInTab(
                kind: kind,
                facilityId: facilityId,
                memberId: member.id,
              ),
              _PaymentsTab(payableId: member.id),
              _RenewalsTab(
                kind: kind,
                facilityId: facilityId,
                memberId: member.id,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Hero card
// ────────────────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.member, required this.kind});

  final FacilityMemberModel member;
  final FacilityKind kind;

  @override
  Widget build(BuildContext context) {
    final isGym = kind == FacilityKind.gym;
    final isActivity = kind == FacilityKind.activity;
    final isActive = member.isActive && !member.isExpired;
    final endDateStr = member.endDate != null
        ? DateFormat.yMMMd().format(member.endDate!)
        : 'N/A';

    int? daysLeft;
    if (member.endDate != null) {
      daysLeft = member.endDate!.difference(DateTime.now()).inDays;
    }

    final gradientColors = isGym
        ? [const Color(0xFF0F2A5E), const Color(0xFF1A4A8A), const Color(0xFF2563EB)]
        : (isActivity
            ? [const Color(0xFF4C1D95), const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
            : [const Color(0xFF064E3B), const Color(0xFF059669), const Color(0xFF10B981)]);

    final shadowColor = isGym ? const Color(0xFF2563EB) : (isActivity ? const Color(0xFF8B5CF6) : const Color(0xFF059669));
    final headerIcon = isGym ? Icons.fitness_center_rounded : (isActivity ? Icons.sports_rounded : Icons.local_library_rounded);
    final String defaultTypeName = isGym ? 'GYM' : (isActivity ? 'ACTIVITY ACADEMY' : 'LIBRARY');
    final String tierFormatted = (member.membershipType != null && member.membershipType!.toLowerCase() != 'none' && member.membershipType!.trim().isNotEmpty) ? member.membershipType!.toUpperCase() : defaultTypeName;
    final String headingText = isGym ? 'Gym Membership' : (isActivity ? 'Activity Academy Pass' : 'Library Membership');

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 100, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradientColors),
        boxShadow: [BoxShadow(color: shadowColor.withValues(alpha: 0.4), blurRadius: 32, offset: const Offset(0, 14))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white.withValues(alpha: 0.3))),
                child: Row(
                  children: [
                    Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? const Color(0xFF34D399) : const Color(0xFFF87171))),
                    const SizedBox(width: 6),
                    Text(isActive ? 'ACTIVE' : 'EXPIRED', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.8)),
                  ],
                ),
              ),
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.25))),
                child: Icon(headerIcon, color: Colors.white, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(tierFormatted, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.4)),
          const SizedBox(height: 4),
          Text(headingText, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Member ID: ${member.id}', style: const TextStyle(color: Colors.white60, fontSize: 11)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _HeroStat(label: 'Valid Until', value: endDateStr, icon: Icons.calendar_today_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _HeroStat(label: daysLeft != null && daysLeft >= 0 ? 'Days Left' : 'Expired', value: daysLeft != null ? (daysLeft >= 0 ? '$daysLeft days' : '${daysLeft.abs()} days ago') : 'N/A', icon: Icons.hourglass_bottom_rounded, valueColor: daysLeft != null && daysLeft < 7 && daysLeft >= 0 ? const Color(0xFFFBBF24) : null)),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value, required this.icon, this.valueColor});
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.15))),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(color: valueColor ?? Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Overview Tab
// ────────────────────────────────────────────────────────────────────────────

IconData _getAmenityIcon(String name) {
  final lower = name.toLowerCase();
  if (lower.contains('wifi') || lower.contains('wi-fi') || lower.contains('internet')) return Icons.wifi_rounded;
  if (lower.contains('ac') || lower.contains('air') || lower.contains('cooling')) return Icons.ac_unit_rounded;
  if (lower.contains('parking')) return Icons.local_parking_rounded;
  if (lower.contains('shower') || lower.contains('bath')) return Icons.shower_rounded;
  if (lower.contains('locker')) return Icons.lock_rounded;
  if (lower.contains('water') || lower.contains('drink')) return Icons.water_drop_rounded;
  if (lower.contains('treadmill') || lower.contains('cardio') || lower.contains('gym') || lower.contains('fitness')) return Icons.fitness_center_rounded;
  if (lower.contains('book') || lower.contains('read') || lower.contains('study') || lower.contains('library')) return Icons.menu_book_rounded;
  if (lower.contains('cafe') || lower.contains('coffee') || lower.contains('canteen') || lower.contains('tea')) return Icons.local_cafe_rounded;
  if (lower.contains('trainer') || lower.contains('coach') || lower.contains('instructor')) return Icons.sports_rounded;
  if (lower.contains('pool') || lower.contains('swim')) return Icons.pool_rounded;
  if (lower.contains('cctv') || lower.contains('security')) return Icons.security_rounded;
  if (lower.contains('power') || lower.contains('charging') || lower.contains('socket')) return Icons.power_rounded;
  return Icons.check_circle_outline_rounded;
}

class _OverviewTab extends ConsumerWidget {
  const _OverviewTab({
    required this.member,
    required this.kind,
    required this.facilityId,
  });

  final FacilityMemberModel member;
  final FacilityKind kind;
  final String facilityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final isGym = kind == FacilityKind.gym;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    final startStr = member.startDate != null ? DateFormat.yMMMd().format(member.startDate!) : 'N/A';
    final endStr = member.endDate != null ? DateFormat.yMMMd().format(member.endDate!) : 'N/A';
    int? daysLeft;
    if (member.endDate != null) daysLeft = member.endDate!.difference(DateTime.now()).inDays;
    final tierText = (member.membershipType != null && member.membershipType!.toLowerCase() != 'none' && member.membershipType!.trim().isNotEmpty) ? member.membershipType!.toUpperCase() : 'STANDARD';

    final paymentsAsync = ref.watch(paymentListProvider(const PaymentListParams()));
    final List<PaymentModel> allPayments = paymentsAsync.when(
      data: (v) => v,
      loading: () => const <PaymentModel>[],
      error: (_, _) => const <PaymentModel>[],
    );
    final memberPayments = allPayments.where((p) => p.payableId == member.id).toList();
    final totalPaid = memberPayments.fold<double>(0, (s, p) => s + (p.isPaid ? p.amount : 0));
    final paidCount = memberPayments.where((p) => p.isPaid).length;

    final facilityAsync = ref.watch(facilityDetailProvider(kind, facilityId));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        _SectionLabel('QUICK STATS'),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.1,
          children: [
            _StatCard(
              icon: Icons.payments_rounded,
              label: 'Total Paid',
              value: '₹${totalPaid.toStringAsFixed(0)}',
              color: const Color(0xFF10B981),
            ),
            _StatCard(
              icon: Icons.receipt_rounded,
              label: 'Transactions',
              value: '$paidCount',
              color: const Color(0xFF6366F1),
            ),
            _StatCard(
              icon: Icons.calendar_month_rounded,
              label: 'Member Since',
              value: member.startDate != null
                  ? DateFormat('MMM yyyy').format(member.startDate!)
                  : 'N/A',
              color: const Color(0xFF0EA5E9),
            ),
            _StatCard(
              icon: Icons.hourglass_bottom_rounded,
              label: 'Validity',
              value: daysLeft != null
                  ? (daysLeft >= 0 ? '$daysLeft Days' : 'Expired')
                  : (member.isActive ? 'Active' : 'Expired'),
              color: daysLeft != null && daysLeft < 7 && daysLeft >= 0
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFF8B5CF6),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SectionLabel('MEMBER INFORMATION'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4))),
          child: Column(
            children: [
              _DetailRow(icon: Icons.badge_rounded, label: 'Member ID', value: member.id, accent: const Color(0xFF6366F1)),
              _RowDivider(),
              _DetailRow(icon: Icons.workspace_premium_rounded, label: 'Membership Tier', value: tierText, accent: const Color(0xFFF59E0B)),
              _RowDivider(),
              _DetailRow(icon: isGym ? Icons.fitness_center_rounded : Icons.local_library_rounded, label: 'Facility Type', value: kind.name.toUpperCase(), accent: const Color(0xFF2563EB)),
              _RowDivider(),
              _DetailRow(icon: Icons.login_rounded, label: 'Start Date', value: startStr, accent: const Color(0xFF10B981)),
              _RowDivider(),
              _DetailRow(icon: Icons.logout_rounded, label: 'End Date', value: endStr, accent: const Color(0xFFEF4444)),
              _RowDivider(),
              _DetailRow(icon: Icons.hourglass_bottom_rounded, label: 'Validity', value: daysLeft != null ? (daysLeft >= 0 ? '$daysLeft days remaining' : 'Expired ${daysLeft.abs()} days ago') : 'Active', accent: const Color(0xFF8B5CF6)),
              _RowDivider(),
              _DetailRow(
                icon: Icons.info_rounded, label: 'Status', accent: member.isActive && !member.isExpired ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                customValue: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: (member.isActive && !member.isExpired ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)), child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: member.isActive && !member.isExpired ? const Color(0xFF10B981) : const Color(0xFFEF4444))), const SizedBox(width: 5), Text(member.isActive && !member.isExpired ? 'ACTIVE' : 'EXPIRED', style: TextStyle(color: member.isActive && !member.isExpired ? const Color(0xFF10B981) : const Color(0xFFEF4444), fontWeight: FontWeight.w700, fontSize: 11))])),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _SectionLabel('INCLUDED BENEFITS & AMENITIES'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
          ),
          child: facilityAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
            ),
            error: (_, _) => Column(
              children: [
                _BenefitRow(
                  icon: Icons.wifi_rounded,
                  label: 'High-speed Wi-Fi Access',
                  accent: const Color(0xFF0EA5E9),
                ),
                _RowDivider(),
                _BenefitRow(
                  icon: isGym
                      ? Icons.fitness_center_rounded
                      : (kind == FacilityKind.activity ? Icons.sports_rounded : Icons.menu_book_rounded),
                  label: isGym
                      ? 'Gym Floor Access'
                      : (kind == FacilityKind.activity ? 'Activity Academy Access' : 'Library Access'),
                  accent: const Color(0xFF2563EB),
                ),
                _RowDivider(),
                _BenefitRow(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Digital QR Check-in',
                  accent: const Color(0xFF8B5CF6),
                ),
              ],
            ),
            data: (facility) {
              final activeAmenities = (facility.amenities ?? [])
                  .where((a) => a.isEffectiveActive)
                  .toList();

              if (activeAmenities.isEmpty) {
                return Column(
                  children: [
                    _BenefitRow(
                      icon: Icons.wifi_rounded,
                      label: 'High-speed Wi-Fi Access',
                      accent: const Color(0xFF0EA5E9),
                    ),
                    _RowDivider(),
                    _BenefitRow(
                      icon: isGym
                          ? Icons.fitness_center_rounded
                          : (kind == FacilityKind.activity ? Icons.sports_rounded : Icons.menu_book_rounded),
                      label: isGym
                          ? 'Gym Floor Access'
                          : (kind == FacilityKind.activity ? 'Activity Academy Access' : 'Library Access'),
                      accent: const Color(0xFF2563EB),
                    ),
                    _RowDivider(),
                    _BenefitRow(
                      icon: Icons.qr_code_scanner_rounded,
                      label: 'Digital QR Check-in',
                      accent: const Color(0xFF8B5CF6),
                    ),
                  ],
                );
              }

              final accents = [
                const Color(0xFF0EA5E9),
                const Color(0xFF10B981),
                const Color(0xFF8B5CF6),
                const Color(0xFFF59E0B),
                const Color(0xFFEC4899),
                const Color(0xFF06B6D4),
              ];

              return Column(
                children: activeAmenities.asMap().entries.map((entry) {
                  final i = entry.key;
                  final a = entry.value;
                  return Column(
                    children: [
                      if (i > 0) _RowDivider(),
                      _BenefitRow(
                        icon: _getAmenityIcon(a.name),
                        label: a.name,
                        accent: accents[i % accents.length],
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.2, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)));
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label, this.value, this.customValue, required this.accent});
  final IconData icon; final String label; final String? value; final Widget? customValue; final Color accent;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), child: Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 18, color: accent)), const SizedBox(width: 14), Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65), fontWeight: FontWeight.w500))), const SizedBox(width: 8), if (customValue != null) customValue! else if (value != null) Flexible(child: Text(value!, textAlign: TextAlign.end, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis, maxLines: 2))]));
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.icon, required this.label, required this.accent});
  final IconData icon; final String label; final Color accent;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: Row(children: [Container(width: 34, height: 34, decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 17, color: accent)), const SizedBox(width: 14), Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)), const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18)]));
}

class _RowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(height: 1, indent: 64, color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4));
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.55),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Check-in History Tab
// ────────────────────────────────────────────────────────────────────────────

class _CheckInTab extends ConsumerWidget {
  const _CheckInTab({
    required this.kind,
    required this.facilityId,
    required this.memberId,
  });

  final FacilityKind kind;
  final String facilityId;
  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kind == FacilityKind.gym) {
      final attendanceAsync =
          ref.watch(memberAttendanceHistoryProvider(facilityId, memberId));

      return attendanceAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorStateView(
          error: error,
          onRetry: () =>
              ref.invalidate(memberAttendanceHistoryProvider(facilityId, memberId)),
        ),
        data: (records) {
          if (records.isEmpty) {
            return const EmptyStateView(
              icon: Icons.history_rounded,
              message: 'No check-in records yet.',
            );
          }

          final totalSessions = records.length;
          final totalSeconds =
              records.fold<int>(0, (s, r) => s + (r.duration ?? 0));
          final totalHours = totalSeconds ~/ 3600;
          final openSessions = records.where((r) => r.isOpenSession).length;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            children: [
              Row(
                children: [
                  _CheckInStat(
                    label: 'Sessions',
                    value: '$totalSessions',
                    icon: Icons.fitness_center_rounded,
                    color: const Color(0xFF6366F1),
                  ),
                  const SizedBox(width: 10),
                  _CheckInStat(
                    label: 'Total Hours',
                    value: '${totalHours}h',
                    icon: Icons.timer_rounded,
                    color: const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 10),
                  _CheckInStat(
                    label: 'Open',
                    value: '$openSessions',
                    icon: Icons.lock_open_rounded,
                    color: const Color(0xFFF59E0B),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionLabel('HISTORY'),
              const SizedBox(height: 10),
              ...records.asMap().entries.map((entry) {
                final i = entry.key;
                final r = entry.value;
                final isDark = Theme.of(context).brightness == Brightness.dark;
                final accent = r.isOpenSession
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF10B981);
                return Container(
                  margin: EdgeInsets.only(top: i == 0 ? 0 : 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: accent.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          r.isOpenSession
                              ? Icons.timer_rounded
                              : Icons.check_circle_rounded,
                          color: accent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.date != null
                                  ? DateFormat('EEE, d MMM yyyy')
                                      .format(r.date!)
                                  : 'Unknown date',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                if (r.checkInAt != null) ...[
                                  const Icon(Icons.login_rounded,
                                      size: 12, color: Color(0xFF10B981)),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('h:mm a').format(r.checkInAt!),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: const Color(0xFF10B981)),
                                  ),
                                ],
                                if (r.checkOutAt != null) ...[
                                  const SizedBox(width: 10),
                                  const Icon(Icons.logout_rounded,
                                      size: 12, color: Color(0xFFEF4444)),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('h:mm a').format(r.checkOutAt!),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: const Color(0xFFEF4444)),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          r.isOpenSession
                              ? 'Open'
                              : (r.formattedDuration ?? 'N/A'),
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      );
    }

    // For Library and Activity (or fallback)
    final historyAsync = ref.watch(memberCheckInHistoryProvider((kind, facilityId, memberId)));

    return historyAsync.when(
      loading: () => const LoadingIndicator(),
      error: (error, _) => ErrorStateView(
        error: error,
        onRetry: () =>
            ref.invalidate(memberCheckInHistoryProvider((kind, facilityId, memberId))),
      ),
      data: (records) {
        if (records.isEmpty) {
          return const EmptyStateView(
            icon: Icons.history_rounded,
            message: 'No check-in records yet.',
          );
        }

        final totalSessions = records.length;
        final totalMinutes = records.fold<int>(0, (s, r) => s + ((r['duration_minutes'] as num?)?.toInt() ?? 0));
        final totalHours = totalMinutes ~/ 60;
        final openSessions = records.where((r) => r['is_currently_inside'] == true).length;

        final IconData icon = kind == FacilityKind.library
            ? Icons.menu_book_rounded
            : Icons.sports_rounded;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            Row(
              children: [
                _CheckInStat(
                  label: 'Sessions',
                  value: '$totalSessions',
                  icon: icon,
                  color: const Color(0xFF6366F1),
                ),
                const SizedBox(width: 10),
                _CheckInStat(
                  label: 'Total Hours',
                  value: '${totalHours}h',
                  icon: Icons.timer_rounded,
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(width: 10),
                _CheckInStat(
                  label: 'Open',
                  value: '$openSessions',
                  icon: Icons.lock_open_rounded,
                  color: const Color(0xFFF59E0B),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionLabel('HISTORY'),
            const SizedBox(height: 10),
            ...records.asMap().entries.map((entry) {
              final i = entry.key;
              final r = entry.value;
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final isInside = r['is_currently_inside'] == true;
              final accent = isInside
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFF10B981);
              final checkInTime = r['check_in_time'] ?? '--';
              final checkOutTime = r['check_out_time'] ?? '--';
              final dateFormatted = r['date_formatted'] ?? r['date'] ?? 'Session';
              final durText = r['duration_text'] ?? (isInside ? 'In Session' : 'Recorded');

              return Container(
                margin: EdgeInsets.only(top: i == 0 ? 0 : 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: accent.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isInside
                            ? Icons.timer_rounded
                            : Icons.check_circle_rounded,
                        color: accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateFormatted.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.login_rounded,
                                  size: 12, color: Color(0xFF10B981)),
                              const SizedBox(width: 4),
                              Text(
                                checkInTime.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: const Color(0xFF10B981)),
                              ),
                              if (checkOutTime != '--' && !isInside) ...[
                                const SizedBox(width: 10),
                                const Icon(Icons.logout_rounded,
                                    size: 12, color: Color(0xFFEF4444)),
                                const SizedBox(width: 4),
                                Text(
                                  checkOutTime.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: const Color(0xFFEF4444)),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        durText.toString(),
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _CheckInStat extends StatelessWidget {
  const _CheckInStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: color)),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Payments Tab
// ────────────────────────────────────────────────────────────────────────────

class _PaymentsTab extends ConsumerWidget {
  const _PaymentsTab({required this.payableId});

  final String payableId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync =
        ref.watch(paymentListProvider(const PaymentListParams()));

    return paymentsAsync.when(
      loading: () => const LoadingIndicator(),
      error: (error, _) => ErrorStateView(error: error),
      data: (payments) {
        final filtered =
            payments.where((p) => p.payableId == payableId).toList();
        if (filtered.isEmpty) {
          return const EmptyStateView(
            icon: Icons.receipt_long_rounded,
            message: 'No payments recorded yet.',
          );
        }

        final totalPaid = filtered
            .fold<double>(0, (s, p) => s + (p.isPaid ? p.amount : 0));
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF064E3B), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet_rounded,
                      color: Colors.white, size: 30),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Paid',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 12)),
                      Text(
                        '₹${totalPaid.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${filtered.length} txns',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionLabel('TRANSACTIONS'),
            const SizedBox(height: 10),
            ...filtered.asMap().entries.map((entry) {
              final i = entry.key;
              final p = entry.value;
              final accent = p.isPaid
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444);
              return Container(
                margin: EdgeInsets.only(top: i == 0 ? 0 : 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accent.withValues(alpha: 0.2)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      p.isPaid
                          ? Icons.check_circle_rounded
                          : Icons.schedule_rounded,
                      color: accent,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    NumberFormat.currency(
                            symbol: '₹', decimalDigits: 0)
                        .format(p.amount),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.status.toUpperCase(),
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                      if (p.paidAt != null)
                        Text(
                          DateFormat('d MMM yyyy, h:mm a')
                              .format(p.paidAt!),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.5),
                              ),
                        ),
                    ],
                  ),
                  trailing: p.invoiceNumber != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '#${p.invoiceNumber}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.4),
                                  ),
                            ),
                            const Icon(Icons.chevron_right_rounded,
                                size: 16),
                          ],
                        )
                      : const Icon(Icons.chevron_right_rounded, size: 16),
                  onTap: () => context.push('/payments/${p.id}'),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Renewals Tab
// ────────────────────────────────────────────────────────────────────────────

class _RenewalsTab extends ConsumerWidget {
  const _RenewalsTab({
    required this.kind,
    required this.facilityId,
    required this.memberId,
  });

  final FacilityKind kind;
  final String facilityId;
  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final renewalsAsync =
        ref.watch(memberRenewalsProvider(kind, facilityId, memberId));

    return renewalsAsync.when(
      loading: () => const LoadingIndicator(),
      error: (error, _) => ErrorStateView(
        error: error,
        onRetry: () =>
            ref.invalidate(memberRenewalsProvider(kind, facilityId, memberId)),
      ),
      data: (renewals) {
        if (renewals.isEmpty) {
          return const EmptyStateView(
            icon: Icons.autorenew_rounded,
            message: 'No renewal history yet.',
          );
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            _SectionLabel('RENEWAL HISTORY'),
            const SizedBox(height: 10),
            ...renewals.asMap().entries.map((entry) {
              final i = entry.key;
              final r = entry.value;
              const accent = Color(0xFF8B5CF6);
              return Container(
                margin: EdgeInsets.only(top: i == 0 ? 0 : 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: accent.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.autorenew_rounded,
                          color: accent, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.createdAt != null
                                ? DateFormat('d MMM yyyy')
                                    .format(r.createdAt!)
                                : 'N/A',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          if (r.newEndDate != null)
                            Text(
                              'New expiry: ${DateFormat('d MMM yyyy').format(r.newEndDate!)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                            ),
                          if (r.extendedInterval != null)
                            Text(
                              '+${r.extendedCount} ${r.extendedInterval}',
                              style: const TextStyle(
                                color: accent,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${r.amountPaid.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: accent,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Check-in bottom sheet
// ────────────────────────────────────────────────────────────────────────────

class _CheckInSheet extends ConsumerStatefulWidget {
  const _CheckInSheet({required this.gymId, required this.member});

  final String gymId;
  final FacilityMemberModel member;

  @override
  ConsumerState<_CheckInSheet> createState() => _CheckInSheetState();
}

class _CheckInSheetState extends ConsumerState<_CheckInSheet> {
  bool _submitting = false;
  String? _resultMessage;
  bool _success = false;

  Future<void> _checkInNow() async {
    setState(() => _submitting = true);
    try {
      await ref
          .read(gymAttendanceRepositoryProvider)
          .checkIn(widget.gymId, memberId: widget.member.id);
      if (!mounted) return;
      setState(() {
        _resultMessage = 'Checked in successfully!';
        _success = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _resultMessage = 'Failed to check in. Please try again.';
        _success = false;
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Quick Gym Check-In',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Show this QR code at the gym entrance',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: QrImageView(
                data: GymCheckInQrPayload(
                  gymId: widget.gymId,
                  memberId: widget.member.id,
                ).encode(),
                size: 200,
              ),
            ),
            const SizedBox(height: 20),
            if (_resultMessage != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: (_success ? Colors.green : Colors.red)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (_success ? Colors.green : Colors.red)
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _success
                          ? Icons.check_circle_rounded
                          : Icons.error_rounded,
                      color: _success ? Colors.green : Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _resultMessage!,
                      style: TextStyle(
                        color: _success ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _submitting ? null : _checkInNow,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.login_rounded),
                label: Text(
                  _submitting ? 'Checking in...' : 'Confirm Check-In',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

