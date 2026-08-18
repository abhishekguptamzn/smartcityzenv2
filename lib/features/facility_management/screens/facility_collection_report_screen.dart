import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';

final collectionReportProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (FacilityKind, String, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getCollectionsReport(args.$1, args.$2, period: args.$3);
});

class FacilityCollectionReportScreen extends ConsumerStatefulWidget {
  const FacilityCollectionReportScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilityCollectionReportScreen> createState() => _FacilityCollectionReportScreenState();
}

class _FacilityCollectionReportScreenState extends ConsumerState<FacilityCollectionReportScreen> {
  String _selectedPeriod = 'month';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final reportAsync = ref.watch(collectionReportProvider((widget.kind, widget.facilityId, _selectedPeriod)));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/client/facilities');
            }
          },
        ),
        title: const Text('Collection Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting collections statement...'), behavior: SnackBarBehavior.floating),
              );
            },
          ),
        ],
      ),
      body: AmbientBackground(
        child: Column(
          children: [
            // Period Selector Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPeriod,
                        items: const [
                          DropdownMenuItem(value: 'today', child: Text('Today', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                          DropdownMenuItem(value: 'week', child: Text('This Week', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                          DropdownMenuItem(value: 'month', child: Text('This Month', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                          DropdownMenuItem(value: 'quarter', child: Text('This Quarter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                          DropdownMenuItem(value: 'year', child: Text('This Year', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedPeriod = val);
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.filter_list_rounded),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Big Total Collection Card
            reportAsync.when(
              data: (data) {
                final total = (data['total_collection'] as num?)?.toDouble() ?? 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x06000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Collection', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Text(
                          '₹${total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Transactions Header
            reportAsync.when(
              data: (data) {
                final count = data['total_transactions'] ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'Transactions ($count)',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 6),

            // Transactions List
            Expanded(
              child: reportAsync.when(
                data: (data) {
                  final txs = data['transactions'] as List<CollectionTransaction>? ?? [];

                  if (txs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 40, color: scheme.onSurfaceVariant),
                          const SizedBox(height: 8),
                          Text('No payment transactions recorded for this period', style: TextStyle(color: scheme.onSurfaceVariant)),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: txs.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, idx) {
                      final tx = txs[idx];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.arrow_downward_rounded, color: Color(0xFF059669), size: 16),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tx.memberName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${tx.date} • ${tx.planName}',
                                    style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹${tx.amount.toStringAsFixed(0)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      tx.paymentMethod,
                                      style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'Paid',
                                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                                      ),
                                    ),
                                  ],
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
                error: (err, _) => Center(child: Text('Error loading collections: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
