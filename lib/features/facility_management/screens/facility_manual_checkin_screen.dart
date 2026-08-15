import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';

final facilityCheckinMembersProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, (FacilityKind, String, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  final kind = args.$1;
  final id = args.$2;
  final search = args.$3;

  if (kind == FacilityKind.gym) {
    return repo.getGymMembers(id, search: search, status: 'active');
  } else {
    return repo.getLibraryMembers(id, search: search, status: 'active');
  }
});

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
  final Set<String> _loadingMemberIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleCheckin(Map<String, dynamic> member) async {
    final memberId = member['id']?.toString() ?? '';
    if (memberId.isEmpty) return;

    setState(() => _loadingMemberIds.add(memberId));

    try {
      final res = await ref.read(clientFacilityRepositoryProvider).checkIn(
        widget.kind,
        widget.facilityId,
        memberId: memberId,
      );

      final userName = res['user_name'] ?? member['user']?['name'] ?? 'Member';
      final already = res['already_checked_in'] == true;

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(already
              ? '$userName is already checked in.'
              : '✅ $userName checked in successfully!'),
          backgroundColor: already ? Colors.orange.shade800 : const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to check in: ${e.toString()}'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingMemberIds.remove(memberId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final membersAsync = ref.watch(facilityCheckinMembersProvider((widget.kind, widget.facilityId, _searchQuery)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Check-in'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.refresh(facilityCheckinMembersProvider((widget.kind, widget.facilityId, _searchQuery))),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: AmbientBackground(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by name, mobile or member ID',
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() => _searchQuery = val.trim());
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list_rounded),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            // Members Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Text(
                    'All Members',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Members List
            Expanded(
              child: membersAsync.when(
                data: (members) {
                  if (members.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_search_rounded, size: 48, color: scheme.onSurfaceVariant),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isEmpty ? 'No members registered yet' : 'No members found matching "$_searchQuery"',
                            style: TextStyle(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: members.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final member = members[index];
                      final user = member['user'] as Map<String, dynamic>? ?? {};
                      final memberId = member['id']?.toString() ?? 'MG1000';
                      final userName = user['name']?.toString() ?? 'Citizen Member';
                      final planName = member['membership_type']?.toString() ?? 'Standard';
                      final endDate = member['end_date']?.toString() ?? 'Valid';
                      final isLoading = _loadingMemberIds.contains(memberId);

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: const Color(0xFF0D9488).withValues(alpha: 0.12),
                              child: Text(
                                userName.isNotEmpty ? userName[0].toUpperCase() : 'M',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'ID: $memberId • $planName',
                                    style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                                  ),
                                  Text(
                                    'Valid till: $endDate',
                                    style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant.withValues(alpha: 0.8)),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: isLoading ? null : () => _handleCheckin(member),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF059669)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text(
                                      'CHECK IN',
                                      style: TextStyle(
                                        color: Color(0xFF059669),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),

            // Bottom Tip Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF0284C7), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tip: You can check-in only active members whose membership is valid.',
                      style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
