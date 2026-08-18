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
            final currencyFormat = NumberFormat.currency(
              name: payment.currency,
              decimalDigits: 2,
            );
            final accent = payment.isPaid ? scheme.secondary : scheme.error;
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
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          payment.status,
                          style: Theme.of(context).textTheme.bodyMedium,
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
                        _ReceiptRow(label: l10n.status, value: payment.status),
                        const Divider(height: 24),
                        _ReceiptRow(
                          label: l10n.paymentMethod,
                          value: payment.paymentMethod ?? '—',
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
                          label: l10n.dueDate,
                          value: payment.dueDate != null
                              ? DateFormat.yMMMd().format(payment.dueDate!)
                              : '—',
                        ),
                        const Divider(height: 24),
                        _ReceiptRow(
                          label: l10n.paidOn,
                          value: payment.paidAt != null
                              ? DateFormat.yMMMd().format(payment.paidAt!)
                              : '—',
                        ),
                        if (payment.notes != null &&
                            payment.notes!.isNotEmpty) ...[
                          const Divider(height: 24),
                          _ReceiptRow(label: l10n.notes, value: payment.notes!),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
