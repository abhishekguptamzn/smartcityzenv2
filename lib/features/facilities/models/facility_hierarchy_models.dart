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
    this.rawIcon,
    this.types = const [],
    this.facilityKind,
    this.isActivity = false,
  });

  final String id;
  final String name;
  final String slug;
  final IconData icon;
  final String? rawIcon;
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
    this.rawIcon,
    this.color,
  });

  final String id;
  final String categoryId;
  final String name;
  final String slug;
  final IconData icon;
  final String? rawIcon;
  final Color? color;
}

Color parseHexColor(String? hexString, {Color fallback = const Color(0xFF0D9488)}) {
  if (hexString == null || hexString.trim().isEmpty) return fallback;
  final clean = hexString.replaceAll('#', '').trim();
  if (clean.length == 6) {
    final val = int.tryParse('FF$clean', radix: 16);
    if (val != null) return Color(val);
  } else if (clean.length == 8) {
    final val = int.tryParse(clean, radix: 16);
    if (val != null) return Color(val);
  }
  return fallback;
}

/// Helper to parse icon names or map categories to icon/colors
IconData resolveCategoryIcon(
  String? iconName, {
  String? nameHint,
  IconData fallback = Icons.category_rounded,
}) {
  final raw = (iconName ?? '').toLowerCase().trim();
  final hint = (nameHint ?? '').toLowerCase().trim();
  final target = raw.isNotEmpty ? raw : hint;

  if (target.isEmpty) return fallback;

  // 1. Direct standard Material Icon name mapping (snake_case or kebab-case)
  final normalized = target.replaceAll('-', '_').replaceAll(' ', '_');

  const directMap = <String, IconData>{
    // Education & Knowledge
    'school': Icons.school_rounded,
    'education': Icons.school_rounded,
    'menu_book': Icons.menu_book_rounded,
    'book': Icons.local_library_rounded,
    'library': Icons.local_library_rounded,
    'local_library': Icons.local_library_rounded,
    'calculate': Icons.calculate_rounded,
    'abacus': Icons.calculate_rounded,
    'coaching': Icons.menu_book_rounded,
    'tuition': Icons.school_rounded,
    'home_tuition': Icons.home_work_rounded,
    'school_tuition': Icons.school_rounded,
    'code': Icons.code_rounded,
    'coding': Icons.code_rounded,
    'coding_classes': Icons.code_rounded,
    'precision_manufacturing': Icons.precision_manufacturing_rounded,
    'robotics': Icons.precision_manufacturing_rounded,
    'translate': Icons.translate_rounded,
    'languages': Icons.translate_rounded,

    // Sports & Fitness
    'fitness_center': Icons.fitness_center_rounded,
    'gym': Icons.fitness_center_rounded,
    'fitness': Icons.fitness_center_rounded,
    'fitness_training': Icons.fitness_center_rounded,
    'exercise': Icons.fitness_center_rounded,
    'directions_run': Icons.directions_run_rounded,
    'running': Icons.directions_run_rounded,
    'zumba': Icons.directions_run_rounded,
    'sports_cricket': Icons.sports_cricket_rounded,
    'cricket': Icons.sports_cricket_rounded,
    'cricket_academy': Icons.sports_cricket_rounded,
    'sports_soccer': Icons.sports_soccer_rounded,
    'football': Icons.sports_soccer_rounded,
    'football_academy': Icons.sports_soccer_rounded,
    'sports_tennis': Icons.sports_tennis_rounded,
    'tennis': Icons.sports_tennis_rounded,
    'tennis_academy': Icons.sports_tennis_rounded,
    'badminton': Icons.sports_tennis_rounded,
    'badminton_academy': Icons.sports_tennis_rounded,
    'pool': Icons.pool_rounded,
    'swimming': Icons.pool_rounded,
    'swimming_pool': Icons.pool_rounded,
    'self_improvement': Icons.self_improvement_rounded,
    'yoga': Icons.self_improvement_rounded,
    'meditation': Icons.self_improvement_rounded,
    'sports_kabaddi': Icons.sports_kabaddi_rounded,
    'kabaddi': Icons.sports_kabaddi_rounded,
    'martial_arts': Icons.sports_kabaddi_rounded,
    'karate': Icons.sports_mma_rounded,
    'sports_gymnastics': Icons.sports_gymnastics_rounded,
    'sports_basketball': Icons.sports_basketball_rounded,
    'basketball': Icons.sports_basketball_rounded,
    'sports_volleyball': Icons.sports_volleyball_rounded,
    'volleyball': Icons.sports_volleyball_rounded,

    // Arts, Culture & Music
    'palette': Icons.palette_rounded,
    'arts': Icons.palette_rounded,
    'art': Icons.palette_rounded,
    'brush': Icons.brush_rounded,
    'painting': Icons.brush_rounded,
    'draw': Icons.draw_rounded,
    'drawing': Icons.draw_rounded,
    'mic': Icons.mic_rounded,
    'singing': Icons.mic_rounded,
    'singing_classes': Icons.mic_rounded,
    'music': Icons.music_note_rounded,
    'music_note': Icons.music_note_rounded,
    'library_music': Icons.library_music_rounded,
    'music_classes': Icons.library_music_rounded,
    'nightlife': Icons.nightlife_rounded,
    'dance': Icons.nightlife_rounded,
    'dance_classes': Icons.nightlife_rounded,
    'dance_fitness': Icons.music_note_rounded,
    'theater_comedy': Icons.theater_comedy_rounded,
    'drama': Icons.theater_comedy_rounded,
    'casino': Icons.casino_rounded,
    'chess': Icons.casino_rounded,
    'interests': Icons.interests_rounded,
    'hobby': Icons.interests_rounded,
    'hobby_classes': Icons.interests_rounded,

    // Kids & Childcare
    'child_care': Icons.child_care_rounded,
    'child_friendly': Icons.child_friendly_rounded,
    'kids': Icons.child_care_rounded,
    'children': Icons.child_care_rounded,

    // Civic, Health & Emergency
    'local_hospital': Icons.local_hospital_rounded,
    'hospital': Icons.local_hospital_rounded,
    'healthcare': Icons.local_hospital_rounded,
    'health': Icons.medical_services_rounded,
    'medical_services': Icons.medical_services_rounded,
    'emergency': Icons.local_police_rounded,
    'local_police': Icons.local_police_rounded,
    'police': Icons.local_police_rounded,
    'shield': Icons.shield_rounded,
    'museum': Icons.museum_rounded,
    'attractions': Icons.museum_rounded,
    'restaurant': Icons.restaurant_rounded,
    'dining': Icons.restaurant_rounded,
    'local_cafe': Icons.local_cafe_rounded,
    'directions_bus': Icons.directions_bus_rounded,
    'transit': Icons.directions_bus_rounded,
    'home': Icons.home_rounded,
    'grid_view': Icons.grid_view_rounded,
  };

  if (directMap.containsKey(normalized)) {
    return directMap[normalized]!;
  }

  // 2. Keyword fallback matching on icon name & name hint
  final combined = '$raw $hint'.toLowerCase();

  if (combined.contains('sing') || combined.contains('vocal') || combined.contains('mic') || combined.contains('karaoke')) {
    return Icons.mic_rounded;
  }
  if (combined.contains('cricket') || combined.contains('bat')) {
    return Icons.sports_cricket_rounded;
  }
  if (combined.contains('tennis') || combined.contains('badminton') || combined.contains('squash') || combined.contains('racket')) {
    return Icons.sports_tennis_rounded;
  }
  if (combined.contains('foot') || combined.contains('soccer')) {
    return Icons.sports_soccer_rounded;
  }
  if (combined.contains('swim') || combined.contains('pool') || combined.contains('aqua') || combined.contains('diving')) {
    return Icons.pool_rounded;
  }
  if (combined.contains('yoga') || combined.contains('meditat') || combined.contains('wellness')) {
    return Icons.self_improvement_rounded;
  }
  if (combined.contains('dance') || combined.contains('zumba') || combined.contains('choreograph')) {
    return Icons.nightlife_rounded;
  }
  if (combined.contains('music') || combined.contains('guitar') || combined.contains('piano') || combined.contains('instrument')) {
    return Icons.library_music_rounded;
  }
  if (combined.contains('paint') || combined.contains('brush') || combined.contains('draw') || combined.contains('sketch') || combined.contains('craft') || combined.contains('art')) {
    return Icons.palette_rounded;
  }
  if (combined.contains('code') || combined.contains('program') || combined.contains('develop') || combined.contains('software')) {
    return Icons.code_rounded;
  }
  if (combined.contains('robot') || combined.contains('ai') || combined.contains('machine') || combined.contains('tech')) {
    return Icons.precision_manufacturing_rounded;
  }
  if (combined.contains('abacus') || combined.contains('math') || combined.contains('calculat')) {
    return Icons.calculate_rounded;
  }
  if (combined.contains('chess') || combined.contains('board') || combined.contains('game')) {
    return Icons.casino_rounded;
  }
  if (combined.contains('martial') || combined.contains('karate') || combined.contains('judo') || combined.contains('boxing') || combined.contains('kabaddi')) {
    return Icons.sports_kabaddi_rounded;
  }
  if (combined.contains('gym') || combined.contains('fit') || combined.contains('workout') || combined.contains('train') || combined.contains('body')) {
    return Icons.fitness_center_rounded;
  }
  if (combined.contains('book') || combined.contains('librar') || combined.contains('read') || combined.contains('study')) {
    return Icons.local_library_rounded;
  }
  if (combined.contains('school') || combined.contains('edu') || combined.contains('tutor') || combined.contains('tuition') || combined.contains('coach') || combined.contains('class')) {
    return Icons.school_rounded;
  }
  if (combined.contains('kid') || combined.contains('child') || combined.contains('toddler') || combined.contains('nursery')) {
    return Icons.child_care_rounded;
  }
  if (combined.contains('lang') || combined.contains('speak') || combined.contains('english') || combined.contains('french') || combined.contains('hindi')) {
    return Icons.translate_rounded;
  }
  if (combined.contains('hosp') || combined.contains('clinic') || combined.contains('doctor') || combined.contains('med')) {
    return Icons.local_hospital_rounded;
  }
  if (combined.contains('police') || combined.contains('emerg') || combined.contains('alert') || combined.contains('safe') || combined.contains('fire')) {
    return Icons.local_police_rounded;
  }
  if (combined.contains('museum') || combined.contains('monument') || combined.contains('heritage') || combined.contains('sight')) {
    return Icons.museum_rounded;
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
      rawIcon: 'local_library',
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
          color: Color(0xFF0F766E),
        ),
        FacilityTypeItem(
          id: 'central',
          categoryId: 'libraries',
          name: 'Central Libraries',
          slug: 'central',
          icon: Icons.menu_book_rounded,
          color: Color(0xFF0F766E),
        ),
        FacilityTypeItem(
          id: 'study',
          categoryId: 'libraries',
          name: 'Study Lounges',
          slug: 'study',
          icon: Icons.chair_rounded,
          color: Color(0xFF0F766E),
        ),
        FacilityTypeItem(
          id: 'digital',
          categoryId: 'libraries',
          name: 'Digital Libraries',
          slug: 'digital',
          icon: Icons.laptop_chromebook_rounded,
          color: Color(0xFF0F766E),
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
      rawIcon: 'fitness_center',
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
          color: Color(0xFF0284C7),
        ),
        FacilityTypeItem(
          id: 'general',
          categoryId: 'gyms',
          name: 'Fitness Centers',
          slug: 'fitness',
          icon: Icons.fitness_center_rounded,
          color: Color(0xFF0284C7),
        ),
        FacilityTypeItem(
          id: 'cardio',
          categoryId: 'gyms',
          name: 'Strength & Cardio',
          slug: 'strength',
          icon: Icons.directions_run_rounded,
          color: Color(0xFF0284C7),
        ),
        FacilityTypeItem(
          id: 'crossfit',
          categoryId: 'gyms',
          name: 'CrossFit Studios',
          slug: 'crossfit',
          icon: Icons.sports_gymnastics_rounded,
          color: Color(0xFF0284C7),
        ),
      ],
    ),
  );

  // 3. Dynamic Activity Categories from Backend API (Sports, Education, Arts, Kids, Fitness, etc.)
  final curatedCategoryPalettes = <String, List<Color>>{
    'education': [const Color(0xFF1D4ED8), const Color(0xFF3B82F6)], // Vibrant Royal Azure
    'fitness': [const Color(0xFF0284C7), const Color(0xFF38BDF8)], // Cyan Sky
    'arts': [const Color(0xFFBE185D), const Color(0xFFEC4899)], // Rose Magenta
    'kids': [const Color(0xFF6D28D9), const Color(0xFF8B5CF6)], // Deep Violet Purple
    'sports': [const Color(0xFFEA580C), const Color(0xFFF97316)], // Energetic Flame Orange
  };

  final defaultGradients = [
    [const Color(0xFF1D4ED8), const Color(0xFF3B82F6)], // Royal Blue
    [const Color(0xFFEA580C), const Color(0xFFF97316)], // Flame Orange
    [const Color(0xFF0284C7), const Color(0xFF38BDF8)], // Sky Cyan
    [const Color(0xFFBE185D), const Color(0xFFEC4899)], // Rose Pink
    [const Color(0xFF6D28D9), const Color(0xFF8B5CF6)], // Violet Purple
    [const Color(0xFF0F766E), const Color(0xFF14B8A6)], // Emerald Teal
  ];

  for (var i = 0; i < activityCategories.length; i++) {
    final cat = activityCategories[i];
    final slugKey = cat.slug.toLowerCase();
    final gradient = curatedCategoryPalettes[slugKey] ??
        (cat.color != null && cat.color!.isNotEmpty
            ? [parseHexColor(cat.color), parseHexColor(cat.color).withValues(alpha: 0.8)]
            : defaultGradients[i % defaultGradients.length]);
    final catColor = gradient.first;

    final types = <FacilityTypeItem>[
      FacilityTypeItem(
        id: 'all',
        categoryId: cat.id,
        name: 'All ${cat.name}',
        slug: 'all',
        icon: Icons.grid_view_rounded,
        color: catColor,
      ),
      ...cat.types.map(
        (t) => FacilityTypeItem(
          id: t.id,
          categoryId: cat.id,
          name: t.name,
          slug: t.slug,
          icon: resolveCategoryIcon(t.icon, nameHint: t.name),
          rawIcon: t.icon,
          color: catColor,
        ),
      ),
    ];

    items.add(
      FacilityCategoryItem(
        id: cat.id,
        name: cat.name,
        slug: cat.slug,
        icon: resolveCategoryIcon(cat.icon, nameHint: cat.name),
        rawIcon: cat.icon,
        gradientColors: gradient,
        description: cat.description ?? 'Verified academies and centers in your city.',
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
      rawIcon: 'museum',
      gradientColors: [Color(0xFFD97706), Color(0xFFFBBF24)],
      description: 'Monuments, Heritage Sites & Cultural Landmarks',
      types: [
        FacilityTypeItem(
          id: 'all',
          categoryId: 'attractions',
          name: 'All Attractions',
          slug: 'all',
          icon: Icons.grid_view_rounded,
          color: Color(0xFFD97706),
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
      rawIcon: 'local_hospital',
      gradientColors: [Color(0xFFE11D48), Color(0xFFFB7185)],
      description: 'Emergency Desks, Clinics & Municipal Hospitals',
      types: [
        FacilityTypeItem(
          id: 'all',
          categoryId: 'healthcare',
          name: 'All Healthcare',
          slug: 'all',
          icon: Icons.grid_view_rounded,
          color: Color(0xFFE11D48),
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
      rawIcon: 'local_police',
      gradientColors: [Color(0xFFDC2626), Color(0xFFF87171)],
      description: 'Police, Fire Brigade, Disaster Control & Ambulance',
      types: [
        FacilityTypeItem(
          id: 'all',
          categoryId: 'emergency',
          name: 'All Emergency Services',
          slug: 'all',
          icon: Icons.grid_view_rounded,
          color: Color(0xFFDC2626),
        ),
      ],
    ),
  );

  return items;
}
