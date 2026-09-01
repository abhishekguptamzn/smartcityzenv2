import 'package:dio/dio.dart';

import '../models/api_error.dart';

enum AppExceptionCode {
  validation,
  authentication,
  authorization,
  accountBlocked,
  accountInactive,
  notFound,
  conflict,
  badRequest,
  rateLimited,
  server,
  network,
  unknown,
}

/// Typed exception thrown by [dio_client]'s error-mapping interceptor. UI
/// layers switch on [code] and localize a message rather than showing
/// [message]/[apiError] directly (those are for logs/debugging).
class AppException implements Exception {
  const AppException({
    required this.code,
    required this.message,
    this.apiError,
    this.retryAfterSeconds,
    this.fieldErrors,
  });

  final AppExceptionCode code;
  final String message;
  final ApiError? apiError;
  final int? retryAfterSeconds;

  /// Field -> list of messages, lifted from `error.details` on a 422 so forms
  /// can map server validation errors back onto individual fields.
  final Map<String, List<String>>? fieldErrors;

  /// Human-readable message prioritizing specific validation field errors over
  /// generic "The given data was invalid." messages.
  String get userMessage {
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      final messages = <String>[];
      for (final msgs in fieldErrors!.values) {
        for (final m in msgs) {
          final trimmed = m.trim();
          if (trimmed.isNotEmpty && !messages.contains(trimmed)) {
            messages.add(trimmed);
          }
        }
      }
      if (messages.isNotEmpty) {
        return messages.join('\n');
      }
    }
    if (message.isNotEmpty) {
      return message;
    }
    return 'An unexpected error occurred.';
  }

  String get displayMessage => userMessage;

  static AppException? from(Object? error) {
    if (error is AppException) return error;
    if (error is DioException) {
      if (error.error is AppException) {
        return error.error as AppException;
      }
      final response = error.response;
      if (response?.data is Map) {
        final data = response!.data as Map;
        if (data['error'] is Map) {
          try {
            final apiError = ApiError.fromJson(
              Map<String, dynamic>.from(data['error'] as Map),
            );
            return AppException.fromApiError(AppExceptionCode.unknown, apiError);
          } catch (_) {}
        }
      }
    }
    return null;
  }

  /// Extracts a clean, human-readable error message from any error or exception,
  /// resolving DioException, AppException, API validation details, and general errors.
  static String extractMessage(Object? error, {String fallback = 'Operation failed. Please try again.'}) {
    if (error == null) return fallback;

    final appEx = AppException.from(error);
    if (appEx != null) {
      final msg = appEx.userMessage;
      if (msg.isNotEmpty) return msg;
    }

    if (error is DioException) {
      final response = error.response;
      if (response?.data is Map) {
        final data = response!.data as Map;
        if (data['error'] is Map) {
          final errMap = data['error'] as Map;
          if (errMap['details'] is Map) {
            final details = errMap['details'] as Map;
            final msgs = <String>[];
            for (final v in details.values) {
              if (v is List) {
                msgs.addAll(v.map((e) => e.toString().trim()).where((s) => s.isNotEmpty));
              } else if (v != null && v.toString().trim().isNotEmpty) {
                msgs.add(v.toString().trim());
              }
            }
            if (msgs.isNotEmpty) return msgs.join('\n');
          }
          if (errMap['message'] != null && errMap['message'].toString().trim().isNotEmpty) {
            return errMap['message'].toString().trim();
          }
        }
        if (data['message'] != null && data['message'].toString().trim().isNotEmpty) {
          return data['message'].toString().trim();
        }
      }

      final errorObj = error.error;
      if (errorObj != null && errorObj is! DioException) {
        final str = errorObj.toString();
        if (str.isNotEmpty && !str.startsWith('DioException')) {
          return str;
        }
      }

      return error.message ?? fallback;
    }

    if (error is Exception) {
      final str = error.toString();
      return str.startsWith('Exception: ') ? str.substring(11) : str;
    }

    return error.toString();
  }

  factory AppException.fromApiError(
    AppExceptionCode code,
    ApiError error, {
    int? retryAfterSeconds,
  }) {
    Map<String, List<String>>? fieldErrors;
    final details = error.details;
    if (details != null) {
      fieldErrors = <String, List<String>>{};
      for (final entry in details.entries) {
        final value = entry.value;
        if (value is List) {
          fieldErrors[entry.key] = value.map((e) => e.toString()).toList();
        } else if (value != null) {
          fieldErrors[entry.key] = <String>[value.toString()];
        }
      }
    }

    String resolvedMessage = error.message;
    if (fieldErrors != null && fieldErrors.isNotEmpty) {
      final messages = <String>[];
      for (final msgs in fieldErrors.values) {
        for (final m in msgs) {
          final trimmed = m.trim();
          if (trimmed.isNotEmpty && !messages.contains(trimmed)) {
            messages.add(trimmed);
          }
        }
      }
      if (messages.isNotEmpty) {
        resolvedMessage = messages.join('\n');
      }
    }

    return AppException(
      code: code,
      message: resolvedMessage,
      apiError: error,
      retryAfterSeconds: retryAfterSeconds,
      fieldErrors: fieldErrors,
    );
  }

  @override
  String toString() => userMessage;
}
