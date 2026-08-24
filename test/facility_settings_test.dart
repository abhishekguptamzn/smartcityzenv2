import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartcityzenv2/data/models/facility_model.dart';
import 'package:smartcityzenv2/features/facility_management/screens/facility_settings_screen.dart';

void main() {
  group('Facility Settings Screen Tests', () {
    const testFacility = FacilityModel(
      id: 'gym-001',
      name: 'Deccan Fitness & Strength Hub',
      address: 'FC Road, Shivaji Nagar',
      openingTime: '06:00 AM',
      closingTime: '10:00 PM',
      bleVerificationEnabled: true,
      bleStrictMode: false,
      bleProximitySensitivity: 'high',
      bleServiceUuid: 'test-uuid-1234',
      qrRotationInterval: 15,
      kind: FacilityKind.gym,
    );

    testWidgets('renders facility settings tiles including Edit Details and BLE Physical Presence', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            facilityDetailSettingsProvider((FacilityKind.gym, 'gym-001'))
                .overrideWith((ref) async => testFacility),
          ],
          child: const MaterialApp(
            home: FacilitySettingsScreen(
              kind: FacilityKind.gym,
              facilityId: 'gym-001',
              facility: testFacility,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Facility Settings'), findsOneWidget);
      expect(find.text('Deccan Fitness & Strength Hub'), findsOneWidget);
      expect(find.text('Edit Facility Details'), findsOneWidget);
      expect(find.text('Operating Hours'), findsOneWidget);
      expect(find.text('Physical Presence (BLE Settings)'), findsOneWidget);
      expect(find.text('Live QR Turnstile Screen'), findsOneWidget);
      expect(find.text('Fee Plans & Pricing'), findsOneWidget);
      expect(find.text('Broadcast & Member Communication'), findsOneWidget);
      expect(find.text('ACTIVE'), findsNWidgets(2)); // Badge on facility card + badge on BLE tile
    });
  });
}
