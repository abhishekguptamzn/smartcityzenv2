import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/show_confirm_dialog.dart';
import '../widgets/facility_qr_modal.dart';
import '../widgets/renew_member_modal.dart';
import 'facility_dashboard_screen.dart';
import 'facility_member_detail_screen.dart';

final facilityCheckinMembersProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, (FacilityKind, String, String)>(
        (ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  final kind = args.$1;
  final id = args.$2;
  final search = args.$3;

  if (kind == FacilityKind.gym) {
    return repo.getGymMembers(id, search: search);
  } else {
    return repo.getLibraryMembers(id, search: search);
  }
});

final facilityLiveOccupancyProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, (FacilityKind, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getCurrentStatus(args.$1, args.$2);
});

enum CheckinFilter { all, insideNow, expiringSoon, outside }

class FacilityManualCheckinScreen extends ConsumerStatefulWidget {
  const FacilityManualCheckinScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilityManualCheckinScreen> createState() =>
      _FacilityManualCheckinScreenState();
}

class _FacilityManualCheckinScreenState
    extends ConsumerState<FacilityManualCheckinScreen> {
  final _searchController = TextEditingController();
  final _quickCodeController = TextEditingController();
  String _searchQuery = '';
  CheckinFilter _activeFilter = CheckinFilter.all;
  final Set<String> _loadingMemberIds = {};
  final Set<String> _recentlyCheckedInIds = {};
  final Set<String> _recentlyCheckedOutIds = {};
  bool _quickActionLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    _quickCodeController.dispose();
    super.dispose();
  }

  void _refreshAll() {
    ref.invalidate(
        facilityCheckinMembersProvider((widget.kind, widget.facilityId, _searchQuery)));
    ref.invalidate(
        facilityLiveOccupancyProvider((widget.kind, widget.facilityId)));
    ref.invalidate(
        facilityStatsProvider((widget.kind, widget.facilityId)));
  }

  Future<void> _handleCheckin(Map<String, dynamic> member, {bool allowOverride = false}) async {
    final memberId = member['id']?.toString() ?? '';
    if (memberId.isEmpty) return;

    final userName = member['user']?['name'] ?? member['name'] ?? 'Member';
    final endStr = member['end_date']?.toString();
    DateTime? endDate;
    if (endStr != null && endStr.isNotEmpty) {
      endDate = DateTime.tryParse(endStr);
    }
    final now = DateTime.now();
    final isExpired = endDate != null && endDate.isBefore(now);

    if (isExpired && !allowOverride) {
      final formattedEnd = DateFormat('d MMM yyyy').format(endDate);
      final proceed = await showAppConfirmDialog(
        context: context,
        title: 'Membership Expired',
        message:
            '$userName\'s membership pass expired on $formattedEnd. Log desk check-in anyway as manager override?',
        confirmLabel: 'Allow Check-in',
        cancelLabel: 'Cancel',
        type: ConfirmDialogType.warning,
        details: [
          ConfirmDetailRow(label: 'Member', value: userName),
          ConfirmDetailRow(
              label: 'Expired On', value: formattedEnd, isHighlighted: true),
        ],
      );
      if (!proceed) return;
      allowOverride = true;
    }

    setState(() => _loadingMemberIds.add(memberId));

    try {
      HapticFeedback.lightImpact();
      final res = await ref.read(clientFacilityRepositoryProvider).checkIn(
            widget.kind,
            widget.facilityId,
            memberId: memberId,
            allowOverride: allowOverride,
          );

      final already = res['already_checked_in'] == true;

      setState(() {
        _recentlyCheckedInIds.add(memberId);
        _recentlyCheckedOutIds.remove(memberId);
      });

      _refreshAll();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                already
                    ? Icons.info_outline_rounded
                    : Icons.check_circle_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  already
                      ? '$userName is already checked in.'
                      : '✅ $userName checked in successfully!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor:
              already ? const Color(0xFFD97706) : const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to check in: $e'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingMemberIds.remove(memberId));
      }
    }
  }

  Future<void> _handleCheckout(
      Map<String, dynamic> member, String? sessionId) async {
    final memberId = member['id']?.toString() ?? '';
    if (memberId.isEmpty) return;

    final userName = member['user']?['name'] ?? member['name'] ?? 'Member';

    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Confirm Check-Out',
      message: 'Log manual check-out for $userName?',
      confirmLabel: 'Check Out',
      cancelLabel: 'Cancel',
      type: ConfirmDialogType.warning,
      details: [
        ConfirmDetailRow(label: 'Member', value: userName),
        ConfirmDetailRow(
            label: 'Action',
            value: 'Check-Out Session',
            isHighlighted: true),
      ],
    );
    if (!confirmed) return;

    setState(() => _loadingMemberIds.add(memberId));

    try {
      HapticFeedback.lightImpact();
      final res = await ref.read(clientFacilityRepositoryProvider).checkOut(
            widget.kind,
            widget.facilityId,
            memberId: memberId,
            sessionId: sessionId,
          );

      final duration = res['duration_minutes'] ?? res['duration'] ?? 0;

      setState(() {
        _recentlyCheckedInIds.remove(memberId);
        _recentlyCheckedOutIds.add(memberId);
      });

      _refreshAll();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '✅ $userName checked out successfully! (Session: $duration mins)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF0284C7),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to check out: $e'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingMemberIds.remove(memberId));
      }
    }
  }

  Future<void> _handleQuickCodeAction({required bool isCheckIn}) async {
    final code = _quickCodeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a Member ID, Citizen Code, Mobile or Email.'),
          backgroundColor: Color(0xFFD97706),
        ),
      );
      return;
    }

    setState(() => _quickActionLoading = true);

    try {
      HapticFeedback.lightImpact();
      if (isCheckIn) {
        final res = await ref.read(clientFacilityRepositoryProvider).checkIn(
              widget.kind,
              widget.facilityId,
              code: code,
              allowOverride: true,
            );
        final userName = res['user_name'] ?? 'Citizen';
        final already = res['already_checked_in'] == true;
        _quickCodeController.clear();
        _refreshAll();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(already ? '$userName is already checked in.' : '✅ $userName checked in successfully!'),
            backgroundColor: already ? const Color(0xFFD97706) : const Color(0xFF059669),
          ),
        );
      } else {
        final res = await ref.read(clientFacilityRepositoryProvider).checkOut(
              widget.kind,
              widget.facilityId,
              memberId: code,
              userId: code,
            );
        final duration = res['duration_minutes'] ?? res['duration'] ?? 0;
        _quickCodeController.clear();
        _refreshAll();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Checked out successfully! (Session: $duration mins)'),
            backgroundColor: const Color(0xFF0284C7),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    } finally {
      if (mounted) setState(() => _quickActionLoading = false);
    }
  }

  void _openQrScanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Scan Citizen QR for Desk Attendance',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: MobileScanner(
                  onDetect: (capture) {
                    final barcode = capture.barcodes.firstOrNull;
                    if (barcode != null && barcode.rawValue != null) {
                      final rawValue = barcode.rawValue!;
                      Navigator.pop(ctx);
                      _quickCodeController.text = rawValue;
                      _showScannedQrActionDialog(rawValue);
                    }
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Align citizen ID barcode or QR code within the viewfinder.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showScannedQrActionDialog(String scannedCode) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Scanned Citizen QR', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Scanned Code: $scannedCode', style: const TextStyle(fontSize: 13, fontFamily: 'monospace')),
            const SizedBox(height: 12),
            const Text('Choose action to record at desk:'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
            onPressed: () {
              Navigator.pop(ctx);
              _handleQuickCodeAction(isCheckIn: false);
            },
            icon: const Icon(Icons.logout_rounded, size: 16),
            label: const Text('Check Out'),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0D9488)),
            onPressed: () {
              Navigator.pop(ctx);
              _handleQuickCodeAction(isCheckIn: true);
            },
            icon: const Icon(Icons.login_rounded, size: 16),
            label: const Text('Check In'),
          ),
        ],
      ),
    );
  }

  void _openRenewModal(Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RenewMemberModal(
        kind: widget.kind,
        facilityId: widget.facilityId,
        facility: widget.facility,
        member: member,
        onSuccess: () => _refreshAll(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isGym = widget.kind == FacilityKind.gym;
    final primaryColor =
        isGym ? const Color(0xFF0D9488) : const Color(0xFF0284C7);

    final membersAsync = ref.watch(facilityCheckinMembersProvider(
        (widget.kind, widget.facilityId, _searchQuery)));
    final statsAsync =
        ref.watch(facilityStatsProvider((widget.kind, widget.facilityId)));
    final liveOccupancyAsync =
        ref.watch(facilityLiveOccupancyProvider((widget.kind, widget.facilityId)));

    final liveMembers = (liveOccupancyAsync.value?['members_inside']
            as List<LiveSessionMember>?) ??
        [];
    final Map<String, LiveSessionMember> insideByMemberId = {
      for (var m in liveMembers) m.memberId: m
    };

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manual Desk Check-in & Out',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              widget.facility?.name ??
                  (isGym ? 'Gym Facility' : 'Library Hub'),
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Show QR Code',
            icon: const Icon(Icons.qr_code_2_rounded),
            onPressed: () {
              showFacilityQrModal(
                context: context,
                kind: widget.kind,
                facilityId: widget.facilityId,
                facilityName: widget.facility?.name ?? 'Facility',
              );
            },
          ),
          IconButton(
            tooltip: 'Refresh List',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => _refreshAll(),
          ),
        ],
      ),
      body: AmbientBackground(
        child: Column(
          children: [
            // Top Live Stats Mini Banner
            statsAsync.when(
              data: (stats) => Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: primaryColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MiniStatItem(
                      label: "Today's Visits",
                      value: '${stats.todayCheckins}',
                      color: primaryColor,
                    ),
                    Container(
                        height: 24,
                        width: 1,
                        color: primaryColor.withValues(alpha: 0.2)),
                    _MiniStatItem(
                      label: 'Inside Now',
                      value: '${stats.currentlyInside}',
                      color: const Color(0xFF10B981),
                    ),
                    Container(
                        height: 24,
                        width: 1,
                        color: primaryColor.withValues(alpha: 0.2)),
                    _MiniStatItem(
                      label: 'Active Members',
                      value: '${stats.activeMembers}',
                      color: const Color(0xFF6366F1),
                    ),
                  ],
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            // Top Quick Desk Action Card (Direct Code Input / Camera Scan / One-tap Check-in/out)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flash_on_rounded, size: 16, color: primaryColor),
                      const SizedBox(width: 6),
                      Text(
                        'Quick Desk Check-in / Check-out',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _quickCodeController,
                          decoration: InputDecoration(
                            hintText: 'Enter Member ID, Mobile, Code...',
                            hintStyle: const TextStyle(fontSize: 12),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        tooltip: 'Scan Citizen QR',
                        style: IconButton.styleFrom(
                          backgroundColor: primaryColor.withValues(alpha: 0.12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _openQrScanner,
                        icon: Icon(Icons.qr_code_scanner_rounded, color: primaryColor, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _quickActionLoading ? null : () => _handleQuickCodeAction(isCheckIn: true),
                          icon: const Icon(Icons.login_rounded, size: 15),
                          label: const Text('Check In', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF0D9488),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _quickActionLoading ? null : () => _handleQuickCodeAction(isCheckIn: false),
                          icon: const Icon(Icons.logout_rounded, size: 15),
                          label: const Text('Check Out', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search Bar for Member List
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Search members list below...',
                  prefixIcon:
                      Icon(Icons.search_rounded, color: primaryColor),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: scheme.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: scheme.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        BorderSide(color: primaryColor, width: 1.5),
                  ),
                ),
                onChanged: (val) {
                  setState(() => _searchQuery = val.trim());
                },
              ),
            ),

            // Filter Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All Members',
                    icon: Icons.people_outline_rounded,
                    isSelected: _activeFilter == CheckinFilter.all,
                    onTap: () =>
                        setState(() => _activeFilter = CheckinFilter.all),
                    color: primaryColor,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Inside Now (${liveMembers.length})',
                    icon: Icons.meeting_room_rounded,
                    isSelected: _activeFilter == CheckinFilter.insideNow,
                    onTap: () => setState(
                        () => _activeFilter = CheckinFilter.insideNow),
                    color: const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Expiring Soon',
                    icon: Icons.hourglass_top_rounded,
                    isSelected: _activeFilter == CheckinFilter.expiringSoon,
                    onTap: () => setState(
                        () => _activeFilter = CheckinFilter.expiringSoon),
                    color: const Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Outside / Not In',
                    icon: Icons.person_outline_rounded,
                    isSelected: _activeFilter == CheckinFilter.outside,
                    onTap: () => setState(
                        () => _activeFilter = CheckinFilter.outside),
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Members List
            Expanded(
              child: membersAsync.when(
                data: (allMembers) {
                  final now = DateTime.now();

                  final filteredMembers = allMembers.where((m) {
                    final mId = m['id']?.toString() ?? '';
                    final isInside = (insideByMemberId.containsKey(mId) ||
                            _recentlyCheckedInIds.contains(mId)) &&
                        !_recentlyCheckedOutIds.contains(mId);

                    if (_activeFilter == CheckinFilter.insideNow) {
                      return isInside;
                    }
                    if (_activeFilter == CheckinFilter.outside) {
                      return !isInside;
                    }
                    if (_activeFilter == CheckinFilter.expiringSoon) {
                      final endStr = m['end_date']?.toString();
                      if (endStr == null || endStr.isEmpty) return false;
                      try {
                        final end = DateTime.parse(endStr);
                        final diff = end.difference(now).inDays;
                        return diff >= 0 && diff <= 7;
                      } catch (_) {
                        return false;
                      }
                    }
                    return true;
                  }).toList();

                  if (filteredMembers.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: scheme.primary.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.person_search_rounded,
                                  size: 48, color: scheme.primary),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? (_activeFilter == CheckinFilter.insideNow
                                      ? 'No members currently inside facility.'
                                      : 'No members registered yet.')
                                  : 'No members matching "$_searchQuery"',
                              style: theme.textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Use Quick Desk Check-in above or search to record attendance.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: filteredMembers.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final member = filteredMembers[index];
                      final user =
                          (member['user'] as Map<String, dynamic>?) ?? {};
                      final memberId = member['id']?.toString() ?? 'ID';
                      final userName = user['name']?.toString() ??
                          member['name']?.toString() ??
                          'Citizen Member';
                      final userPhone = user['phone']?.toString() ??
                          member['phone']?.toString() ??
                          '';
                      final planName = member['membership_type']?.toString() ??
                          member['plan_name']?.toString() ??
                          'Standard';
                      final rawEndDate = member['end_date']?.toString();
                      final status =
                          (member['status']?.toString() ?? 'active')
                              .toLowerCase();

                      final liveSession = insideByMemberId[memberId];
                      final isInside = (liveSession != null ||
                              _recentlyCheckedInIds.contains(memberId)) &&
                          !_recentlyCheckedOutIds.contains(memberId);
                      final isLoading = _loadingMemberIds.contains(memberId);

                      // Calculate validity
                      bool isExpired = false;
                      bool isExpiringSoon = false;
                      String validityLabel = 'Valid';
                      if (rawEndDate != null && rawEndDate.isNotEmpty) {
                        try {
                          final endDate = DateTime.parse(rawEndDate);
                          final diff = endDate.difference(now).inDays;
                          final formatted =
                              DateFormat('dd MMM yyyy').format(endDate);
                          if (diff < 0) {
                            isExpired = true;
                            validityLabel = 'Expired on $formatted';
                          } else if (diff <= 7) {
                            isExpiringSoon = true;
                            validityLabel =
                                'Expiring in $diff day(s) ($formatted)';
                          } else {
                            validityLabel = 'Valid till $formatted';
                          }
                        } catch (_) {
                          validityLabel = 'Valid till $rawEndDate';
                        }
                      }

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isInside
                                ? const Color(0xFF10B981).withValues(alpha: 0.6)
                                : isExpired
                                    ? const Color(0xFFEF4444)
                                        .withValues(alpha: 0.3)
                                    : scheme.outlineVariant
                                        .withValues(alpha: 0.3),
                            width: isInside ? 1.5 : 1.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x08000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Member Avatar with initials
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: isInside
                                      ? const Color(0xFF10B981)
                                          .withValues(alpha: 0.15)
                                      : primaryColor.withValues(alpha: 0.12),
                                  child: Text(
                                    userName.isNotEmpty
                                        ? userName[0].toUpperCase()
                                        : 'M',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: isInside
                                          ? const Color(0xFF059669)
                                          : primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Member Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              userName,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isInside)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF10B981)
                                                    .withValues(alpha: 0.15),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                      Icons
                                                          .check_circle_rounded,
                                                      size: 12,
                                                      color: Color(0xFF059669)),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    liveSession != null
                                                        ? 'INSIDE (${liveSession.checkInTime})'
                                                        : 'INSIDE NOW',
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF059669)),
                                                  ),
                                                ],
                                              ),
                                            )
                                          else
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: scheme
                                                    .surfaceContainerHighest,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                'OUTSIDE',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: scheme
                                                        .onSurfaceVariant),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: scheme
                                                  .surfaceContainerHighest,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              '#$memberId',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'monospace',
                                                  color:
                                                      scheme.onSurfaceVariant),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            planName.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    scheme.onSurfaceVariant),
                                          ),
                                          if (userPhone.isNotEmpty) ...[
                                            Text(' • ',
                                                style: TextStyle(
                                                    color: scheme
                                                        .onSurfaceVariant)),
                                            Text(userPhone,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: scheme
                                                        .onSurfaceVariant)),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            isExpired
                                                ? Icons.error_outline_rounded
                                                : isExpiringSoon
                                                    ? Icons.warning_amber_rounded
                                                    : Icons.verified_rounded,
                                            size: 13,
                                            color: isExpired
                                                ? const Color(0xFFEF4444)
                                                : isExpiringSoon
                                                    ? const Color(0xFFF59E0B)
                                                    : const Color(0xFF10B981),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            validityLabel,
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: isExpired ||
                                                      isExpiringSoon
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: isExpired
                                                  ? const Color(0xFFEF4444)
                                                  : isExpiringSoon
                                                      ? const Color(0xFFD97706)
                                                      : scheme
                                                          .onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1),
                            const SizedBox(height: 10),

                            // Actions Row (View Profile + Renew Pass + Check-in / Check-out Buttons)
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            FacilityMemberDetailScreen(
                                          kind: widget.kind,
                                          facilityId: widget.facilityId,
                                          memberId: memberId,
                                          facility: widget.facility,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                      Icons.person_outline_rounded,
                                      size: 16),
                                  label: const Text('View',
                                      style: TextStyle(fontSize: 12)),
                                  style: TextButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (isExpired ||
                                        isExpiringSoon ||
                                        status != 'active') ...[
                                      OutlinedButton.icon(
                                        onPressed: () =>
                                            _openRenewModal(member),
                                        icon: const Icon(
                                            Icons.autorenew_rounded,
                                            size: 15,
                                            color: Color(0xFF0D9488)),
                                        label: const Text(
                                          'Renew',
                                          style: TextStyle(
                                              color: Color(0xFF0D9488),
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Color(0xFF0D9488)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 6),
                                          visualDensity:
                                              VisualDensity.compact,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                    ],

                                    // Check In Button
                                    FilledButton.icon(
                                      onPressed: isLoading
                                          ? null
                                          : () => _handleCheckin(member),
                                      icon: isLoading
                                          ? const SizedBox(
                                              width: 12,
                                              height: 12,
                                              child:
                                                  CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white),
                                            )
                                          : const Icon(
                                              Icons.login_rounded,
                                              size: 15,
                                            ),
                                      label: const Text(
                                        'CHECK IN',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11),
                                      ),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        visualDensity:
                                            VisualDensity.compact,
                                      ),
                                    ),
                                    const SizedBox(width: 6),

                                    // Check Out Button
                                    FilledButton.icon(
                                      onPressed: isLoading
                                          ? null
                                          : () => _handleCheckout(member,
                                              liveSession?.sessionId),
                                      icon: const Icon(
                                        Icons.logout_rounded,
                                        size: 15,
                                      ),
                                      label: const Text(
                                        'CHECK OUT',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11),
                                      ),
                                      style: FilledButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFDC2626),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        visualDensity:
                                            VisualDensity.compact,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Failed to load members: $err',
                      style: TextStyle(color: scheme.error, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatItem extends StatelessWidget {
  const _MiniStatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 16, color: color),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color
                : Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withValues(alpha: 0.4),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 14,
                color: isSelected
                    ? color
                    : Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? color
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
