import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/api/app_exception.dart';
import '../../../data/models/facility_batch_model.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/models/fee_plan_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/show_confirm_dialog.dart';
import '../screens/facility_dashboard_screen.dart';
import '../screens/facility_members_screen.dart';

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

  List<FacilityBatchModel> _batches = [];
  FacilityBatchModel? _selectedBatch;
  bool _loadingBatches = true;

  // 'batch' or 'plan'
  String _renewalSource = 'plan';
  bool _submitting = false;

  late DateTime _startDate;
  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _refCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();
  String _paymentMethod = 'cash';

  @override
  void initState() {
    super.initState();
    final currentEndStr = widget.member['end_date']?.toString();
    final now = DateTime.now();
    DateTime? currentEnd;
    if (currentEndStr != null && currentEndStr.isNotEmpty) {
      currentEnd = DateTime.tryParse(currentEndStr);
    }
    final isExpired = currentEnd == null || currentEnd.isBefore(now);
    _startDate = isExpired ? now : currentEnd;

    // If member already has a batch assigned, default to batch renewal
    final hasBatch = widget.member['batch_id'] != null ||
        widget.member['batch'] != null ||
        (widget.member['membership_type']?.toString().toLowerCase() == 'batch');
    if (hasBatch) {
      _renewalSource = 'batch';
    }

    _fetchPlansAndBatches();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _refCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchPlansAndBatches() async {
    final repo = ref.read(clientFacilityRepositoryProvider);

    // 1. Fetch Fee Plans
    try {
      final plans = await repo.getFacilityPlans(widget.kind, widget.facilityId);
      if (mounted) {
        setState(() {
          _plans = plans.where((p) => p.isActive).toList();
          _loadingPlans = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingPlans = false);
    }

    // 2. Fetch Batches
    try {
      final batches = await repo.getBatches(widget.kind, widget.facilityId, status: 'active');
      if (mounted) {
        setState(() {
          _batches = batches;
          _loadingBatches = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingBatches = false);
    }

    // 3. Resolve initial selection
    if (mounted) {
      setState(() {
        final memberBatchId = widget.member['batch_id']?.toString() ??
            (widget.member['batch'] is Map ? widget.member['batch']['id']?.toString() : null);

        if (memberBatchId != null && memberBatchId.isNotEmpty) {
          final matched = _batches.where((b) => b.id == memberBatchId).firstOrNull;
          if (matched != null) {
            _selectedBatch = matched;
          } else if (widget.member['batch'] is Map) {
            try {
              _selectedBatch = FacilityBatchModel.fromJson(widget.member['batch'] as Map<String, dynamic>);
            } catch (_) {}
          }
        }

        if (_selectedBatch == null && _batches.isNotEmpty && _renewalSource == 'batch') {
          _selectedBatch = _batches.first;
        }

        if (_plans.isNotEmpty && _selectedPlan == null) {
          _selectedPlan = _plans.first;
        }

        if (_renewalSource == 'batch' && _selectedBatch != null) {
          _applyBatchPrice(_selectedBatch!);
        } else if (_selectedPlan != null) {
          _applyPlanPrice(_selectedPlan!);
        }
      });
    }
  }

  void _applyBatchPrice(FacilityBatchModel batch) {
    final fee = batch.fee ?? (batch.feePlan?.amount ?? 0.0);
    _amountCtrl.text = fee > 0 ? fee.toStringAsFixed(0) : '0';
  }

  void _applyPlanPrice(FeePlanModel plan) {
    _amountCtrl.text = plan.amount.toStringAsFixed(0);
  }

  DateTime _calculateRenewedEndDate(DateTime baseDate) {
    if (_renewalSource == 'batch' && _selectedBatch != null) {
      if (_selectedBatch!.feePlan != null) {
        return _calculatePlanEndDate(baseDate, _selectedBatch!.feePlan!);
      }
      if (_selectedBatch!.endDate != null) {
        final batchEnd = DateTime.tryParse(_selectedBatch!.endDate!);
        if (batchEnd != null && batchEnd.isAfter(baseDate)) {
          return batchEnd;
        }
      }
      // Default batch pass validity is 1 month
      return DateTime(baseDate.year, baseDate.month + 1, baseDate.day);
    }

    if (_selectedPlan != null) {
      return _calculatePlanEndDate(baseDate, _selectedPlan!);
    }

    return baseDate.add(const Duration(days: 30));
  }

  DateTime _calculatePlanEndDate(DateTime baseDate, FeePlanModel plan) {
    final count = plan.intervalCount > 0 ? plan.intervalCount : 1;
    final interval = plan.interval.toLowerCase();
    switch (interval) {
      case 'hour':
      case 'hours':
      case 'hourly':
        return DateTime(baseDate.year, baseDate.month, baseDate.day + 1);
      case 'day':
      case 'days':
      case 'daily':
        return baseDate.add(Duration(days: count));
      case 'week':
      case 'weeks':
      case 'weekly':
        return baseDate.add(Duration(days: count * 7));
      case 'year':
      case 'years':
      case 'yearly':
      case 'annual':
        return DateTime(baseDate.year + count, baseDate.month, baseDate.day);
      default: // month
        return DateTime(baseDate.year, baseDate.month + count, baseDate.day);
    }
  }

  String _getDurationLabel() {
    if (_renewalSource == 'batch' && _selectedBatch != null) {
      if (_selectedBatch!.feePlan != null) {
        final fp = _selectedBatch!.feePlan!;
        return '${fp.intervalCount} ${fp.interval}';
      }
      return '1 month (Batch)';
    }

    if (_selectedPlan != null) {
      return '${_selectedPlan!.intervalCount} ${_selectedPlan!.interval}';
    }

    return '1 month';
  }

  Future<void> _submitRenewal() async {
    final memberId = widget.member['id']?.toString();
    if (memberId == null || memberId.isEmpty) return;

    final user = widget.member['user'] as Map<String, dynamic>? ?? {};
    final userName = user['name']?.toString() ?? widget.member['name']?.toString() ?? 'Citizen Member';
    final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0.0;

    final String planTitle;
    if (_renewalSource == 'batch' && _selectedBatch != null) {
      planTitle = '${_selectedBatch!.name} (Batch Pass)';
    } else if (_selectedPlan != null) {
      planTitle = '${_selectedPlan!.name} (${_selectedPlan!.intervalCount} ${_selectedPlan!.interval})';
    } else {
      planTitle = 'Custom Fee Pass';
    }

    final endDate = _calculateRenewedEndDate(_startDate);
    final validityStr = '${DateFormat("d MMM yyyy").format(_startDate)} → ${DateFormat("d MMM yyyy").format(endDate)}';

    final confirm = await showAppConfirmDialog(
      context: context,
      title: 'Confirm Pass Renewal',
      message: 'Please verify the membership pass renewal details before recording the payment.',
      confirmLabel: 'Confirm & Renew',
      details: [
        ConfirmDetailRow(label: 'Member', value: userName),
        ConfirmDetailRow(label: 'Pass Type', value: planTitle),
        ConfirmDetailRow(label: 'Validity Window', value: validityStr),
        ConfirmDetailRow(label: 'Amount Payable', value: '₹${amount.toStringAsFixed(0)}', isHighlighted: true),
        ConfirmDetailRow(label: 'Payment Method', value: _paymentMethod.toUpperCase()),
      ],
    );

    if (!confirm) return;

    setState(() => _submitting = true);

    try {
      final repo = ref.read(clientFacilityRepositoryProvider);
      final batchIdToSave = _renewalSource == 'batch'
          ? _selectedBatch?.id
          : (widget.member['batch_id']?.toString());
      final feePlanIdToSave = _renewalSource == 'batch'
          ? _selectedBatch?.feePlanId
          : _selectedPlan?.id;

      await repo.renewMember(
        widget.kind,
        widget.facilityId,
        memberId,
        feePlanId: feePlanIdToSave,
        batchId: batchIdToSave,
        amount: amount,
        startDate: DateFormat('yyyy-MM-dd').format(_startDate),
        paymentMethod: _paymentMethod,
        transactionReference: _refCtrl.text.trim().isNotEmpty ? _refCtrl.text.trim() : null,
        notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
      );

      // Invalidate stats and members cache so dashboard auto-updates
      ref.invalidate(facilityStatsProvider((widget.kind, widget.facilityId)));
      ref.invalidate(facilityMembersProvider((widget.kind, widget.facilityId)));
      ref.invalidate(myOwnedFacilitiesProvider);

      if (mounted) {
        Navigator.of(context).pop();
        widget.onSuccess();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Membership renewed, payment recorded & receipt emailed!'),
            backgroundColor: Color(0xFF059669),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = AppException.extractMessage(e, fallback: 'Renewal failed. Please try again.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 4),
          ),
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
    final isGym = widget.kind == FacilityKind.gym;
    final primaryColor = isGym ? const Color(0xFF0D9488) : const Color(0xFF0284C7);

    final user = widget.member['user'] as Map<String, dynamic>? ?? {};
    final userName = user['name']?.toString() ?? widget.member['name']?.toString() ?? 'Citizen Member';
    final userEmail = user['email']?.toString() ?? widget.member['email']?.toString() ?? '';
    final currentEndStr = widget.member['end_date']?.toString();

    final now = DateTime.now();
    DateTime? currentEnd;
    if (currentEndStr != null && currentEndStr.isNotEmpty) {
      currentEnd = DateTime.tryParse(currentEndStr);
    }

    final isExpired = currentEnd == null || currentEnd.isBefore(now);
    final calculatedNewEnd = _calculateRenewedEndDate(_startDate);
    final durationLabel = _getDurationLabel();
    final hasBatchesOption = _batches.isNotEmpty || _selectedBatch != null;
    final isBatchMode = _renewalSource == 'batch' && hasBatchesOption;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
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
              // Drag handle
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

              // Title Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.autorenew_rounded, color: primaryColor, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Renew Membership Pass',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$userName ${userEmail.isNotEmpty ? "($userEmail)" : ""}',
                                style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
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

              // Current Expiry Status Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isExpired
                      ? Colors.redAccent.withValues(alpha: 0.08)
                      : primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isExpired
                        ? Colors.redAccent.withValues(alpha: 0.25)
                        : primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isExpired ? Icons.warning_amber_rounded : Icons.badge_outlined,
                      color: isExpired ? Colors.redAccent : primaryColor,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Member: $userName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(
                            'Current Expiry: ${currentEnd != null ? DateFormat('dd MMM yyyy').format(currentEnd) : "Expired"} ${isExpired ? "(Overdue)" : "(Active)"}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isExpired ? Colors.redAccent : scheme.onSurfaceVariant,
                              fontWeight: isExpired ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Renewal Pass Type Switcher (If batches exist)
              if (hasBatchesOption) ...[
                Text('Renewal Pass Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: scheme.onSurface)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _renewalSource = 'batch';
                              if (_selectedBatch == null && _batches.isNotEmpty) {
                                _selectedBatch = _batches.first;
                              }
                              if (_selectedBatch != null) {
                                _applyBatchPrice(_selectedBatch!);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isBatchMode ? primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: isBatchMode
                                  ? [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.school_rounded, size: 16, color: isBatchMode ? Colors.white : scheme.onSurfaceVariant),
                                const SizedBox(width: 6),
                                Text(
                                  'Batch Pass',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isBatchMode ? Colors.white : scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _renewalSource = 'plan';
                              if (_selectedPlan == null && _plans.isNotEmpty) {
                                _selectedPlan = _plans.first;
                              }
                              if (_selectedPlan != null) {
                                _applyPlanPrice(_selectedPlan!);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !isBatchMode ? primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: !isBatchMode
                                  ? [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.sell_outlined, size: 16, color: !isBatchMode ? Colors.white : scheme.onSurfaceVariant),
                                const SizedBox(width: 6),
                                Text(
                                  'Facility Fee Plan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: !isBatchMode ? Colors.white : scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Batch Selection View
              if (isBatchMode) ...[
                Text('Select Batch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: scheme.onSurface)),
                const SizedBox(height: 8),
                if (_loadingBatches)
                  const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
                else if (_batches.isEmpty && _selectedBatch == null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('No active batches found. You can specify a custom amount below or switch to Fee Plan.', style: TextStyle(fontSize: 12)),
                  )
                else ...[
                  DropdownButtonFormField<FacilityBatchModel>(
                    initialValue: _batches.any((b) => b.id == _selectedBatch?.id)
                        ? _batches.firstWhere((b) => b.id == _selectedBatch?.id)
                        : (_batches.isNotEmpty ? _batches.first : _selectedBatch),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.school_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                    items: (_batches.isNotEmpty ? _batches : (_selectedBatch != null ? [_selectedBatch!] : <FacilityBatchModel>[])).map((b) {
                      final fee = b.fee ?? (b.feePlan?.amount ?? 0.0);
                      final timing = b.startTime != null && b.endTime != null ? ' (${b.startTime} - ${b.endTime})' : '';
                      return DropdownMenuItem<FacilityBatchModel>(
                        value: b,
                        child: Text(
                          '${b.name} — ₹${fee.toStringAsFixed(0)}$timing',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedBatch = val;
                          _applyBatchPrice(val);
                        });
                      }
                    },
                  ),
                ],
              ] else ...[
                // Fee Plan Picklist View
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
                    initialValue: _plans.any((p) => p.id == _selectedPlan?.id)
                        ? _plans.firstWhere((p) => p.id == _selectedPlan?.id)
                        : (_plans.isNotEmpty ? _plans.first : null),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.sell_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                    items: _plans.map((p) {
                      final intervalStr = p.intervalCount > 1 ? '${p.intervalCount} ${p.interval}s' : p.interval;
                      return DropdownMenuItem<FeePlanModel>(
                        value: p,
                        child: Text('${p.name} — ₹${p.amount.toStringAsFixed(0)} / $intervalStr'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedPlan = val;
                          _applyPlanPrice(val);
                        });
                      }
                    },
                  ),
              ],
              const SizedBox(height: 14),

              // Renewal Start Date Picker (Editable)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
                ),
                leading: Icon(Icons.calendar_today_rounded, color: primaryColor),
                title: const Text('Renewal Start Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text(
                  '${DateFormat('dd MMM yyyy').format(_startDate)} ${isExpired ? "(Started from today)" : "(Continuing from current expiry)"}',
                  style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                ),
                trailing: const Icon(Icons.edit_calendar_rounded, size: 20),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 730)),
                  );
                  if (picked != null) setState(() => _startDate = picked);
                },
              ),
              const SizedBox(height: 12),

              // Dynamic Calculated Expiry Date Preview (matching Add Member Modal)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.event_available_rounded, color: primaryColor, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Calculated Renewal Validity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            '${DateFormat('dd MMM yyyy').format(_startDate)} → ${DateFormat('dd MMM yyyy').format(calculatedNewEnd)} ($durationLabel)',
                            style: TextStyle(
                              fontSize: 12,
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Payment Details Section Header
              Text('Payment & Billing Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: scheme.onSurface)),
              const SizedBox(height: 8),

              // Amount & Payment Mode in Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                      decoration: InputDecoration(
                        labelText: 'Amount (₹)',
                        prefixIcon: const Icon(Icons.currency_rupee_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _paymentMethod,
                      decoration: InputDecoration(
                        labelText: 'Payment Mode',
                        prefixIcon: const Icon(Icons.payment_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'cash', child: Text('Cash at Desk')),
                        DropdownMenuItem(value: 'upi', child: Text('UPI / QR')),
                        DropdownMenuItem(value: 'card', child: Text('Card / POS')),
                        DropdownMenuItem(value: 'bank_transfer', child: Text('Bank Transfer')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _paymentMethod = v);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Reference No & Notes
              TextField(
                controller: _refCtrl,
                decoration: InputDecoration(
                  labelText: 'Transaction Ref / Receipt No (Optional)',
                  prefixIcon: const Icon(Icons.receipt_long_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesCtrl,
                decoration: InputDecoration(
                  labelText: 'Remarks / Notes (Optional)',
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),

              // Submit & Issue Button
              FilledButton.icon(
                onPressed: _submitting ? null : _submitRenewal,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: primaryColor,
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
                  _submitting ? 'Recording Payment & Renewing...' : 'Record Payment & Renew Pass',
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
