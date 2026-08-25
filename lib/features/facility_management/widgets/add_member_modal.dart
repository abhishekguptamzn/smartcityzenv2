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
import '../screens/facility_dashboard_screen.dart';
import '../screens/facility_members_screen.dart';

enum AddMemberMode { scan, manual }

Future<void> showAddMemberModal({
  required BuildContext context,
  required FacilityKind kind,
  required String facilityId,
  FacilityModel? facility,
  AddMemberMode initialMode = AddMemberMode.scan,
  required VoidCallback onSuccess,
}) {
  HapticFeedback.lightImpact();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => AddMemberModal(
      kind: kind,
      facilityId: facilityId,
      facility: facility,
      initialMode: initialMode,
      onSuccess: onSuccess,
    ),
  );
}

class AddMemberModal extends ConsumerStatefulWidget {
  const AddMemberModal({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
    this.initialMode = AddMemberMode.scan,
    required this.onSuccess,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;
  final AddMemberMode initialMode;
  final VoidCallback onSuccess;

  @override
  ConsumerState<AddMemberModal> createState() => _AddMemberModalState();
}

class _AddMemberModalState extends ConsumerState<AddMemberModal> {
  late AddMemberMode _mode;
  final TextEditingController _citizenIdCtrl = TextEditingController();
  final MobileScannerController _scannerCtrl = MobileScannerController();

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
    _mode = widget.initialMode;
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
      final plans = await repo.getFacilityPlans(widget.kind, widget.facilityId);
      if (mounted) {
        setState(() {
          _plans = plans.where((p) => p.isActive).toList();
          _selectedPlan = null;
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

    if (_selectedCitizen != null &&
        _selectedCitizen!.id != trimmed &&
        _selectedCitizen!.email != trimmed) {
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
      _citizenIdCtrl.text = citizen.name.isNotEmpty
          ? '${citizen.name} (${citizen.email.isNotEmpty ? citizen.email : citizen.id})'
          : citizen.id;
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
          _mode = AddMemberMode.manual;
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

    // Prevent duplicate enrollment if already a member in this facility
    final membersAsync = ref.read(facilityMembersProvider((widget.kind, widget.facilityId)));
    final currentMembers = membersAsync.asData?.value ?? [];
    final citizenId = _selectedCitizen?.id ?? code;
    final citizenEmail = _selectedCitizen?.email;

    final existingMember = currentMembers.where((m) {
      final user = m['user'] as Map<String, dynamic>? ?? {};
      final uId = user['id']?.toString() ?? '';
      final uEmail = user['email']?.toString() ?? '';
      final memId = m['id']?.toString() ?? '';
      final status = (m['status']?.toString() ?? 'active').toLowerCase();
      final isExisting = (citizenId.isNotEmpty && (uId == citizenId || memId == citizenId)) ||
          (citizenEmail != null && citizenEmail.isNotEmpty && uEmail.toLowerCase() == citizenEmail.toLowerCase());
      return isExisting && status != 'cancelled';
    }).firstOrNull;

    if (existingMember != null) {
      final passId = existingMember['id'] ?? 'Pass';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This citizen is already enrolled in this facility ($passId). Please renew or record payment on their existing pass instead.'),
          backgroundColor: const Color(0xFFDC2626),
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    if (_selectedPlan != null) {
      final calculatedEndDate = _calculateInitialEndDate(_startDate, _selectedPlan);
      final intervalUnit = _selectedPlan!.intervalCount > 1
          ? '${_selectedPlan!.intervalCount} ${_selectedPlan!.interval}s'
          : _selectedPlan!.interval;
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
      final citizenId = _selectedCitizen?.id ?? code;
      final payload = <String, dynamic>{
        'user_id': citizenId,
        'citizen_id': citizenId,
        'start_date': DateFormat('yyyy-MM-dd').format(_startDate),
        if (_selectedPlan != null) ...{
          'fee_plan_id': _selectedPlan!.id,
          'end_date': DateFormat('yyyy-MM-dd').format(_calculateInitialEndDate(_startDate, _selectedPlan)),
        },
      };

      await repo.addFacilityMember(widget.kind, widget.facilityId, payload);

      ref.invalidate(facilityStatsProvider((widget.kind, widget.facilityId)));
      ref.invalidate(facilityMembersProvider((widget.kind, widget.facilityId)));
      ref.invalidate(myOwnedFacilitiesProvider);

      if (!mounted) return;
      widget.onSuccess();
      Navigator.of(context).pop();

      final successMsg = _selectedPlan != null
          ? 'Member enrolled with active plan! Welcome pass & receipt emailed.'
          : 'Citizen registered as new member! You can assign a fee plan anytime.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMsg),
          backgroundColor: const Color(0xFF0D9488),
          duration: const Duration(seconds: 3),
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
            child: SegmentedButton<AddMemberMode>(
              segments: const [
                ButtonSegment(
                  value: AddMemberMode.scan,
                  icon: Icon(Icons.qr_code_scanner_rounded),
                  label: Text('Scan Citizen QR'),
                ),
                ButtonSegment(
                  value: AddMemberMode.manual,
                  icon: Icon(Icons.search_rounded),
                  label: Text('Search / ID'),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (set) => setState(() => _mode = set.first),
            ),
          ),

          // Body Content based on Mode
          Expanded(
            child: _mode == AddMemberMode.scan
                ? _buildScannerMode(theme, scheme)
                : _buildManualMode(theme, scheme),
          ),

          // Submit Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: isGym ? const Color(0xFF0D9488) : const Color(0xFF0284C7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _submitting ? null : _submitEnrollment,
                icon: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.person_add_rounded),
                label: Text(
                  _submitting ? 'Enrolling...' : 'Enroll Member',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerMode(ThemeData theme, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MobileScanner(
                    controller: _scannerCtrl,
                    onDetect: _onBarcodeDetected,
                  ),
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.kind == FacilityKind.gym
                            ? const Color(0xFF0D9488)
                            : const Color(0xFF0284C7),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Point camera at Citizen Digital ID QR Code',
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          _buildFeePlanSelector(theme, scheme),
        ],
      ),
    );
  }

  Widget _buildManualMode(ThemeData theme, ColorScheme scheme) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        TextField(
          controller: _citizenIdCtrl,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            labelText: 'Search Citizen by Name / Phone / Email',
            hintText: 'e.g. John Doe, 9876543210, citizen@example.com',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _isSearching
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : (_citizenIdCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: _clearSelectedCitizen,
                      )
                    : null),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),

        // Live Search Results
        if (_searchResults.isNotEmpty && _selectedCitizen == null)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchResults.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final c = _searchResults[i];
                final phoneStr = c.phone != null && c.phone!.isNotEmpty ? ' • ${c.phone}' : '';

                final membersAsync = ref.read(facilityMembersProvider((widget.kind, widget.facilityId)));
                final currentMembers = membersAsync.asData?.value ?? [];
                final existing = currentMembers.where((m) {
                  final user = m['user'] as Map<String, dynamic>? ?? {};
                  final uId = user['id']?.toString() ?? '';
                  final uEmail = user['email']?.toString() ?? '';
                  final status = (m['status']?.toString() ?? 'active').toLowerCase();
                  return status != 'cancelled' && (uId == c.id || (c.email.isNotEmpty && uEmail.toLowerCase() == c.email.toLowerCase()));
                }).firstOrNull;

                final isAlreadyEnrolled = existing != null;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isAlreadyEnrolled ? Colors.amber.withValues(alpha: 0.15) : scheme.primary.withValues(alpha: 0.1),
                    child: Text(
                      c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                      style: TextStyle(color: isAlreadyEnrolled ? Colors.amber.shade800 : scheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      if (isAlreadyEnrolled)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            'Already Member (${existing['id']})',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber.shade800),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Text('${c.email.isNotEmpty ? c.email : ""}$phoneStr'),
                  onTap: () {
                    if (isAlreadyEnrolled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${c.name} is already enrolled (${existing['id']}). Please renew their existing pass from the members list.'),
                          backgroundColor: Colors.amber.shade800,
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    }
                    _selectCitizen(c);
                  },
                );
              },
            ),
          ),

        const SizedBox(height: 16),
        _buildFeePlanSelector(theme, scheme),
        const SizedBox(height: 16),
        _buildStartDatePicker(theme, scheme),
      ],
    );
  }

  Widget _buildFeePlanSelector(ThemeData theme, ColorScheme scheme) {
    if (_loadingPlans) {
      return const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()));
    }

    if (_plans.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.amber, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'No active fee plans created yet. Enrolling as a general active member.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Fee Plan (Optional)',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<FeePlanModel>(
          initialValue: _selectedPlan,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          hint: const Text('New Member (No Fee Plan / Inactive Pass)'),
          isExpanded: true,
          items: [
            const DropdownMenuItem<FeePlanModel>(
              value: null,
              child: Text('New Member (No Fee Plan / Inactive Pass)'),
            ),
            ..._plans.map((plan) {
              final intervalUnit = plan.intervalCount > 1
                  ? '${plan.intervalCount} ${plan.interval}s'
                  : plan.interval;
              return DropdownMenuItem<FeePlanModel>(
                value: plan,
                child: Text('${plan.name} — ₹${plan.amount.toStringAsFixed(0)} / $intervalUnit'),
              );
            }),
          ],
          onChanged: (plan) => setState(() => _selectedPlan = plan),
        ),
      ],
    );
  }

  Widget _buildStartDatePicker(ThemeData theme, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Joining / Start Date', style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton.icon(
                icon: const Icon(Icons.calendar_today_rounded, size: 16),
                label: Text(DateFormat('dd MMM yyyy').format(_startDate)),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _startDate = picked);
                },
              ),
            ],
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Membership Status', style: TextStyle(fontWeight: FontWeight.bold)),
              if (_selectedPlan != null)
                Text(
                  'Expires ${DateFormat("dd MMM yyyy").format(_calculateInitialEndDate(_startDate, _selectedPlan))}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'NEW (NO ACTIVE PLAN)',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
