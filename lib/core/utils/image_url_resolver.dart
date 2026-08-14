import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

import '../config/app_config.dart';

/// Centralized utility for resolving image URLs across Web, Android Emulator,
/// iOS Simulator, physical devices, and backend storage paths.
class ImageUrlResolver {
  const ImageUrlResolver._();

  /// Dynamically configured active API base URL (e.g. from AppConfigController).
  static String? activeBaseUrl;

  /// Sets or updates the active API base URL used for image resolution.
  static void setActiveBaseUrl(String? url) {
    if (url != null && url.trim().isNotEmpty) {
      activeBaseUrl = url.trim();
    }
  }

  /// Resolves any relative, local, or platform-specific image URL into a
  /// fully reachable HTTP URL for the current runtime target.
  static String? resolve(String? rawUrl, {String? baseApiUrl}) {
    if (rawUrl == null) return null;
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) return null;

    final String activeBase =
        baseApiUrl ?? activeBaseUrl ?? AppConfig.platformDefaultBaseUrl();
    final Uri baseUri =
        Uri.tryParse(activeBase) ?? Uri.parse('https://smartct.online/api/v1');

    final String targetHost = baseUri.host.isNotEmpty ? baseUri.host : 'localhost';
    final int? targetPort = baseUri.hasPort ? baseUri.port : null;
    final String targetScheme =
        baseUri.scheme.isNotEmpty ? baseUri.scheme : 'http';
    final String portPart = targetPort != null ? ':$targetPort' : '';
    final String rootOrigin = '$targetScheme://$targetHost$portPart';

    // 1. Relative paths from Laravel storage (e.g. '/storage/media/...' or 'storage/media/...')
    if (trimmed.startsWith('/')) {
      return '$rootOrigin$trimmed';
    }
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      return '$rootOrigin/$trimmed';
    }

    // 2. Full HTTP URLs
    try {
      final uri = Uri.parse(trimmed);

      // If the URL host is localhost, loopback, or emulator alias,
      // rewrite scheme, host, and port to match the active API target.
      final isLocalOrEmulatorHost =
          uri.host == 'localhost' ||
          uri.host == '127.0.0.1' ||
          uri.host == '10.0.2.2' ||
          uri.host == '10.0.3.2' ||
          uri.host == '0.0.0.0';

      if (isLocalOrEmulatorHost) {
        // If we are on Android emulator and targetHost is localhost/127.0.0.1, convert to 10.0.2.2
        String effectiveHost = targetHost;
        if (!kIsWeb) {
          try {
            if (Platform.isAndroid &&
                (effectiveHost == 'localhost' ||
                    effectiveHost == '127.0.0.1' ||
                    effectiveHost == '0.0.0.0')) {
              effectiveHost = '10.0.2.2';
            }
          } catch (_) {}
        }

        return uri.replace(
          scheme: targetScheme,
          host: effectiveHost,
          port: targetPort ?? (uri.hasPort ? uri.port : null),
        ).toString();
      }

      // If on Web and host was hardcoded to 10.0.2.2, point back to localhost/targetHost
      if (kIsWeb && uri.host == '10.0.2.2') {
        return uri.replace(
          scheme: targetScheme,
          host: targetHost == '10.0.2.2' ? 'localhost' : targetHost,
          port: targetPort ?? (uri.hasPort ? uri.port : null),
        ).toString();
      }

      return uri.toString();
    } catch (_) {
      return trimmed;
    }
  }
}
