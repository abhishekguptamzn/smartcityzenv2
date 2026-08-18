import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/payments_providers.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading_indicator.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  final _scrollController = ScrollController();
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref
            .read(
              paymentListProvider(
                PaymentListParams(status: _statusFilter),
              ).notifier,
            )
            .loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final params = PaymentListParams(status: _statusFilter);
    final paymentsAsync = ref.watch(paymentListProvider(params));
    final statuses = <String?>[null, 'paid', 'pending', 'failed', 'refunded'];

    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(l10n.myPayments),
      ),
      body: AmbientBackground(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (final status in statuses)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(status ?? l10n.filters),
                        selected: _statusFilter == status,
                        selectedColor: scheme.secondary,
                        labelStyle: TextStyle(
                          color: _statusFilter == status
                              ? scheme.onSecondary
                              : null,
                        ),
                        onSelected: (_) =>
                            setState(() => _statusFilter = status),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: paymentsAsync.when(
                loading: () => const LoadingIndicator(),
                error: (error, _) => ErrorStateView(
                  error: error,
                  onRetry: () => ref.invalidate(paymentListProvider(params)),
                ),
                data: (payments) {
                  if (payments.isEmpty) {
                    return EmptyStateView(
                      icon: Icons.receipt_long_rounded,
                      message: l10n.noPaymentsYet,
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(paymentListProvider(params));
                      await ref.read(paymentListProvider(params).future);
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: payments.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final p = payments[i];
                        final accent = p.isPaid
                            ? scheme.secondary
                            : scheme.error;
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: accent.withValues(alpha: 0.14),
                              child: Icon(
                                p.isPaid
                                    ? Icons.check_rounded
                                    : Icons.schedule_rounded,
                                color: accent,
                                size: 18,
                              ),
                            ),
                            title: Text(
                              NumberFormat.currency(
                                name: p.currency,
                                decimalDigits: 0,
                              ).format(p.amount),
                            ),
                            subtitle: Text(p.paymentMethod ?? p.status),
                            trailing: Text(
                              p.paidAt != null
                                  ? DateFormat.yMMMd().format(p.paidAt!)
                                  : p.status,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            onTap: () => context.push('/payments/${p.id}'),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
