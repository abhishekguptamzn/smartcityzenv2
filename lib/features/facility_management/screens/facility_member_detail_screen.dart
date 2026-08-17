import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/api/app_exception.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/show_confirm_dialog.dart';
import '../widgets/payment_detail_modal.dart';
import '../widgets/renew_member_modal.dart';
import 'facility_console_screen.dart';

final memberDetailsProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (FacilityKind, String, String)>((ref, args) async {
  final (kind, facilityId, memberId) = args;
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getMemberDetails(kind, facilityId, memberId);
});

final memberAttendanceReportProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (FacilityKind, String, String, String)>((ref, args) async {
  final (kind, facilityId, memberId, period) = args;
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getMemberAttendanceReport(kind, facilityId, memberId, period: period);
});

final memberPaymentsProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (FacilityKind, String, String)>((ref, args) async {
  final (kind, facilityId, memberId) = args;
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getMemberPayments(kind, facilityId, memberId);
});

class FacilityMemberDetailScreen extends ConsumerStatefulWidget {
  const FacilityMemberDetailScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    required this.memberId,
    this.facility,
    this.initialMember,
  });

  final FacilityKind kind;
  final String facilityId;
  final String memberId;
  final FacilityModel? facility;
  final Map<String, dynamic>? initialMember;

  @override
  ConsumerState<FacilityMemberDetailScreen> createState() => _FacilityMemberDetailScreenState();
}

