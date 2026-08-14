import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/image_url_resolver.dart';
import 'amenity_model.dart';
import 'city_model.dart';

part 'facility_model.freezed.dart';
part 'facility_model.g.dart';

/// Client-side discriminator. Libraries and gyms share one JSON shape but live
/// on different endpoints, so the repository stamps this after deserializing.
enum FacilityKind {
  library,
  gym;

  String get pathSegment => this == FacilityKind.library ? 'libraries' : 'gyms';

  String get payableMemberType =>
      this == FacilityKind.library ? 'LibraryMember' : 'GymMember';

  static FacilityKind fromPathSegment(String value) =>
      value == 'libraries' || value == 'library'
      ? FacilityKind.library
      : FacilityKind.gym;
}

@freezed
abstract class FacilityModel with _$FacilityModel {
  const FacilityModel._();

  const factory FacilityModel({
    required String id,
    required String name,
    String? description,
    String? address,
    @JsonKey(name: 'city_id') String? cityId,
    CityModel? city,
    @JsonKey(fromJson: _toDouble) double? latitude,
    @JsonKey(fromJson: _toDouble) double? longitude,
    @JsonKey(name: 'distance_km', fromJson: _toDouble) double? distanceKm,
    @JsonKey(name: 'distance_formatted') String? distanceFormatted,
    @JsonKey(name: 'image_url') String? imageUrl,
    Map<String, dynamic>? image,
    List<Map<String, dynamic>>? images,
    List<AmenityModel>? amenities,
    Map<String, dynamic>? location,
    @JsonKey(name: 'contact_phone') String? contactPhone,
    @JsonKey(name: 'contact_email') String? contactEmail,
    @JsonKey(name: 'opening_time') String? openingTime,
    @JsonKey(name: 'closing_time') String? closingTime,
    @Default('active') String status,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(FacilityKind.library)
    FacilityKind kind,
  }) = _FacilityModel;

  factory FacilityModel.fromJson(Map<String, dynamic> json) =>
      _$FacilityModelFromJson(json);

  /// Primary cover image URL from image_url, image object, or first item in images list.
  String? get coverImageUrl {
    String? raw;
    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      raw = imageUrl!.trim();
    } else if (image != null && image!['url'] is String) {
      final u = image!['url'] as String;
      if (u.trim().isNotEmpty) raw = u.trim();
    } else if (images != null && images!.isNotEmpty) {
      final first = images!.firstWhere(
        (m) => m['is_primary'] == true,
        orElse: () => images!.first,
      );
      if (first['url'] is String) {
        final u = first['url'] as String;
        if (u.trim().isNotEmpty) raw = u.trim();
      }
    }
    return ImageUrlResolver.resolve(raw);
  }

  /// All gallery image URLs resolved for platform target.
  List<String> get galleryImageUrls {
    if (images == null || images!.isEmpty) {
      final cover = coverImageUrl;
      return cover != null ? [cover] : const [];
    }
    final urls = <String>[];
    for (final item in images!) {
      final u = item['url'];
      if (u is String && u.trim().isNotEmpty) {
        final resolved = ImageUrlResolver.resolve(u.trim());
        if (resolved != null && resolved.isNotEmpty) {
          urls.add(resolved);
        }
      }
    }
    if (urls.isEmpty) {
      final cover = coverImageUrl;
      if (cover != null) urls.add(cover);
    }
    return urls;
  }

  /// Active amenities enabled in this facility.
  List<AmenityModel> get activeAmenities {
    if (amenities == null) return const [];
    return amenities!.where((a) => a.isEffectiveActive).toList();
  }

  /// Whether the facility is currently within its published opening hours.
  /// Computed client-side; the API exposes no "open now" flag.
  bool get isOpenNow {
    if (status != 'active') return false;
    final Duration? open = _parseTime(openingTime);
    final Duration? close = _parseTime(closingTime);
    if (open == null || close == null) return false;

    final DateTime now = DateTime.now();
    final Duration current = Duration(hours: now.hour, minutes: now.minute);

    if (close > open) {
      return current >= open && current < close;
    }
    // Overnight window (e.g. 22:00 -> 06:00).
    return current >= open || current < close;
  }

  String? get openingTimeShort => _shortTime(openingTime);

  String? get closingTimeShort => _shortTime(closingTime);
}

Duration? _parseTime(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  final List<String> parts = raw.split(':');
  if (parts.length < 2) return null;
  final int? h = int.tryParse(parts[0]);
  final int? m = int.tryParse(parts[1]);
  if (h == null || m == null) return null;
  return Duration(hours: h, minutes: m);
}

String? _shortTime(String? raw) {
  final Duration? parsed = _parseTime(raw);
  if (parsed == null) return null;
  final int h = parsed.inHours;
  final int m = parsed.inMinutes % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
