import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/providers/facility_member_providers.dart';
import '../../../core/providers/gym_attendance_providers.dart';
import '../../../core/providers/payments_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/facility_member_model.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/repositories/gym_attendance_repository.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../checkin/gym_checkin_qr_payload.dart';

class MembershipDetailsScreen extends ConsumerStatefulWidget {
  const MembershipDetailsScreen({
    super.key,
    required this.kind,
    required this.memberId,
    this.facilityId,
  });

  final FacilityKind kind;
  final String memberId;
  final String? facilityId;

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
    final tabCount = widget.kind == FacilityKind.gym ? 3 : 2;
    _tabController = TabController(length: tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showCheckInSheet(
    BuildContext context,
    FacilityMemberModel member,
  ) async {
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) =>
          _CheckInSheet(gymId: widget.facilityId!, member: member, l10n: l10n),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasFacilityId = widget.facilityId != null;

    return Scaffold(
      appBar: AppBar(
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
        title: Text(l10n.membershipDetails),
      ),
      body: AmbientBackground(
        child: !hasFacilityId
            ? _DegradedView(l10n: l10n)
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
                    error: (_, _) => _DegradedView(l10n: l10n),
                    data: (member) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: _MembershipHeroCard(
                            member: member,
                            kind: widget.kind,
                            onCheckIn:
                                widget.kind == FacilityKind.gym &&
                                    member.isActive
                                ? () => _showCheckInSheet(context, member)
                                : null,
                          ),
                        ),
                        TabBar(
                          controller: _tabController,
                          tabs: [
                            Tab(text: l10n.details),
                            if (widget.kind == FacilityKind.gym)
                              Tab(text: l10n.attendance),
                            Tab(text: l10n.payments),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _DetailsTab(member: member),
                              if (widget.kind == FacilityKind.gym)
                                _AttendanceTab(
                                  gymId: widget.facilityId!,
                                  memberId: widget.memberId,
                                ),
                              _PaymentsTab(payableId: widget.memberId),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _DegradedView extends StatelessWidget {
  const _DegradedView({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      icon: Icons.support_agent_rounded,
      message: l10n.contactStaffBody,
    );
  }
}

class _MembershipHeroCard extends StatelessWidget {
  const _MembershipHeroCard({
    required this.member,
    required this.kind,
    this.onCheckIn,
  });

  final FacilityMemberModel member;
  final FacilityKind kind;
  final VoidCallback? onCheckIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final colors = context.appColors;
    final dateStr = member.endDate != null
        ? DateFormat.yMMMd().format(member.endDate!)
        : '—';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.idCardGradientStart, colors.idCardGradientEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: colors.idCardGlow.withValues(alpha: 0.3),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.idCardGlow.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  member.membershipType?.toUpperCase() ?? '',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.idCardGlow,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  kind == FacilityKind.library
                      ? Icons.local_library_rounded
                      : Icons.fitness_center_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            member.user?.city?.name ?? l10n.cityzenIdentity,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          if (member.startDate != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: Colors.white60,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.joined(DateFormat.yMMMd().format(member.startDate!)),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          Text(
            l10n.validityStatus.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white54,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: (member.isActive ? scheme.error : scheme.error).withValues(
                alpha: member.isActive ? 0.16 : 0.24,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: (member.isActive ? colors.idCardGlow : scheme.error)
                    .withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.validUntil(dateStr),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: member.isActive ? colors.idCardGlow : scheme.error,
                  ),
                ),
                Icon(
                  member.isActive
                      ? Icons.check_circle_rounded
                      : Icons.error_outline_rounded,
                  color: member.isActive ? colors.idCardGlow : scheme.error,
                  size: 20,
                ),
              ],
            ),
          ),
          if (onCheckIn != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onCheckIn,
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.onSurface,
                  foregroundColor: scheme.surface,
                ),
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: Text(l10n.quickCheckIn),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailsTab extends StatelessWidget {
  const _DetailsTab({required this.member});

  final FacilityMemberModel member;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final startStr = member.startDate != null
        ? DateFormat.yMMMd().format(member.startDate!)
        : '—';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoSection(
          title: l10n.memberInformation,
          children: [
            _Row(label: l10n.memberId, value: member.id),
            const SizedBox(height: 12),
            _Row(label: l10n.tier, value: member.membershipType ?? '—'),
            const SizedBox(height: 12),
            _Row(label: l10n.joined(startStr), value: ''),
            const SizedBox(height: 12),
            _Row(label: l10n.status, value: member.status),
          ],
        ),
        const SizedBox(height: 16),
        _InfoSection(
          title: l10n.amenities,
          children: [
            _AmenityRow(
              icon: Icons.wifi_rounded,
              label: l10n.freeWifi,
              accent: scheme.secondary,
            ),
            const SizedBox(height: 12),
            _AmenityRow(
              icon: member.facilityKind == FacilityKind.library
                  ? Icons.menu_book_rounded
                  : Icons.fitness_center_rounded,
              label: member.facilityKind == FacilityKind.library
                  ? l10n.libraries
                  : l10n.gyms,
              accent: scheme.primary,
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(letterSpacing: 0.8),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _AmenityRow extends StatelessWidget {
  const _AmenityRow({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: accent),
        ),
        const SizedBox(width: 12),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        if (value.isNotEmpty)
          Text(value, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}

class _AttendanceTab extends ConsumerWidget {
  const _AttendanceTab({required this.gymId, required this.memberId});

  final String gymId;
  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final attendanceAsync = ref.watch(
      memberAttendanceHistoryProvider(gymId, memberId),
    );

    return attendanceAsync.when(
      loading: () => const LoadingIndicator(),
      error: (error, _) => ErrorStateView(
        error: error,
        onRetry: () =>
            ref.invalidate(memberAttendanceHistoryProvider(gymId, memberId)),
      ),
      data: (records) {
        if (records.isEmpty) {
          return EmptyStateView(
            icon: Icons.history_rounded,
            message: l10n.noResultsFound,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: records.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final r = records[i];
            final scheme = Theme.of(context).colorScheme;
            final accent = r.isOpenSession ? scheme.tertiary : scheme.secondary;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: accent.withValues(alpha: 0.14),
                  child: Icon(
                    r.isOpenSession
                        ? Icons.timer_rounded
                        : Icons.check_circle_rounded,
                    color: accent,
                    size: 20,
                  ),
                ),
                title: Text(
                  r.date != null ? DateFormat.yMMMd().format(r.date!) : '—',
                ),
                subtitle: Text(r.formattedDuration ?? '—'),
              ),
            );
          },
        );
      },
    );
  }
}

class _PaymentsTab extends ConsumerWidget {
  const _PaymentsTab({required this.payableId});

  final String payableId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final paymentsAsync = ref.watch(
      paymentListProvider(const PaymentListParams()),
    );

    return paymentsAsync.when(
      loading: () => const LoadingIndicator(),
      error: (error, _) => ErrorStateView(error: error),
      data: (payments) {
        final filtered = payments
            .where((p) => p.payableId == payableId)
            .toList();
        if (filtered.isEmpty) {
          return EmptyStateView(
            icon: Icons.receipt_long_rounded,
            message: l10n.noPaymentsYet,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final p = filtered[i];
            final scheme = Theme.of(context).colorScheme;
            final accent = p.isPaid ? scheme.secondary : scheme.error;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: accent.withValues(alpha: 0.14),
                  child: Icon(
                    p.isPaid ? Icons.check_rounded : Icons.schedule_rounded,
                    color: accent,
                    size: 20,
                  ),
                ),
                title: Text(
                  NumberFormat.currency(
                    name: p.currency,
                    decimalDigits: 0,
                  ).format(p.amount),
                ),
                subtitle: Text(p.status),
                onTap: () =>
                    Navigator.of(context).pushNamed('/payments/${p.id}'),
              ),
            );
          },
        );
      },
    );
  }
}

class _CheckInSheet extends ConsumerStatefulWidget {
  const _CheckInSheet({
    required this.gymId,
    required this.member,
    required this.l10n,
  });

  final String gymId;
  final FacilityMemberModel member;
  final AppLocalizations l10n;

  @override
  ConsumerState<_CheckInSheet> createState() => _CheckInSheetState();
}

class _CheckInSheetState extends ConsumerState<_CheckInSheet> {
  bool _submitting = false;
  String? _resultMessage;

  Future<void> _checkInNow() async {
    setState(() => _submitting = true);
    try {
      await ref
          .read(gymAttendanceRepositoryProvider)
          .checkIn(widget.gymId, memberId: widget.member.id);
      if (!mounted) return;
      setState(() => _resultMessage = widget.l10n.quickCheckIn);
    } catch (_) {
      if (!mounted) return;
      setState(() => _resultMessage = widget.l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.l10n.quickCheckIn,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            QrImageView(
              data: GymCheckInQrPayload(
                gymId: widget.gymId,
                memberId: widget.member.id,
              ).encode(),
              size: 180,
            ),
            const SizedBox(height: 20),
            if (_resultMessage != null) ...[
              Text(
                _resultMessage!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitting ? null : _checkInNow,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(widget.l10n.quickCheckIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
