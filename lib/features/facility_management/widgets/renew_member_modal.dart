import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/models/fee_plan_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../screens/facility_console_screen.dart';

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

  DateTime _calculateRenewedEndDate(DateTime baseDate, FeePlanModel? plan) {
    if (plan == null) return baseDate.add(const Duration(days: 30));
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
        startDate: DateFormat('yyyy-MM-dd').format(_startDate),
        paymentMethod: _paymentMethod,
        transactionReference: _refCtrl.text.trim().isNotEmpty ? _refCtrl.text.trim() : null,
        notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
      );

      // Invalidate stats cache so dashboard auto-updates
      ref.invalidate(facilityStatsProvider((widget.kind, widget.facilityId)));

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Renewal failed: $e'),
            backgroundColor: Colors.redAccent,
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
    final calculatedNewEnd = _calculateRenewedEndDate(_startDate, _selectedPlan);
    final durationLabel = _selectedPlan != null
        ? '${_selectedPlan!.intervalCount} ${_selectedPlan!.interval}'
        : '1 month';

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
                        _amountCtrl.text = val.amount.toStringAsFixed(0);
                      });
                    }
                  },
                ),
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
