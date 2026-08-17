import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/amenity_model.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/loading_indicator.dart';

final globalAmenitiesProvider = FutureProvider.autoDispose<List<AmenityModel>>((ref) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getGlobalAmenities();
});

Future<List<AmenityModel>?> showAmenitySelectorSheet({
  required BuildContext context,
  required FacilityKind kind,
  required String facilityId,
  required List<AmenityModel> initiallySelected,
}) async {
  HapticFeedback.lightImpact();

  return showModalBottomSheet<List<AmenityModel>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => AmenitySelectorSheet(
      kind: kind,
      facilityId: facilityId,
      initiallySelected: initiallySelected,
    ),
  );
}

class AmenitySelectorSheet extends ConsumerStatefulWidget {
  const AmenitySelectorSheet({
    super.key,
    required this.kind,
    required this.facilityId,
    required this.initiallySelected,
  });

  final FacilityKind kind;
  final String facilityId;
  final List<AmenityModel> initiallySelected;

  @override
  ConsumerState<AmenitySelectorSheet> createState() => _AmenitySelectorSheetState();
}

class _AmenitySelectorSheetState extends ConsumerState<AmenitySelectorSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  late Set<String> _selectedIds;
  late Map<String, AmenityModel> _selectedMap;
  bool _isCreatingNew = false;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.initiallySelected.map((a) => a.id).toSet();
    _selectedMap = {for (var a in widget.initiallySelected) a.id: a};
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  IconData _resolveAmenityIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('wifi') || lower.contains('wi-fi') || lower.contains('internet')) {
      return Icons.wifi_rounded;
    } else if (lower.contains('ac') || lower.contains('air') || lower.contains('cool')) {
      return Icons.ac_unit_rounded;
    } else if (lower.contains('reading') || lower.contains('book') || lower.contains('study') || lower.contains('quiet')) {
      return Icons.chair_rounded;
    } else if (lower.contains('newspaper') || lower.contains('journal') || lower.contains('magazin')) {
      return Icons.newspaper_rounded;
    } else if (lower.contains('water') || lower.contains('dispenser') || lower.contains('drink')) {
      return Icons.local_drink_rounded;
    } else if (lower.contains('power') || lower.contains('plug') || lower.contains('charging')) {
      return Icons.power_rounded;
    } else if (lower.contains('parking') || lower.contains('valet')) {
      return Icons.local_parking_rounded;
    } else if (lower.contains('locker') || lower.contains('storage')) {
      return Icons.lock_outline_rounded;
    } else if (lower.contains('gym') || lower.contains('dumbbell') || lower.contains('weight') || lower.contains('treadmill')) {
      return Icons.fitness_center_rounded;
    } else if (lower.contains('shower') || lower.contains('bath') || lower.contains('washroom')) {
      return Icons.shower_rounded;
    } else if (lower.contains('cafe') || lower.contains('coffee') || lower.contains('tea')) {
      return Icons.coffee_rounded;
    } else if (lower.contains('cctv') || lower.contains('security') || lower.contains('guard')) {
      return Icons.videocam_outlined;
    }
    return Icons.check_circle_outline_rounded;
  }

  Future<void> _handleCreateCustomAmenity() async {
    final name = _searchQuery.trim();
    if (name.isEmpty) return;

    setState(() => _isCreatingNew = true);
    HapticFeedback.mediumImpact();

    try {
      final repo = ref.read(clientFacilityRepositoryProvider);
      final created = await repo.createAmenity(name);
      if (created != null) {
        setState(() {
          _selectedIds.add(created.id);
          _selectedMap[created.id] = created;
          _searchCtrl.clear();
          _searchQuery = '';
        });
        ref.invalidate(globalAmenitiesProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add custom amenity: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreatingNew = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = widget.kind == FacilityKind.gym ? const Color(0xFF0D9488) : const Color(0xFF0284C7);

    final amenitiesAsync = ref.watch(globalAmenitiesProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 30,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add_task_rounded, color: primaryColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Select Amenities (${_selectedIds.length})',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16.5),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              decoration: InputDecoration(
                hintText: 'Search amenities (e.g. WiFi, AC, Reading Area)...',
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Amenities List / Grid
          Expanded(
            child: amenitiesAsync.when(
              data: (amenitiesList) {
                final allMap = <String, AmenityModel>{};
                for (var a in amenitiesList) {
                  allMap[a.id] = a;
                }
                for (var entry in _selectedMap.entries) {
                  allMap.putIfAbsent(entry.key, () => entry.value);
                }
                for (var a in amenitiesList) {
                  if (_selectedIds.contains(a.id)) {
                    _selectedMap.putIfAbsent(a.id, () => a);
                  }
                }
                final list = allMap.values.toList();

                final filtered = list.where((a) {
                  if (_searchQuery.isEmpty) return true;
                  return a.name.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();

                final exactMatch = filtered.any((a) => a.name.toLowerCase() == _searchQuery.toLowerCase());

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  children: [
                    // Quick Selected Summary
                    if (_selectedIds.isNotEmpty && _searchQuery.isEmpty) ...[
                      const Text(
                        'Currently Active on Facility',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedIds.map((id) {
                          final amenity = allMap[id];
                          if (amenity == null) return const SizedBox.shrink();
                          final iconData = _resolveAmenityIcon(amenity.name);

                          return Chip(
                            avatar: Icon(iconData, size: 16, color: primaryColor),
                            label: Text(
                              amenity.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            backgroundColor: primaryColor.withValues(alpha: 0.12),
                            deleteIcon: const Icon(Icons.close_rounded, size: 14),
                            onDeleted: () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _selectedIds.remove(id);
                                _selectedMap.remove(id);
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: primaryColor.withValues(alpha: 0.3)),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      const Text(
                        'All Available Catalog Amenities',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Filtered List
                    if (filtered.isNotEmpty) ...[
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: filtered.map((amenity) {
                          final isSelected = _selectedIds.contains(amenity.id);
                          final iconData = _resolveAmenityIcon(amenity.name);

                          return InkWell(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                if (isSelected) {
                                  _selectedIds.remove(amenity.id);
                                  _selectedMap.remove(amenity.id);
                                } else {
                                  _selectedIds.add(amenity.id);
                                  _selectedMap[amenity.id] = amenity;
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryColor.withValues(alpha: 0.14)
                                    : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? primaryColor
                                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                  width: isSelected ? 1.6 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    iconData,
                                    size: 17,
                                    color: isSelected ? primaryColor : Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    amenity.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      color: isSelected
                                          ? primaryColor
                                          : (isDark ? Colors.white : const Color(0xFF1E293B)),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    isSelected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                                    size: 16,
                                    color: isSelected ? primaryColor : Colors.grey.shade400,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    // Option to create custom if not exact match
                    if (_searchQuery.isNotEmpty && !exactMatch) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.add_circle_rounded, color: Color(0xFF10B981), size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Add "$_searchQuery" as new custom amenity',
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: _isCreatingNew ? null : _handleCreateCustomAmenity,
                              child: _isCreatingNew
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text('Add', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
              loading: () => const Center(child: LoadingIndicator()),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Failed to load amenities: $err'),
                ),
              ),
            ),
          ),

          // Bottom Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  final resultList = <AmenityModel>[];
                  for (final id in _selectedIds) {
                    final item = _selectedMap[id];
                    if (item != null) {
                      resultList.add(item);
                    }
                  }
                  Navigator.of(context).pop(resultList);
                },
                child: Text(
                  'Apply ${_selectedIds.length} Amenities',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
