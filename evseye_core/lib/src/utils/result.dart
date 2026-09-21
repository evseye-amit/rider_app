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

  R fold<R>(R Function(Failure failure) onError, R Function(T value) onSuccess) =>
      switch (this) {
        Ok<T>(:final value) => onSuccess(value),
        Err<T>(:final failure) => onError(failure),
      };

  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        Ok<T>(:final value) => Result<R>.ok(transform(value)),
        Err<T>(:final failure) => Result<R>.err(failure),
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

sealed class Failure {
  const Failure(this.message);

  final String message;

  String get code;

  @override
  String toString() => '$runtimeType($code): $message';
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);

  @override
  String get code => 'network';
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again.', this.status]);

  final int? status;

  @override
  String get code => status == null ? 'server' : 'server_$status';
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Your session has expired. Please sign in again.']);

  @override
  String get code => 'auth';
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.fieldErrors = const {}});

  final Map<String, String> fieldErrors;

  @override
  String get code => 'validation';
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not read local data.']);

  @override
  String get code => 'cache';
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found.']);

  @override
  String get code => 'not_found';
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = 'Your account cannot do that.']);

  @override
  String get code => 'forbidden';
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Sign in to continue.']);

  @override
  String get code => 'unauthorized';
}

final class RateLimitFailure extends Failure {
  const RateLimitFailure([super.message = 'Too many attempts. Wait a moment.']);

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
