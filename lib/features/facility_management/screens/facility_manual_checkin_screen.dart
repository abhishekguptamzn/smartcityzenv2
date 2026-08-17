import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/show_confirm_dialog.dart';
import '../widgets/facility_qr_modal.dart';
import '../widgets/renew_member_modal.dart';
import 'facility_console_screen.dart';
import 'facility_member_detail_screen.dart';

final facilityCheckinMembersProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, (FacilityKind, String, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  final kind = args.$1;
  final id = args.$2;
  final search = args.$3;

  if (kind == FacilityKind.gym) {
    return repo.getGymMembers(id, search: search);
  } else {
    return repo.getLibraryMembers(id, search: search);
  }
});

enum CheckinFilter { allActive, expiringSoon, checkedInToday }

class FacilityManualCheckinScreen extends ConsumerStatefulWidget {
  const FacilityManualCheckinScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilityManualCheckinScreen> createState() => _FacilityManualCheckinScreenState();
}

class _FacilityManualCheckinScreenState extends ConsumerState<FacilityManualCheckinScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  CheckinFilter _activeFilter = CheckinFilter.allActive;
  final Set<String> _loadingMemberIds = {};
  final Set<String> _recentlyCheckedInIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleCheckin(Map<String, dynamic> member) async {
    final memberId = member['id']?.toString() ?? '';
    if (memberId.isEmpty) return;

    final endStr = member['end_date']?.toString();
    DateTime? endDate;
    if (endStr != null && endStr.isNotEmpty) {
      endDate = DateTime.tryParse(endStr);
    }
    final now = DateTime.now();
    final isExpired = endDate != null && endDate.isBefore(now);

    if (isExpired) {
      final userName = member['user']?['name'] ?? member['name'] ?? 'Member';
      final formattedEnd = DateFormat('d MMM yyyy').format(endDate);
      final proceed = await showAppConfirmDialog(
        context: context,
        title: 'Membership Expired',
        message: '$userName\'s membership pass expired on $formattedEnd. Log desk check-in anyway or renew pass?',
        confirmLabel: 'Allow Check-in',
        cancelLabel: 'Cancel',
        type: ConfirmDialogType.warning,
        details: [
          ConfirmDetailRow(label: 'Member', value: userName),
          ConfirmDetailRow(label: 'Expired On', value: formattedEnd, isHighlighted: true),
        ],
      );
      if (!proceed) return;
    }

    setState(() => _loadingMemberIds.add(memberId));

    try {
      final res = await ref.read(clientFacilityRepositoryProvider).checkIn(
        widget.kind,
        widget.facilityId,
        memberId: memberId,
      );

      final userName = res['user_name'] ?? member['user']?['name'] ?? member['name'] ?? 'Member';
      final already = res['already_checked_in'] == true;

      setState(() {
        _recentlyCheckedInIds.add(memberId);
      });

      ref.invalidate(facilityStatsProvider((widget.kind, widget.facilityId)));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                already ? Icons.info_outline_rounded : Icons.check_circle_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  already
                      ? '$userName is already checked in.'
                      : '✅ $userName checked in successfully!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: already ? const Color(0xFFD97706) : const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to check in: ${e.toString()}'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingMemberIds.remove(memberId));
      }
    }
  }

  void _openRenewModal(Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RenewMemberModal(
        kind: widget.kind,
        facilityId: widget.facilityId,
        facility: widget.facility,
        member: member,
        onSuccess: () {
          ref.invalidate(facilityCheckinMembersProvider((widget.kind, widget.facilityId, _searchQuery)));
          ref.invalidate(facilityStatsProvider((widget.kind, widget.facilityId)));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isGym = widget.kind == FacilityKind.gym;
    final primaryColor = isGym ? const Color(0xFF0D9488) : const Color(0xFF0284C7);

    final membersAsync = ref.watch(facilityCheckinMembersProvider((widget.kind, widget.facilityId, _searchQuery)));
    final statsAsync = ref.watch(facilityStatsProvider((widget.kind, widget.facilityId)));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manual Desk Check-in',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              widget.facility?.name ?? (isGym ? 'Gym Facility' : 'Library Hub'),
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Show QR Code',
            icon: const Icon(Icons.qr_code_2_rounded),
            onPressed: () {
              showFacilityQrModal(
                context: context,
                kind: widget.kind,
                facilityId: widget.facilityId,
                facilityName: widget.facility?.name ?? 'Facility',
              );
            },
          ),
          IconButton(
            tooltip: 'Refresh List',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.refresh(facilityCheckinMembersProvider((widget.kind, widget.facilityId, _searchQuery))),
          ),
        ],
      ),
      body: AmbientBackground(
        child: Column(
          children: [
            // Top Live Stats Mini Banner
            statsAsync.when(
              data: (stats) => Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MiniStatItem(
                      label: "Today's Visits",
                      value: '${stats.todayCheckins}',
                      color: primaryColor,
                    ),
                    Container(height: 24, width: 1, color: primaryColor.withValues(alpha: 0.2)),
                    _MiniStatItem(
                      label: 'Inside Now',
                      value: '${stats.currentlyInside}',
                      color: const Color(0xFF10B981),
                    ),
                    Container(height: 24, width: 1, color: primaryColor.withValues(alpha: 0.2)),
                    _MiniStatItem(
                      label: 'Active Members',
                      value: '${stats.activeMembers}',
                      color: const Color(0xFF6366F1),
                    ),
                  ],
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Search member by name, mobile, ID...',
                  prefixIcon: Icon(Icons.search_rounded, color: primaryColor),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: primaryColor, width: 1.5),
                  ),
                ),
                onChanged: (val) {
                  setState(() => _searchQuery = val.trim());
                },
              ),
            ),

            // Filter Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All Members',
                    icon: Icons.people_outline_rounded,
                    isSelected: _activeFilter == CheckinFilter.allActive,
                    onTap: () => setState(() => _activeFilter = CheckinFilter.allActive),
                    color: primaryColor,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Expiring Soon',
                    icon: Icons.hourglass_top_rounded,
                    isSelected: _activeFilter == CheckinFilter.expiringSoon,
                    onTap: () => setState(() => _activeFilter = CheckinFilter.expiringSoon),
                    color: const Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Recently Checked-in',
                    icon: Icons.check_circle_outline_rounded,
                    isSelected: _activeFilter == CheckinFilter.checkedInToday,
                    onTap: () => setState(() => _activeFilter = CheckinFilter.checkedInToday),
                    color: const Color(0xFF10B981),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Members List
            Expanded(
              child: membersAsync.when(
                data: (allMembers) {
                  // Apply Client Filter
                  final now = DateTime.now();
                  final filteredMembers = allMembers.where((m) {
                    if (_activeFilter == CheckinFilter.checkedInToday) {
                      final mId = m['id']?.toString() ?? '';
                      return _recentlyCheckedInIds.contains(mId);
                    }
                    if (_activeFilter == CheckinFilter.expiringSoon) {
                      final endStr = m['end_date']?.toString();
                      if (endStr == null || endStr.isEmpty) return false;
                      try {
                        final end = DateTime.parse(endStr);
                        final diff = end.difference(now).inDays;
                        return diff >= 0 && diff <= 7;
                      } catch (_) {
                        return false;
                      }
                    }
                    return true;
                  }).toList();

                  if (filteredMembers.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: scheme.primary.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.person_search_rounded, size: 48, color: scheme.primary),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? (_activeFilter == CheckinFilter.checkedInToday
                                      ? 'No desk check-ins recorded in this session yet.'
                                      : 'No members found.')
                                  : 'No members matching "$_searchQuery"',
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Search by name, registered mobile, or member ID to log attendance.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: filteredMembers.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final member = filteredMembers[index];
                      final user = (member['user'] as Map<String, dynamic>?) ?? {};
                      final memberId = member['id']?.toString() ?? 'ID';
                      final userName = user['name']?.toString() ?? member['name']?.toString() ?? 'Citizen Member';
                      final userPhone = user['phone']?.toString() ?? member['phone']?.toString() ?? '';
                      final planName = member['membership_type']?.toString() ?? member['plan_name']?.toString() ?? 'Standard';
                      final rawEndDate = member['end_date']?.toString();
                      final status = (member['status']?.toString() ?? 'active').toLowerCase();

                      final isCheckedInRecently = _recentlyCheckedInIds.contains(memberId);
                      final isLoading = _loadingMemberIds.contains(memberId);

                      // Calculate validity
                      bool isExpired = false;
                      bool isExpiringSoon = false;
                      String validityLabel = 'Valid';
                      if (rawEndDate != null && rawEndDate.isNotEmpty) {
                        try {
                          final endDate = DateTime.parse(rawEndDate);
                          final diff = endDate.difference(now).inDays;
                          final formatted = DateFormat('dd MMM yyyy').format(endDate);
                          if (diff < 0) {
                            isExpired = true;
                            validityLabel = 'Expired on $formatted';
                          } else if (diff <= 7) {
                            isExpiringSoon = true;
                            validityLabel = 'Expiring in $diff day(s) ($formatted)';
                          } else {
                            validityLabel = 'Valid till $formatted';
                          }
                        } catch (_) {
                          validityLabel = 'Valid till $rawEndDate';
                        }
                      }

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isCheckedInRecently
                                ? const Color(0xFF10B981).withValues(alpha: 0.5)
                                : isExpired
                                    ? const Color(0xFFEF4444).withValues(alpha: 0.3)
                                    : scheme.outlineVariant.withValues(alpha: 0.3),
                            width: isCheckedInRecently ? 1.5 : 1.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x08000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Member Avatar with initials
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: primaryColor.withValues(alpha: 0.12),
                                  child: Text(
                                    userName.isNotEmpty ? userName[0].toUpperCase() : 'M',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Member Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              userName,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isCheckedInRecently)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF059669)),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    'CHECKED IN',
                                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: scheme.surfaceContainerHighest,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              '#$memberId',
                                              style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: scheme.onSurfaceVariant),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            planName.toUpperCase(),
                                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: scheme.onSurfaceVariant),
                                          ),
                                          if (userPhone.isNotEmpty) ...[
                                            Text(' • ', style: TextStyle(color: scheme.onSurfaceVariant)),
                                            Text(userPhone, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            isExpired
                                                ? Icons.error_outline_rounded
                                                : isExpiringSoon
                                                    ? Icons.warning_amber_rounded
                                                    : Icons.verified_rounded,
                                            size: 13,
                                            color: isExpired
                                                ? const Color(0xFFEF4444)
                                                : isExpiringSoon
                                                    ? const Color(0xFFF59E0B)
                                                    : const Color(0xFF10B981),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            validityLabel,
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: isExpired || isExpiringSoon ? FontWeight.bold : FontWeight.normal,
                                              color: isExpired
                                                  ? const Color(0xFFEF4444)
                                                  : isExpiringSoon
                                                      ? const Color(0xFFD97706)
                                                      : scheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1),
                            const SizedBox(height: 10),

                            // Actions Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => FacilityMemberDetailScreen(
                                          kind: widget.kind,
                                          facilityId: widget.facilityId,
                                          memberId: memberId,
                                          facility: widget.facility,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.person_outline_rounded, size: 16),
                                  label: const Text('View Profile', style: TextStyle(fontSize: 12)),
                                  style: TextButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (isExpired || isExpiringSoon || status != 'active')
                                      OutlinedButton.icon(
                                        onPressed: () => _openRenewModal(member),
                                        icon: const Icon(Icons.autorenew_rounded, size: 16, color: Color(0xFF0D9488)),
                                        label: const Text(
                                          'Renew Pass',
                                          style: TextStyle(color: Color(0xFF0D9488), fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Color(0xFF0D9488)),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      ),
                                    if (isExpired || isExpiringSoon || status != 'active') const SizedBox(width: 8),
                                    FilledButton.icon(
                                      onPressed: isLoading || isExpired ? null : () => _handleCheckin(member),
                                      icon: isLoading
                                          ? const SizedBox(
                                              width: 14,
                                              height: 14,
                                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                            )
                                          : Icon(
                                              isCheckedInRecently ? Icons.check_rounded : Icons.login_rounded,
                                              size: 16,
                                            ),
                                      label: Text(
                                        isCheckedInRecently ? 'CHECK IN AGAIN' : 'LOG CHECK-IN',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: isCheckedInRecently ? const Color(0xFF059669) : primaryColor,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        visualDensity: VisualDensity.compact,
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
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Failed to load members: $err',
                      style: TextStyle(color: scheme.error, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatItem extends StatelessWidget {
  const _MiniStatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: color),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? color : Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? color : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
