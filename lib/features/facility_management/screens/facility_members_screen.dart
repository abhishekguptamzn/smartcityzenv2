import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/models/fee_plan_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
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
                        'Scan citizen QR codes or enter citizen IDs to enroll new members.',
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: CircleAvatar(
                      backgroundColor: scheme.primary.withValues(alpha: 0.15),
                      child: Text(
                        (user['name']?.toString().isNotEmpty == true)
                            ? user['name'].toString()[0].toUpperCase()
                            : 'C',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            user['name']?.toString() ?? 'Citizen Member',
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 3),
                        Text(
                          'Pass ID: ${m['id'] ?? 'N/A'} • Type: ${m['membership_type'] ?? plan['name'] ?? 'Standard'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (startDate != null || endDate != null)
                          Text(
                            'Valid: ${startDate ?? 'Now'} → ${endDate ?? 'Ongoing'}',
                            style: TextStyle(
                              fontSize: 11,
                              color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
                            ),
                          ),
                        if (user['email'] != null || user['phone'] != null)
                          Text(
                            '👤 ${user['email'] ?? user['phone']}',
                            style: TextStyle(
                              fontSize: 11,
                              color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
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
  _AddMode _mode = _AddMode.scan;
  final TextEditingController _citizenIdCtrl = TextEditingController();
  final MobileScannerController _scannerCtrl = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  List<FeePlanModel> _plans = [];
  FeePlanModel? _selectedPlan;
  bool _loadingPlans = true;
  bool _submitting = false;
  DateTime _startDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  @override
  void dispose() {
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
    final code = _citizenIdCtrl.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please scan a QR code or enter a Citizen ID'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    final repo = ref.read(clientFacilityRepositoryProvider);

    try {
      final payload = {
        'citizen_id': code,
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
      height: MediaQuery.of(context).size.height * 0.85,
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
                  value: _AddMode.scan,
                  icon: Icon(Icons.qr_code_scanner_rounded),
                  label: Text('Scan QR Code'),
                ),
                ButtonSegment(
                  value: _AddMode.manual,
                  icon: Icon(Icons.badge_outlined),
                  label: Text('Citizen ID / Search'),
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
            icon: const Icon(Icons.edit_note_rounded),
            label: const Text('Enter Citizen ID Manually'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView(ThemeData theme, ColorScheme scheme) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Citizen ID Field
        TextField(
          controller: _citizenIdCtrl,
          decoration: InputDecoration(
            labelText: 'Citizen ID / QR Code / Email / Phone',
            hintText: 'e.g. USR8K2M1X9 or CITIZEN-USR8K...',
            prefixIcon: const Icon(Icons.qr_code_rounded),
            suffixIcon: IconButton(
              icon: const Icon(Icons.qr_code_scanner_rounded),
              tooltip: 'Open Camera Scanner',
              onPressed: () => setState(() => _mode = _AddMode.scan),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
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
