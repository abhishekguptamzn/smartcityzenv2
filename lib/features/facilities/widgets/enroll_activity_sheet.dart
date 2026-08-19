import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/activities_providers.dart';
import '../../../data/models/activity_batch_model.dart';
import '../../../data/models/activity_model.dart';
import '../../../data/models/fee_plan_model.dart';
import '../../../data/repositories/activities_repository.dart';

class EnrollActivitySheet extends ConsumerStatefulWidget {
  const EnrollActivitySheet({
    super.key,
    required this.activity,
    this.initialBatch,
    this.initialFeePlan,
  });

  final ActivityModel activity;
  final ActivityBatchModel? initialBatch;
  final FeePlanModel? initialFeePlan;

  static const Color _primary = Color(0xFF1565D8);

  static Future<bool?> show(
    BuildContext context, {
    required ActivityModel activity,
    ActivityBatchModel? initialBatch,
    FeePlanModel? initialFeePlan,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EnrollActivitySheet(
        activity: activity,
        initialBatch: initialBatch,
        initialFeePlan: initialFeePlan,
      ),
    );
  }

  @override
  ConsumerState<EnrollActivitySheet> createState() => _EnrollActivitySheetState();
}

class _EnrollActivitySheetState extends ConsumerState<EnrollActivitySheet> {
  ActivityBatchModel? _selectedBatch;
  FeePlanModel? _selectedFeePlan;
  DateTime _startDate = DateTime.now();
  String _paymentMethod = 'upi';
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedBatch = widget.initialBatch ??
        (widget.activity.batches.isNotEmpty ? widget.activity.batches.first : null);
    _selectedFeePlan = widget.initialFeePlan ??
        (widget.activity.feePlans.isNotEmpty ? widget.activity.feePlans.first : null);
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final formattedStartDate =
        "${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')}";

    final amount = _selectedFeePlan?.amount ?? 0.0;

    final payload = {
      if (_selectedBatch != null) 'batch_id': _selectedBatch!.id,
      if (_selectedFeePlan != null) 'fee_plan_id': _selectedFeePlan!.id,
      'enrollment_type': _selectedFeePlan?.interval ?? 'monthly',
      'start_date': formattedStartDate,
      'payment_method': _paymentMethod,
      'amount_paid': amount,
    };

    try {
      final repo = ref.read(activitiesRepositoryProvider);
      final enrollment = await repo.enroll(widget.activity.id, payload);

      ref.invalidate(myActivityEnrollmentsProvider);
      ref.invalidate(activityDetailsProvider(widget.activity.id));

      if (mounted) {
        Navigator.of(context).pop(true);
        _showSuccessDialog(enrollment.id);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _showSuccessDialog(String enrollmentId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Text('🎉 ', style: TextStyle(fontSize: 24)),
            Text('Enrollment Confirmed!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You have been successfully enrolled in ${widget.activity.name}.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.qr_code_2_rounded, color: Color(0xFF10B981), size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Turnstile QR Pass Active',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF10B981)),
                        ),
                        Text(
                          'Pass Ref: $enrollmentId',
                          style: const TextStyle(fontSize: 10.5, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Awesome'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF181B26) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Enroll & Get Activity Pass',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                widget.activity.name,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 20),

              // Batch Selection (if batches available)
              if (widget.activity.batches.isNotEmpty) ...[
                Text(
                  '1. Select Class Batch',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...widget.activity.batches.map((b) {
                  final isSelected = _selectedBatch?.id == b.id;
                  return InkWell(
                    onTap: () => setState(() => _selectedBatch = b),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? EnrollActivitySheet._primary.withValues(alpha: 0.1)
                            : (isDark ? const Color(0xFF232736) : const Color(0xFFF8FAFC)),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? EnrollActivitySheet._primary
                              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isSelected ? EnrollActivitySheet._primary : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  b.name,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                                if (b.instructor != null)
                                  Text(
                                    'Coach: ${b.instructor!.name}',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (b.availableSpots != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: b.availableSpots! > 0
                                    ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                    : Colors.redAccent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${b.availableSpots} spots left',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: b.availableSpots! > 0 ? const Color(0xFF10B981) : Colors.redAccent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],

              // Fee Plan Selection
              if (widget.activity.feePlans.isNotEmpty) ...[
                Text(
                  '2. Select Membership Pass / Fee Plan',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...widget.activity.feePlans.map((fp) {
                  final isSelected = _selectedFeePlan?.id == fp.id;
                  return InkWell(
                    onTap: () => setState(() => _selectedFeePlan = fp),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? EnrollActivitySheet._primary.withValues(alpha: 0.1)
                            : (isDark ? const Color(0xFF232736) : const Color(0xFFF8FAFC)),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? EnrollActivitySheet._primary
                              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isSelected ? EnrollActivitySheet._primary : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fp.name,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                                Text(
                                  'Duration: ${fp.intervalCount} ${fp.interval}(s)',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹${fp.amount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: EnrollActivitySheet._primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],

              // Start Date Picker
              Text(
                '3. Start Date',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (picked != null) setState(() => _startDate = picked);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF232736) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 18, color: EnrollActivitySheet._primary),
                      const SizedBox(width: 10),
                      Text(
                        '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const Spacer(),
                      const Text(
                        'Change',
                        style: TextStyle(fontSize: 12, color: EnrollActivitySheet._primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Payment Method
              Text(
                '4. Payment Method',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _paymentMethodChip('upi', 'UPI / QR', Icons.qr_code_2_rounded),
                  const SizedBox(width: 8),
                  _paymentMethodChip('card', 'Debit / Card', Icons.credit_card_rounded),
                  const SizedBox(width: 8),
                  _paymentMethodChip('cash', 'Pay at Center', Icons.storefront_rounded),
                ],
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ],

              const SizedBox(height: 24),

              // Total & Confirm Button
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('TOTAL PAYABLE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text(
                        _selectedFeePlan != null ? '₹${_selectedFeePlan!.amount.toStringAsFixed(0)}' : 'Free Entry',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: EnrollActivitySheet._primary),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: EnrollActivitySheet._primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'Confirm & Activate Pass',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentMethodChip(String method, String label, IconData icon) {
    final isSelected = _paymentMethod == method;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _paymentMethod = method),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? EnrollActivitySheet._primary.withValues(alpha: 0.1)
                : (isDark ? const Color(0xFF232736) : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? EnrollActivitySheet._primary
                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: isSelected ? EnrollActivitySheet._primary : Colors.grey),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? EnrollActivitySheet._primary : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
