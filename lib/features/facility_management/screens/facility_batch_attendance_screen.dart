import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/api/app_exception.dart';
import '../../../data/models/facility_batch_model.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import 'facility_batch_detail_screen.dart';
import 'facility_batches_screen.dart';

class FacilityBatchAttendanceScreen extends ConsumerStatefulWidget {
  const FacilityBatchAttendanceScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
    this.initialBatchId,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;
  final String? initialBatchId;

  @override
  ConsumerState<FacilityBatchAttendanceScreen> createState() => _FacilityBatchAttendanceScreenState();
}

class _FacilityBatchAttendanceScreenState extends ConsumerState<FacilityBatchAttendanceScreen> {
  String? _selectedBatchId;
  DateTime _attendanceDate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // memberId -> 'present' | 'absent'
  final Map<String, String> _rosterStatus = {};
  bool _loadingAttendance = false;
  bool _savingRoster = false;

  @override
  void initState() {
    super.initState();
    _selectedBatchId = widget.initialBatchId;
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBatchAttendance(String batchId) async {
    if (!mounted) return;
    setState(() => _loadingAttendance = true);
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(_attendanceDate);
      final data = await ref.read(clientFacilityRepositoryProvider).getBatchAttendance(
            widget.kind,
            widget.facilityId,
            batchId,
            date: dateStr,
          );
      final attendances = data['attendances'] as List? ?? [];
      final Map<String, String> statuses = {};
      for (final att in attendances) {
        if (att is Map) {
          final memId = att['facility_member_id']?.toString() ?? att['member_id']?.toString() ?? '';
          final status = att['status']?.toString().toLowerCase() ?? 'present';
          if (memId.isNotEmpty) {
            statuses[memId] = status == 'absent' ? 'absent' : 'present';
          }
        }
      }
      if (mounted) {
        setState(() {
          _rosterStatus.clear();
          _rosterStatus.addAll(statuses);
          _loadingAttendance = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loadingAttendance = false);
      }
    }
  }

  Future<void> _saveRoster(List<FacilityBatchMemberItem> members, FacilityBatchModel? batch) async {
    if (_selectedBatchId == null) return;
    setState(() => _savingRoster = true);
    final dateStr = DateFormat('yyyy-MM-dd').format(_attendanceDate);

    final List<Map<String, dynamic>> records = members.map<Map<String, dynamic>>((m) {
      final status = _rosterStatus[m.memberId] ?? _rosterStatus[m.id] ?? 'present';
      return {
        'member_id': m.id,
        'status': status,
      };
    }).toList();

    try {
      final res = await ref.read(clientFacilityRepositoryProvider).markBatchAttendance(
            widget.kind,
            widget.facilityId,
            _selectedBatchId!,
            date: dateStr,
            records: records,
          );
      final presentCount = records.where((r) => r['status'] == 'present').length;
      final absentCount = records.where((r) => r['status'] == 'absent').length;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Attendance saved: $presentCount Present, $absentCount Absent on ${DateFormat("dd MMM yyyy").format(_attendanceDate)}. Notifications dispatched.',
            ),
            backgroundColor: const Color(0xFF059669),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppException.extractMessage(e, fallback: 'Failed to save batch attendance');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: const Color(0xFFDC2626)),
        );
      }
    } finally {
      if (mounted) setState(() => _savingRoster = false);
    }
  }

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
        title: const Text('Batch Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () {
              if (_selectedBatchId != null) {
                ref.invalidate(batchMembersProvider((widget.kind, widget.facilityId, _selectedBatchId!)));
                _loadBatchAttendance(_selectedBatchId!);
              }
            },
          ),
        ],
      ),
      body: AmbientBackground(
        child: batchesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Failed to load batches: $err')),
          data: (batches) {
            if (batches.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.groups_outlined, size: 64, color: scheme.onSurfaceVariant.withValues(alpha: 0.5)),
                      const SizedBox(height: 16),
                      Text('No Batches Configured', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'Create batches first in Manage Batches to start recording attendance.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: primaryColor),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Create Batch'),
                        onPressed: () => context.push(
                          '/client/manage/batches/${widget.kind.pathSegment}/${widget.facilityId}',
                          extra: widget.facility,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Set initial batch if unset
            if (_selectedBatchId == null || !batches.any((b) => b.id == _selectedBatchId)) {
              _selectedBatchId = batches.first.id;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadBatchAttendance(_selectedBatchId!);
              });
            }

            final currentBatch = batches.firstWhere(
              (b) => b.id == _selectedBatchId,
              orElse: () => batches.first,
            );

            final membersAsync = ref.watch(batchMembersProvider((widget.kind, widget.facilityId, currentBatch.id)));

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                // 1. Batch Selector Dropdown Card
                GlassContainer(
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.groups_rounded, size: 18, color: primaryColor),
                          const SizedBox(width: 8),
                          const Text('Select Batch / Group', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedBatchId,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            items: batches.map((b) {
                              return DropdownMenuItem<String>(
                                value: b.id,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            b.name,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${b.timingDisplay} • ${b.category ?? "General"}',
                                            style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${b.enrolledCount}/${b.capacity}',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (newBatchId) {
                              if (newBatchId != null && newBatchId != _selectedBatchId) {
                                setState(() {
                                  _selectedBatchId = newBatchId;
                                  _rosterStatus.clear();
                                });
                                _loadBatchAttendance(newBatchId);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 2. Date Navigation Card
                GlassContainer(
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left_rounded),
                        tooltip: 'Previous Day',
                        onPressed: () {
                          setState(() {
                            _attendanceDate = _attendanceDate.subtract(const Duration(days: 1));
                          });
                          if (_selectedBatchId != null) _loadBatchAttendance(_selectedBatchId!);
                        },
                      ),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _attendanceDate,
                            firstDate: DateTime(2023),
                            lastDate: DateTime.now().add(const Duration(days: 7)),
                          );
                          if (picked != null) {
                            setState(() => _attendanceDate = picked);
                            if (_selectedBatchId != null) _loadBatchAttendance(_selectedBatchId!);
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_today_rounded, size: 16, color: primaryColor),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('EEEE, dd MMM yyyy').format(_attendanceDate),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right_rounded),
                        tooltip: 'Next Day',
                        onPressed: () {
                          setState(() {
                            _attendanceDate = _attendanceDate.add(const Duration(days: 1));
                          });
                          if (_selectedBatchId != null) _loadBatchAttendance(_selectedBatchId!);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 3. Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search members by name or phone...',
                    hintStyle: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    filled: true,
                    fillColor: theme.cardColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 4. Members List & Live Stats
                membersAsync.when(
                  loading: () => const Center(
                    child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
                  ),
                  error: (err, _) => Center(child: Text('Failed to load batch members: $err')),
                  data: (members) {
                    if (members.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(Icons.person_off_rounded, size: 48, color: scheme.onSurfaceVariant.withValues(alpha: 0.5)),
                              const SizedBox(height: 12),
                              const Text('No members enrolled in this batch.', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      );
                    }

                    // Filter members by search query
                    final filtered = members.where((m) {
                      if (_searchQuery.isEmpty) return true;
                      final name = m.displayName.toLowerCase();
                      final phone = (m.userPhone ?? '').toLowerCase();
                      final memNum = (m.membershipNumber ?? '').toLowerCase();
                      return name.contains(_searchQuery) || phone.contains(_searchQuery) || memNum.contains(_searchQuery);
                    }).toList();

                    final presentCount = members.where((m) {
                      final status = _rosterStatus[m.memberId] ?? _rosterStatus[m.id];
                      return status == 'present';
                    }).length;

                    final absentCount = members.where((m) {
                      final status = _rosterStatus[m.memberId] ?? _rosterStatus[m.id];
                      return status == 'absent';
                    }).length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Live Summary Counters & Bulk Actions
                        GlassContainer(
                          borderRadius: BorderRadius.circular(14),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  _buildStatBadge('$presentCount Present', const Color(0xFF059669), const Color(0xFFECFDF5)),
                                  const SizedBox(width: 8),
                                  _buildStatBadge('$absentCount Absent', const Color(0xFFDC2626), const Color(0xFFFEF2F2)),
                                ],
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                                    onPressed: () {
                                      setState(() {
                                        for (final m in members) {
                                          _rosterStatus[m.memberId] = 'present';
                                          _rosterStatus[m.id] = 'present';
                                        }
                                      });
                                    },
                                    child: const Text('All Present', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                                    onPressed: () {
                                      setState(() {
                                        for (final m in members) {
                                          _rosterStatus[m.memberId] = 'absent';
                                          _rosterStatus[m.id] = 'absent';
                                        }
                                      });
                                    },
                                    child: const Text('All Absent', style: TextStyle(fontSize: 12, color: Color(0xFFDC2626))),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (_loadingAttendance)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: LinearProgressIndicator(minHeight: 2),
                          ),

                        if (filtered.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: Text('No matching members found.')),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 8),
                            itemBuilder: (ctx, i) {
                              final m = filtered[i];
                              final status = _rosterStatus[m.memberId] ?? _rosterStatus[m.id] ?? 'present';
                              final isPresent = status == 'present';

                              return GlassContainer(
                                borderRadius: BorderRadius.circular(14),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: isPresent
                                          ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                          : const Color(0xFFEF4444).withValues(alpha: 0.15),
                                      child: Icon(
                                        isPresent ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                        color: isPresent ? const Color(0xFF059669) : const Color(0xFFDC2626),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            m.displayName,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          if (m.userPhone != null && m.userPhone!.isNotEmpty)
                                            Text(
                                              m.userPhone!,
                                              style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant),
                                            ),
                                        ],
                                      ),
                                    ),
                                    SegmentedButton<String>(
                                      style: SegmentedButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                        selectedBackgroundColor: isPresent
                                            ? const Color(0xFF10B981).withValues(alpha: 0.2)
                                            : const Color(0xFFEF4444).withValues(alpha: 0.2),
                                        selectedForegroundColor: isPresent ? const Color(0xFF059669) : const Color(0xFFDC2626),
                                      ),
                                      segments: const [
                                        ButtonSegment(
                                          value: 'present',
                                          label: Text('P', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                        ),
                                        ButtonSegment(
                                          value: 'absent',
                                          label: Text('A', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                        ),
                                      ],
                                      selected: {status},
                                      onSelectionChanged: (val) {
                                        setState(() {
                                          _rosterStatus[m.memberId] = val.first;
                                          _rosterStatus[m.id] = val.first;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: _savingRoster
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.save_rounded),
                            label: Text(
                              _savingRoster ? 'Saving & Notifying...' : 'Save Batch Attendance',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            onPressed: _savingRoster ? null : () => _saveRoster(members, currentBatch),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatBadge(String label, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
