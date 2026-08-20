import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

/// Utility class for client-side file and image upload validation.
class FileValidator {
  FileValidator._();

  /// Default maximum allowed image size: 10 MB.
  static const int defaultMaxImageSizeBytes = 10 * 1024 * 1024;

  /// Allowed image file extensions.
  static const List<String> defaultAllowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
    'avif',
    'heic',
    'heif',
  ];

  /// Validates raw byte payload of an image before uploading.
  /// Returns `null` if valid, or a descriptive error message if invalid.
  static String? validateImageBytes(
    Uint8List? bytes, {
    String? filename,
    int maxSizeBytes = defaultMaxImageSizeBytes,
    List<String> allowedExtensions = defaultAllowedImageExtensions,
  }) {
    if (bytes == null || bytes.isEmpty) {
      return 'No image data selected. Please choose a valid image.';
    }

    if (bytes.lengthInBytes > maxSizeBytes) {
      final sizeInMb = (bytes.lengthInBytes / (1024 * 1024)).toStringAsFixed(1);
      final maxMb = (maxSizeBytes / (1024 * 1024)).toStringAsFixed(0);
      return 'Image size ($sizeInMb MB) exceeds the maximum allowed limit of $maxMb MB. Please select a smaller image.';
    }

    if (filename != null && filename.isNotEmpty && filename.contains('.')) {
      final ext = filename.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(ext)) {
        return 'Unsupported image format (.$ext). Please upload ${allowedExtensions.join(', ')}.';
      }
    }

    return null;
  }

  /// Validates an [XFile] picked via ImagePicker.
  /// Reads bytes and checks size & format.
  /// Returns `null` if valid, or a descriptive error message if invalid.
  static Future<String?> validateXFile(
    XFile? file, {
    int maxSizeBytes = defaultMaxImageSizeBytes,
    List<String> allowedExtensions = defaultAllowedImageExtensions,
  }) async {
    if (file == null) {
      return 'No image file selected.';
    }

    final filename = file.name.isNotEmpty ? file.name : file.path.split('/').last;
    if (filename.contains('.')) {
      final ext = filename.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(ext)) {
        return 'Unsupported image format (.$ext). Allowed formats: ${allowedExtensions.join(', ')}.';
      }
    }

    final length = await file.length();
    if (length == 0) {
      return 'The selected image is empty (0 bytes).';
    }

    if (length > maxSizeBytes) {
      final sizeInMb = (length / (1024 * 1024)).toStringAsFixed(1);
      final maxMb = (maxSizeBytes / (1024 * 1024)).toStringAsFixed(0);
      return 'Image size ($sizeInMb MB) exceeds the maximum allowed limit of $maxMb MB. Please select a smaller image.';
    }

    return null;
  }
}
