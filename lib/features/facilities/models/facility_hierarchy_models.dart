import 'package:flutter/material.dart';
import '../../../data/models/activity_category_model.dart';
import '../../../data/models/facility_model.dart';

class FacilityCategoryItem {
  const FacilityCategoryItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.gradientColors,
    required this.description,
    this.types = const [],
    this.facilityKind,
    this.isActivity = false,
  });

  final String id;
  final String name;
  final String slug;
  final IconData icon;
  final List<Color> gradientColors;
  final String description;
  final List<FacilityTypeItem> types;
  final FacilityKind? facilityKind;
  final bool isActivity;

  Color get primaryColor => gradientColors.first;
}

class FacilityTypeItem {
  const FacilityTypeItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    required this.icon,
    this.color,
  });

  final String id;
  final String categoryId;
  final String name;
  final String slug;
  final IconData icon;
  final Color? color;
}

/// Helper to parse icon names or map categories to icon/colors
IconData resolveCategoryIcon(String? iconName, {IconData fallback = Icons.category_rounded}) {
  if (iconName == null || iconName.isEmpty) return fallback;
  final lower = iconName.toLowerCase();
  if (lower.contains('book') || lower.contains('library') || lower.contains('read')) {
    return Icons.local_library_rounded;
  }
  if (lower.contains('gym') || lower.contains('fitness') || lower.contains('dumb')) {
    return Icons.fitness_center_rounded;
  }
  if (lower.contains('sport') || lower.contains('cricket') || lower.contains('foot') || lower.contains('ball')) {
    return Icons.sports_soccer_rounded;
  }
  if (lower.contains('swim') || lower.contains('pool') || lower.contains('aqua')) {
    return Icons.pool_rounded;
  }
  if (lower.contains('yoga') || lower.contains('meditat')) {
    return Icons.self_improvement_rounded;
  }
  if (lower.contains('dance') || lower.contains('music') || lower.contains('art')) {
    return Icons.theater_comedy_rounded;
  }
  if (lower.contains('edu') || lower.contains('school') || lower.contains('coach')) {
    return Icons.school_rounded;
  }
  if (lower.contains('health') || lower.contains('hosp') || lower.contains('med')) {
    return Icons.local_hospital_rounded;
  }
  if (lower.contains('museum') || lower.contains('heritage') || lower.contains('attract')) {
    return Icons.museum_rounded;
  }
  if (lower.contains('transit') || lower.contains('bus') || lower.contains('metro')) {
    return Icons.directions_bus_rounded;
  }
  if (lower.contains('police') || lower.contains('emerg') || lower.contains('alert')) {
    return Icons.local_police_rounded;
  }
  return fallback;
}

