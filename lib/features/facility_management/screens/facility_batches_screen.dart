import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/facility_batch_model.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';

final facilityBatchesProvider = FutureProvider.autoDispose
    .family<List<FacilityBatchModel>, (FacilityKind, String)>((ref, tuple) async {
  final (kind, facilityId) = tuple;
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getBatches(kind, facilityId);
});

class FacilityBatchesScreen extends ConsumerStatefulWidget {
  const FacilityBatchesScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilityBatchesScreen> createState() => _FacilityBatchesScreenState();
}

class _FacilityBatchesScreenState extends ConsumerState<FacilityBatchesScreen> {
  String _searchQuery = '';
  String _statusFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = widget.kind == FacilityKind.gym
        ? const Color(0xFF0D9488)
        : (widget.kind == FacilityKind.activity
            ? const Color(0xFF1565D8)
            : const Color(0xFF0284C7));

    final batchesAsync = ref.watch(facilityBatchesProvider((widget.kind, widget.facilityId)));

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
        title: Text(widget.facility != null ? '${widget.facility!.name} Batches' : 'Batches & Timetables'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(facilityBatchesProvider((widget.kind, widget.facilityId))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Batch', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () async {
          HapticFeedback.lightImpact();
          await context.push(
            '/client/manage/batches/${widget.kind.pathSegment}/${widget.facilityId}/create',
            extra: widget.facility,
          );
          ref.invalidate(facilityBatchesProvider((widget.kind, widget.facilityId)));
        },
      ),
      body: AmbientBackground(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(facilityBatchesProvider((widget.kind, widget.facilityId)));
          },
          child: Column(
            children: [
              // Search & Filter Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search batch name, room, or category...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        isDense: true,
                        filled: true,
                        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('all', 'All Batches'),
                          const SizedBox(width: 8),
                          _buildFilterChip('active', 'Active'),
                          const SizedBox(width: 8),
                          _buildFilterChip('inactive', 'Archived / Inactive'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Batch List
              Expanded(
                child: batchesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                          const SizedBox(height: 12),
                          Text('Failed to load batches: $err', textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Try Again'),
                            onPressed: () => ref.invalidate(facilityBatchesProvider((widget.kind, widget.facilityId))),
                          ),
                        ],
                      ),
                    ),
                  ),
                  data: (batches) {
                    final filtered = batches.where((b) {
                      final matchesSearch = _searchQuery.isEmpty ||
                          b.name.toLowerCase().contains(_searchQuery) ||
                          (b.room != null && b.room!.toLowerCase().contains(_searchQuery)) ||
                          (b.category != null && b.category!.toLowerCase().contains(_searchQuery));
                      final matchesStatus = _statusFilter == 'all' ||
                          (_statusFilter == 'active' && b.status == 'active') ||
                          (_statusFilter == 'inactive' && b.status != 'active');
                      return matchesSearch && matchesStatus;
                    }).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.groups_outlined, size: 48, color: primaryColor),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isNotEmpty ? 'No matching batches found' : 'No Batches Created Yet',
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? 'Try changing your search terms or filters.'
                                    : 'Create time-slotted batches with capacity limits, scheduled fees and attendance rosters.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                              ),
                              if (_searchQuery.isEmpty) ...[
                                const SizedBox(height: 16),
                                FilledButton.icon(
                                  style: FilledButton.styleFrom(backgroundColor: primaryColor),
                                  icon: const Icon(Icons.add_rounded),
                                  label: const Text('Create First Batch'),
                                  onPressed: () async {
                                    await context.push(
                                      '/client/manage/batches/${widget.kind.pathSegment}/${widget.facilityId}/create',
                                      extra: widget.facility,
                                    );
                                    ref.invalidate(facilityBatchesProvider((widget.kind, widget.facilityId)));
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 88),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final batch = filtered[i];
                        return _buildBatchCard(context, batch, primaryColor, isDark, scheme);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _statusFilter == key;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _statusFilter = key),
      selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildBatchCard(
    BuildContext context,
    FacilityBatchModel batch,
    Color primaryColor,
    bool isDark,
    ColorScheme scheme,
  ) {
    final capacity = batch.capacity;
    final enrolled = batch.enrolledCount;
    final progress = capacity > 0 ? (enrolled / capacity).clamp(0.0, 1.0) : 0.0;
    final isFull = batch.isFull || (capacity > 0 && enrolled >= capacity);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Title, Room, Status & Actions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              batch.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (batch.room != null && batch.room!.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: scheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                batch.room!,
                                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (batch.category != null && batch.category!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          batch.category!,
                          style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (batch.status == 'active' ? const Color(0xFF10B981) : Colors.grey)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    batch.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: batch.status == 'active' ? const Color(0xFF059669) : Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded, size: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  onSelected: (action) => _handleBatchAction(action, batch),
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Edit Batch'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'attendance',
                      child: Row(
                        children: [
                          Icon(Icons.checklist_rounded, size: 18),
                          SizedBox(width: 8),
                          Text('Mark Roster Attendance'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete Batch', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Timings & Fee Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule_rounded, size: 14, color: Color(0xFF0284C7)),
                      const SizedBox(width: 4),
                      Text(
                        batch.timingDisplay,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0369A1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.payments_outlined, size: 14, color: Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Text(
                        batch.feeDisplay,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (batch.recurringDaysFormatted != null) ...[
              const SizedBox(height: 6),
              Text(
                'Days: ${batch.recurringDaysFormatted}',
                style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant),
              ),
            ],

            const SizedBox(height: 12),

            // Capacity & Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Capacity: $enrolled / $capacity Enrolled',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  isFull ? 'FULL' : '${batch.availableSpots} spots left',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: isFull ? Colors.red.shade700 : primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: scheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isFull ? Colors.red : primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.people_outline_rounded, size: 16),
                    label: const Text('Members & Details', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      context.push(
                        '/client/manage/batches/${widget.kind.pathSegment}/${widget.facilityId}/${batch.id}',
                        extra: (widget.facility, batch),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.how_to_reg_rounded, size: 16),
                    label: const Text('Roster', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      context.push(
                        '/client/manage/batches/${widget.kind.pathSegment}/${widget.facilityId}/${batch.id}/attendance',
                        extra: (widget.facility, batch),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleBatchAction(String action, FacilityBatchModel batch) async {
    switch (action) {
      case 'edit':
        await context.push(
          '/client/manage/batches/${widget.kind.pathSegment}/${widget.facilityId}/${batch.id}/edit',
          extra: (widget.facility, batch),
        );
        ref.invalidate(facilityBatchesProvider((widget.kind, widget.facilityId)));
        break;
      case 'attendance':
        context.push(
          '/client/manage/batches/${widget.kind.pathSegment}/${widget.facilityId}/${batch.id}/attendance',
          extra: (widget.facility, batch),
        );
        break;
      case 'delete':
        _confirmDeleteBatch(batch);
        break;
    }
  }

  void _confirmDeleteBatch(FacilityBatchModel batch) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Batch'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${batch.name}"?\n\nExisting attendance records and members will be detached from this batch schedule.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref
                    .read(clientFacilityRepositoryProvider)
                    .deleteBatch(widget.kind, widget.facilityId, batch.id);
                ref.invalidate(facilityBatchesProvider((widget.kind, widget.facilityId)));
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Batch deleted successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete batch: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
