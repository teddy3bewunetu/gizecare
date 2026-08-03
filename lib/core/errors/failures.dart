import 'package:equatable/equatable.dart';

/// Base type for domain and infrastructure failures.
///
/// UI layers map [Failure] into user-visible messages; never throw raw
/// exceptions across feature boundaries.
sealed class Failure extends Equatable {
  const Failure(this.message, {this.cause});

  /// Human-readable description suitable for logs / UI mapping.
  final String message;

  /// Optional underlying error for diagnostics.
  final Object? cause;

  @override
  List<Object?> get props => [message, cause];
}

/// Persistence / Drift / filesystem failures.
final class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.cause});
}

/// Unexpected programming or platform errors.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.cause});
}

/// Validation / invariant failures from domain use cases.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.cause});
}

/// Platform service failures (idle, activity, screenshots, tray).
final class PlatformFailure extends Failure {
  const PlatformFailure(super.message, {super.cause});
}

/// HTTP / remote API failures.
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.cause, this.statusCode});

  final int? statusCode;
}
