enum OnboardType {
  user,
  library,
  gym;

  String get displayName {
    switch (this) {
      case OnboardType.user:
        return 'User';
      case OnboardType.library:
        return 'Library';
      case OnboardType.gym:
        return 'Gym';
    }
  }

  String get subtitle {
    switch (this) {
      case OnboardType.user:
        return 'Personal Account';
      case OnboardType.library:
        return 'Library Account';
      case OnboardType.gym:
        return 'Gym Account';
    }
  }

  String get description {
    switch (this) {
      case OnboardType.user:
        return 'Create a personal account';
      case OnboardType.library:
        return 'Onboard your library';
      case OnboardType.gym:
        return 'Onboard your gym';
    }
  }

  List<String> get highlights {
    switch (this) {
      case OnboardType.user:
        return [
          'Access all CityZen features',
          'Personalized experience',
          'Manage your activities',
        ];
      case OnboardType.library:
        return [
          'Manage your library',
          'Track members & activities',
          'Access analytics & more',
        ];
      case OnboardType.gym:
        return [
          'Manage your gym',
          'Track members & attendance',
          'Access analytics & more',
        ];
    }
  }
}

class OwnerSearchResult {
  const OwnerSearchResult({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.role,
    this.cityId,
  });

  factory OwnerSearchResult.fromJson(Map<String, dynamic> json) {
    return OwnerSearchResult(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      role: json['role'] as String?,
      cityId: json['city_id'] as String?,
    );
  }

  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? role;
  final String? cityId;
}

class OnboardDraft {
  const OnboardDraft({
    this.type = OnboardType.user,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.cityId = '',
    this.cityName = '',
    this.ownerId = '',
    this.ownerName = '',
    this.ownerEmail = '',
    this.ownerAvatar = '',
  });

  final OnboardType type;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String cityId;
  final String cityName;
  final String ownerId;
  final String ownerName;
  final String ownerEmail;
  final String ownerAvatar;

  OnboardDraft copyWith({
    OnboardType? type,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? cityId,
    String? cityName,
    String? ownerId,
    String? ownerName,
    String? ownerEmail,
    String? ownerAvatar,
  }) {
    return OnboardDraft(
      type: type ?? this.type,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      ownerAvatar: ownerAvatar ?? this.ownerAvatar,
    );
  }
}

class TokenVerificationResult {
  const TokenVerificationResult({
    required this.type,
    required this.email,
    required this.payload,
    required this.expiresAt,
    required this.cities,
    required this.amenities,
  });

  factory TokenVerificationResult.fromJson(Map<String, dynamic> json) {
    final payloadMap = (json['payload'] as Map<String, dynamic>?) ?? {};
    final citiesList = ((json['cities'] as List<dynamic>?) ?? [])
        .map((c) => c as Map<String, dynamic>)
        .toList();
    final amenitiesList = ((json['amenities'] as List<dynamic>?) ?? [])
        .map((a) => a as Map<String, dynamic>)
        .toList();

    return TokenVerificationResult(
      type: json['type'] as String? ?? 'user',
      email: json['email'] as String? ?? '',
      payload: payloadMap,
      expiresAt: json['expires_at'] as String? ?? '',
      cities: citiesList,
      amenities: amenitiesList,
    );
  }

  final String type;
  final String email;
  final Map<String, dynamic> payload;
  final String expiresAt;
  final List<Map<String, dynamic>> cities;
  final List<Map<String, dynamic>> amenities;
}
