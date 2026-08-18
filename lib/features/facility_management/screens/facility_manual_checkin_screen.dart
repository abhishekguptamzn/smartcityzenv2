import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
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
  final Set<String> _selectedMemberIds = {};
  final Set<String> _recentlyCheckedInIds = {};
  final Set<String> _recentlyCheckedOutIds = {};
  bool _quickActionLoading = false;
  bool _bulkActionLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    _quickCodeController.dispose();
    super.dispose();
  }

  void _refreshAll() {
    ref.invalidate(facilityCheckinMembersProvider(
        (widget.kind, widget.facilityId, _searchQuery)));
    ref.invalidate(
        facilityLiveOccupancyProvider((widget.kind, widget.facilityId)));
    ref.invalidate(facilityStatsProvider((widget.kind, widget.facilityId)));
  }

  void _toggleMemberSelection(String memberId) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedMemberIds.contains(memberId)) {
        _selectedMemberIds.remove(memberId);
      } else {
        _selectedMemberIds.add(memberId);
      }
    });
  }

  void _selectAllMembers(List<Map<String, dynamic>> members) {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedMemberIds.clear();
      for (final m in members) {
        final id = m['id']?.toString();
        if (id != null && id.isNotEmpty) {
          _selectedMemberIds.add(id);
        }
      }
    });
  }

  void _clearSelection() {
    HapticFeedback.lightImpact();
    setState(() => _selectedMemberIds.clear());
  }

  Future<void> _handleCheckin(Map<String, dynamic> member,
      {bool allowOverride = false}) async {
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

  Future<void> _handleBulkCheckin(List<Map<String, dynamic>> allMembers) async {
    final selectedList = allMembers.where((m) {
      final id = m['id']?.toString() ?? '';
      return _selectedMemberIds.contains(id);
    }).toList();

    if (selectedList.isEmpty) return;

    final confirm = await showAppConfirmDialog(
      context: context,
      title: 'Bulk Check-In',
      message:
          'Are you sure you want to log desk check-in for all ${selectedList.length} selected member(s)?',
      confirmLabel: 'Check In ${selectedList.length} Members',
      details: [
        ConfirmDetailRow(
            label: 'Selected Members', value: '${selectedList.length}'),
        ConfirmDetailRow(
            label: 'Action', value: 'Log Desk Check-In', isHighlighted: true),
      ],
    );
    if (!confirm) return;

    setState(() => _bulkActionLoading = true);
    int successCount = 0;
    int failedCount = 0;

    final repo = ref.read(clientFacilityRepositoryProvider);
    for (final member in selectedList) {
      final memberId = member['id']?.toString() ?? '';
      if (memberId.isEmpty) continue;
      try {
        await repo.checkIn(
          widget.kind,
          widget.facilityId,
          memberId: memberId,
          allowOverride: true,
        );
        successCount++;
      } catch (_) {
        failedCount++;
      }
    }

    _selectedMemberIds.clear();
    _refreshAll();
    if (mounted) {
      setState(() => _bulkActionLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Bulk Check-In completed: $successCount succeeded${failedCount > 0 ? ", $failedCount failed" : ""}'),
          backgroundColor:
              failedCount == 0 ? const Color(0xFF059669) : const Color(0xFFD97706),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleBulkCheckout(
    List<Map<String, dynamic>> allMembers,
    Map<String, Map<String, dynamic>> activeMap,
  ) async {
    final selectedList = allMembers.where((m) {
      final id = m['id']?.toString() ?? '';
      return _selectedMemberIds.contains(id);
    }).toList();

    if (selectedList.isEmpty) return;

    final confirm = await showAppConfirmDialog(
      context: context,
      title: 'Bulk Check-Out',
      message:
          'Are you sure you want to check out all ${selectedList.length} selected member(s)?',
      confirmLabel: 'Check Out ${selectedList.length} Members',
      type: ConfirmDialogType.warning,
      details: [
        ConfirmDetailRow(
            label: 'Selected Members', value: '${selectedList.length}'),
        ConfirmDetailRow(
            label: 'Action', value: 'Log Check-Out', isHighlighted: true),
      ],
    );
    if (!confirm) return;

    setState(() => _bulkActionLoading = true);
    int successCount = 0;
    int failedCount = 0;

    final repo = ref.read(clientFacilityRepositoryProvider);
    for (final member in selectedList) {
      final memberId = member['id']?.toString() ?? '';
      if (memberId.isEmpty) continue;
      final liveSession = activeMap[memberId];
      try {
        await repo.checkOut(
          widget.kind,
          widget.facilityId,
          memberId: memberId,
          sessionId: liveSession?['session_id']?.toString(),
        );
        successCount++;
      } catch (_) {
        failedCount++;
      }
    }

    _selectedMemberIds.clear();
    _refreshAll();
    if (mounted) {
      setState(() => _bulkActionLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Bulk Check-Out completed: $successCount checked out${failedCount > 0 ? ", $failedCount failed" : ""}'),
          backgroundColor: const Color(0xFF0284C7),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleQuickDeskAction(bool isCheckIn) async {
    final query = _quickCodeController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please enter a Member ID, Citizen Code, Mobile number, or Email.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _quickActionLoading = true);
    final repo = ref.read(clientFacilityRepositoryProvider);

    try {
      HapticFeedback.mediumImpact();
      if (isCheckIn) {
        final res = await repo.checkIn(
          widget.kind,
          widget.facilityId,
          memberId: query,
          allowOverride: true,
        );
        final already = res['already_checked_in'] == true;
        _quickCodeController.clear();
        _refreshAll();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(already
                ? 'Member $query is already checked in.'
                : '✅ Check-in recorded for $query!'),
            backgroundColor:
                already ? const Color(0xFFD97706) : const Color(0xFF059669),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        await repo.checkOut(
          widget.kind,
          widget.facilityId,
          memberId: query,
        );
        _quickCodeController.clear();
        _refreshAll();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Check-out recorded for $query!'),
            backgroundColor: const Color(0xFF0284C7),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Action failed for "$query": $e'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
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
      backgroundColor: Colors.black,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Scan Citizen QR',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MobileScanner(
                onDetect: (capture) {
                  final barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    final raw = barcodes.first.rawValue;
                    if (raw != null && raw.isNotEmpty) {
                      Navigator.pop(ctx);
                      _quickCodeController.text = raw;
                      _showQuickActionSheet(raw);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActionSheet(String code) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Scanned Code: $code',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _handleQuickDeskAction(true);
                      },
                      icon: const Icon(Icons.login_rounded),
                      label: const Text('Check In'),
                      style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF059669)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _handleQuickDeskAction(false);
                      },
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Check Out'),
                      style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        member: member,
        facility: widget.facility,
        onSuccess: _refreshAll,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scheme = theme.colorScheme;
    final primaryColor = widget.kind == FacilityKind.gym
        ? const Color(0xFF2563EB)
        : const Color(0xFF0D9488);

    final membersAsync = ref.watch(facilityCheckinMembersProvider(
        (widget.kind, widget.facilityId, _searchQuery)));
    final occupancyAsync = ref.watch(
        facilityLiveOccupancyProvider((widget.kind, widget.facilityId)));

    final activeOccupancy = occupancyAsync.value;
    final currentInsideCount =
        (activeOccupancy?['current_inside'] as num?)?.toInt() ?? 0;
    final activeList = (activeOccupancy?['active_members'] as List?) ?? [];
    final activeMap = <String, Map<String, dynamic>>{};
    for (final item in activeList) {
      if (item is Map) {
        final mId =
            item['member_id']?.toString() ?? item['id']?.toString();
        if (mId != null && mId.isNotEmpty) {
          activeMap[mId] = Map<String, dynamic>.from(item);
        }
      }
    }

    final allMembers = membersAsync.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.kind == FacilityKind.gym ? "Gym" : "Library"} Manual Check-In',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              widget.facility?.name ?? 'Desk Attendance Station',
              style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_2_rounded),
            tooltip: 'Facility QR',
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
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: _refreshAll,
          ),
        ],
      ),
      bottomNavigationBar: _selectedMemberIds.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  ),
                ],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${_selectedMemberIds.length} Selected',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () => _selectAllMembers(allMembers),
                              child: const Text('Select All',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            TextButton(
                              onPressed: _clearSelection,
                              child: const Text('Clear',
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: _clearSelection,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _bulkActionLoading
                                ? null
                                : () => _handleBulkCheckin(allMembers),
                            icon: _bulkActionLoading
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.login_rounded, size: 16),
                            label: Text(
                                'Check In (${_selectedMemberIds.length})',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF059669),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _bulkActionLoading
                                ? null
                                : () => _handleBulkCheckout(
                                    allMembers, activeMap),
                            icon: const Icon(Icons.logout_rounded, size: 16),
                            label: Text(
                                'Check Out (${_selectedMemberIds.length})',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFDC2626),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // Top Quick Desk Action Card
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.desk_rounded,
                            size: 16, color: primaryColor),
                        const SizedBox(width: 6),
                        const Text(
                          'QUICK DESK ACTION',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
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
                              hintText: 'Member ID / Phone / Code...',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          onPressed: _openQrScanner,
                          icon: const Icon(Icons.camera_alt_rounded, size: 18),
                          tooltip: 'Scan QR with Camera',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _quickActionLoading
                                ? null
                                : () => _handleQuickDeskAction(true),
                            icon: const Icon(Icons.login_rounded, size: 15),
                            label: const Text('Check In',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF059669),
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _quickActionLoading
                                ? null
                                : () => _handleQuickDeskAction(false),
                            icon: const Icon(Icons.logout_rounded, size: 15),
                            label: const Text('Check Out',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFDC2626),
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar & Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Filter member list by name/phone...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 18),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 16),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                      onChanged: (val) => setState(() => _searchQuery = val),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Tabs (All / Inside Now / Outside)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All Members'),
                    selected: _activeFilter == CheckinFilter.all,
                    onSelected: (val) {
                      if (val) setState(() => _activeFilter = CheckinFilter.all);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    avatar: const Icon(Icons.circle,
                        color: Color(0xFF10B981), size: 10),
                    label: Text('Inside Now ($currentInsideCount)'),
                    selected: _activeFilter == CheckinFilter.insideNow,
                    onSelected: (val) {
                      if (val) {
                        setState(() => _activeFilter = CheckinFilter.insideNow);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Outside'),
                    selected: _activeFilter == CheckinFilter.outside,
                    onSelected: (val) {
                      if (val) {
                        setState(() => _activeFilter = CheckinFilter.outside);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Expiring Soon'),
                    selected: _activeFilter == CheckinFilter.expiringSoon,
                    onSelected: (val) {
                      if (val) {
                        setState(
                            () => _activeFilter = CheckinFilter.expiringSoon);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // Members List
            Expanded(
              child: membersAsync.when(
                data: (members) {
                  var filtered = members;
                  if (_activeFilter == CheckinFilter.insideNow) {
                    filtered = members.where((m) {
                      final id = m['id']?.toString() ?? '';
                      return activeMap.containsKey(id) ||
                          _recentlyCheckedInIds.contains(id);
                    }).toList();
                  } else if (_activeFilter == CheckinFilter.outside) {
                    filtered = members.where((m) {
                      final id = m['id']?.toString() ?? '';
                      return !activeMap.containsKey(id) &&
                          !_recentlyCheckedInIds.contains(id);
                    }).toList();
                  } else if (_activeFilter == CheckinFilter.expiringSoon) {
                    final now = DateTime.now();
                    final thirtyDays = now.add(const Duration(days: 30));
                    filtered = members.where((m) {
                      final endStr = m['end_date']?.toString();
                      if (endStr == null || endStr.isEmpty) return false;
                      final endDate = DateTime.tryParse(endStr);
                      if (endDate == null) return false;
                      return endDate.isAfter(now) &&
                          endDate.isBefore(thirtyDays);
                    }).toList();
                  }

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search_rounded,
                              size: 48, color: scheme.onSurfaceVariant),
                          const SizedBox(height: 8),
                          Text(
                            'No members found matching filter.',
                            style: TextStyle(
                                color: scheme.onSurfaceVariant, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final member = filtered[index];
                      final memberId = member['id']?.toString() ?? '';
                      final userName = member['user']?['name'] ??
                          member['name'] ??
                          'Citizen Member';
                      final userPhone = member['user']?['phone'] ??
                          member['phone'] ??
                          '';
                      final planName = member['plan']?['name'] ??
                          member['plan_name'] ??
                          'Standard Plan';
                      final endStr = member['end_date']?.toString();
                      DateTime? endDate;
                      if (endStr != null && endStr.isNotEmpty) {
                        endDate = DateTime.tryParse(endStr);
                      }
                      final now = DateTime.now();
                      final isExpired =
                          endDate != null && endDate.isBefore(now);
                      final isExpiringSoon = endDate != null &&
                          !isExpired &&
                          endDate.isBefore(now.add(const Duration(days: 7)));

                      final liveSession = activeMap[memberId];
                      final isCheckedIn = (liveSession != null ||
                              _recentlyCheckedInIds.contains(memberId)) &&
                          !_recentlyCheckedOutIds.contains(memberId);

                      final isSelected =
                          _selectedMemberIds.contains(memberId);
                      final isLoading =
                          _loadingMemberIds.contains(memberId);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryColor.withValues(alpha: 0.07)
                              : (isDark
                                  ? const Color(0xFF1E293B)
                                  : Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? primaryColor
                                : (isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFE2E8F0)),
                            width: isSelected ? 1.8 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(alpha: isDark ? 0.2 : 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Member Profile Header & Checkbox
                            InkWell(
                              onTap: () => _toggleMemberSelection(memberId),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12, 12, 12, 8),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    // Selection Checkbox
                                    Checkbox(
                                      value: isSelected,
                                      activeColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      onChanged: (_) =>
                                          _toggleMemberSelection(memberId),
                                    ),
                                    const SizedBox(width: 4),

                                    // Avatar
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: isCheckedIn
                                          ? const Color(0xFFECFDF5)
                                          : const Color(0xFFEFF6FF),
                                      child: Icon(
                                        isCheckedIn
                                            ? Icons.person_pin_circle_rounded
                                            : Icons.person_outline_rounded,
                                        color: isCheckedIn
                                            ? const Color(0xFF059669)
                                            : primaryColor,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Name, Plan, Validity
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  userName,
                                                  style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 14.5,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // Live Status Badge
                                              if (isCheckedIn)
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                        0xFFECFDF5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: const Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.circle,
                                                          size: 8,
                                                          color: Color(
                                                              0xFF10B981)),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        'INSIDE',
                                                        style: TextStyle(
                                                          fontSize: 10.5,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                              0xFF059669),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              else
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: scheme
                                                        .surfaceContainerHighest,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    'OUTSIDE',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: scheme
                                                          .onSurfaceVariant,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '#$memberId • $planName ${userPhone.isNotEmpty ? "• $userPhone" : ""}',
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: scheme.onSurfaceVariant,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (endDate != null) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              isExpired
                                                  ? 'Expired ${DateFormat("d MMM yyyy").format(endDate)}'
                                                  : 'Valid till ${DateFormat("d MMM yyyy").format(endDate)}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: isExpired ||
                                                        isExpiringSoon
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                color: isExpired
                                                    ? const Color(0xFFEF4444)
                                                    : isExpiringSoon
                                                        ? const Color(
                                                            0xFFD97706)
                                                        : scheme
                                                            .onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const Divider(height: 1),

                            // Unmistakable Action Buttons Below Each Member
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Row(
                                children: [
                                  // View Details Icon Button
                                  IconButton(
                                    icon: const Icon(
                                        Icons.person_outline_rounded,
                                        size: 18),
                                    tooltip: 'View Profile',
                                    visualDensity: VisualDensity.compact,
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
                                  ),

                                  if (isExpired || isExpiringSoon) ...[
                                    OutlinedButton.icon(
                                      onPressed: () => _openRenewModal(member),
                                      icon: const Icon(Icons.autorenew_rounded,
                                          size: 14, color: Color(0xFF0D9488)),
                                      label: const Text('Renew',
                                          style: TextStyle(
                                              color: Color(0xFF0D9488),
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Color(0xFF0D9488)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],

                                  const Spacer(),

                                  // Check In Button
                                  FilledButton.icon(
                                    onPressed: isLoading
                                        ? null
                                        : () => _handleCheckin(member),
                                    icon: isLoading
                                        ? const SizedBox(
                                            width: 12,
                                            height: 12,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white),
                                          )
                                        : const Icon(Icons.login_rounded,
                                            size: 15),
                                    label: const Text('CHECK IN',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11)),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: isCheckedIn
                                          ? const Color(0xFF6B7280)
                                          : const Color(0xFF059669),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Check Out Button
                                  FilledButton.icon(
                                    onPressed: isLoading
                                        ? null
                                        : () => _handleCheckout(
                                            member,
                                            liveSession?['session_id']
                                                ?.toString()),
                                    icon: const Icon(Icons.logout_rounded,
                                        size: 15),
                                    label: const Text('CHECK OUT',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11)),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: isCheckedIn
                                          ? const Color(0xFFDC2626)
                                          : const Color(0xFF9CA3AF),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                ],
                              ),
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
