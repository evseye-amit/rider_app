import 'dart:async';
import 'dart:convert';

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
    Map<String, String>? headers,
    T Function(dynamic data)? parse,
    bool skipAuth = false,
    bool refreshOnUnauthorized = true,
  }) => _send<T>(
    'POST',
    path,
    body: body,
    query: query,
    headers: headers,
    parse: parse,
    skipAuth: skipAuth,
    refreshOnUnauthorized: refreshOnUnauthorized,
  );

  Future<void> ensureFreshSession() async {
    final String? token = _tokens.accessToken;
    if (token == null || token.isEmpty) return;
    final DateTime? expiry = _expiryOf(token);
    if (expiry == null || expiry.difference(DateTime.now()) > const Duration(minutes: 1)) return;
    await _refreshOnce();
  }

  static DateTime? _expiryOf(String token) {
    final List<String> parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final Object? claims = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      final Object? exp = claims is Map ? claims['exp'] : null;
      return exp is num ? DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000) : null;
    } on Object {
      return null;
    }
  }

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
    Map<String, String>? headers,
    T Function(dynamic data)? parse,
    bool skipAuth = false,
    bool refreshOnUnauthorized = true,
    bool isRetry = false,
  }) async {
    try {
      final Response<dynamic> res = await _dio.request<dynamic>(
        path,
        data: body,
        queryParameters: query,
        options: Options(
          method: method,
          headers: headers,
          extra: {'skipAuth': skipAuth},

          contentType: body == null ? null : Headers.jsonContentType,
        ),
      );

      if (res.statusCode == 401 && !skipAuth && refreshOnUnauthorized && !isRetry && _tokens.hasSession) {
        final bool refreshed = await _refreshOnce();
        if (refreshed) {
          return await _send<T>(method, path, body: body, query: query, headers: headers, parse: parse, isRetry: true);
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
    String? serverCode;
    if (body is Map && body['error'] is Map) {
      final Map<dynamic, dynamic> error = body['error'] as Map;
      final String? code = error['code']?.toString();
      serverCode = code;
      final String? raw = error['message']?.toString();
      final bool rawIsCode = raw != null && RegExp(r'^[A-Z][A-Z0-9_]+$').hasMatch(raw);
      final String? effective = code == 'HTTP_ERROR' && rawIsCode ? raw : code;
      message = _messageForCode(effective) ?? (rawIsCode || raw == 'Internal server error' ? null : raw);
    }
    return switch (status) {
      400 || 422 => ValidationFailure(message ?? ActiveLocale.strings.errorDidNotLookRight, serverCode: serverCode),
      401 => UnauthorizedFailure(message ?? ActiveLocale.strings.commonSignContinue, serverCode),

      403 => ForbiddenFailure(message ?? ActiveLocale.strings.commonAccountCannotDo, serverCode),
      404 => NotFoundFailure(message ?? ActiveLocale.strings.commonNotFound, serverCode),
      429 => RateLimitFailure(message ?? ActiveLocale.strings.commonTooManyAttemptsWaitMoment, serverCode),
      _ => ServerFailure(message ?? ActiveLocale.strings.commonSomethingWentWrongPleaseTry, status, serverCode),
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

String? _messageForCode(String? code) => switch (code) {
  'PENALTY_CATALOGUE_CHANGED' => ActiveLocale.strings.submissionPriceChanged,
  'EXCHANGE_DISABLED' => ActiveLocale.strings.exchangeErrorDisabled,
  'AGREEMENT_NOT_FOUND' => ActiveLocale.strings.exchangeErrorNoRental,
  'AGREEMENT_NOT_ACTIVE' => ActiveLocale.strings.exchangeErrorRentalInactive,
  'ACTIVE_ALLOCATION_REQUIRED' => ActiveLocale.strings.errorActiveScooterRequired,
  'MINIMUM_DAYS_NOT_MET' => ActiveLocale.strings.exchangeErrorTooSoon,
  'COLLECTION_RESTRICTION_ACTIVE' => ActiveLocale.strings.exchangeErrorDuesPending,
  'EXCHANGE_NOT_FOUND' => ActiveLocale.strings.exchangeErrorNotFound,
  'EXCHANGE_STATE_CHANGED' || 'EXCHANGE_STATE_INVALID' => ActiveLocale.strings.exchangeErrorChanged,
  'EXCHANGE_VERSION_STALE' => ActiveLocale.strings.exchangeErrorStale,
  'EXCHANGE_OFFER_EXPIRED' => ActiveLocale.strings.exchangeOfferExpiredMessage,
  'EXCHANGE_OFFER_NOT_PRESENTED' => ActiveLocale.strings.exchangeErrorOfferClosed,
  'EXCHANGE_OFFER_INTEGRITY_FAILED' => ActiveLocale.strings.exchangeErrorOfferInvalid,
  'EXCHANGE_CANCELLATION_REQUIRES_COMPENSATION' => ActiveLocale.strings.exchangeErrorCannotCancel,
  'INVALID_EXCHANGE_INPUT' => ActiveLocale.strings.errorDidNotLookRight,
  'OLD_RETURN_ASSESSMENT_REQUIRED' => ActiveLocale.strings.exchangeErrorReturnFirst,
  'OLD_RETURN_ALREADY_COMPLETED' => ActiveLocale.strings.exchangeErrorAlreadyReturned,
  'OLD_RETURN_NOT_COMPLETED' => ActiveLocale.strings.exchangeErrorReturnUnfinished,
  'RETURN_INSPECTION_NOT_COMPLETED' => ActiveLocale.strings.exchangeErrorInspectionUnfinished,
  'REPLACEMENT_NOT_AVAILABLE' => ActiveLocale.strings.exchangeErrorScooterUnavailable,
  'REPLACEMENT_RESERVED' => ActiveLocale.strings.exchangeErrorScooterReserved,
  'SAME_VEHICLE' => ActiveLocale.strings.exchangeErrorSameScooter,
  'REPLACEMENT_HOLD_EXPIRED' => ActiveLocale.strings.exchangeErrorHoldExpired,
  'RIDER_TERMS_NOT_CONFIGURED' => ActiveLocale.strings.exchangeErrorNoTerms,
  'RIDER_SECURITY_CHANGE_REQUIRES_SEPARATE_AMENDMENT' => ActiveLocale.strings.exchangeErrorSecurityChange,
  'RIDER_SECURITY_REPLENISHMENT_REQUIRED' => ActiveLocale.strings.exchangeErrorSecurityTopUp,
  'EXCHANGE_DEPOSIT_OUTSTANDING' => ActiveLocale.strings.exchangeErrorDepositsUnsettled,
  'NEW_HANDOVER_NOT_COMPLETED' => ActiveLocale.strings.exchangeErrorHandoverUnfinished,
  'OLD_RENTAL_PAYMENT_NO_LONGER_VERIFIED' ||
  'EXCHANGE_PRORATION_STALE' ||
  'EXCHANGE_BILLING_CYCLE_STALE' => ActiveLocale.strings.exchangeErrorBillingChanged,
  'COMMERCIAL_VERSION_MISSING' ||
  'REPLACEMENT_SELECTION_MISSING' ||
  'EXCHANGE_AMENDMENT_MISSING' ||
  'EXCHANGE_OFFER_MISSING' => ActiveLocale.strings.exchangeErrorRecordsMissing,
  'VEHICLE_NOT_AVAILABLE' => ActiveLocale.strings.exchangeErrorScooterUnavailable,
  'BATTERY_PLAN_NOT_AVAILABLE' => ActiveLocale.strings.exchangeErrorBatteryPlan,
  'RIDER_NOT_ELIGIBLE' => ActiveLocale.strings.exchangeErrorNotEligible,
  'RATE_CARD_NOT_FOUND' ||
  'RATE_CARD_VERSION_NOT_FOUND' ||
  'RATE_CARD_AMBIGUOUS' ||
  'RATE_CARD_VERSION_AMBIGUOUS' ||
  'BASE_RENTAL_NOT_CONFIGURED' ||
  'PRICING_RULE_CONFLICT' ||
  'COMMERCIAL_CONFIGURATION_INVALID' ||
  'INVALID_COMMERCIAL_PREVIEW_INPUT' => ActiveLocale.strings.exchangeErrorPricingSetup,
  'RIDER_NOT_FOUND' => ActiveLocale.strings.errorRiderProfileMissing,
  'VEHICLE_NOT_FOUND' || 'HUB_NOT_FOUND' || 'CLIENT_NOT_FOUND' => ActiveLocale.strings.commonNotFound,
  'AGREEMENT_NOT_TERMINABLE' => ActiveLocale.strings.returnsErrorNotTerminable,
  'RETURN_ALREADY_REQUESTED' => ActiveLocale.strings.returnsErrorAlreadyRequested,
  'RETURN_NOT_CANCELLABLE' => ActiveLocale.strings.returnsErrorNotCancellable,
  'RETURN_ALREADY_RECEIVED' => ActiveLocale.strings.returnsErrorAlreadyReceived,
  'RETURN_NOT_RECEIVABLE' => ActiveLocale.strings.returnsErrorNotReceivable,
  'RETURN_BEFORE_AGREEMENT' => ActiveLocale.strings.returnsErrorBeforeAgreement,
  'PENALTY_CASE_IMMUTABLE' => ActiveLocale.strings.returnsErrorPenaltiesLocked,
  'PENALTY_CASE_NOT_SUBMITTABLE' => ActiveLocale.strings.returnsErrorNotSubmittable,
  'PENALTY_REVISION_REQUIRES_REPLACEMENT' => ActiveLocale.strings.returnsErrorRevisePenalties,
  'PENALTY_NOT_DISPUTABLE' => ActiveLocale.strings.returnsErrorNotDisputable,
  'PENALTY_OVERRIDE_NOT_ALLOWED' => ActiveLocale.strings.returnsErrorOverrideNotAllowed,
  'PENALTY_MANAGER_APPROVAL_REQUIRED' => ActiveLocale.strings.returnsErrorSubmitFirst,
  'PENALTY_STATE_CHANGED' ||
  'PENALTY_REVISION_NOT_SUBMITTED' ||
  'PENALTY_REVISION_CHANGED' => ActiveLocale.strings.returnsErrorStateChanged,
  'VEHICLE_RETURN_REQUIRED' => ActiveLocale.strings.returnsErrorReceiveFirst,
  'VEHICLE_RETURN_INSPECTION_REQUIRED' => ActiveLocale.strings.returnsErrorInspectFirst,
  'RIDER_APPROVAL_NOT_PENDING' => ActiveLocale.strings.returnsErrorApprovalNotPending,
  'SAFE_FOR_REUSE_REQUIRED' => ActiveLocale.strings.inspectionErrorSafeForReuse,
  'UNSAFE_REASON_REQUIRED' => ActiveLocale.strings.inspectionErrorUnsafeReason,
  'REFERRAL_CODE_INVALID' => ActiveLocale.strings.onboardingReferralNotFound,
  'REFERRAL_CODE_EXPIRED' => ActiveLocale.strings.referErrorCodeExpired,
  'REFERRAL_SELF_NOT_ALLOWED' => ActiveLocale.strings.referErrorSelf,
  'REFERRAL_ALREADY_ATTRIBUTED' => ActiveLocale.strings.referErrorAlreadyLinked,
  'REFERRAL_CAMPAIGN_INACTIVE' => ActiveLocale.strings.referErrorCampaignInactive,
  'REFERRAL_LIMIT_EXCEEDED' => ActiveLocale.strings.referErrorLimit,
  'REFERRAL_NOT_ELIGIBLE' => ActiveLocale.strings.referErrorNotEligible,
  'REFERRAL_FEATURE_NOT_ENABLED' => ActiveLocale.strings.referErrorNotEnabled,
  'REFERRAL_NOT_FOUND' => ActiveLocale.strings.referErrorNotFound,
  'RENTAL_PLAN_REQUIRED' => ActiveLocale.strings.planErrorRequired,
  'ALLOCATION_TEAM_LEAD_REQUIRED' => ActiveLocale.strings.allocationTeamLeadRequired,
  'RENTAL_AGREEMENT_NOT_READY' => ActiveLocale.strings.planErrorAgreementNotReady,
  'RENTAL_AGREEMENT_NOT_ACTIVE' => ActiveLocale.strings.planErrorAgreementNotActive,
  'ALLOCATION_AGREEMENT_MISMATCH' => ActiveLocale.strings.planErrorAgreementMismatch,
  'PLAN_SELECTION_CLOSED' => ActiveLocale.strings.planErrorSelectionClosed,
  'PLAN_SELECTION_CHANGED' => ActiveLocale.strings.planErrorSelectionChanged,
  'EXCHANGE_PLAN_ALREADY_SELECTED' => ActiveLocale.strings.planErrorExchangePlan,
  'COMMERCIAL_OFFER_NOT_ACCEPTABLE' || 'COMMERCIAL_OFFER_EXPIRED' => ActiveLocale.strings.planErrorOfferNotValid,
  'TERMS_VERSION_MISMATCH' => ActiveLocale.strings.planErrorTermsChanged,
  'FLEET_REQUEST_REQUIRED' => ActiveLocale.strings.planErrorFleetRequestRequired,
  'PAYMENT_REFERENCE_REQUIRED' => ActiveLocale.strings.planErrorPaymentReferenceRequired,
  'DEPLOYMENT_PAYMENT_STALE' => ActiveLocale.strings.planErrorPaymentStale,
  'VEHICLE_DEPOSIT_NOT_CONFIGURED' => ActiveLocale.strings.planErrorDepositNotConfigured,
  'ONBOARDING_FEE_NOT_CONFIGURED' => ActiveLocale.strings.planErrorFeeNotConfigured,
  'WALLET_NOT_FOUND' => ActiveLocale.strings.walletErrorNotFound,
  'RECEIPT_NOT_FOUND' => ActiveLocale.strings.walletErrorReceiptNotFound,
  'TRANSACTION_NOT_FOUND' => ActiveLocale.strings.walletErrorTransactionNotFound,
  'SECURITY_DEPOSIT_NOT_FOUND' => ActiveLocale.strings.walletErrorDepositNotFound,
  'INVALID_STATEMENT_PERIOD' => ActiveLocale.strings.walletErrorStatementPeriod,
  'INVALID_PAGINATION' => ActiveLocale.strings.errorDidNotLookRight,
  _ => null,
};
