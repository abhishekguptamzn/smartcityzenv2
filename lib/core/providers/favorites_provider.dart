import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kFavoritesKey = 'smartcityzen_favorites_v1';

class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    _loadFromDisk();
    return {};
  }

  Future<void> _loadFromDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_kFavoritesKey) ?? [];
      state = list.toSet();
    } catch (_) {}
  }

  Future<bool> toggle(String facilityId) async {
    final next = Set<String>.from(state);
    final isNowFavorite = !next.contains(facilityId);
    if (isNowFavorite) {
      next.add(facilityId);
    } else {
      next.remove(facilityId);
    }
    state = next;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_kFavoritesKey, next.toList());
    } catch (_) {}

    return isNowFavorite;
  }

  bool isFavorite(String facilityId) => state.contains(facilityId);
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(
  FavoritesNotifier.new,
);
