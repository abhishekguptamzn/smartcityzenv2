import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/api/app_exception.dart';
import '../../../data/models/facility_batch_model.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/add_member_modal.dart';

final batchDetailsProvider = FutureProvider.autoDispose
    .family<FacilityBatchModel, (FacilityKind, String, String)>((ref, tuple) async {
  final (kind, facilityId, batchId) = tuple;
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getBatchDetails(kind, facilityId, batchId);
});

final batchMembersProvider = FutureProvider.autoDispose
    .family<List<FacilityBatchMemberItem>, (FacilityKind, String, String)>((ref, tuple) async {
  final (kind, facilityId, batchId) = tuple;
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getBatchMembers(kind, facilityId, batchId);
});

class FacilityBatchDetailScreen extends ConsumerStatefulWidget {
  const FacilityBatchDetailScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    required this.batchId,
    this.facility,
    this.initialBatch,
    this.initialTab = 0,
  });

  final FacilityKind kind;
  final String facilityId;
  final String batchId;
  final FacilityModel? facility;
  final FacilityBatchModel? initialBatch;
  final int initialTab;

  @override
  ConsumerState<FacilityBatchDetailScreen> createState() => _FacilityBatchDetailScreenState();
}

class _FacilityBatchDetailScreenState extends ConsumerState<FacilityBatchDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Attendance Tab State
  DateTime _attendanceDate = DateTime.now();
  final Set<String> _presentMemberIds = {};
  bool _loadingAttendance = false;
  bool _savingRoster = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
    _loadDateAttendance();
  }

  Future<void> _loadDateAttendance() async {
    if (!mounted) return;
    setState(() => _loadingAttendance = true);
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(_attendanceDate);
      final data = await ref.read(clientFacilityRepositoryProvider).getBatchAttendance(
            widget.kind,
            widget.facilityId,
            widget.batchId,
            date: dateStr,
          );
      final attendances = data['attendances'] as List? ?? [];
      final Set<String> present = {};
      for (final att in attendances) {
        if (att is Map) {
          final memId = att['facility_member_id']?.toString() ?? att['member_id']?.toString() ?? '';
          final userId = att['user_id']?.toString() ?? '';
          if (memId.isNotEmpty) present.add(memId);
          if (userId.isNotEmpty) present.add(userId);
        }
      }
      if (mounted) {
        setState(() {
          _presentMemberIds.clear();
          _presentMemberIds.addAll(present);
          _loadingAttendance = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loadingAttendance = false);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

    final batchAsync = ref.watch(batchDetailsProvider((widget.kind, widget.facilityId, widget.batchId)));
    final batch = batchAsync.value ?? widget.initialBatch;

    return Scaffold(
      appBar: AppBar(
        title: Text(batch?.name ?? 'Batch Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Batch',
            onPressed: () async {
              if (batch != null) {
                await context.push(
                  '/client/manage/batches/${widget.kind.pathSegment}/${widget.facilityId}/${batch.id}/edit',
                  extra: (widget.facility, batch),
                );
                ref.invalidate(batchDetailsProvider((widget.kind, widget.facilityId, widget.batchId)));
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.campaign_outlined),
            tooltip: 'Broadcast Announcement',
            onPressed: () {
              if (batch != null) _showAnnouncementModal(context, batch);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          tabs: const [
            Tab(icon: Icon(Icons.people_outline_rounded), text: 'Members'),
            Tab(icon: Icon(Icons.checklist_rounded), text: 'Roster Attendance'),
            Tab(icon: Icon(Icons.campaign_rounded), text: 'Announcements'),
          ],
        ),
      ),
      body: AmbientBackground(
        child: batch == null && batchAsync.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  // TAB 1: MEMBERS
                  _buildMembersTab(batch, primaryColor, scheme, isDark),

                  // TAB 2: ROSTER ATTENDANCE
                  _buildRosterTab(batch, primaryColor, scheme, isDark),

                  // TAB 3: ANNOUNCEMENTS
                  _buildAnnouncementsTab(batch, primaryColor, scheme, isDark),
                ],
              ),
      ),
    );
  }

  Widget _buildMembersTab(
    FacilityBatchModel? batch,
    Color primaryColor,
    ColorScheme scheme,
    bool isDark,
  ) {
    final membersAsync = ref.watch(batchMembersProvider((widget.kind, widget.facilityId, widget.batchId)));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(batchMembersProvider((widget.kind, widget.facilityId, widget.batchId)));
        ref.invalidate(batchDetailsProvider((widget.kind, widget.facilityId, widget.batchId)));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          if (batch != null) _buildBatchHeaderCard(batch, primaryColor, scheme, isDark),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enrolled Members (${batch?.enrolledCount ?? 0})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                icon: const Icon(Icons.person_add_rounded, size: 16),
                label: const Text('Add Member', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  showAddMemberModal(
                    context: context,
                    kind: widget.kind,
                    facilityId: widget.facilityId,
                    facility: widget.facility,
                    onSuccess: () {
                      ref.invalidate(batchMembersProvider((widget.kind, widget.facilityId, widget.batchId)));
                      ref.invalidate(batchDetailsProvider((widget.kind, widget.facilityId, widget.batchId)));
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          membersAsync.when(
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            error: (err, _) => Center(child: Text('Failed to load members: $err')),
            data: (members) {
              if (members.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.people_outline_rounded, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        const Text('No members enrolled in this batch yet', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Tap "Add Member" to assign citizens to this time slot.', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: members.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) {
                  final m = members[i];
                  final joinedDate = (m.startDate != null ? DateTime.tryParse(m.startDate!) : null) ?? DateTime.now();
                  return GlassContainer(
                    borderRadius: BorderRadius.circular(14),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryColor.withValues(alpha: 0.15),
                          child: Text(
                            m.displayName.isNotEmpty ? m.displayName[0].toUpperCase() : '?',
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                              if (m.userPhone != null && m.userPhone!.isNotEmpty)
                                Text(m.userPhone!, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                              Text(
                                'Joined: ${DateFormat("dd MMM yyyy").format(joinedDate)}',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, size: 18),
                          onSelected: (act) => _handleMemberAction(act, m, batch),
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(
                              value: 'switch',
                              child: Row(
                                children: [
                                  Icon(Icons.swap_horiz_rounded, size: 18),
                                  SizedBox(width: 8),
                                  Text('Switch Batch'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'unenroll',
                              child: Row(
                                children: [
                                  Icon(Icons.person_remove_rounded, size: 18, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Unenroll', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRosterTab(
    FacilityBatchModel? batch,
    Color primaryColor,
    ColorScheme scheme,
    bool isDark,
  ) {
    final membersAsync = ref.watch(batchMembersProvider((widget.kind, widget.facilityId, widget.batchId)));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Date Selector Card
        GlassContainer(
          borderRadius: BorderRadius.circular(14),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Roster Date', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('EEEE, dd MMM yyyy').format(_attendanceDate),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today_rounded, size: 16),
                label: const Text('Change'),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _attendanceDate,
                    firstDate: DateTime(2023),
                    lastDate: DateTime.now().add(const Duration(days: 7)),
                  );
                  if (picked != null) {
                    setState(() => _attendanceDate = picked);
                    _loadDateAttendance();
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        membersAsync.when(
          loading: () => const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
          error: (err, _) => Center(child: Text('Failed to load roster: $err')),
          data: (members) {
            if (members.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No members enrolled to take attendance.'),
                ),
              );
            }

            final isAttMgmt = widget.facility?.attendanceManagementEnabled ?? false;
            final allMarked = members.isNotEmpty && members.every((m) => _presentMemberIds.contains(m.memberId) || _presentMemberIds.contains(m.id));
            final presentCount = members.where((m) => _presentMemberIds.contains(m.memberId) || _presentMemberIds.contains(m.id)).length;
            final absentCount = members.length - presentCount;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('Student / Member List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isAttMgmt
                                ? '$presentCount P • $absentCount A'
                                : '$presentCount / ${members.length} Present',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                          ),
                        ),
                      ],
                    ),
                    if (isAttMgmt)
                      Row(
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                            onPressed: () {
                              setState(() {
                                for (final m in members) {
                                  _presentMemberIds.add(m.memberId);
                                  _presentMemberIds.add(m.id);
                                }
                              });
                            },
                            child: const Text('All Present', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                            onPressed: () {
                              setState(() {
                                _presentMemberIds.clear();
                              });
                            },
                            child: const Text('All Absent', style: TextStyle(fontSize: 12, color: Color(0xFFDC2626))),
                          ),
                        ],
                      )
                    else
                      TextButton.icon(
                        style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                        icon: Icon(allMarked ? Icons.clear_all_rounded : Icons.done_all_rounded, size: 16),
                        label: Text(allMarked ? 'Clear All' : 'Mark All Present'),
                        onPressed: () {
                          setState(() {
                            if (allMarked) {
                              _presentMemberIds.clear();
                            } else {
                              for (final m in members) {
                                _presentMemberIds.add(m.memberId);
                                _presentMemberIds.add(m.id);
                              }
                            }
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_loadingAttendance)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: LinearProgressIndicator(minHeight: 2),
                  ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: members.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final m = members[i];
                    final isPresent = _presentMemberIds.contains(m.memberId) || _presentMemberIds.contains(m.id);

                    if (isAttMgmt) {
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
                              selected: {isPresent ? 'present' : 'absent'},
                              onSelectionChanged: (val) {
                                setState(() {
                                  if (val.first == 'present') {
                                    _presentMemberIds.add(m.memberId);
                                    _presentMemberIds.add(m.id);
                                  } else {
                                    _presentMemberIds.remove(m.memberId);
                                    _presentMemberIds.remove(m.id);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (isPresent) {
                              _presentMemberIds.remove(m.memberId);
                              _presentMemberIds.remove(m.id);
                            } else {
                              _presentMemberIds.add(m.memberId);
                              _presentMemberIds.add(m.id);
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: GlassContainer(
                          borderRadius: BorderRadius.circular(14),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: isPresent
                                    ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                    : scheme.surfaceContainerHighest,
                                child: Icon(
                                  isPresent ? Icons.check_circle_rounded : Icons.person_outline_rounded,
                                  color: isPresent ? const Color(0xFF059669) : scheme.onSurfaceVariant,
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
                                      style: TextStyle(
                                        fontWeight: isPresent ? FontWeight.bold : FontWeight.w600,
                                        fontSize: 14,
                                        color: scheme.onSurface,
                                      ),
                                    ),
                                    if (m.userPhone != null && m.userPhone!.isNotEmpty)
                                      Text(
                                        m.userPhone!,
                                        style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant),
                                      ),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isPresent
                                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                      : scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isPresent
                                        ? const Color(0xFF10B981)
                                        : scheme.outlineVariant.withValues(alpha: 0.6),
                                    width: isPresent ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isPresent ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                      size: 15,
                                      color: isPresent ? const Color(0xFF059669) : scheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      isPresent ? 'Present' : 'Check In',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isPresent ? FontWeight.bold : FontWeight.w500,
                                        color: isPresent ? const Color(0xFF059669) : scheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: primaryColor),
                    icon: _savingRoster
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.save_rounded),
                    label: const Text('Save Daily Roster Attendance', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    onPressed: _savingRoster ? null : () => _saveRoster(members, batch),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnnouncementsTab(
    FacilityBatchModel? batch,
    Color primaryColor,
    ColorScheme scheme,
    bool isDark,
  ) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ref.read(clientFacilityRepositoryProvider).getBatchAnnouncements(widget.kind, widget.facilityId, widget.batchId),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = snap.data ?? [];

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Batch Broadcasts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: primaryColor),
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text('New Broadcast'),
                  onPressed: () {
                    if (batch != null) _showAnnouncementModal(context, batch);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (list.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.campaign_outlined, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Text('No Announcements Sent Yet', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Broadcast important updates directly to batch members.', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) {
                  final item = list[i];
                  return GlassContainer(
                    borderRadius: BorderRadius.circular(14),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item['title'] ?? 'Announcement', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(
                              item['created_at'] != null
                                  ? DateFormat('dd MMM, hh:mm a').format(DateTime.parse(item['created_at']))
                                  : '',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(item['message'] ?? '', style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.people_outline_rounded, size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text('${item['recipients_count'] ?? 0} Recipients', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildBatchHeaderCard(
    FacilityBatchModel batch,
    Color primaryColor,
    ColorScheme scheme,
    bool isDark,
  ) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                batch.timingDisplay,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: primaryColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  batch.feeDisplay,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF059669)),
                ),
              ),
            ],
          ),
          if (batch.recurringDaysFormatted != null) ...[
            const SizedBox(height: 4),
            Text('Schedule: ${batch.recurringDaysFormatted}', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
          ],
          if (batch.room != null && batch.room!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text('Room / Studio: ${batch.room}', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enrollment: ${batch.enrolledCount} / ${batch.capacity}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                '${batch.availableSpots} spots left',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: batch.capacity > 0 ? (batch.enrolledCount / batch.capacity).clamp(0.0, 1.0) : 0.0,
              minHeight: 6,
              backgroundColor: scheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMemberAction(String action, FacilityBatchMemberItem member, FacilityBatchModel? batch) async {
    if (action == 'unenroll') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Unenroll Member'),
          content: Text('Remove ${member.displayName} from ${batch?.name ?? "this batch"}?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Unenroll'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        try {
          await ref.read(clientFacilityRepositoryProvider).unenrollBatchMember(
                widget.kind,
                widget.facilityId,
                widget.batchId,
                member.id,
              );
          ref.invalidate(batchMembersProvider((widget.kind, widget.facilityId, widget.batchId)));
          ref.invalidate(batchDetailsProvider((widget.kind, widget.facilityId, widget.batchId)));
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Member unenrolled')));
          }
        } catch (e) {
          if (mounted) {
            final errorMsg = AppException.extractMessage(e, fallback: 'Failed to unenroll member');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg), backgroundColor: const Color(0xFFDC2626)));
          }
        }
      }
    } else if (action == 'switch') {
      _showSwitchBatchDialog(member, batch);
    }
  }

  void _showSwitchBatchDialog(FacilityBatchMemberItem member, FacilityBatchModel? currentBatch) async {
    final batches = await ref.read(clientFacilityRepositoryProvider).getBatches(widget.kind, widget.facilityId, status: 'active');
    final eligible = batches.where((b) => b.id != widget.batchId).toList();

    if (!mounted) return;
    if (eligible.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No other active batches available to switch into')),
      );
      return;
    }

    FacilityBatchModel? targetBatch = eligible.first;

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('Switch Batch'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Move ${member.displayName} to another batch timetable:'),
              const SizedBox(height: 12),
              DropdownButtonFormField<FacilityBatchModel>(
                initialValue: targetBatch,
                decoration: InputDecoration(
                  labelText: 'Target Batch',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: eligible.map((b) {
                  return DropdownMenuItem(
                    value: b,
                    child: Text('${b.name} (${b.timingDisplay})'),
                  );
                }).toList(),
                onChanged: (b) => setDialogState(() => targetBatch = b),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                if (targetBatch == null) return;
                Navigator.pop(ctx);
                try {
                  await ref.read(clientFacilityRepositoryProvider).switchBatch(
                        widget.kind,
                        widget.facilityId,
                        widget.batchId,
                        member.id,
                        targetBatch!.id,
                      );
                  ref.invalidate(batchMembersProvider((widget.kind, widget.facilityId, widget.batchId)));
                  ref.invalidate(batchDetailsProvider((widget.kind, widget.facilityId, widget.batchId)));
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Switched ${member.displayName} to ${targetBatch!.name}')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    final errorMsg = AppException.extractMessage(e, fallback: 'Batch switch failed');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMsg), backgroundColor: const Color(0xFFDC2626)),
                    );
                  }
                }
              },
              child: const Text('Confirm Switch'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveRoster(List<FacilityBatchMemberItem> members, FacilityBatchModel? batch) async {
    setState(() => _savingRoster = true);
    final dateStr = DateFormat('yyyy-MM-dd').format(_attendanceDate);

    final records = members.map((m) {
      final isPresent = _presentMemberIds.contains(m.memberId) || _presentMemberIds.contains(m.id);
      return {
        'member_id': m.id,
        'status': isPresent ? 'present' : 'absent',
      };
    }).toList();

    try {
      final res = await ref.read(clientFacilityRepositoryProvider).markBatchAttendance(
            widget.kind,
            widget.facilityId,
            widget.batchId,
            date: dateStr,
            records: records,
          );
      final count = res['saved'] ?? records.where((r) => r['status'] == 'present').length;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Attendance saved: $count present on ${DateFormat("dd MMM yyyy").format(_attendanceDate)}'),
            backgroundColor: const Color(0xFF059669),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppException.extractMessage(e, fallback: 'Failed to save attendance');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: const Color(0xFFDC2626)),
        );
      }
    } finally {
      if (mounted) setState(() => _savingRoster = false);
    }
  }

  void _showAnnouncementModal(BuildContext context, FacilityBatchModel batch) {
    final titleCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    bool sending = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Broadcast to ${batch.name}',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Send notification to all ${batch.enrolledCount} enrolled members.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Title *', hintText: 'e.g. Schedule Update / Class Cancelled'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: msgCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Message *', hintText: 'Enter your message...'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  icon: sending
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send_rounded),
                  label: const Text('Send Announcement'),
                  onPressed: sending
                      ? null
                      : () async {
                          if (titleCtrl.text.trim().isEmpty || msgCtrl.text.trim().isEmpty) return;
                          final messenger = ScaffoldMessenger.of(context);
                          final nav = Navigator.of(ctx);
                          setSheetState(() => sending = true);
                          try {
                            await ref.read(clientFacilityRepositoryProvider).sendBatchAnnouncement(
                                  widget.kind,
                                  widget.facilityId,
                                  widget.batchId,
                                  {
                                    'title': titleCtrl.text.trim(),
                                    'message': msgCtrl.text.trim(),
                                  },
                                );
                            nav.pop();
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Announcement broadcasted successfully!'), backgroundColor: Color(0xFF0D9488)),
                            );
                            if (mounted) {
                              setState(() {}); // refresh announcements
                            }
                          } catch (e) {
                            messenger.showSnackBar(
                              SnackBar(content: Text('Failed to send: $e'), backgroundColor: Colors.red),
                            );
                          } finally {
                            if (ctx.mounted) setSheetState(() => sending = false);
                          }
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
