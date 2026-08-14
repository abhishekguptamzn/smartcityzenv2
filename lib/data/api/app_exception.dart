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

  static AppException? from(Object? error) {
    if (error is AppException) return error;
    if (error is DioException && error.error is AppException) {
      return error.error as AppException;
    }
    return null;
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
    return AppException(
      code: code,
      message: error.message,
      apiError: error,
      retryAfterSeconds: retryAfterSeconds,
      fieldErrors: fieldErrors,
    );
  }

  @override
  String toString() => 'AppException(${code.name}): $message';
}
