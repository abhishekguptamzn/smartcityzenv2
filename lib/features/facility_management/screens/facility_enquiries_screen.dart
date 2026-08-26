import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/facility_management_skeletons.dart';

final facilityEnquiriesProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (FacilityKind, String, String, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getEnquiries(args.$1, args.$2, status: args.$3, search: args.$4);
});

class FacilityEnquiriesScreen extends ConsumerStatefulWidget {
  const FacilityEnquiriesScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilityEnquiriesScreen> createState() => _FacilityEnquiriesScreenState();
}

class _FacilityEnquiriesScreenState extends ConsumerState<FacilityEnquiriesScreen> {
  String _selectedStatus = 'all';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final enquiriesAsync = ref.watch(facilityEnquiriesProvider((widget.kind, widget.facilityId, _selectedStatus, _searchQuery)));

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
        title: const Text('Enquiries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.refresh(facilityEnquiriesProvider((widget.kind, widget.facilityId, _selectedStatus, _searchQuery))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewEnquirySheet(context),
        backgroundColor: const Color(0xFF0D9488),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('New Enquiry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: AmbientBackground(
        child: Column(
          children: [
            // Filter Chips Row
            enquiriesAsync.when(
              data: (data) {
                final counts = data['counts'] as Map<String, dynamic>? ?? {};
                final allCount = counts['all'] ?? 0;
                final newCount = counts['new'] ?? 0;
                final repliedCount = counts['replied'] ?? 0;
                final closedCount = counts['closed'] ?? 0;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _FilterTabChip(
                        label: 'All',
                        count: allCount,
                        isSelected: _selectedStatus == 'all',
                        onTap: () => setState(() => _selectedStatus = 'all'),
                      ),
                      const SizedBox(width: 8),
                      _FilterTabChip(
                        label: 'New',
                        count: newCount,
                        isSelected: _selectedStatus == 'new',
                        badgeColor: const Color(0xFFF97316),
                        onTap: () => setState(() => _selectedStatus = 'new'),
                      ),
                      const SizedBox(width: 8),
                      _FilterTabChip(
                        label: 'Replied',
                        count: repliedCount,
                        isSelected: _selectedStatus == 'replied',
                        badgeColor: const Color(0xFF0284C7),
                        onTap: () => setState(() => _selectedStatus = 'replied'),
                      ),
                      const SizedBox(width: 8),
                      _FilterTabChip(
                        label: 'Closed',
                        count: closedCount,
                        isSelected: _selectedStatus == 'closed',
                        badgeColor: const Color(0xFF10B981),
                        onTap: () => setState(() => _selectedStatus = 'closed'),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search enquiries...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                  ),
                ),
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
              ),
            ),
            const SizedBox(height: 6),

            // Enquiries List
            Expanded(
              child: enquiriesAsync.when(
                data: (data) {
                  final enquiries = data['enquiries'] as List<FacilityEnquiryItem>? ?? [];

                  if (enquiries.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.forum_outlined, size: 48, color: scheme.onSurfaceVariant),
                          const SizedBox(height: 12),
                          Text('No enquiries found', style: TextStyle(color: scheme.onSurfaceVariant)),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: enquiries.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, idx) {
                      final item = enquiries[idx];

                      Color badgeBg = const Color(0xFFF97316).withValues(alpha: 0.12);
                      Color badgeText = const Color(0xFFEA580C);
                      String badgeLabel = 'NEW';

                      if (item.status == 'replied') {
                        badgeBg = const Color(0xFF0284C7).withValues(alpha: 0.12);
                        badgeText = const Color(0xFF0284C7);
                        badgeLabel = 'REPLIED';
                      } else if (item.status == 'closed') {
                        badgeBg = const Color(0xFF10B981).withValues(alpha: 0.12);
                        badgeText = const Color(0xFF059669);
                        badgeLabel = 'CLOSED';
                      }

                      return InkWell(
                        onTap: () {
                          context.push(
                            '/client/manage/enquiries/${widget.kind.pathSegment}/${widget.facilityId}/${item.id}',
                            extra: {'enquiry': item, 'facility': widget.facility},
                          ).then((_) {
                            ref.invalidate(facilityEnquiriesProvider((widget.kind, widget.facilityId, _selectedStatus, _searchQuery)));
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                                    child: Text(
                                      item.name.isNotEmpty ? item.name[0].toUpperCase() : 'C',
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6), fontSize: 13),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ),
                                  Text(
                                    item.timeFormatted,
                                    style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: badgeBg,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      badgeLabel,
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: badgeText),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.message,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const FacilityEnquiriesSkeleton(),
                error: (err, _) => Center(child: Text('Error loading enquiries: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewEnquirySheet(BuildContext context) {
    final user = ref.read(authControllerProvider).value;
    final nameCtrl = TextEditingController(text: user?.name ?? '');
    final emailCtrl = TextEditingController(text: user?.email ?? '');
    final phoneCtrl = TextEditingController(text: user?.phone ?? '');
    final subjectCtrl = TextEditingController();
    final messageCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          margin: EdgeInsets.only(top: 80, bottom: MediaQuery.of(ctx).viewInsets.bottom),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Create Enquiry', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Customer Name *', border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter customer name' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Customer Email *', border: OutlineInputBorder()),
                    validator: (v) => (v == null || !v.contains('@')) ? 'Please enter a valid email' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: subjectCtrl,
                    decoration: const InputDecoration(labelText: 'Subject *', border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a subject' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: messageCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Message / Query *', border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your message or query' : null,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0D9488),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }
                              setModalState(() => isSubmitting = true);
                              try {
                                await ref.read(clientFacilityRepositoryProvider).submitCitizenEnquiry(
                                  widget.kind,
                                  widget.facilityId,
                                  {
                                    'name': nameCtrl.text.trim(),
                                    'email': emailCtrl.text.trim(),
                                    'phone': phoneCtrl.text.trim(),
                                    'subject': subjectCtrl.text.trim(),
                                    'message': messageCtrl.text.trim(),
                                  },
                                );
                                if (ctx.mounted) Navigator.pop(ctx);
                                ref.invalidate(facilityEnquiriesProvider((widget.kind, widget.facilityId, _selectedStatus, _searchQuery)));
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Enquiry submitted successfully!'),
                                      backgroundColor: Color(0xFF10B981),
                                    ),
                                  );
                                }
                              } catch (e) {
                                setModalState(() => isSubmitting = false);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to submit enquiry: $e'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              }
                            },
                      child: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Submit Enquiry', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterTabChip extends StatelessWidget {
  const _FilterTabChip({
    required this.label,
    required this.count,
    required this.isSelected,
    this.badgeColor,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final Color? badgeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? scheme.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? scheme.primary : scheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : scheme.onSurface,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : (badgeColor ?? scheme.primary).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : (badgeColor ?? scheme.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
