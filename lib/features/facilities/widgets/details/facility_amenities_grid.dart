import 'package:flutter/material.dart';

import '../../../../core/utils/icon_helper.dart';
import '../../../../data/models/amenity_model.dart';

class FacilityAmenitiesGrid extends StatelessWidget {
  const FacilityAmenitiesGrid({
    super.key,
    required this.amenities,
    this.primaryColor = const Color(0xFF0F766E),
  });

  final List<AmenityModel> amenities;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    if (amenities.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Standard civic facility amenities available on site.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: amenities.map((amenity) {
        final icon = IconHelper.getIconData(amenity.icon) ?? Icons.stars_rounded;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                amenity.name,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
