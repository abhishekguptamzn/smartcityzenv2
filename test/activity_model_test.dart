import 'package:flutter_test/flutter_test.dart';
import 'package:smartcityzenv2/core/services/location_service.dart';
import 'package:smartcityzenv2/data/models/activity_model.dart';

void main() {
  test('LocationService instantiates safely without throwing', () {
    final service = LocationService();
    expect(service, isNotNull);
  });
  test('ActivityModel deserialization from live API payload', () {
    final json = {
      "id": "FAC7JXHOWL",
      "category_id": "CAT9ONE5Y8",
      "category": {
        "id": "CAT9ONE5Y8",
        "name": "Education",
        "slug": "education",
        "icon": "school",
        "color": "#3B82F6",
        "description": null,
        "sort_order": null,
        "is_active": null
      },
      "type_id": "TYP9TG6Q7F",
      "type": {
        "id": "TYP9TG6Q7F",
        "category_id": "CAT9ONE5Y8",
        "name": "Coaching",
        "slug": "coaching",
        "icon": "menu_book",
        "schema_template": null,
        "sort_order": null,
        "is_active": null
      },
      "name": "Pinnacle Science & Commerce Coaching",
      "description": null,
      "address": "B-44 Barakhamba Road, Connaught Place - 110001",
      "city_id": "CTYG2RTN4C",
      "city": {
        "id": "CTYG2RTN4C",
        "name": "New Delhi",
        "state": "Delhi (NCT)",
        "tagline": null,
        "description": null,
        "latitude": 28.6139,
        "longitude": 77.209,
        "is_capital": null,
        "timezone": null
      },
      "location": {
        "latitude": "28.63150000",
        "longitude": "77.21670000",
        "address": "B-44 Barakhamba Road, Connaught Place - 110001"
      },
      "latitude": "28.63150000",
      "longitude": "77.21670000",
      "contact_phone": "9811002012",
      "contact_email": "info@pinnaclecoaching.test",
      "website": "https://pinnaclesciencecommercecoaching.smartcityzen.test",
      "opening_time": "08:30:00",
      "closing_time": "20:30:00",
      "is_open_now": true,
      "status": "active",
      "verification_status": "verified",
      "is_featured": false,
      "rating": 4.75,
      "review_count": 24,
      "max_capacity": null,
      "owner_id": "USR3HKMVSR",
      "distance_km": null,
      "distance_formatted": null,
      "image": null,
      "image_url": null,
      "logo": null,
      "logo_url": null,
      "checkout_enabled": true,
      "default_checkout_time": null,
      "default_checkout_duration_minutes": 120,
      "batch_management_enabled": false,
      "attendance_management_enabled": false,
      "ble_verification_enabled": false,
      "ble_strict_mode": false,
      "ble_service_uuid": null,
      "ble_secret_key": null,
      "ble_proximity_sensitivity": "medium",
      "qr_rotation_interval": 15,
      "metadata": null,
      "created_by": null,
      "created_at": "2026-10-07T14:53:50+05:30",
      "updated_at": "2026-10-07T14:53:50+05:30"
    };

    final model = ActivityModel.fromJson(json);
    expect(model.id, equals('FAC7JXHOWL'));
    expect(model.name, equals('Pinnacle Science & Commerce Coaching'));
    expect(model.latitude, equals(28.6315));
    expect(model.longitude, equals(77.2167));
  });
}
