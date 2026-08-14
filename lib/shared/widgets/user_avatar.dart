import 'package:flutter/material.dart';

import '../../core/utils/image_url_resolver.dart';
import '../../data/models/user_model.dart';

/// Clean, robust user avatar with resolved image URL, error handling,
/// and initials fallback.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.user,
    this.photoUrl,
    this.name,
    this.radius = 20,
    this.border,
    this.backgroundColor,
  });

  final UserModel? user;
  final String? photoUrl;
  final String? name;
  final double radius;
  final BoxBorder? border;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final String? rawUrl = photoUrl ?? user?.effectiveAvatarUrl;
    final String? resolvedUrl = ImageUrlResolver.resolve(rawUrl);

    final String displayName = name ?? user?.name ?? '';
    final String initials = _getInitials(displayName);

    Widget fallbackInitials() {
      return Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: border,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D9488), Color(0xFF0284C7)],
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: radius * 0.75,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    if (resolvedUrl == null || resolvedUrl.isEmpty) {
      return fallbackInitials();
    }

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border,
        color: backgroundColor ?? Colors.grey.shade200,
      ),
      child: ClipOval(
        child: Image.network(
          resolvedUrl,
          key: ValueKey(resolvedUrl),
          gaplessPlayback: true,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => fallbackInitials(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            if (loadingProgress.expectedTotalBytes != null &&
                loadingProgress.cumulativeBytesLoaded >=
                    (loadingProgress.expectedTotalBytes ?? 0)) {
              return child;
            }
            return fallbackInitials();
          },
        ),
      ),
    );
  }

  static String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
