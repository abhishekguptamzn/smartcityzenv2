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
    final memberSearchCtrl = TextEditingController();
    String targetFilter = 'active';
    int expiringDays = 7;
    final Set<String> selectedMemberIds = <String>{};
    List<Map<String, dynamic>> availableMembers = [];
    bool loadingMembers = false;
    String memberSearchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final theme = Theme.of(context);
          final scheme = theme.colorScheme;

          void loadMembersIfNeeded() async {
            if (availableMembers.isNotEmpty || loadingMembers) return;
            setSheetState(() => loadingMembers = true);
            try {
              final repo = ref.read(clientFacilityRepositoryProvider);
              final members = widget.kind == FacilityKind.gym
                  ? await repo.getGymMembers(widget.facilityId)
                  : await repo.getLibraryMembers(widget.facilityId);
              setSheetState(() {
                availableMembers = members;
                loadingMembers = false;
              });
            } catch (_) {
              setSheetState(() => loadingMembers = false);
            }
          }

          if (targetFilter == 'selected_members') {
            loadMembersIfNeeded();
          }

          final filteredMemberList = availableMembers.where((m) {
            if (memberSearchQuery.isEmpty) return true;
            final user = m['user'] as Map<String, dynamic>? ?? {};
            final name = user['name']?.toString().toLowerCase() ?? '';
            final email = user['email']?.toString().toLowerCase() ?? '';
            final phone = user['phone']?.toString().toLowerCase() ?? '';
            final q = memberSearchQuery.toLowerCase();
            return name.contains(q) || email.contains(q) || phone.contains(q);
          }).toList();

          return Container(
            margin: EdgeInsets.only(top: 60, bottom: MediaQuery.of(ctx).viewInsets.bottom),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Compose Broadcast Email', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Target Recipients
                  const Text('Recipients Target', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      ChoiceChip(
                        label: const Text('Active Members', style: TextStyle(fontSize: 12)),
                        selected: targetFilter == 'active',
                        onSelected: (val) {
                          if (val) setSheetState(() => targetFilter = 'active');
                        },
                      ),
                      ChoiceChip(
                        avatar: const Icon(Icons.hourglass_bottom_rounded, size: 16),
                        label: Text('Expiring in $expiringDays Days', style: const TextStyle(fontSize: 12)),
                        selected: targetFilter == 'expiring_in_days',
                        onSelected: (val) {
                          if (val) setSheetState(() => targetFilter = 'expiring_in_days');
                        },
                      ),
                      ChoiceChip(
                        avatar: const Icon(Icons.checklist_rounded, size: 16),
                        label: Text(
                          selectedMemberIds.isEmpty
                              ? 'Select Specific Members'
                              : '${selectedMemberIds.length} Members Selected',
                          style: const TextStyle(fontSize: 12),
                        ),
                        selected: targetFilter == 'selected_members',
                        onSelected: (val) {
                          if (val) {
                            setSheetState(() => targetFilter = 'selected_members');
                            loadMembersIfNeeded();
                          }
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
                  const SizedBox(height: 12),

                  // Expiring in Days Options
                  if (targetFilter == 'expiring_in_days') ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.event_busy_rounded, color: Colors.amber, size: 18),
                              SizedBox(width: 8),
                              Text('Select Expiration Window', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              for (final d in [3, 7, 14, 30])
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: Text('$d Days', style: const TextStyle(fontSize: 11)),
                                    selected: expiringDays == d,
                                    onSelected: (val) {
                                      if (val) setSheetState(() => expiringDays = d);
                                    },
                                  ),
                                ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: scheme.outlineVariant),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, size: 16),
                                        visualDensity: VisualDensity.compact,
                                        onPressed: expiringDays > 1 ? () => setSheetState(() => expiringDays--) : null,
                                      ),
                                      Text('$expiringDays d', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                      IconButton(
                                        icon: const Icon(Icons.add, size: 16),
                                        visualDensity: VisualDensity.compact,
                                        onPressed: expiringDays < 90 ? () => setSheetState(() => expiringDays++) : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Will target members whose membership validity expires within the next $expiringDays days.',
                            style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Selected Specific Members Checklist
                  if (targetFilter == 'selected_members') ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select Members (${selectedMemberIds.length} selected)',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                                    onPressed: availableMembers.isEmpty
                                        ? null
                                        : () {
                                            setSheetState(() {
                                              for (final m in availableMembers) {
                                                final id = m['id']?.toString() ?? '';
                                                if (id.isNotEmpty) selectedMemberIds.add(id);
                                              }
                                            });
                                          },
                                    child: const Text('Select All', style: TextStyle(fontSize: 11)),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                                    onPressed: selectedMemberIds.isEmpty
                                        ? null
                                        : () => setSheetState(() => selectedMemberIds.clear()),
                                    child: const Text('Clear', style: TextStyle(fontSize: 11)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TextField(
                            controller: memberSearchCtrl,
                            onChanged: (val) => setSheetState(() => memberSearchQuery = val),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Search members by name/email...',
                              prefixIcon: const Icon(Icons.search, size: 18),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (loadingMembers)
                            const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()))
                          else if (filteredMemberList.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text('No members found', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                            )
                          else
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 180),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredMemberList.length,
                                itemBuilder: (c, idx) {
                                  final m = filteredMemberList[idx];
                                  final id = m['id']?.toString() ?? '';
                                  final user = m['user'] as Map<String, dynamic>? ?? {};
                                  final name = user['name']?.toString() ?? 'Member';
                                  final email = user['email']?.toString() ?? '';
                                  final isChecked = id.isNotEmpty && selectedMemberIds.contains(id);

                                  return CheckboxListTile(
                                    dense: true,
                                    value: isChecked,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                    subtitle: Text(email.isNotEmpty ? email : '#$id', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                                    onChanged: id.isEmpty
                                        ? null
                                        : (val) {
                                            setSheetState(() {
                                              if (val == true) {
                                                selectedMemberIds.add(id);
                                              } else {
                                                selectedMemberIds.remove(id);
                                              }
                                            });
                                          },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Internal Broadcast Title (e.g. Pass Renewal Reminder) *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: subjectCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Email Subject Line *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: messageCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Message Body (Formatted HTML/Text) *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        if (titleCtrl.text.trim().isEmpty || subjectCtrl.text.trim().isEmpty || messageCtrl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill out Title, Subject, and Message.')),
                          );
                          return;
                        }

                        if (targetFilter == 'selected_members' && selectedMemberIds.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select at least 1 member from the checklist.')),
                          );
                          return;
                        }

                        Navigator.pop(ctx);
                        try {
                          final payload = {
                            'title': titleCtrl.text.trim(),
                            'subject': subjectCtrl.text.trim(),
                            'message': messageCtrl.text.trim(),
                            'target_filter': targetFilter,
                            if (targetFilter == 'expiring_in_days') 'days': expiringDays,
                            if (targetFilter == 'selected_members') ...{
                              'recipient_ids': selectedMemberIds.toList(),
                              'member_ids': selectedMemberIds.toList(),
                            },
                          };

                          final res = await ref.read(clientFacilityRepositoryProvider).sendCommunication(
                            widget.kind,
                            widget.facilityId,
                            payload,
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
                      style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0D9488), padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Send Broadcast Email', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
