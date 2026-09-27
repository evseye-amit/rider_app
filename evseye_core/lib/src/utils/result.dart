import '../l10n/active_locale.dart';

sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok<T>;
  const factory Result.err(Failure failure) = Err<T>;

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  T? get valueOrNull => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Ok<T>() => null,
    Err<T>(:final failure) => failure,
  };

  R fold<R>(R Function(Failure failure) onError, R Function(T value) onSuccess) => switch (this) {
    Ok<T>(:final value) => onSuccess(value),
    Err<T>(:final failure) => onError(failure),
  };

  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Ok<T>(:final value) => Result<R>.ok(transform(value)),
    Err<T>(:final failure) => Result<R>.err(failure),
  };

  T getOrThrow() => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>(:final failure) => throw failure,
  };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}

sealed class Failure implements Exception {
  const Failure([this._message]);

  final String? _message;

  /// Message shown to the user, resolved in the active locale.
  String get message => _message ?? defaultMessage;

  String get defaultMessage;

  String get code;

  @override
  String toString() => '$runtimeType($code): $message';
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super._message]);

  @override
  String get defaultMessage => ActiveLocale.strings.commonNoInternetConnection;

  @override
  String get code => 'network';
}

final class ServerFailure extends Failure {
  const ServerFailure([super._message, this.status]);

  @override
  String get defaultMessage => ActiveLocale.strings.commonSomethingWentWrongPleaseTry;

  final int? status;

  @override
  String get code => status == null ? 'server' : 'server_$status';
}

final class AuthFailure extends Failure {
  const AuthFailure([super._message]);

  @override
  String get defaultMessage => ActiveLocale.strings.commonSessionHasExpiredPleaseSign;

  @override
  String get code => 'auth';
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super._message, {this.fieldErrors = const {}});

  @override
  String get defaultMessage => ActiveLocale.strings.hubSomethingWentWrong;

  final Map<String, String> fieldErrors;

  @override
  String get code => 'validation';
}

final class CacheFailure extends Failure {
  const CacheFailure([super._message]);

  @override
  String get defaultMessage => ActiveLocale.strings.commonCouldNotReadLocalData;

  @override
  String get code => 'cache';
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super._message]);

  @override
  String get defaultMessage => ActiveLocale.strings.commonNotFound;

  @override
  String get code => 'not_found';
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super._message]);

  @override
  String get defaultMessage => ActiveLocale.strings.commonAccountCannotDo;

  @override
  String get code => 'forbidden';
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super._message]);

  @override
  String get defaultMessage => ActiveLocale.strings.commonSignContinue;

  @override
  String get code => 'unauthorized';
}

final class RateLimitFailure extends Failure {
  const RateLimitFailure([super._message]);

  @override
  String get defaultMessage => ActiveLocale.strings.commonTooManyAttemptsWaitMoment;

  @override
  String get code => 'rate_limit';
}

abstract class UseCase<T, P> {
  const UseCase();

  Future<Result<T>> call(P params);
}

class NoParams {
  const NoParams();
}
