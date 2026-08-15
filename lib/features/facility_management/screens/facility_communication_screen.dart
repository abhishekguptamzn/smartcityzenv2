import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';

final facilityCommunicationsProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (FacilityKind, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getCommunications(args.$1, args.$2);
});

class FacilityCommunicationScreen extends ConsumerStatefulWidget {
  const FacilityCommunicationScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilityCommunicationScreen> createState() => _FacilityCommunicationScreenState();
}

class _FacilityCommunicationScreenState extends ConsumerState<FacilityCommunicationScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final commsAsync = ref.watch(facilityCommunicationsProvider((widget.kind, widget.facilityId)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Communication'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.refresh(facilityCommunicationsProvider((widget.kind, widget.facilityId))),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _showComposeSheet,
            icon: const Icon(Icons.add_rounded),
            label: const Text('New Communication', style: TextStyle(fontWeight: FontWeight.bold)),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ),
      body: AmbientBackground(
        child: commsAsync.when(
          data: (data) {
            final stats = data['stats'] as Map<String, dynamic>? ?? {};
            final totalSent = stats['total_sent'] ?? 0;
            final totalEmails = stats['total_emails'] ?? 0;
            final thisMonth = stats['this_month_count'] ?? 0;
            final communications = data['communications'] as List<FacilityCommunicationItem>? ?? [];

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 3 Stat Summary Cards
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('Sent', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                            const SizedBox(height: 4),
                            Text('$totalSent', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(height: 32, width: 1, color: scheme.outlineVariant.withValues(alpha: 0.4)),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Emails', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                            const SizedBox(height: 4),
                            Text('$totalEmails', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(height: 32, width: 1, color: scheme.outlineVariant.withValues(alpha: 0.4)),
                      Expanded(
                        child: Column(
                          children: [
                            Text('This Month', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                            const SizedBox(height: 4),
                            Text('$thisMonth', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Recent Communications Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Communications',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View All', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Communications List
                if (communications.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.mark_email_read_outlined, size: 40, color: scheme.onSurfaceVariant),
                          const SizedBox(height: 8),
                          Text('No broadcasts sent yet', style: TextStyle(color: scheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  )
                else
                  for (final item in communications) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'To: ${item.recipientsCount} Members',
                                  style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.dateFormatted,
                                  style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant.withValues(alpha: 0.8)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Email',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  void _showComposeSheet() {
    final titleCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    final messageCtrl = TextEditingController();
    String targetFilter = 'active';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          margin: EdgeInsets.only(top: 80, bottom: MediaQuery.of(ctx).viewInsets.bottom),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('New Broadcast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 12),

                // Target Recipients
                const Text('Recipients Target', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('All Active Members', style: TextStyle(fontSize: 12)),
                      selected: targetFilter == 'active',
                      onSelected: (val) {
                        if (val) setSheetState(() => targetFilter = 'active');
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Unpaid Members', style: TextStyle(fontSize: 12)),
                      selected: targetFilter == 'unpaid',
                      onSelected: (val) {
                        if (val) setSheetState(() => targetFilter = 'unpaid');
                      },
                    ),
                    ChoiceChip(
                      label: const Text('All Registered', style: TextStyle(fontSize: 12)),
                      selected: targetFilter == 'all',
                      onSelected: (val) {
                        if (val) setSheetState(() => targetFilter = 'all');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Internal Title (e.g. Weekend Special Offer) *', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: subjectCtrl,
                  decoration: const InputDecoration(labelText: 'Email Subject *', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: messageCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Message Body *', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      if (titleCtrl.text.trim().isEmpty || subjectCtrl.text.trim().isEmpty || messageCtrl.text.trim().isEmpty) {
                        return;
                      }
                      Navigator.pop(ctx);
                      try {
                        final res = await ref.read(clientFacilityRepositoryProvider).sendCommunication(
                          widget.kind,
                          widget.facilityId,
                          {
                            'title': titleCtrl.text.trim(),
                            'subject': subjectCtrl.text.trim(),
                            'message': messageCtrl.text.trim(),
                            'target_filter': targetFilter,
                          },
                        );

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(res['meta']?['message'] ?? 'Broadcast dispatched successfully!'),
                            backgroundColor: const Color(0xFF059669),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        ref.invalidate(facilityCommunicationsProvider((widget.kind, widget.facilityId)));
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red.shade700),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0D9488)),
                    child: const Text('Send Broadcast Email'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
