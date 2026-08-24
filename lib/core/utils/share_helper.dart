import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class AppShareHelper {
  AppShareHelper._();

  static const String _defaultDomain = 'https://admin.smartct.online';

  /// Generates a full deep link / web link and invokes the native share sheet.
  static Future<void> shareContent({
    required BuildContext context,
    required String title,
    required String path,
    String? subtitle,
  }) async {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final url = '$_defaultDomain$cleanPath';
    final shareText = subtitle != null && subtitle.isNotEmpty
        ? '$title - $subtitle\n$url'
        : '$title\n$url';

    try {
      if (kIsWeb) {
        await Clipboard.setData(ClipboardData(text: url));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Link copied to clipboard: $url'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: title,
        ),
      );
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: url));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Link copied: $url'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Shares arbitrary text with clipboard fallback.
  static Future<void> shareText({
    required BuildContext context,
    required String text,
    String? subject,
  }) async {
    try {
      if (kIsWeb) {
        await Clipboard.setData(ClipboardData(text: text));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Copied to clipboard!'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      await SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: subject,
        ),
      );
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: text));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied to clipboard!'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