/// Transform backend dynamic ActivityCategoryModel list into enriched FacilityCategoryItems
List<FacilityCategoryItem> buildUnifiedCategories(List<ActivityCategoryModel> activityCategories) {
  final List<FacilityCategoryItem> items = [];

  // 1. Public Libraries (Core Facility)
  items.add(
    const FacilityCategoryItem(
      id: 'libraries',
      name: 'Public Libraries',
      slug: 'libraries',
      icon: Icons.local_library_rounded,
      gradientColors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
      description: 'Study Hubs, Books, Digital Archives & Reading Rooms',
      facilityKind: FacilityKind.library,
      types: [
        FacilityTypeItem(
          id: 'all',
          categoryId: 'libraries',
          name: 'All Libraries',
          slug: 'all',
          icon: Icons.grid_view_rounded,
        ),
        FacilityTypeItem(
          id: 'central',
          categoryId: 'libraries',
          name: 'Central Libraries',
          slug: 'central',
          icon: Icons.menu_book_rounded,
        ),
        FacilityTypeItem(
          id: 'study',
          categoryId: 'libraries',
          name: 'Study Lounges',
          slug: 'study',
          icon: Icons.chair_rounded,
        ),
        FacilityTypeItem(
          id: 'digital',
          categoryId: 'libraries',
          name: 'Digital Libraries',
          slug: 'digital',
          icon: Icons.laptop_chromebook_rounded,
        ),
      ],
    ),
  );

  // 2. Gyms & Fitness (Core Facility)
  items.add(
    const FacilityCategoryItem(
      id: 'gyms',
      name: 'Gyms & Fitness',
      slug: 'gyms',
      icon: Icons.fitness_center_rounded,
      gradientColors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
      description: 'Gymnasiums, Fitness Centers & Cardio Studios',
      facilityKind: FacilityKind.gym,
      types: [
        FacilityTypeItem(
          id: 'all',
          categoryId: 'gyms',
          name: 'All Gyms',
          slug: 'all',
          icon: Icons.grid_view_rounded,
        ),
        FacilityTypeItem(
          id: 'general',
          categoryId: 'gyms',
          name: 'Fitness Centers',
          slug: 'fitness',
          icon: Icons.fitness_center_rounded,
        ),
        FacilityTypeItem(
          id: 'cardio',
          categoryId: 'gyms',
          name: 'Strength & Cardio',
          slug: 'strength',
          icon: Icons.directions_run_rounded,
        ),
        FacilityTypeItem(
          id: 'crossfit',
          categoryId: 'gyms',
          name: 'CrossFit Studios',
          slug: 'crossfit',
          icon: Icons.sports_gymnastics_rounded,
        ),
      ],
    ),
  );

  // 3. Dynamic Activity Categories from Backend API (Sports, Yoga, Dance, Coaching, Aquatics, etc.)
  final defaultGradients = [
    [const Color(0xFFEA580C), const Color(0xFFFB923C)], // Sports (Orange)
    [const Color(0xFF059669), const Color(0xFF34D399)], // Wellness (Green)
    [const Color(0xFF7C3AED), const Color(0xFFA78BFA)], // Arts (Purple)
    [const Color(0xFF4F46E5), const Color(0xFF818CF8)], // Education (Indigo)
    [const Color(0xFFDB2777), const Color(0xFFF472B6)], // Dance (Pink)
    [const Color(0xFF0284C7), const Color(0xFF60A5FA)], // Swimming (Blue)
  ];

  for (var i = 0; i < activityCategories.length; i++) {
    final cat = activityCategories[i];
    final gradient = defaultGradients[i % defaultGradients.length];
    final types = <FacilityTypeItem>[
      FacilityTypeItem(
        id: 'all',
        categoryId: cat.id,
        name: 'All ${cat.name}',
        slug: 'all',
        icon: Icons.grid_view_rounded,
      ),
      ...cat.types.map(
        (t) => FacilityTypeItem(
          id: t.id,
          categoryId: cat.id,
          name: t.name,
          slug: t.slug,
          icon: resolveCategoryIcon(t.icon ?? t.name),
        ),
      ),
    ];

    items.add(
      FacilityCategoryItem(
        id: cat.id,
        name: cat.name,
        slug: cat.slug,
        icon: resolveCategoryIcon(cat.icon ?? cat.name),
        gradientColors: gradient,
        description: cat.description ?? 'Verified academies and activity centers in your city.',
        facilityKind: FacilityKind.activity,
        isActivity: true,
        types: types,
      ),
    );
  }

  // 4. City Attractions & Heritage
  items.add(
    const FacilityCategoryItem(
      id: 'attractions',
      name: 'City Attractions',
      slug: 'attractions',
      icon: Icons.museum_rounded,
      gradientColors: [Color(0xFFD97706), Color(0xFFFBBF24)],
      description: 'Monuments, Heritage Sites & Cultural Landmarks',
      types: [
        FacilityTypeItem(
          id: 'all',
          categoryId: 'attractions',
          name: 'All Attractions',
          slug: 'all',
          icon: Icons.grid_view_rounded,
        ),
      ],
    ),
  );

  // 5. Hospitals & Healthcare
  items.add(
    const FacilityCategoryItem(
      id: 'healthcare',
      name: 'Hospitals & Health',
      slug: 'healthcare',
      icon: Icons.local_hospital_rounded,
      gradientColors: [Color(0xFFE11D48), Color(0xFFFB7185)],
      description: 'Emergency Desks, Clinics & Municipal Hospitals',
      types: [
        FacilityTypeItem(
          id: 'all',
          categoryId: 'healthcare',
          name: 'All Healthcare',
          slug: 'all',
          icon: Icons.grid_view_rounded,
        ),
      ],
    ),
  );

  // 6. Emergency 112
  items.add(
    const FacilityCategoryItem(
      id: 'emergency',
      name: 'Emergency 112',
      slug: 'emergency',
      icon: Icons.local_police_rounded,
      gradientColors: [Color(0xFFDC2626), Color(0xFFF87171)],
      description: 'Police, Fire Brigade, Disaster Control & Ambulance',
      types: [
        FacilityTypeItem(
          id: 'all',
          categoryId: 'emergency',
          name: 'All Emergency Services',
          slug: 'all',
          icon: Icons.grid_view_rounded,
        ),
      ],
    ),
  );

  return items;
}
