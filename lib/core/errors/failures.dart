import 'package:self/core/errors/failure.dart';

/// Base class for all network related failures.
sealed class NetworkFailure extends Failure {}

/// No internet connection.
final class NoInternetFailure extends NetworkFailure {}

/// Connection timeout.
/// Request send timeout.
/// Response timeout.
final class  TimeoutFailure extends NetworkFailure {}

/// Request cancelled.
final class RequestCancelledFailure extends NetworkFailure {}

// HTTP 400
final class BadRequestFailure extends Failure {}

// HTTP 401
final class UnAuthorizedFailure extends Failure {
  const UnAuthorizedFailure();
}

//HTTP 403
final class ForbiddenFailure extends Failure {}

// HTTP 404
final class NotFoundFailure extends Failure {}

// HTTP 500+
final class ServerFailure extends Failure {}

// Unknow error
final class UnknownFailure extends Failure {}
