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
                        final isRefunded = p.status.toLowerCase() == 'refunded';
                        final isPaid = p.isPaid;
                        final accent = isRefunded
                            ? const Color(0xFFF59E0B)
                            : (isPaid ? scheme.secondary : scheme.error);

                        final facilityName = (p.facilityName != null && p.facilityName!.isNotEmpty)
                            ? p.facilityName!
                            : (p.notes != null && p.notes!.isNotEmpty && !p.notes!.startsWith('http')
                                ? p.notes!
                                : (p.payableType ?? 'Civic Facility'));

                        final timestamp = p.paidAt ?? p.createdAt;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isRefunded
                                  ? const Color(0xFFF59E0B).withValues(alpha: 0.3)
                                  : Colors.transparent,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => context.push('/payments/${p.id}'),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: accent.withValues(alpha: 0.14),
                                    child: Icon(
                                      isRefunded
                                          ? Icons.replay_rounded
                                          : (isPaid ? Icons.check_circle_rounded : Icons.schedule_rounded),
                                      color: accent,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          facilityName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time_rounded,
                                              size: 13,
                                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              timestamp != null
                                                  ? DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toLocal())
                                                  : (p.dueDate != null
                                                      ? DateFormat('dd MMM yyyy').format(p.dueDate!.toLocal())
                                                      : '—'),
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        NumberFormat.currency(
                                          name: p.currency.toUpperCase() == 'INR' ? 'INR' : p.currency,
                                          symbol: p.currency.toUpperCase() == 'INR' || p.currency.isEmpty ? '₹' : p.currency,
                                          decimalDigits: 0,
                                        ).format(p.amount),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: accent.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          p.status.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w800,
                                            color: accent,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
