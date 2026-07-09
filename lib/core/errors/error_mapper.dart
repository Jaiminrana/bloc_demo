import 'package:dio/dio.dart';
import 'package:self/core/errors/failure.dart';

import 'failures.dart';

class ErrorMapper {
  const ErrorMapper._();

  static Failure map(Object error) {
    if (error is! DioException) {
      return UnknownFailure();
    }

    return switch (error.type) {
      DioExceptionType.connectionError => NoInternetFailure(),

      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => TimeoutFailure(),

      DioExceptionType.cancel => RequestCancelledFailure(),

      DioExceptionType.badResponse => _mapStatusCode(
        error.response?.statusCode,
      ),

      DioExceptionType.badCertificate ||
      DioExceptionType.unknown => UnknownFailure(),
    };
  }

  static Failure _mapStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return BadRequestFailure();

      case 401:
        return UnAuthorizedFailure();

      case 403:
        return ForbiddenFailure();

      case 404:
        return NotFoundFailure();

      case 500:
      case 501:
      case 502:
      case 503:
        return ServerFailure();

      default:
        return UnknownFailure();
    }
  }
}
