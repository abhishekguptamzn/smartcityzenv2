import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartcityzenv2/data/models/onboard_model.dart';
import 'package:smartcityzenv2/data/models/user_model.dart';
import 'package:smartcityzenv2/features/facilities/models/civic_service_item.dart';
import 'package:smartcityzenv2/l10n/gen/app_localizations.dart';
import 'package:smartcityzenv2/shared/widgets/glass_bottom_nav.dart';
import 'package:smartcityzenv2/shared/widgets/user_avatar.dart';

void main() {
  group('UserAvatar Widget Tests', () {
    testWidgets('renders initials fallback when photoUrl is null', (
      WidgetTester tester,
    ) async {
      const user = UserModel(
        id: 'USR001',
        name: 'Jane Doe',
        email: 'jane@example.com',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserAvatar(user: user, radius: 24),
          ),
        ),
      );

      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('renders single letter initials for single name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserAvatar(name: 'Admin', radius: 20),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('renders question mark for empty name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserAvatar(name: '', radius: 20),
          ),
        ),
      );

      expect(find.text('?'), findsOneWidget);
    });
  });

  group('GlassBottomNav Widget Tests', () {
    testWidgets('renders exactly 5 navigation items: Home, Services, Check-in, ID, Settings', (
      WidgetTester tester,
    ) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            bottomNavigationBar: GlassBottomNav(
              currentIndex: 0,
              onTap: (index) => tappedIndex = index,
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Services'), findsOneWidget);
      expect(find.text('Check-in'), findsOneWidget);
      expect(find.text('ID'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // Tap Check-in (index 2)
      await tester.tap(find.text('Check-in'));
      await tester.pump();
      expect(tappedIndex, equals(2));

      // Tap Settings (index 4)
      await tester.tap(find.text('Settings'));
      await tester.pump();
      expect(tappedIndex, equals(4));
    });
  });

  group('Civic Services Catalog Tests', () {
    test('contains comprehensive municipal services across healthcare, fitness, arts and coaching', () {
      expect(kCivicServicesCatalog.isNotEmpty, isTrue);

      final categories =
          kCivicServicesCatalog.map((s) => s.category).toSet();
      expect(
        categories,
        containsAll([
          CivicCategory.healthcare,
          CivicCategory.libraries,
          CivicCategory.gyms,
          CivicCategory.yoga,
          CivicCategory.dance,
          CivicCategory.coaching,
          CivicCategory.emergency,
        ]),
      );
    });
  });

  group('Onboard Module Model & Screen Tests', () {
    test('OnboardType enum provides accurate names, subtitles and highlights', () {
      expect(OnboardType.user.displayName, equals('User'));
      expect(OnboardType.user.subtitle, equals('Personal Account'));
      expect(OnboardType.user.highlights.length, equals(3));

      expect(OnboardType.library.displayName, equals('Library'));
      expect(OnboardType.library.subtitle, equals('Library Account'));

      expect(OnboardType.gym.displayName, equals('Gym'));
      expect(OnboardType.gym.subtitle, equals('Gym Account'));
    });

    test('OnboardDraft updates properly via copyWith', () {
      const draft = OnboardDraft();
      expect(draft.type, equals(OnboardType.user));

      final updated = draft.copyWith(
        type: OnboardType.library,
        name: 'Central Study Library',
        email: 'library@city.com',
        phone: '+91 98765 43210',
        address: 'Main Road',
        cityId: 'CTY001',
        cityName: 'Muzaffarnagar',
        ownerId: 'USR001',
        ownerName: 'Amit Verma',
      );

      expect(updated.type, equals(OnboardType.library));
      expect(updated.name, equals('Central Study Library'));
      expect(updated.ownerName, equals('Amit Verma'));
    });

    test('TokenVerificationResult parses JSON accurately', () {
      final json = {
        'type': 'library',
        'email': 'lib@example.com',
        'payload': {
          'name': 'Public Library',
          'phone': '+91 99999 88888',
        },
        'expires_at': '2026-08-11T12:00:00Z',
        'cities': [
          {'id': 'CTY001', 'name': 'Muzaffarnagar', 'state': 'Uttar Pradesh'}
        ],
        'amenities': [
          {'id': 'AMN001', 'name': 'WiFi', 'icon': 'wifi'}
        ],
      };

      final result = TokenVerificationResult.fromJson(json);
      expect(result.type, equals('library'));
      expect(result.email, equals('lib@example.com'));
      expect(result.payload['name'], equals('Public Library'));
      expect(result.cities.length, equals(1));
      expect(result.amenities.length, equals(1));
    });
  });
}
