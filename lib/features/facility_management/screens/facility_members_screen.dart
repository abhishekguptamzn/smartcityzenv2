import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/models/fee_plan_model.dart';
import '../../../data/models/onboard_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../data/repositories/onboard_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/renew_member_modal.dart';
import 'facility_member_detail_screen.dart';

final facilityMembersProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, (FacilityKind, String)>((ref, tuple) async {
  final (kind, facilityId) = tuple;
  final repo = ref.watch(clientFacilityRepositoryProvider);
  if (kind == FacilityKind.gym) {
    return repo.getGymMembers(facilityId);
  } else {
    return repo.getLibraryMembers(facilityId);
  }
});

enum MemberFilterStatus { all, active, expiring, expired }

class FacilityMembersScreen extends ConsumerStatefulWidget {
  const FacilityMembersScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilityMembersScreen> createState() => _FacilityMembersScreenState();
}

class _FacilityMembersScreenState extends ConsumerState<FacilityMembersScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  MemberFilterStatus _selectedFilter = MemberFilterStatus.all;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openAddMemberModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddMemberModal(
        kind: widget.kind,
        facilityId: widget.facilityId,
        facility: widget.facility,
        onSuccess: () => ref.refresh(facilityMembersProvider((widget.kind, widget.facilityId))),
      ),
    );
  }

  void _openRenewMemberModal(BuildContext context, Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RenewMemberModal(
        kind: widget.kind,
        facilityId: widget.facilityId,
        facility: widget.facility,
        member: member,
        onSuccess: () => ref.refresh(facilityMembersProvider((widget.kind, widget.facilityId))),
      ),
    );
  }

  void _openHistoryModal(BuildContext context, Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _MemberRenewalsHistorySheet(
        kind: widget.kind,
        facilityId: widget.facilityId,
        member: member,
      ),
    );
  }

  void _confirmRemoveMember(BuildContext context, Map<String, dynamic> member) {
    final userName = member['user']?['name']?.toString() ?? 'this member';
    final memberId = member['id']?.toString() ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Remove Member'),
          ],
        ),
        content: Text(
          'Are you sure you want to remove $userName from this ${widget.kind == FacilityKind.gym ? "gym" : "library"}? Their active digital pass will be revoked.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref.read(clientFacilityRepositoryProvider).deleteMember(widget.kind, widget.facilityId, memberId);
                ref.invalidate(facilityMembersProvider((widget.kind, widget.facilityId)));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Member $userName removed successfully.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to remove member: $e')),
                  );
                }
              }
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _filterMembers(List<Map<String, dynamic>> members) {
    final now = DateTime.now();
    return members.where((m) {
      final user = m['user'] as Map<String, dynamic>? ?? {};
      final name = (user['name']?.toString() ?? '').toLowerCase();
      final email = (user['email']?.toString() ?? '').toLowerCase();
      final phone = (user['phone']?.toString() ?? '').toLowerCase();
      final id = (m['id']?.toString() ?? '').toLowerCase();
      final query = _searchQuery.toLowerCase();

      final matchesSearch = query.isEmpty ||
          name.contains(query) ||
          email.contains(query) ||
          phone.contains(query) ||
          id.contains(query);

      if (!matchesSearch) return false;

      final status = (m['status']?.toString() ?? 'active').toLowerCase();
      final endDateStr = m['end_date']?.toString();
      DateTime? endDate;
      if (endDateStr != null && endDateStr.isNotEmpty) {
        endDate = DateTime.tryParse(endDateStr);
      }

      final isExpired = status != 'active' || (endDate != null && endDate.isBefore(now));
      final daysRemaining = endDate != null ? endDate.difference(now).inDays : 999;
      final isExpiringSoon = !isExpired && daysRemaining <= 7;

      switch (_selectedFilter) {
        case MemberFilterStatus.active:
          return !isExpired;
        case MemberFilterStatus.expiring:
          return isExpiringSoon;
        case MemberFilterStatus.expired:
          return isExpired;
        case MemberFilterStatus.all:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final membersAsync = ref.watch(facilityMembersProvider((widget.kind, widget.facilityId)));
    final isGym = widget.kind == FacilityKind.gym;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.facility?.name ?? (isGym ? "Gym" : "Library")} Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => ref.refresh(facilityMembersProvider((widget.kind, widget.facilityId))),
          ),
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            tooltip: 'Add Member',
            onPressed: () => _openAddMemberModal(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddMemberModal(context),
        icon: const Icon(Icons.qr_code_scanner_rounded),
        label: const Text('Add Member'),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
      ),
      body: AmbientBackground(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                decoration: InputDecoration(
                  hintText: 'Search member by name, email, phone, or ID...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                  ),
                ),
              ),
            ),

            // Status Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  _buildFilterChip('All', MemberFilterStatus.all),
                  const SizedBox(width: 8),
                  _buildFilterChip('Active', MemberFilterStatus.active),
                  const SizedBox(width: 8),
                  _buildFilterChip('Expiring Soon (≤7d)', MemberFilterStatus.expiring),
                  const SizedBox(width: 8),
                  _buildFilterChip('Expired', MemberFilterStatus.expired),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Members List
            Expanded(
              child: membersAsync.when(
                data: (allMembers) {
                  final filteredMembers = _filterMembers(allMembers);

                  if (filteredMembers.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: scheme.primary.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.people_outline_rounded,
                                size: 44,
                                color: scheme.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              allMembers.isEmpty
                                  ? 'No Enrolled Members Yet'
                                  : 'No Matching Members Found',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              allMembers.isEmpty
                                  ? 'Scan citizen QR codes or search citizen accounts to enroll new members.'
                                  : 'Try adjusting your search query or filter chips.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            if (allMembers.isEmpty) ...[
                              const SizedBox(height: 18),
                              FilledButton.icon(
                                onPressed: () => _openAddMemberModal(context),
                                icon: const Icon(Icons.person_add_rounded),
                                label: const Text('Add First Member'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: filteredMembers.length,
                    itemBuilder: (ctx, idx) {
                      final m = filteredMembers[idx];
                      final user = m['user'] as Map<String, dynamic>? ?? {};
                      final plan = m['fee_plan'] as Map<String, dynamic>? ?? {};
                      final status = m['status']?.toString().toLowerCase() ?? 'active';
                      final startDate = m['start_date']?.toString();
                      final endDate = m['end_date']?.toString();

                      final now = DateTime.now();
                      DateTime? endDateTime;
                      if (endDate != null && endDate.isNotEmpty) {
                        endDateTime = DateTime.tryParse(endDate);
                      }
                      final isExpired = status != 'active' || (endDateTime != null && endDateTime.isBefore(now));
                      final daysRemaining = endDateTime != null ? endDateTime.difference(now).inDays : 999;
                      final isExpiringSoon = !isExpired && daysRemaining <= 7;

                      Color statusColor = const Color(0xFF10B981);
                      String statusText = 'ACTIVE';
                      if (isExpired) {
                        statusColor = const Color(0xFFEF4444);
                        statusText = 'EXPIRED';
                      } else if (isExpiringSoon) {
                        statusColor = const Color(0xFFF59E0B);
                        statusText = daysRemaining == 0 ? 'EXPIRES TODAY' : 'EXPIRES IN ${daysRemaining}D';
                      }

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => FacilityMemberDetailScreen(
                                  kind: widget.kind,
                                  facilityId: widget.facilityId,
                                  memberId: m['id'].toString(),
                                  facility: widget.facility,
                                  initialMember: m,
                                ),
                              ),
                            );
                            ref.invalidate(facilityMembersProvider((widget.kind, widget.facilityId)));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isExpired
                                    ? Colors.redAccent.withValues(alpha: 0.3)
                                    : (isExpiringSoon
                                        ? Colors.amber.withValues(alpha: 0.4)
                                        : scheme.outlineVariant.withValues(alpha: 0.3)),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: statusColor.withValues(alpha: 0.15),
                                      child: Text(
                                        (user['name']?.toString().isNotEmpty == true)
                                            ? user['name'].toString()[0].toUpperCase()
                                            : 'C',
                                        style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user['name']?.toString() ?? 'Citizen Member',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Pass: ${m['id'] ?? 'N/A'} • ${plan['name'] ?? m['membership_type'] ?? 'Standard'}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: scheme.onSurfaceVariant,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        statusText,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                if (startDate != null || endDate != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isExpired ? Icons.event_busy_rounded : Icons.event_available_rounded,
                                          size: 14,
                                          color: isExpired ? Colors.redAccent : scheme.primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Validity: ${startDate ?? 'Now'} → ${endDate ?? 'Ongoing'}',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w500,
                                            color: scheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (user['email'] != null || user['phone'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      children: [
                                        Icon(Icons.contact_mail_outlined, size: 14, color: scheme.onSurfaceVariant.withValues(alpha: 0.7)),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${user['email'] ?? user['phone']}',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const Divider(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.history_rounded, size: 18),
                                      tooltip: 'Renewal History',
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => _openHistoryModal(context, m),
                                    ),
                                    const SizedBox(width: 4),
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.redAccent,
                                        side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.4)),
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        visualDensity: VisualDensity.compact,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      icon: const Icon(Icons.person_remove_rounded, size: 14),
                                      label: const Text('Remove', style: TextStyle(fontSize: 12)),
                                      onPressed: () => _confirmRemoveMember(context, m),
                                    ),
                                    const SizedBox(width: 8),
                                    FilledButton.icon(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(0xFF0D9488),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        visualDensity: VisualDensity.compact,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      icon: const Icon(Icons.autorenew_rounded, size: 14),
                                      label: const Text('Record Payment / Renew', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      onPressed: () => _openRenewMemberModal(context, m),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Text('Error loading members: $err', style: TextStyle(color: scheme.error)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, MemberFilterStatus status) {
    final isSelected = _selectedFilter == status;
    return FilterChip(
      selected: isSelected,
      label: Text(label, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      onSelected: (_) => setState(() => _selectedFilter = status),
    );
  }
}

enum _AddMode { scan, manual }

class _AddMemberModal extends ConsumerStatefulWidget {
  const _AddMemberModal({
    required this.kind,
    required this.facilityId,
    this.facility,
    required this.onSuccess,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;
  final VoidCallback onSuccess;

  @override
  ConsumerState<_AddMemberModal> createState() => _AddMemberModalState();
}

class _AddMemberModalState extends ConsumerState<_AddMemberModal> {
  _AddMode _mode = _AddMode.manual;
  final TextEditingController _citizenIdCtrl = TextEditingController();
  final MobileScannerController _scannerCtrl = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  List<FeePlanModel> _plans = [];
  FeePlanModel? _selectedPlan;
  bool _loadingPlans = true;
  bool _submitting = false;
  DateTime _startDate = DateTime.now();

  Timer? _debounceTimer;
  bool _isSearching = false;
  List<OwnerSearchResult> _searchResults = [];
  OwnerSearchResult? _selectedCitizen;

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _citizenIdCtrl.dispose();
    _scannerCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchPlans() async {
    try {
      final repo = ref.read(clientFacilityRepositoryProvider);
      final plans = widget.kind == FacilityKind.gym
          ? await repo.getGymPlans(widget.facilityId)
          : await repo.getLibraryPlans(widget.facilityId);
      if (mounted) {
        setState(() {
          _plans = plans.where((p) => p.isActive).toList();
          _selectedPlan = null; // Fee plan is optional!
          _loadingPlans = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingPlans = false);
    }
  }

  DateTime _calculateInitialEndDate(DateTime start, FeePlanModel? plan) {
    if (plan == null) return start.add(const Duration(days: 30));
    final count = plan.intervalCount;
    final interval = plan.interval.toLowerCase();
    switch (interval) {
      case 'hour':
      case 'hours':
      case 'hourly':
        return DateTime(start.year, start.month, start.day + 1);
      case 'day':
      case 'days':
      case 'daily':
        return start.add(Duration(days: count));
      case 'week':
      case 'weeks':
      case 'weekly':
        return start.add(Duration(days: count * 7));
      case 'year':
      case 'years':
      case 'yearly':
      case 'annual':
        return DateTime(start.year + count, start.month, start.day);
      default: // month
        return DateTime(start.year, start.month + count, start.day);
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();

    if (_selectedCitizen != null && _selectedCitizen!.id != trimmed && _selectedCitizen!.email != trimmed) {
      setState(() => _selectedCitizen = null);
    }

    if (trimmed.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    _debounceTimer = Timer(const Duration(milliseconds: 250), () async {
      try {
        final repo = ref.read(onboardRepositoryProvider);
        final results = await repo.searchOwners(trimmed);
        if (mounted) {
          setState(() {
            _searchResults = results;
            _isSearching = false;
          });
        }
      } catch (_) {
        if (mounted) {
          setState(() => _isSearching = false);
        }
      }
    });
  }

  void _selectCitizen(OwnerSearchResult citizen) {
    setState(() {
      _selectedCitizen = citizen;
      _citizenIdCtrl.text = citizen.name.isNotEmpty ? '${citizen.name} (${citizen.email.isNotEmpty ? citizen.email : citizen.id})' : citizen.id;
      _searchResults = [];
    });
  }

  void _clearSelectedCitizen() {
    setState(() {
      _selectedCitizen = null;
      _citizenIdCtrl.clear();
      _searchResults = [];
    });
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final raw = barcode.rawValue?.trim();
      if (raw != null && raw.isNotEmpty) {
        HapticFeedback.mediumImpact();
        setState(() {
          _citizenIdCtrl.text = raw;
          _mode = _AddMode.manual;
        });
        _onSearchChanged(raw);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Citizen QR detected: $raw'),
            backgroundColor: const Color(0xFF0D9488),
            duration: const Duration(seconds: 2),
          ),
        );
        break;
      }
    }
  }

  Future<void> _submitEnrollment() async {
    final code = _selectedCitizen?.id ?? _citizenIdCtrl.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select or enter a Citizen ID / Email'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    if (_selectedPlan != null) {
      final calculatedEndDate = _calculateInitialEndDate(_startDate, _selectedPlan);
      final intervalUnit = _selectedPlan!.intervalCount > 1 ? '${_selectedPlan!.intervalCount} ${_selectedPlan!.interval}s' : _selectedPlan!.interval;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.assignment_turned_in_rounded, color: Color(0xFF0D9488)),
              SizedBox(width: 8),
              Text('Confirm Fee Plan Assignment'),
            ],
          ),
          content: Text(
            'You are enrolling this member with the fee plan "${_selectedPlan!.name}" (₹${_selectedPlan!.amount.toStringAsFixed(0)} / $intervalUnit).\n\n• Start Date: ${DateFormat("dd MMM yyyy").format(_startDate)}\n• End Date: ${DateFormat("dd MMM yyyy").format(calculatedEndDate)}\n\nDo you want to confirm and generate this membership pass?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(false),
              child: const Text('Back / Edit'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0D9488)),
              onPressed: () => Navigator.of(dialogCtx).pop(true),
              child: const Text('Confirm & Enroll'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    setState(() => _submitting = true);
    final repo = ref.read(clientFacilityRepositoryProvider);

    try {
      final calculatedEndDate = _calculateInitialEndDate(_startDate, _selectedPlan);
      final payload = {
        'citizen_id': _selectedCitizen?.id ?? code,
        if (_selectedPlan != null) 'fee_plan_id': _selectedPlan!.id,
        'start_date': DateFormat('yyyy-MM-dd').format(_startDate),
        'end_date': DateFormat('yyyy-MM-dd').format(calculatedEndDate),
      };

      if (widget.kind == FacilityKind.gym) {
        await repo.addGymMember(widget.facilityId, payload);
      } else {
        await repo.addLibraryMember(widget.facilityId, payload);
      }

      if (!mounted) return;
      widget.onSuccess();
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Member enrolled successfully! Welcome pass & receipt emailed.'),
          backgroundColor: Color(0xFF0D9488),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enrollment failed: $err'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isGym = widget.kind == FacilityKind.gym;

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isGym ? const Color(0xFF0D9488) : const Color(0xFF0284C7))
                            .withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_add_rounded,
                        color: isGym ? const Color(0xFF0D9488) : const Color(0xFF0284C7),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Member',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.facility?.name ?? (isGym ? 'Gym' : 'Library'),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),

          // Mode Selector Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: SegmentedButton<_AddMode>(
              segments: const [
                ButtonSegment(
                  value: _AddMode.manual,
                  icon: Icon(Icons.search_rounded),
                  label: Text('Search / Citizen ID'),
                ),
                ButtonSegment(
                  value: _AddMode.scan,
                  icon: Icon(Icons.qr_code_scanner_rounded),
                  label: Text('Scan QR Code'),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (set) => setState(() => _mode = set.first),
            ),
          ),

          const Divider(height: 1),

          // Main Body
          Expanded(
            child: _mode == _AddMode.scan
                ? _buildScannerView(theme, scheme)
                : _buildFormView(theme, scheme),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerView(ThemeData theme, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MobileScanner(
                    controller: _scannerCtrl,
                    onDetect: _onBarcodeDetected,
                    errorBuilder: (ctx, err) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Camera error or permission denied: $err',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: scheme.error),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF0D9488), width: 3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Point camera at Citizen QR Code from the citizen app',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => setState(() => _mode = _AddMode.manual),
            icon: const Icon(Icons.search_rounded),
            label: const Text('Search Citizen Account Manually'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView(ThemeData theme, ColorScheme scheme) {
    final calculatedEndDate = _calculateInitialEndDate(_startDate, _selectedPlan);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Selected Citizen Card Banner
        if (_selectedCitizen != null) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0D9488).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF0D9488), width: 1.5),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF0D9488),
                  child: Text(
                    _selectedCitizen!.name.isNotEmpty ? _selectedCitizen!.name[0].toUpperCase() : 'C',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedCitizen!.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D9488),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'MATCHED',
                              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedCitizen!.email.isNotEmpty ? _selectedCitizen!.email : (_selectedCitizen!.phone ?? _selectedCitizen!.id),
                        style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: ${_selectedCitizen!.id}',
                        style: const TextStyle(fontSize: 10, color: Color(0xFF0D9488), fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  tooltip: 'Clear selection',
                  onPressed: _clearSelectedCitizen,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Citizen ID / Search Field
        TextField(
          controller: _citizenIdCtrl,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            labelText: 'Search Citizen by Name, Email, Phone, or ID',
            hintText: 'e.g. John, john@example.com, USR...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isSearching)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else if (_citizenIdCtrl.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 20),
                    onPressed: _clearSelectedCitizen,
                  ),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  tooltip: 'Open Camera Scanner',
                  onPressed: () => setState(() => _mode = _AddMode.scan),
                ),
              ],
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),

        // Live Search Results Dropdown List
        if (_searchResults.isNotEmpty && _selectedCitizen == null) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x15000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
                  child: Text(
                    'MATCHING CITIZENS (${_searchResults.length})',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _searchResults.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (ctx, idx) {
                    final citizen = _searchResults[idx];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: scheme.primary.withValues(alpha: 0.15),
                        child: Text(
                          citizen.name.isNotEmpty ? citizen.name[0].toUpperCase() : 'C',
                          style: TextStyle(color: scheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      title: Text(
                        citizen.name.isNotEmpty ? citizen.name : 'Citizen User',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      subtitle: Text(
                        '${citizen.email.isNotEmpty ? citizen.email : citizen.id}${citizen.phone != null ? ' • ${citizen.phone}' : ''}',
                        style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      onTap: () => _selectCitizen(citizen),
                    );
                  },
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        // Fee Plan Dropdown Picklist (Optional)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Select Fee Plan (Optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: scheme.onSurface)),
            Text('Optional', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 6),
        if (_loadingPlans)
          const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
        else if (_plans.isNotEmpty)
          DropdownButtonFormField<FeePlanModel?>(
            initialValue: _selectedPlan,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.sell_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
            items: [
              const DropdownMenuItem<FeePlanModel?>(
                value: null,
                child: Text('None / Free Pass (Standard Monthly)'),
              ),
              ..._plans.map((p) {
                final intervalUnit = p.intervalCount > 1 ? '${p.intervalCount} ${p.interval}s' : p.interval;
                return DropdownMenuItem<FeePlanModel?>(
                  value: p,
                  child: Text('${p.name} — ₹${p.amount.toStringAsFixed(0)} / $intervalUnit'),
                );
              }),
            ],
            onChanged: (p) => setState(() => _selectedPlan = p),
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No custom fee plans defined. Default standard plan will be assigned.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),

        // Start Date Selector
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          leading: const Icon(Icons.calendar_today_rounded),
          title: const Text('Start Date'),
          subtitle: Text(DateFormat('dd MMM yyyy').format(_startDate)),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _startDate,
              firstDate: DateTime.now().subtract(const Duration(days: 30)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) setState(() => _startDate = picked);
          },
        ),
        const SizedBox(height: 14),

        // Auto-calculated Expiry Preview Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0D9488).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF0D9488).withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              const Icon(Icons.verified_rounded, color: Color(0xFF0D9488), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Initial Membership Validity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(
                      '${DateFormat('dd MMM yyyy').format(_startDate)} → ${DateFormat('dd MMM yyyy').format(calculatedEndDate)} (${_selectedPlan != null ? "${_selectedPlan!.intervalCount} ${_selectedPlan!.interval}" : "1 month"})',
                      style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Submit Button
        FilledButton.icon(
          onPressed: _submitting ? null : _submitEnrollment,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color(0xFF0D9488),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: _submitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Icon(Icons.check_circle_outline_rounded),
          label: Text(
            _submitting ? 'Enrolling & Issuing Pass...' : 'Enroll Member & Send Pass',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ],
    );
  }
}



class _MemberRenewalsHistorySheet extends ConsumerStatefulWidget {
  const _MemberRenewalsHistorySheet({
    required this.kind,
    required this.facilityId,
    required this.member,
  });

  final FacilityKind kind;
  final String facilityId;
  final Map<String, dynamic> member;

  @override
  ConsumerState<_MemberRenewalsHistorySheet> createState() => _MemberRenewalsHistorySheetState();
}

class _MemberRenewalsHistorySheetState extends ConsumerState<_MemberRenewalsHistorySheet> {
  List<Map<String, dynamic>> _renewals = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final memberId = widget.member['id']?.toString();
    if (memberId == null || memberId.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'Member ID missing';
      });
      return;
    }

    try {
      final repo = ref.read(clientFacilityRepositoryProvider);
      final history = await repo.getMemberRenewals(widget.kind, widget.facilityId, memberId);
      if (mounted) {
        setState(() {
          _renewals = history;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = widget.member['user'] as Map<String, dynamic>? ?? {};
    final userName = user['name']?.toString() ?? 'Citizen Member';

    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Renewal & Payment History', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text(userName, style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text('Error loading history: $_error', style: TextStyle(color: scheme.error)))
                    : _renewals.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.receipt_long_outlined, size: 40, color: scheme.onSurfaceVariant.withValues(alpha: 0.5)),
                                const SizedBox(height: 10),
                                Text('No previous renewal logs found for this member.', style: TextStyle(color: scheme.onSurfaceVariant)),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _renewals.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 10),
                            itemBuilder: (ctx, idx) {
                              final item = _renewals[idx];
                              final amount = (item['amount_paid'] as num?)?.toDouble() ?? 0.0;
                              final plan = item['fee_plan'] as Map<String, dynamic>? ?? {};
                              final payment = item['payment'] as Map<String, dynamic>? ?? {};
                              final prevEnd = item['previous_end_date']?.toString() ?? '--';
                              final newEnd = item['new_end_date']?.toString() ?? '--';
                              final date = item['created_at']?.toString() ?? '';

                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          plan['name']?.toString() ?? 'Membership Extension',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                        Text(
                                          '₹${amount.toStringAsFixed(0)}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D9488), fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Extended: $prevEnd → $newEnd',
                                      style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant),
                                    ),
                                    if (payment['invoice_number'] != null)
                                      Text(
                                        'Invoice: ${payment['invoice_number']} • Mode: ${(payment['payment_method'] ?? 'cash').toString().toUpperCase()}',
                                        style: TextStyle(fontSize: 10.5, color: scheme.onSurfaceVariant.withValues(alpha: 0.8)),
                                      ),
                                    if (date.isNotEmpty)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          date.length > 10 ? date.substring(0, 10) : date,
                                          style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant.withValues(alpha: 0.6)),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
