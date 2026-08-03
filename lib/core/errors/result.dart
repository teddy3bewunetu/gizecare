import 'package:gizecare/core/errors/failures.dart';

/// Functional result wrapper used by repositories and use cases.
///
/// Prefer returning [Result] over throwing across architectural boundaries.
sealed class Result<T> {
  const Result();

  /// Whether this instance represents success.
  bool get isSuccess => this is Success<T>;

  /// Whether this instance represents failure.
  bool get isFailure => this is Err<T>;

  /// Value when successful; throws if this is [Err].
  T get requireValue => switch (this) {
        Success(:final value) => value,
        Err(:final failure) =>
          throw StateError('Result failed: $failure'),
      };

  /// Failure when unsuccessful; throws if this is [Success].
  Failure get requireFailure => switch (this) {
        Err(:final failure) => failure,
        Success() => throw StateError('Result succeeded'),
      };

  /// Pattern-matches success and failure branches.
  R when<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      Success(:final value) => onSuccess(value),
      Err(:final failure) => onFailure(failure),
    };
  }
}

/// Successful [Result] carrying [value].
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

/// Failed [Result] carrying [failure].
final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
