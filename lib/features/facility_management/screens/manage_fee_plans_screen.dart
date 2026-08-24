import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/models/fee_plan_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading/loading_button.dart';
import '../widgets/facility_management_skeletons.dart';
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 92),
              itemCount: plans.length,
              itemBuilder: (ctx, idx) {
                final plan = plans[idx];
                return _FeePlanCardItem(
                  key: ValueKey(plan.id),
                  plan: plan,
                  kind: kind,
                  facilityId: facilityId,
                  onEdit: () => _openPlanDialog(context, ref, plan),
                );
              },
            );
          },
          loading: () => const FeePlansSkeleton(),
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

/// A sleek, individual fee plan card with instant optimistic toggles
class _FeePlanCardItem extends ConsumerStatefulWidget {
  const _FeePlanCardItem({
    super.key,
    required this.plan,
    required this.kind,
    required this.facilityId,
    required this.onEdit,
  });

  final FeePlanModel plan;
  final FacilityKind kind;
  final String facilityId;
  final VoidCallback onEdit;

  @override
  ConsumerState<_FeePlanCardItem> createState() => _FeePlanCardItemState();
}

class _FeePlanCardItemState extends ConsumerState<_FeePlanCardItem> {
  late bool _isActive;
  late bool _showToCitizen;
  bool _isUpdatingActive = false;
  bool _isUpdatingCitizen = false;

  @override
  void initState() {
    super.initState();
    _isActive = widget.plan.isActive;
    _showToCitizen = widget.plan.showToCitizen;
  }

  @override
  void didUpdateWidget(covariant _FeePlanCardItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.plan.isActive != widget.plan.isActive) {
      _isActive = widget.plan.isActive;
    }
    if (oldWidget.plan.showToCitizen != widget.plan.showToCitizen) {
      _showToCitizen = widget.plan.showToCitizen;
    }
  }

  Future<void> _toggleActive(bool newValue) async {
    if (_isUpdatingActive) return;
    setState(() {
      _isActive = newValue;
      _isUpdatingActive = true;
    });

    try {
      final repo = ref.read(clientFacilityRepositoryProvider);
      await repo.updateFacilityPlan(widget.kind, widget.facilityId, widget.plan.id, {
        'is_active': newValue,
      });
      ref.invalidate(facilityPlansFamilyProvider((widget.kind, widget.facilityId)));
      ref.invalidate(facilityStatsProvider((widget.kind, widget.facilityId)));
    } catch (err) {
      if (mounted) {
        setState(() => _isActive = !newValue);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update plan status: $err'),
            backgroundColor: const Color(0xFFDC2626),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdatingActive = false);
    }
  }

  Future<void> _toggleCitizenView(bool newValue) async {
    if (_isUpdatingCitizen) return;
    setState(() {
      _showToCitizen = newValue;
      _isUpdatingCitizen = true;
    });

    try {
      final repo = ref.read(clientFacilityRepositoryProvider);
      await repo.updateFacilityPlan(widget.kind, widget.facilityId, widget.plan.id, {
        'show_to_citizen': newValue,
      });
      ref.invalidate(facilityPlansFamilyProvider((widget.kind, widget.facilityId)));
    } catch (err) {
      if (mounted) {
        setState(() => _showToCitizen = !newValue);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update citizen visibility: $err'),
            backgroundColor: const Color(0xFFDC2626),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdatingCitizen = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: const Text('Delete Plan?'),
        content: Text('Are you sure you want to delete "${widget.plan.name}"?'),
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

    if (confirm == true && mounted) {
      try {
        final repo = ref.read(clientFacilityRepositoryProvider);
        await repo.deleteFacilityPlan(widget.kind, widget.facilityId, widget.plan.id);
        ref.invalidate(facilityPlansFamilyProvider((widget.kind, widget.facilityId)));
        ref.invalidate(facilityStatsProvider((widget.kind, widget.facilityId)));
        ref.invalidate(myOwnedFacilitiesProvider);
      } catch (err) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete plan: $err'),
              backgroundColor: const Color(0xFFDC2626),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final p = widget.plan;
    final price = p.amount;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: isDark ? 0.2 : 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Title, Badges & Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.5,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          // Interval badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              p.interval.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10.5,
                                color: scheme.primary,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          // Active status badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: _isActive
                                  ? const Color(0xFF10B981).withValues(alpha: 0.12)
                                  : Colors.grey.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 3,
                                  backgroundColor: _isActive ? const Color(0xFF10B981) : Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _isActive ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: _isActive ? const Color(0xFF059669) : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Public/Hidden citizen visibility badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: _showToCitizen
                                  ? const Color(0xFF0D9488).withValues(alpha: 0.12)
                                  : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _showToCitizen ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                  size: 11,
                                  color: _showToCitizen ? const Color(0xFF0D9488) : const Color(0xFFD97706),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _showToCitizen ? 'Public' : 'Hidden',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: _showToCitizen ? const Color(0xFF0D9488) : const Color(0xFFD97706),
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
                const SizedBox(width: 8),
                Text(
                  '₹${price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 19,
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],

            const SizedBox(height: 10),
            Divider(
              height: 1,
              color: scheme.outlineVariant.withValues(alpha: isDark ? 0.15 : 0.3),
            ),
            const SizedBox(height: 8),

            // Bottom Action & Toggle Bar
            Row(
              children: [
                // Compact Active Toggle
                InkWell(
                  onTap: () => _toggleActive(!_isActive),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _CompactSwitch(
                          value: _isActive,
                          onChanged: _toggleActive,
                          activeColor: const Color(0xFF10B981),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Active',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: _isActive
                                ? (isDark ? Colors.white : const Color(0xFF1E293B))
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Compact Citizen View Toggle
                InkWell(
                  onTap: () => _toggleCitizenView(!_showToCitizen),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _CompactSwitch(
                          value: _showToCitizen,
                          onChanged: _toggleCitizenView,
                          activeColor: const Color(0xFF0D9488),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Citizen View',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: _showToCitizen
                                ? (isDark ? Colors.white : const Color(0xFF1E293B))
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Edit Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onEdit,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                // Delete Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _confirmDelete,
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A compact, modern micro-switch designed for tight cards and lists
class _CompactSwitch extends StatelessWidget {
  const _CompactSwitch({
    required this.value,
    required this.onChanged,
    this.activeColor = const Color(0xFF10B981),
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultInactive = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    final trackColor = value ? activeColor : defaultInactive;

    return GestureDetector(
      onTap: onChanged != null
          ? () {
              HapticFeedback.selectionClick();
              onChanged!(!value);
            }
          : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 36,
        height: 20,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: trackColor,
          boxShadow: value
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.35),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
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
            LoadingButton.filled(
              isLoading: _submitting,
              loadingText: widget.existingPlan != null ? 'Updating Plan...' : 'Creating Plan...',
              onPressed: _submitting ? null : _save,
              child: Text(
                widget.existingPlan != null ? 'Update Plan' : 'Create Plan',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
