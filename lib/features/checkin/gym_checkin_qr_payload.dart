import 'dart:convert';

/// Shared encode/decode for the gym check-in QR code, so the code that
/// generates it (Quick Check-in sheet) and the code that scans it (QR scan
/// screen) always agree on the payload shape.
class GymCheckInQrPayload {
  const GymCheckInQrPayload({required this.gymId, required this.memberId});

  final String gymId;
  final String memberId;

  String encode() => jsonEncode({'gym_id': gymId, 'member_id': memberId});

  static GymCheckInQrPayload? tryDecode(
    String raw, {
    String? defaultMemberId,
  }) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map) {
        final gymId = (decoded['gym_id'] ?? decoded['gymId'] ?? decoded['id'])
            ?.toString();
        final memberId =
            (decoded['member_id'] ?? decoded['memberId'])?.toString() ??
            defaultMemberId;

        if (gymId != null &&
            gymId.isNotEmpty &&
            memberId != null &&
            memberId.isNotEmpty) {
          return GymCheckInQrPayload(gymId: gymId, memberId: memberId);
        }
      }
    } on FormatException {
      // Not JSON, continue to string patterns
    }

    // Pattern 1: "gymId:memberId"
    if (trimmed.contains(':')) {
      final parts = trimmed.split(':');
      if (parts.length == 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
        return GymCheckInQrPayload(gymId: parts[0], memberId: parts[1]);
      }
    }

    // Pattern 2: URL like "https://.../gyms/GYM123"
    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.pathSegments.contains('gyms')) {
      final gymIdx = uri.pathSegments.indexOf('gyms');
      if (gymIdx + 1 < uri.pathSegments.length) {
        final gymId = uri.pathSegments[gymIdx + 1];
        final memberId =
            uri.queryParameters['member_id'] ??
            uri.queryParameters['memberId'] ??
            defaultMemberId;
        if (gymId.isNotEmpty && memberId != null && memberId.isNotEmpty) {
          return GymCheckInQrPayload(gymId: gymId, memberId: memberId);
        }
      }
    }

    // Pattern 3: Raw Gym ID like "GYM..." with default member ID provided
    if (trimmed.startsWith('GYM') &&
        defaultMemberId != null &&
        defaultMemberId.isNotEmpty) {
      return GymCheckInQrPayload(gymId: trimmed, memberId: defaultMemberId);
    }

    return null;
  }
}
