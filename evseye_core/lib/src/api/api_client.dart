import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../l10n/l10n.dart';
import '../utils/result.dart';
import 'api_env.dart';
import 'token_store.dart';

class ApiClient {
  ApiClient({required TokenStore tokens, Dio? dio, String? baseUrl, bool? logRequests})
    : _tokens = tokens,
      _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl ?? ApiEnv.baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 20),
              sendTimeout: const Duration(seconds: 20),

              validateStatus: (_) => true,
            ),
          ) {
    if (logRequests ?? kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          request: true,

          requestHeader: false,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: false,
          maxWidth: 120,

          filter: (options, args) => !_carriesCredentials(options.path),
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final String? token = _tokens.accessToken;
          if (token != null && token.isNotEmpty && options.extra['skipAuth'] != true) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Accept-Language'] = ActiveLocale.languageTag;
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  final TokenStore _tokens;

  void Function()? onSessionExpired;

  Future<bool>? _refreshing;

  Dio get raw => _dio;

  static bool _carriesCredentials(String path) => path.endsWith('/auth/otp/verify') || path.endsWith('/auth/refresh');

  Future<Result<T>> get<T>(String path, {Map<String, dynamic>? query, T Function(dynamic data)? parse}) =>
      _send<T>('GET', path, query: query, parse: parse);

  Future<Result<T>> post<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    T Function(dynamic data)? parse,
    bool skipAuth = false,
  }) => _send<T>('POST', path, body: body, query: query, parse: parse, skipAuth: skipAuth);

  Future<Result<T>> patch<T>(String path, {Object? body, T Function(dynamic data)? parse}) =>
      _send<T>('PATCH', path, body: body, parse: parse);

  Future<Result<T>> put<T>(String path, {Object? body, T Function(dynamic data)? parse}) =>
      _send<T>('PUT', path, body: body, parse: parse);

  Future<Result<T>> delete<T>(String path, {T Function(dynamic data)? parse}) => _send<T>('DELETE', path, parse: parse);

  Future<Result<T>> _send<T>(
    String method,
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    T Function(dynamic data)? parse,
    bool skipAuth = false,
    bool isRetry = false,
  }) async {
    try {
      final Response<dynamic> res = await _dio.request<dynamic>(
        path,
        data: body,
        queryParameters: query,
        options: Options(
          method: method,
          extra: {'skipAuth': skipAuth},

          contentType: body == null ? null : Headers.jsonContentType,
        ),
      );

      if (res.statusCode == 401 && !skipAuth && !isRetry && _tokens.hasSession) {
        final bool refreshed = await _refreshOnce();
        if (refreshed) {
          return await _send<T>(method, path, body: body, query: query, parse: parse, isRetry: true);
        }
        onSessionExpired?.call();
        return Result.err(UnauthorizedFailure(ActiveLocale.strings.errorSessionHasExpiredSignAgain));
      }

      final int status = res.statusCode ?? 0;
      if (status >= 200 && status < 300) {
        final dynamic payload = res.data is Map && (res.data as Map).containsKey('data')
            ? (res.data as Map)['data']
            : res.data;
        return Result.ok(parse == null ? payload as T : parse(payload));
      }

      return Result.err(_failureFor(status, res.data));
    } on DioException catch (e) {
      return Result.err(_failureForException(e));
    } on Object catch (e) {
      return Result.err(ServerFailure('Unexpected error. ($e)'));
    }
  }

  Future<bool> _refreshOnce() {
    return _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
  }

  Future<bool> _doRefresh() async {
    final String? refresh = _tokens.refreshToken;
    if (refresh == null || refresh.isEmpty) return false;
    try {
      final Response<dynamic> res = await _dio.post<dynamic>(
        '/auth/refresh',
        data: {'refreshToken': refresh},
        options: Options(extra: {'skipAuth': true}),
      );
      final int status = res.statusCode ?? 0;
      if (status < 200 || status >= 300) return false;
      final Map<String, dynamic> data = Map<String, dynamic>.from((res.data as Map)['data'] as Map);
      await _tokens.save(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String? ?? refresh,
      );
      return true;
    } on Object {
      return false;
    }
  }

  Failure _failureFor(int status, dynamic body) {
    String? message;
    if (body is Map && body['error'] is Map) {
      message = (body['error'] as Map)['message']?.toString();
    }
    return switch (status) {
      400 || 422 => ValidationFailure(message ?? ActiveLocale.strings.errorDidNotLookRight),
      401 => UnauthorizedFailure(message ?? ActiveLocale.strings.commonSignContinue),

      403 => ForbiddenFailure(message ?? ActiveLocale.strings.commonAccountCannotDo),
      404 => NotFoundFailure(message ?? ActiveLocale.strings.commonNotFound),
      429 => RateLimitFailure(message ?? ActiveLocale.strings.commonTooManyAttemptsWaitMoment),
      _ => ServerFailure(message ?? ActiveLocale.strings.commonSomethingWentWrongPleaseTry, status),
    };
  }

  Failure _failureForException(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => NetworkFailure(ActiveLocale.strings.errorServerTookTooLongAnswer),
      DioExceptionType.connectionError => NetworkFailure(ActiveLocale.strings.errorCouldNotReachServerCheck),
      _ => ServerFailure(e.message ?? ActiveLocale.strings.commonSomethingWentWrongPleaseTry),
    };
  }
}
