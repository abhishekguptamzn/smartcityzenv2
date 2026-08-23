import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/facility_hierarchy_models.dart';

class FacilityTypeChips extends StatelessWidget {
  const FacilityTypeChips({
    super.key,
    required this.types,
    required this.selectedType,
    required this.onSelectType,
    required this.activeColor,
  });

  final List<FacilityTypeItem> types;
  final FacilityTypeItem? selectedType;
  final ValueChanged<FacilityTypeItem> onSelectType;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    if (types.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        itemCount: types.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = types[index];
          final isSelected = (selectedType == null && type.id == 'all') ||
              (selectedType != null && selectedType!.id == type.id);
          final chipColor = type.color ?? activeColor;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                onSelectType(type);
              },
              borderRadius: BorderRadius.circular(22),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? chipColor
                      : (isDark ? const Color(0xFF1E293B) : Colors.white),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected
                        ? chipColor
                        : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? chipColor.withValues(alpha: 0.35)
                          : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: isSelected ? 8 : 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.25)
                            : chipColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        type.icon,
                        size: 14,
                        color: isSelected ? Colors.white : chipColor,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      type.name,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white : const Color(0xFF1E293B)),
                        letterSpacing: -0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
