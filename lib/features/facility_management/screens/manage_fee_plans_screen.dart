import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/models/fee_plan_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import 'facility_dashboard_screen.dart';

final facilityPlansFamilyProvider = FutureProvider.autoDispose.family<List<FeePlanModel>, (FacilityKind, String)>((ref, tuple) async {
  final (kind, facilityId) = tuple;
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getFacilityPlans(kind, facilityId);
});

class ManageFeePlansScreen extends ConsumerWidget {
  const ManageFeePlansScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  void _openPlanDialog(BuildContext context, WidgetRef ref, [FeePlanModel? plan]) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PlanEditorSheet(
        kind: kind,
        facilityId: facilityId,
        existingPlan: plan,
      ),
    ).then((_) {
      ref.invalidate(facilityPlansFamilyProvider((kind, facilityId)));
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final plansAsync = ref.watch(facilityPlansFamilyProvider((kind, facilityId)));
    final isGym = kind == FacilityKind.gym;

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
        title: Text('${facility?.name ?? (isGym ? "Gym" : "Library")} Plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add New Plan',
            onPressed: () => _openPlanDialog(context, ref),
          ),
        ],
      ),
      body: AmbientBackground(
        child: plansAsync.when(
          data: (plans) {
            if (plans.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.sell_outlined,
                          size: 44,
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Membership Plans Configured',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Create daily, monthly, or annual pricing plans for citizens.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: () => _openPlanDialog(context, ref),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Add First Plan'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: plans.length,
              itemBuilder: (ctx, idx) {
                final p = plans[idx];
                final price = p.amount;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: scheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: scheme.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          p.interval.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: scheme.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: p.isActive
                                              ? const Color(0xFF10B981).withValues(alpha: 0.12)
                                              : Colors.grey.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              radius: 3.5,
                                              backgroundColor: p.isActive ? const Color(0xFF10B981) : Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              p.isActive ? 'Active' : 'Inactive',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: p.isActive ? const Color(0xFF059669) : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: p.showToCitizen
                                              ? const Color(0xFF0D9488).withValues(alpha: 0.12)
                                              : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              p.showToCitizen ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                              size: 11,
                                              color: p.showToCitizen ? const Color(0xFF0D9488) : const Color(0xFFD97706),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              p.showToCitizen ? 'Public' : 'Hidden',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: p.showToCitizen ? const Color(0xFF0D9488) : const Color(0xFFD97706),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '₹${price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0D9488),
                              ),
                            ),
                          ],
                        ),
                        if (p.description != null && p.description!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            p.description!,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            // Quick Toggle: Active
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 38,
                                  child: Switch(
                                    value: p.isActive,
                                    activeThumbColor: const Color(0xFF10B981),
                                    onChanged: (val) async {
                                      final repo = ref.read(clientFacilityRepositoryProvider);
                                      await repo.updateFacilityPlan(kind, facilityId, p.id, {
                                        'is_active': val,
                                      });
                                      ref.invalidate(facilityPlansFamilyProvider((kind, facilityId)));
                                    },
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Active',
                                  style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            // Quick Toggle: Show to Citizen
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 38,
                                  child: Switch(
                                    value: p.showToCitizen,
                                    activeThumbColor: const Color(0xFF0D9488),
                                    onChanged: (val) async {
                                      final repo = ref.read(clientFacilityRepositoryProvider);
                                      await repo.updateFacilityPlan(kind, facilityId, p.id, {
                                        'show_to_citizen': val,
                                      });
                                      ref.invalidate(facilityPlansFamilyProvider((kind, facilityId)));
                                    },
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Citizen View',
                                  style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              tooltip: 'Edit',
                              onPressed: () => _openPlanDialog(context, ref, p),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFDC2626)),
                              tooltip: 'Delete',
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (dCtx) => AlertDialog(
                                    title: const Text('Delete Plan?'),
                                    content: Text('Are you sure you want to delete "${p.name}"?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(dCtx, false),
                                        child: const Text('Cancel'),
                                      ),
                                      FilledButton(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: const Color(0xFFDC2626),
                                        ),
                                        onPressed: () => Navigator.pop(dCtx, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  final repo = ref.read(clientFacilityRepositoryProvider);
                                  await repo.deleteFacilityPlan(kind, facilityId, p.id);
                                  ref.invalidate(facilityPlansFamilyProvider((kind, facilityId)));
                                  ref.invalidate(facilityStatsProvider((kind, facilityId)));
                                  ref.invalidate(myOwnedFacilitiesProvider);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Text('Error loading plans: $err', style: TextStyle(color: scheme.error)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openPlanDialog(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Plan'),
      ),
    );
  }
}

class _PlanEditorSheet extends ConsumerStatefulWidget {
  const _PlanEditorSheet({
    required this.kind,
    required this.facilityId,
    this.existingPlan,
  });

  final FacilityKind kind;
  final String facilityId;
  final FeePlanModel? existingPlan;

  @override
  ConsumerState<_PlanEditorSheet> createState() => _PlanEditorSheetState();
}

class _PlanEditorSheetState extends ConsumerState<_PlanEditorSheet> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _selectedDuration = 'Monthly';
  bool _isActive = true;
  bool _showToCitizen = true;
  bool _submitting = false;

  final _durations = ['Hourly', 'Daily', 'Weekly', 'Monthly', 'Annual'];

  @override
  void initState() {
    super.initState();
    if (widget.existingPlan != null) {
      final p = widget.existingPlan!;
      _nameCtrl.text = p.name;
      _priceCtrl.text = p.amount.toStringAsFixed(0);
      _descCtrl.text = p.description ?? '';
      _isActive = p.isActive;
      _showToCitizen = p.showToCitizen;
      _selectedDuration = _durations.firstWhere(
        (d) => d.toLowerCase() == p.interval.toLowerCase(),
        orElse: () => 'Monthly',
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0;
    if (name.isEmpty || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid plan name and price'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    final repo = ref.read(clientFacilityRepositoryProvider);

    try {
      final payload = {
        'name': name,
        'price': price,
        'duration': _selectedDuration,
        'description': _descCtrl.text.trim(),
        'is_active': _isActive,
        'show_to_citizen': _showToCitizen,
      };

      if (widget.existingPlan != null) {
        await repo.updateFacilityPlan(widget.kind, widget.facilityId, widget.existingPlan!.id, payload);
      } else {
        await repo.createFacilityPlan(widget.kind, widget.facilityId, payload);
      }

      ref.invalidate(facilityPlansFamilyProvider((widget.kind, widget.facilityId)));
      ref.invalidate(facilityStatsProvider((widget.kind, widget.facilityId)));
      ref.invalidate(myOwnedFacilitiesProvider);

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Plan ${widget.existingPlan != null ? "updated" : "created"} successfully!'),
          backgroundColor: const Color(0xFF0D9488),
        ),
      );
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save plan: $err'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      margin: EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: viewInsets.bottom + 12,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: scheme.outlineVariant.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              widget.existingPlan != null ? 'Edit Membership Plan' : 'Create New Membership Plan',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: 'Plan Name *',
                hintText: 'e.g. Monthly Standard Pass',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price (₹) *',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedDuration,
                    decoration: InputDecoration(
                      labelText: 'Duration *',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: _durations
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedDuration = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Description & Included Features',
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: scheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    title: const Text('Active Plan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Enable plan for facility operations and renewals', style: TextStyle(fontSize: 11.5)),
                    value: _isActive,
                    activeThumbColor: const Color(0xFF10B981),
                    onChanged: (val) => setState(() => _isActive = val),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile.adaptive(
                    title: const Text('Show to Citizens (Public View)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Display this plan on the public facility & activity details screen', style: TextStyle(fontSize: 11.5)),
                    value: _showToCitizen,
                    activeThumbColor: const Color(0xFF0D9488),
                    onChanged: (val) => setState(() => _showToCitizen = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _submitting ? null : _save,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(widget.existingPlan != null ? 'Update Plan' : 'Create Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