class _FacilityMemberDetailScreenState extends ConsumerState<FacilityMemberDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedAttendancePeriod = 'month';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshAll() {
    ref.invalidate(memberDetailsProvider((widget.kind, widget.facilityId, widget.memberId)));
    ref.invalidate(memberAttendanceReportProvider((widget.kind, widget.facilityId, widget.memberId, _selectedAttendancePeriod)));
    ref.invalidate(memberPaymentsProvider((widget.kind, widget.facilityId, widget.memberId)));
  }

  Future<void> _openDirectCommunicationSheet(BuildContext context, Map<String, dynamic> member) async {
    final name = member['name'] ?? 'Member';
    final email = member['email'] ?? '';
    final subjectController = TextEditingController(text: 'Regarding Your Membership at ${widget.facility?.name ?? "Facility"}');
    final messageController = TextEditingController();
    bool isSending = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mail_outline_rounded, color: Color(0xFF2563EB), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Direct Communication', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text('To: $name ($email)', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    label: const Text('Expiring Pass Reminder', style: TextStyle(fontSize: 11)),
                    onPressed: () {
                      subjectController.text = 'Membership Renewal Reminder';
                      messageController.text = 'Dear $name,\n\nYour membership pass at ${widget.facility?.name ?? "our facility"} is expiring soon. Please renew your pass to ensure uninterrupted access.\n\nThank you!';
                      setSheetState(() {});
                    },
                  ),
                  ActionChip(
                    label: const Text('Payment Receipt', style: TextStyle(fontSize: 11)),
                    onPressed: () {
                      subjectController.text = 'Payment Confirmation & Receipt';
                      messageController.text = 'Dear $name,\n\nWe have received your membership fee. Thank you for your continued support.\n\nBest regards,\n${widget.facility?.name ?? "Management"}';
                      setSheetState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.subject_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Message Body',
                  hintText: 'Type your message to this member...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: isSending
                      ? null
                      : () async {
                          if (subjectController.text.trim().isEmpty || messageController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter both subject and message body.')),
                            );
                            return;
                          }

                          final confirm = await showAppConfirmDialog(
                            context: sheetContext,
                            title: 'Send Direct Email',
                            message: 'Are you sure you want to dispatch this email to $name?',
                            confirmLabel: 'Send Email',
                            details: [
                              ConfirmDetailRow(label: 'Member', value: name),
                              ConfirmDetailRow(label: 'Email', value: email),
                              ConfirmDetailRow(label: 'Subject', value: subjectController.text.trim()),
                            ],
                          );
                          if (!confirm) return;

                          setSheetState(() => isSending = true);
                          try {
                            await ref.read(clientFacilityRepositoryProvider).sendMemberDirectCommunication(
                                  widget.kind,
                                  widget.facilityId,
                                  widget.memberId,
                                  subject: subjectController.text.trim(),
                                  message: messageController.text.trim(),
                                );
                            if (!context.mounted) return;
                            Navigator.of(sheetContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Email dispatched successfully to $email!')),
                            );
                          } catch (e) {
                            final err = AppException.from(e);
                            setSheetState(() => isSending = false);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(err?.message ?? 'Failed to send email.')),
                            );
                          }
                        },
                  icon: isSending
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send_rounded),
                  label: Text(isSending ? 'Sending Email...' : 'Send Communication Email'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openRenewPassModal(Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RenewMemberModal(
        kind: widget.kind,
        facilityId: widget.facilityId,
        facility: widget.facility,
        member: {
          'id': widget.memberId,
          'user': member['user'] ?? {'name': member['name'], 'email': member['email']},
          'name': member['name'],
          'email': member['email'],
          'end_date': member['end_date'],
        },
        onSuccess: () {
          _refreshAll();
        },
      ),
    );
  }

  Future<void> _confirmRemoveMember(BuildContext context, Map<String, dynamic> member) async {
    final name = member['name'] ?? 'this member';
    final email = member['email'] ?? '';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Remove Member?'),
          ],
        ),
        content: Text(
          'Are you sure you want to remove $name ($email) from ${widget.facility?.name ?? "this facility"}?\n\nThis will disable their check-in access and send them a membership cancellation email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: const Text('Yes, Remove Member'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(clientFacilityRepositoryProvider).deleteMember(
              widget.kind,
              widget.facilityId,
              widget.memberId,
            );
        ref.invalidate(facilityStatsProvider((widget.kind, widget.facilityId)));
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name was removed and notified via email.')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        final err = AppException.from(e);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err?.message ?? 'Failed to remove member.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final primaryColor = widget.kind == FacilityKind.gym ? const Color(0xFF0D9488) : const Color(0xFF0284C7);

    final detailsAsync = ref.watch(memberDetailsProvider((widget.kind, widget.facilityId, widget.memberId)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Details & History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refreshAll,
          ),
        ],
      ),
      body: AmbientBackground(
        child: detailsAsync.when(
          data: (details) {
            final member = (details['member'] as Map<String, dynamic>?) ?? widget.initialMember ?? {};
            final name = member['name'] ?? 'Member';
            final email = member['email'] ?? '';
            final phone = member['phone'] ?? '';
            final status = member['status']?.toString() ?? 'active';
            final isActive = status.toLowerCase() == 'active';
            final passType = member['membership_type']?.toString().toUpperCase() ?? 'MONTHLY';
            final daysRemaining = member['days_remaining'];
            final endDateFormatted = member['end_date_formatted'] ?? member['end_date'] ?? 'N/A';

            return Column(
              children: [
                // Member Header Hero Card
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: primaryColor.withValues(alpha: 0.15),
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : 'M',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          name,
                                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: (isActive ? const Color(0xFF10B981) : Colors.redAccent).withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          status.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: isActive ? const Color(0xFF059669) : Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    phone.isNotEmpty ? '$email • $phone' : email,
                                    style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.card_membership_rounded, size: 14, color: primaryColor),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$passType Pass • Valid to $endDateFormatted',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: primaryColor),
                                      ),
                                      if (daysRemaining != null) ...[
                                        const SizedBox(width: 4),
                                        Text(
                                          '($daysRemaining d left)',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: (daysRemaining is num && daysRemaining <= 7) ? Colors.redAccent : Colors.grey.shade600,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Quick Action Buttons Row
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _openDirectCommunicationSheet(context, member),
                                icon: const Icon(Icons.mail_outline_rounded, size: 16),
                                label: const Text('Email Member', style: TextStyle(fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () => _openRenewPassModal(member),
                                icon: const Icon(Icons.autorenew_rounded, size: 16),
                                label: const Text('Renew Pass', style: TextStyle(fontSize: 12)),
                                style: FilledButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 3-Tab Navigator Bar
                Container(
                  color: theme.cardColor,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: primaryColor,
                    unselectedLabelColor: scheme.onSurfaceVariant,
                    indicatorColor: primaryColor,
                    tabs: const [
                      Tab(icon: Icon(Icons.timeline_rounded), text: 'Attendance & Charts'),
                      Tab(icon: Icon(Icons.receipt_long_rounded), text: 'Payments'),
                      Tab(icon: Icon(Icons.person_pin_rounded), text: 'Contact Details'),
                    ],
                  ),
                ),

                // Tab Views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Attendance Report & Daily Time Chart
                      _buildAttendanceTab(context, primaryColor),

                      // Tab 2: Payment History
                      _buildPaymentsTab(context, primaryColor),

                      // Tab 3: Contact & Removal
                      _buildContactTab(context, member),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
                  const SizedBox(height: 12),
                  Text('Failed to load member profile.', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: _refreshAll, child: const Text('Retry')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceTab(BuildContext context, Color primaryColor) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final reportAsync = ref.watch(memberAttendanceReportProvider((widget.kind, widget.facilityId, widget.memberId, _selectedAttendancePeriod)));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(memberAttendanceReportProvider((widget.kind, widget.facilityId, widget.memberId, _selectedAttendancePeriod)));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Period Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPeriodFilterChip('week', 'This Week'),
                const SizedBox(width: 8),
                _buildPeriodFilterChip('month', 'This Month'),
                const SizedBox(width: 8),
                _buildPeriodFilterChip('last_30_days', 'Last 30 Days'),
                const SizedBox(width: 8),
                _buildPeriodFilterChip('all', 'All Time'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          reportAsync.when(
            data: (data) {
              final summary = (data['summary'] as Map<String, dynamic>?) ?? {};
              final totalVisits = (summary['total_visits'] as num?)?.toInt() ?? 0;
              final totalMinutes = (summary['total_duration_minutes'] as num?)?.toInt() ?? 0;
              final avgDailyMinutes = (summary['avg_session_minutes'] as num?)?.toInt() ?? 0;
              final totalHours = (totalMinutes / 60).toStringAsFixed(1);

              final chartData = (data['chart_data'] as List? ?? []).cast<Map<String, dynamic>>();
              final records = (data['records'] as List? ?? []).cast<Map<String, dynamic>>();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Visits', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                              const SizedBox(height: 4),
                              Text('$totalVisits', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Time Spent', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                              const SizedBox(height: 4),
                              Text('$totalHours hrs', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D9488))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Avg Session', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                              const SizedBox(height: 4),
                              Text('$avgDailyMinutes m', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Daily Time Spent Chart Card
                  Text('Daily Time Spent Chart', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: chartData.isEmpty
                        ? const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('No session data in this period.')))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Minutes inside per visit', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 130,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: chartData.map((item) {
                                    final minutes = (item['duration_minutes'] as num?)?.toDouble() ?? 0.0;
                                    final label = item['day_label']?.toString() ?? '';
                                    const maxScale = 180.0; // 3 hours max scale
                                    final heightFactor = (minutes / maxScale).clamp(0.08, 1.0);

                                    return Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${minutes.toInt()}m',
                                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            height: 80 * heightFactor,
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  primaryColor.withValues(alpha: 0.7),
                                                  primaryColor,
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            label,
                                            style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Session Logs
                  Text('Session Check-in Logs', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  if (records.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Center(child: Text('No attendance logs found for this filter.', style: TextStyle(color: scheme.onSurfaceVariant))),
                    )
                  else
                    ...records.map((r) {
                      final dateStr = r['date'] ?? '';
                      final inTime = r['check_in_time'] ?? '--';
                      final outTime = r['check_out_time'] ?? 'Active Inside';
                      final duration = r['duration_minutes'];
                      final isCurrentlyInside = r['is_inside'] == true;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: (isCurrentlyInside ? const Color(0xFF10B981) : primaryColor).withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isCurrentlyInside ? Icons.sensors_rounded : Icons.login_rounded,
                                size: 18,
                                color: isCurrentlyInside ? const Color(0xFF10B981) : primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(dateStr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  const SizedBox(height: 2),
                                  Text('In: $inTime • Out: $outTime', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: (isCurrentlyInside ? const Color(0xFF10B981) : Colors.grey.shade300).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isCurrentlyInside ? 'INSIDE' : (duration != null ? '${duration}m' : '--'),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrentlyInside ? const Color(0xFF059669) : Colors.black87,
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
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            error: (err, _) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('Failed to load attendance report: $err'))),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodFilterChip(String periodKey, String label) {
    final isSelected = _selectedAttendancePeriod == periodKey;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedAttendancePeriod = periodKey);
        }
      },
    );
  }

  Widget _buildPaymentsTab(BuildContext context, Color primaryColor) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final paymentsAsync = ref.watch(memberPaymentsProvider((widget.kind, widget.facilityId, widget.memberId)));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(memberPaymentsProvider((widget.kind, widget.facilityId, widget.memberId)));
      },
      child: paymentsAsync.when(
        data: (data) {
          final rawPayments = data['payments'] ?? data['data'];
          final payments = (rawPayments is List ? rawPayments : []).cast<Map<String, dynamic>>();
          final totalCollected = (data['total_collected'] as num?)?.toDouble() ??
              payments.fold<double>(0.0, (sum, p) => sum + ((p['amount'] as num?)?.toDouble() ?? 0.0));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.85),
                      primaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 32),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Revenue Collected', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        Text('₹${totalCollected.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment Invoices & Receipts', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  if (payments.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${payments.length} Records',
                        style: const TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (payments.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.receipt_long_rounded, size: 40, color: scheme.onSurfaceVariant.withValues(alpha: 0.6)),
                        const SizedBox(height: 8),
                        Text('No payment records logged yet.', style: TextStyle(color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                )
              else
                ...payments.map((p) {
                  final amount = (p['amount'] as num?)?.toDouble() ?? 0.0;
                  final method = (p['payment_method'] ?? 'cash').toString().toUpperCase();
                  final date = p['created_at_formatted'] ?? p['paid_at_formatted'] ?? p['created_at'] ?? p['date'] ?? '';
                  final invoiceNo = p['invoice_number'] ?? (p['id'] != null ? 'INV-${p["id"]}' : 'INV-PAID');
                  final planName = p['plan_name'] ?? p['notes'] ?? 'Membership Pass';
                  final txnRef = p['transaction_reference']?.toString();

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        showPaymentDetailModal(
                          context: context,
                          kind: widget.kind,
                          facilityId: widget.facilityId,
                          paymentId: (p['id'] ?? '').toString(),
                          initialData: p,
                          facility: widget.facility,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.receipt_rounded, color: Color(0xFF10B981), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(planName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                                  const SizedBox(height: 2),
                                  Text('$invoiceNo • $date', style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant)),
                                  const SizedBox(height: 2),
                                  Text('Paid via $method${txnRef != null && txnRef.isNotEmpty ? " • $txnRef" : ""}', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant.withValues(alpha: 0.8))),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹${amount.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF059669)),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('View', style: TextStyle(fontSize: 11, color: scheme.primary, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 2),
                                    Icon(Icons.chevron_right_rounded, size: 14, color: scheme.primary),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            ],
          );
        },
        loading: () => const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
        error: (err, _) => Center(child: Padding(padding: const EdgeInsets.all(16), child: Text('Failed to load payments: $err'))),
      ),
    );
  }

  Widget _buildContactTab(BuildContext context, Map<String, dynamic> member) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final name = member['name'] ?? 'N/A';
    final email = member['email'] ?? 'N/A';
    final phone = member['phone'] ?? 'N/A';
    final city = member['city'] ?? member['city_name'] ?? 'N/A';
    final address = member['address'] ?? 'N/A';
    final joinedAt = member['created_at_formatted'] ?? member['start_date'] ?? 'N/A';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact & Location Information', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.person_outline_rounded, 'Full Name', name),
              const Divider(height: 20),
              _buildInfoRow(
                Icons.email_outlined,
                'Email Address',
                email,
                trailing: IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: email));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email copied to clipboard!')));
                  },
                ),
              ),
              const Divider(height: 20),
              _buildInfoRow(
                Icons.phone_outlined,
                'Phone Number',
                phone,
                trailing: IconButton(
                  icon: const Icon(Icons.call_outlined, size: 18, color: Color(0xFF0D9488)),
                  onPressed: () async {
                    final uri = Uri.parse('tel:$phone');
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  },
                ),
              ),
              const Divider(height: 20),
              _buildInfoRow(Icons.location_city_rounded, 'City', city),
              const Divider(height: 20),
              _buildInfoRow(Icons.place_outlined, 'Address', address),
              const Divider(height: 20),
              _buildInfoRow(Icons.calendar_today_outlined, 'Member Since', joinedAt),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Danger Zone: Member Removal
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_rounded, color: Colors.redAccent, size: 20),
                  const SizedBox(width: 8),
                  Text('Danger Zone', style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Removing this member will immediately revoke facility access, delete active passes, and dispatch an email cancellation notice.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmRemoveMember(context, member),
                  icon: const Icon(Icons.person_remove_rounded, color: Colors.redAccent),
                  label: const Text('Remove & Deactivate Member', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Widget? trailing}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }
}
