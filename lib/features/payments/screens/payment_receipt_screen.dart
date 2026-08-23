import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/payments_providers.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/error_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading_indicator.dart';

class PaymentReceiptScreen extends ConsumerWidget {
  const PaymentReceiptScreen({super.key, required this.paymentId});

  final String paymentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final paymentAsync = ref.watch(paymentDetailProvider(paymentId));

    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/payments');
            }
          },
        ),
        title: Text(l10n.paymentReceipt),
      ),
      body: AmbientBackground(
        child: paymentAsync.when(
          loading: () => const LoadingIndicator(),
          error: (error, _) => ErrorStateView(
            error: error,
            onRetry: () => ref.invalidate(paymentDetailProvider(paymentId)),
          ),
          data: (payment) {
            final isINR = payment.currency.toUpperCase() == 'INR' || payment.currency.isEmpty;
            final currencySymbol = isINR ? '₹' : payment.currency;
            final currencyFormat = NumberFormat.currency(
              locale: 'en_IN',
              symbol: currencySymbol,
              decimalDigits: 2,
            );
            final accent = payment.isPaid ? scheme.secondary : scheme.error;
            final paymentTimestamp = payment.paidAt ?? payment.createdAt;
            final facilityName = (payment.facilityName?.isNotEmpty == true)
                ? payment.facilityName!
                : ((payment.notes?.isNotEmpty == true && !payment.notes!.startsWith('http'))
                    ? payment.notes!
                    : (payment.payableType != null ? payment.payableType! : 'Civic Facility'));

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accent.withValues(alpha: 0.12),
                          ),
                          child: Icon(
                            payment.isPaid
                                ? Icons.check_circle_rounded
                                : Icons.schedule_rounded,
                            size: 44,
                            color: accent,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currencyFormat.format(payment.amount),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          payment.status.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: accent,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ReceiptRow(
                          label: 'Facility',
                          value: facilityName,
                        ),
                        const Divider(height: 24),
                        _ReceiptRow(label: l10n.status, value: payment.status.toUpperCase()),
                        const Divider(height: 24),
                        _ReceiptRow(
                          label: l10n.paymentMethod,
                          value: (payment.paymentMethod ?? 'UPI / BHIM QR').toUpperCase(),
                        ),
                        const Divider(height: 24),
                        _ReceiptRow(
                          label: l10n.transactionReference,
                          value: payment.transactionReference ?? '—',
                        ),
                        const Divider(height: 24),
                        _ReceiptRow(
                          label: l10n.invoiceNumber,
                          value: payment.invoiceNumber ?? '—',
                        ),
                        const Divider(height: 24),
                        _ReceiptRow(
                          label: 'Payment Date',
                          value: paymentTimestamp != null
                              ? DateFormat('dd MMM yyyy').format(paymentTimestamp.toLocal())
                              : (payment.dueDate != null
                                  ? DateFormat('dd MMM yyyy').format(payment.dueDate!.toLocal())
                                  : '—'),
                        ),
                        const Divider(height: 24),
                        _ReceiptRow(
                          label: 'Payment Time',
                          value: paymentTimestamp != null
                              ? DateFormat('hh:mm a').format(paymentTimestamp.toLocal())
                              : '—',
                        ),
                        if (payment.notes != null &&
                            payment.notes!.isNotEmpty &&
                            payment.notes != facilityName) ...[
                          const Divider(height: 24),
                          _ReceiptRow(label: l10n.notes, value: payment.notes!),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (payment.status.toLowerCase() == 'refunded')
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.replay_circle_filled_rounded, color: Color(0xFFF59E0B), size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'This payment was refunded. A refund confirmation has been sent to your registered email and the tax invoice has been cancelled.',
                            style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFFD97706), fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: scheme.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.mail_rounded, color: scheme.secondary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.invoiceEmailedNotice,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}
