class OtpSentResult {
  const OtpSentResult({
    required this.phone,
    this.otp,
    this.cooldownSeconds = 60,
    this.expiresInSeconds = 300,
    this.message,
  });

  final String phone;
  final String? otp;
  final int cooldownSeconds;
  final int expiresInSeconds;
  final String? message;

  factory OtpSentResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return OtpSentResult(
      phone: data['phone'] as String? ?? '',
      otp: data['otp'] as String?,
      cooldownSeconds: (data['cooldown_seconds'] as num?)?.toInt() ?? 60,
      expiresInSeconds: (data['expires_in_seconds'] as num?)?.toInt() ?? 300,
      message: (json['meta'] is Map<String, dynamic>)
          ? (json['meta'] as Map<String, dynamic>)['message'] as String?
          : null,
    );
  }
}
