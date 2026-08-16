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

final facilityMembersProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, (FacilityKind, String)>((ref, tuple) async {
  final (kind, facilityId) = tuple;
  final repo = ref.watch(clientFacilityRepositoryProvider);
  if (kind == FacilityKind.gym) {
    return repo.getGymMembers(facilityId);
  } else {
    return repo.getLibraryMembers(facilityId);
  }
});

class FacilityMembersScreen extends ConsumerWidget {
  const FacilityMembersScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  void _openAddMemberModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddMemberModal(
        kind: kind,
        facilityId: facilityId,
        facility: facility,
        onSuccess: () => ref.refresh(facilityMembersProvider((kind, facilityId))),
      ),
    );
  }

  void _openRenewMemberModal(BuildContext context, WidgetRef ref, Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RenewMemberModal(
        kind: kind,
        facilityId: facilityId,
        facility: facility,
        member: member,
        onSuccess: () => ref.refresh(facilityMembersProvider((kind, facilityId))),
      ),
    );
  }

  void _confirmRemoveMember(BuildContext context, WidgetRef ref, Map<String, dynamic> member) {
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
          'Are you sure you want to remove $userName from this ${kind == FacilityKind.gym ? "gym" : "library"}? Their active digital pass will be revoked.',
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
                await ref.read(clientFacilityRepositoryProvider).deleteMember(kind, facilityId, memberId);
                ref.invalidate(facilityMembersProvider((kind, facilityId)));
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final membersAsync = ref.watch(facilityMembersProvider((kind, facilityId)));
    final isGym = kind == FacilityKind.gym;

    return Scaffold(
      appBar: AppBar(
        title: Text('${facility?.name ?? (isGym ? "Gym" : "Library")} Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => ref.refresh(facilityMembersProvider((kind, facilityId))),
          ),
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            tooltip: 'Add Member',
            onPressed: () => _openAddMemberModal(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddMemberModal(context, ref),
        icon: const Icon(Icons.qr_code_scanner_rounded),
        label: const Text('Add Member'),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
      ),
      body: AmbientBackground(
        child: membersAsync.when(
          data: (members) {
            if (members.isEmpty) {
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
                        'No Enrolled Members Yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Scan citizen QR codes or search citizen accounts to enroll new members.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed: () => _openAddMemberModal(context, ref),
                        icon: const Icon(Icons.person_add_rounded),
                        label: const Text('Add First Member'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: members.length,
              itemBuilder: (ctx, idx) {
                final m = members[idx];
                final user = m['user'] as Map<String, dynamic>? ?? {};
                final plan = m['fee_plan'] as Map<String, dynamic>? ?? {};
                final status = m['status']?.toString().toLowerCase() ?? 'active';
                final isActive = status == 'active';
                final startDate = m['start_date']?.toString();
                final endDate = m['end_date']?.toString();

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: scheme.outlineVariant.withValues(alpha: 0.3),
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
                            backgroundColor: scheme.primary.withValues(alpha: 0.15),
                            child: Text(
                              (user['name']?.toString().isNotEmpty == true)
                                  ? user['name'].toString()[0].toUpperCase()
                                  : 'C',
                              style: TextStyle(
                                color: scheme.primary,
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
                                  'Pass ID: ${m['id'] ?? 'N/A'} • ${m['membership_type'] ?? plan['name'] ?? 'Standard'}',
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
                              color: (isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444))
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isActive ? const Color(0xFF059669) : const Color(0xFFDC2626),
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
                              Icon(Icons.event_available_rounded, size: 14, color: scheme.primary),
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
                            onPressed: () => _confirmRemoveMember(context, ref, m),
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
                            onPressed: () => _openRenewMemberModal(context, ref, m),
                          ),
                        ],
                      ),
                    ],
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
          _plans = plans;
          if (_plans.isNotEmpty) {
            _selectedPlan = _plans.first;
          }
          _loadingPlans = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingPlans = false);
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
          _mode = _AddMode.manual; // Switch to form view with populated ID
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

    setState(() => _submitting = true);
    final repo = ref.read(clientFacilityRepositoryProvider);

    try {
      final payload = {
        'citizen_id': _selectedCitizen?.id ?? code,
        'fee_plan_id': _selectedPlan?.id,
        'start_date': DateFormat('yyyy-MM-dd').format(_startDate),
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
          content: Text('Member enrolled successfully! Welcome pass & PDF emailed.'),
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
      height: MediaQuery.of(context).size.height * 0.88,
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
                          'Add Member',
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
            'Point camera at Citizen QR Code from the user\'s app',
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
            hintText: 'e.g. chotu, chotuji1971@gmail.com, USR...',
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

        // Fee Plan Dropdown
        if (_loadingPlans)
          const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
        else if (_plans.isNotEmpty)
          DropdownButtonFormField<FeePlanModel>(
            initialValue: _selectedPlan,
            decoration: InputDecoration(
              labelText: 'Select Membership Plan',
              prefixIcon: const Icon(Icons.card_membership_rounded),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
            items: _plans.map((p) {
              return DropdownMenuItem(
                value: p,
                child: Text('${p.name} — ₹${p.amount.toStringAsFixed(0)} / ${p.interval}'),
              );
            }).toList(),
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
            _submitting ? 'Enrolling & Sending Pass...' : 'Enroll Member & Send Email Pass',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ],
    );
  }
}

class RenewMemberModal extends ConsumerStatefulWidget {
  const RenewMemberModal({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
    required this.member,
    required this.onSuccess,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;
  final Map<String, dynamic> member;
  final VoidCallback onSuccess;

  @override
  ConsumerState<RenewMemberModal> createState() => _RenewMemberModalState();
}

class _RenewMemberModalState extends ConsumerState<RenewMemberModal> {
  List<FeePlanModel> _plans = [];
  FeePlanModel? _selectedPlan;
  bool _loadingPlans = true;
  bool _submitting = false;

  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _refCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();
  String _paymentMethod = 'cash';

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _refCtrl.dispose();
    _notesCtrl.dispose();
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
          _loadingPlans = false;
          if (_plans.isNotEmpty) {
            _selectedPlan = _plans.first;
            _amountCtrl.text = _selectedPlan!.amount.toStringAsFixed(0);
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingPlans = false);
    }
  }

  Future<void> _submitRenewal() async {
    final memberId = widget.member['id']?.toString();
    if (memberId == null || memberId.isEmpty) return;

    final amount = double.tryParse(_amountCtrl.text.trim()) ?? _selectedPlan?.amount ?? 0.0;

    setState(() => _submitting = true);

    try {
      final repo = ref.read(clientFacilityRepositoryProvider);
      await repo.renewMember(
        widget.kind,
        widget.facilityId,
        memberId,
        feePlanId: _selectedPlan?.id,
        amount: amount,
        paymentMethod: _paymentMethod,
        transactionReference: _refCtrl.text.trim().isNotEmpty ? _refCtrl.text.trim() : null,
        notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
      );

      if (mounted) {
        Navigator.of(context).pop();
        widget.onSuccess();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Membership renewed and payment recorded successfully!'),
            backgroundColor: Color(0xFF059669),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to renew membership: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = widget.member['user'] as Map<String, dynamic>? ?? {};
    final userName = user['name']?.toString() ?? 'Citizen Member';
    final currentEnd = widget.member['end_date']?.toString() ?? 'Active';

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag pill
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Renew Membership',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Record payment & extend validity for $userName',
                          style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Current status card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: scheme.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.badge_outlined, color: scheme.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Member: $userName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('Current Expiry: $currentEnd', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Fee Plan Picklist
              Text('Select Fee Plan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: scheme.onSurface)),
              const SizedBox(height: 8),

              if (_loadingPlans)
                const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
              else if (_plans.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('No active fee plans configured. You can specify a custom amount below.', style: TextStyle(fontSize: 12)),
                )
              else
                DropdownButtonFormField<FeePlanModel>(
                  initialValue: _selectedPlan,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.sell_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                  items: _plans.map((p) {
                    final intervalStr = p.interval;
                    return DropdownMenuItem<FeePlanModel>(
                      value: p,
                      child: Text('${p.name} — ₹${p.amount.toStringAsFixed(0)} / $intervalStr'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedPlan = val;
                        _amountCtrl.text = val.amount.toStringAsFixed(0);
                      });
                    }
                  },
                ),
              const SizedBox(height: 16),

              // Amount to Collect
              Text('Payment Amount (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: scheme.onSurface)),
              const SizedBox(height: 8),
              TextField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.currency_rupee_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  hintText: 'Enter renewal amount',
                ),
              ),
              const SizedBox(height: 16),

              // Payment Method
              Text('Payment Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: scheme.onSurface)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _paymentMethod,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.payments_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                items: const [
                  DropdownMenuItem(value: 'cash', child: Text('Cash at Desk')),
                  DropdownMenuItem(value: 'upi', child: Text('UPI / QR Payment')),
                  DropdownMenuItem(value: 'card', child: Text('Credit / Debit Card')),
                  DropdownMenuItem(value: 'bank_transfer', child: Text('Bank Transfer / Netbanking')),
                ],
                onChanged: (val) => setState(() => _paymentMethod = val ?? 'cash'),
              ),
              const SizedBox(height: 16),

              // Transaction Reference / Notes
              TextField(
                controller: _refCtrl,
                decoration: InputDecoration(
                  labelText: 'Transaction Reference / Receipt ID (Optional)',
                  prefixIcon: const Icon(Icons.receipt_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _notesCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Internal Notes (Optional)',
                  prefixIcon: const Icon(Icons.notes_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Action
              FilledButton.icon(
                onPressed: _submitting ? null : _submitRenewal,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: _submitting
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.check_circle_rounded),
                label: Text(
                  _submitting ? 'Recording Renewal...' : 'Confirm & Renew Membership',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

