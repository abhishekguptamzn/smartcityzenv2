import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../core/config/app_config.dart';
import '../../core/providers/locale_controller.dart';
import '../../core/services/incident_reporter.dart';
import '../models/api_error.dart';
import 'app_exception.dart';
import 'token_storage.dart';

part 'dio_client.g.dart';

final Logger _logger = Logger(printer: PrettyPrinter(methodCount: 0));
const Uuid _uuid = Uuid();

class _AuthHeaderInterceptor extends Interceptor {
  _AuthHeaderInterceptor(this._tokenStorage, this._localeCode);

  final TokenStorage _tokenStorage;
  final String Function() _localeCode;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    if (!kIsWeb) {
      options.headers['Accept-Encoding'] = 'gzip, deflate, br';
      options.headers['Connection'] = 'keep-alive';
    }
    options.headers['Accept-Language'] = _localeCode();
    options.headers['X-Request-Id'] = _uuid.v4();
    handler.next(options);
  }
}

/// Maps non-2xx responses and Dio-level failures (timeouts, connection
/// errors) into a typed [AppException]. Deliberately has no knowledge of
/// navigation/session state: on `authentication`/`accountBlocked`/
/// `accountInactive` it only throws — `authControllerProvider` is the layer
/// that watches for those and signs the user out, keeping this interceptor a
/// pure mapping stage with no side effects.
class _ErrorMappingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final path = err.requestOptions.path;
    // Prevent recursive incident reporting loops on the reporting endpoint itself
    if (!path.contains('/incidents')) {
      final statusCode = err.response?.statusCode ?? 500;
      if (statusCode >= 500 || err.response == null) {
        final sanitizedQueryParams = Map<String, dynamic>.from(
          err.requestOptions.queryParameters,
        )..removeWhere(
            (key, _) => _sensitiveBodyKeyPattern.hasMatch('"$key":'),
          );
        IncidentReporter.reportError(
          error: err,
          stackTrace: err.stackTrace,
          exceptionClass: 'DioException',
          message: 'API ${err.requestOptions.method} ${err.requestOptions.path} failed: ${err.message ?? err.error?.toString()}',
          url: err.requestOptions.path,
          method: err.requestOptions.method,
          code: statusCode,
          severity: statusCode >= 500 ? 'critical' : 'warning',
          payload: {
            'status_code': statusCode,
            'response_data': err.response?.data?.toString(),
            'query_params': sanitizedQueryParams,
          },
        );
      }
    }
    handler.next(_map(err));
  }

  DioException _map(DioException err) {
    final response = err.response;
    if (response == null) {
      final networkTypes = {
        DioExceptionType.connectionError,
        DioExceptionType.connectionTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.sendTimeout,
      };
      final code = networkTypes.contains(err.type)
          ? AppExceptionCode.network
          : AppExceptionCode.unknown;
      return err.copyWith(
        error: AppException(
          code: code,
          message: err.message ?? 'Network error',
        ),
      );
    }

    ApiError? apiError;
    final data = response.data;
    if (data is Map<String, dynamic> && data['error'] is Map) {
      try {
        apiError = ApiError.fromJson(
          Map<String, dynamic>.from(data['error'] as Map),
        );
      } catch (_) {
        apiError = null;
      }
    }

    apiError ??= ApiError(
      code: 'HTTP_ERROR',
      message: 'Request failed with status ${response.statusCode}',
    );

    int? retryAfterSeconds;
    final retryAfterHeader = response.headers.value('Retry-After');
    if (retryAfterHeader != null) {
      retryAfterSeconds = int.tryParse(retryAfterHeader);
    }

    final code = switch (apiError.code) {
      'VALIDATION_ERROR' => AppExceptionCode.validation,
      'AUTHENTICATION_ERROR' => AppExceptionCode.authentication,
      'AUTHORIZATION_ERROR' => AppExceptionCode.authorization,
      'ACCOUNT_BLOCKED' => AppExceptionCode.accountBlocked,
      'ACCOUNT_INACTIVE' => AppExceptionCode.accountInactive,
      'NOT_FOUND' => AppExceptionCode.notFound,
      'CONFLICT' => AppExceptionCode.conflict,
      'BAD_REQUEST' => AppExceptionCode.badRequest,
      'METHOD_NOT_ALLOWED' => AppExceptionCode.badRequest,
      'PAYLOAD_TOO_LARGE' => AppExceptionCode.badRequest,
      'TOO_MANY_REQUESTS' => AppExceptionCode.rateLimited,
      'INTERNAL_SERVER_ERROR' => AppExceptionCode.server,
      _ => AppExceptionCode.unknown,
    };

    return err.copyWith(
      error: AppException.fromApiError(
        code,
        apiError,
        retryAfterSeconds: retryAfterSeconds,
      ),
    );
  }
}

// Body values for these keys can appear in arbitrary JSON/form encodings
// that a regex can't safely scrub in place, so any log line naming one of
// them is dropped entirely rather than partially redacted.
final RegExp _sensitiveBodyKeyPattern = RegExp(
  r'"?(password|password_confirmation|current_password|new_password|'
  r'new_password_confirmation|access_token|id_token|reset_token|token)"?\s*:',
  caseSensitive: false,
);

PrettyDioLogger _buildLogger() {
  return PrettyDioLogger(
    requestHeader: false,
    requestBody: false,
    responseBody: false,
    responseHeader: false,
    compact: true,
    logPrint: (Object object) {
      final line = object.toString();
      if (_sensitiveBodyKeyPattern.hasMatch(line)) {
        return;
      }
      if (line.contains('Authorization')) {
        return;
      }
      _logger.d(line);
    },
  );
}

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final config = ref.watch(appConfigControllerProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: Duration(milliseconds: config.connectTimeoutMs),
      receiveTimeout: Duration(milliseconds: config.receiveTimeoutMs),
    ),
  );

  dio.interceptors.add(
    _AuthHeaderInterceptor(
      tokenStorage,
      () => ref.read(localeControllerProvider).languageCode,
    ),
  );

  if (!kIsWeb && config.enableRequestLogging) {
    dio.interceptors.add(_buildLogger());
  }

  dio.interceptors.add(_ErrorMappingInterceptor());

  return dio;
}

/// The health endpoint lives outside `/api/v1`, so it needs its own client
/// with the version segment stripped from the configured base URL.
@Riverpod(keepAlive: true)
Dio healthDio(Ref ref) {
  final config = ref.watch(appConfigControllerProvider);
  final unversioned = config.apiBaseUrl.replaceFirst(RegExp(r'/api/v1/?$'), '');
  return Dio(
    BaseOptions(
      baseUrl: unversioned,
      connectTimeout: Duration(milliseconds: config.connectTimeoutMs),
      receiveTimeout: Duration(milliseconds: config.receiveTimeoutMs),
    ),
  );
}
