import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_controller.g.dart';

const supportedLocales = <Locale>[
  Locale('en'),
  Locale('hi'),
  Locale('es'),
  Locale('fr'),
  Locale('ar'),
];

const _prefsKey = 'settings.locale';

@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  Locale build() {
    _hydrate();
    return _deviceLocaleOrFallback();
  }

  Locale _deviceLocaleOrFallback() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    final match = supportedLocales.firstWhere(
      (l) => l.languageCode == deviceLocale.languageCode,
      orElse: () => const Locale('en'),
    );
    return match;
  }

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null) {
      final match = supportedLocales.firstWhere(
        (l) => l.languageCode == saved,
        orElse: () => state,
      );
      state = match;
    }
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
    state = locale;
  }
}
