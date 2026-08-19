import 'package:flutter/material.dart';

/// Universal Icon Helper to resolve Material Icons strings, Unicode Emojis,
/// and fallback symbols dynamically across the SmartCityzen mobile client.
class IconHelper {
  IconHelper._();

  static const Map<String, IconData> _materialIconMap = {
    // Fitness & Sports
    'fitness_center': Icons.fitness_center_rounded,
    'exercise': Icons.fitness_center_rounded,
    'sports_gym': Icons.fitness_center_rounded,
    'self_improvement': Icons.self_improvement_rounded,
    'yoga': Icons.self_improvement_rounded,
    'spa': Icons.spa_rounded,
    'meditation': Icons.spa_rounded,
    'directions_run': Icons.directions_run_rounded,
    'zumba': Icons.directions_run_rounded,
    'sports_kabaddi': Icons.sports_kabaddi_rounded,
    'sports_martial_arts': Icons.sports_martial_arts_rounded,
    'karate': Icons.sports_martial_arts_rounded,
    'taekwondo': Icons.sports_martial_arts_rounded,
    'pool': Icons.pool_rounded,
    'swimming': Icons.pool_rounded,
    'sports_cricket': Icons.sports_cricket_rounded,
    'cricket': Icons.sports_cricket_rounded,
    'sports_soccer': Icons.sports_soccer_rounded,
    'football': Icons.sports_soccer_rounded,
    'sports_tennis': Icons.sports_tennis_rounded,
    'tennis': Icons.sports_tennis_rounded,
    'sports_badminton': Icons.sports_tennis_rounded,
    'badminton': Icons.sports_tennis_rounded,
    'sports_basketball': Icons.sports_basketball_rounded,
    'basketball': Icons.sports_basketball_rounded,
    'sports_volleyball': Icons.sports_volleyball_rounded,
    'volleyball': Icons.sports_volleyball_rounded,
    'sports_mma': Icons.sports_mma_rounded,
    'boxing': Icons.sports_mma_rounded,
    'skateboarding': Icons.skateboarding_rounded,
    'skating': Icons.skateboarding_rounded,
    'pedal_bike': Icons.pedal_bike_rounded,
    'cycling': Icons.pedal_bike_rounded,
    'emoji_events': Icons.emoji_events_rounded,
    'tournament': Icons.emoji_events_rounded,

    // Education & Coaching
    'school': Icons.school_rounded,
    'menu_book': Icons.menu_book_rounded,
    'tuition': Icons.menu_book_rounded,
    'home': Icons.home_rounded,
    'home_tuition': Icons.home_rounded,
    'psychology': Icons.psychology_rounded,
    'competitive_exam': Icons.psychology_rounded,
    'code': Icons.code_rounded,
    'coding': Icons.code_rounded,
    'computer': Icons.computer_rounded,
    'record_voice_over': Icons.record_voice_over_rounded,
    'spoken_english': Icons.record_voice_over_rounded,
    'translate': Icons.translate_rounded,
    'language': Icons.translate_rounded,
    'construction': Icons.construction_rounded,
    'skill_development': Icons.construction_rounded,
    'work': Icons.work_rounded,
    'career': Icons.work_rounded,
    'badge': Icons.badge_rounded,
    'interview': Icons.badge_rounded,
    'calculate': Icons.calculate_rounded,
    'abacus': Icons.calculate_rounded,
    'vedic_maths': Icons.calculate_rounded,
    'science': Icons.science_rounded,
    'robotics': Icons.smart_toy_rounded,
    'smart_toy': Icons.smart_toy_rounded,
    'toys': Icons.toys_rounded,
    'child_care': Icons.child_care_rounded,
    'daycare': Icons.child_care_rounded,

    // Arts & Culture
    'palette': Icons.palette_rounded,
    'painting': Icons.palette_rounded,
    'drawing': Icons.palette_rounded,
    'brush': Icons.brush_rounded,
    'theater_comedy': Icons.theater_comedy_rounded,
    'drama': Icons.theater_comedy_rounded,
    'music_note': Icons.music_note_rounded,
    'vocal_music': Icons.music_note_rounded,
    'piano': Icons.piano_rounded,
    'keyboard': Icons.piano_rounded,
    'guitar': Icons.music_note_rounded,
    'camera_alt': Icons.camera_alt_rounded,
    'photography': Icons.camera_alt_rounded,
    'auto_fix_high': Icons.auto_fix_high_rounded,
    'magic': Icons.auto_fix_high_rounded,

    // Municipal, Facilities & Amenities
    'local_library': Icons.local_library_rounded,
    'library_books': Icons.library_books_rounded,
    'local_hospital': Icons.local_hospital_rounded,
    'local_pharmacy': Icons.local_pharmacy_rounded,
    'medical_services': Icons.medical_services_rounded,
    'directions_bus': Icons.directions_bus_rounded,
    'train': Icons.train_rounded,
    'local_police': Icons.local_police_rounded,
    'local_fire_department': Icons.local_fire_department_rounded,
    'location_city': Icons.location_city_rounded,
    'wifi': Icons.wifi_rounded,
    'ac_unit': Icons.ac_unit_rounded,
    'local_parking': Icons.local_parking_rounded,
    'water_drop': Icons.water_drop_rounded,
    'lock': Icons.lock_rounded,
    'restaurant': Icons.restaurant_rounded,
    'accessible': Icons.accessible_rounded,
    'power': Icons.power_rounded,
    'videocam': Icons.videocam_rounded,
    'shower': Icons.shower_rounded,
  };

  /// Returns true if the string is likely an emoji rather than a Material Icon name.
  static bool isEmoji(String? iconStr) {
    if (iconStr == null || iconStr.trim().isEmpty) return false;
    final trimmed = iconStr.trim();
    if (trimmed.length <= 2) return true;
    final hasAlphaUnderscore = RegExp(r'^[a-z0-9_]+$').hasMatch(trimmed);
    return !hasAlphaUnderscore;
  }

  /// Maps a Material Icon name (e.g. `fitness_center`, `school`) to an [IconData].
  static IconData? getIconData(String? iconStr) {
    if (iconStr == null || iconStr.trim().isEmpty) return null;
    final key = iconStr.trim().toLowerCase();
    return _materialIconMap[key];
  }

  /// Universal Widget builder that gracefully displays either a Material Icon or an Emoji.
  static Widget buildIcon(
    String? iconStr, {
    double size = 18,
    Color? color,
    String defaultEmoji = '🎯',
    IconData defaultIcon = Icons.stars_rounded,
  }) {
    if (iconStr == null || iconStr.trim().isEmpty) {
      return Text(
        defaultEmoji,
        style: TextStyle(fontSize: size),
      );
    }

    final trimmed = iconStr.trim();

    if (isEmoji(trimmed)) {
      return Text(
        trimmed,
        style: TextStyle(fontSize: size),
      );
    }

    final iconData = getIconData(trimmed) ?? defaultIcon;
    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }
}
