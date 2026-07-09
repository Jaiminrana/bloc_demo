import 'failure.dart';
import 'failures.dart';

class FailureMessageMapper {
  const FailureMessageMapper._();

  static String map(Failure failure) {
    return switch (failure) {
      NoInternetFailure() => 'Please check your internet connection.',

      TimeoutFailure() => 'The request timed out. Please try again.',

      RequestCancelledFailure() => 'Request was cancelled.',

      UnAuthorizedFailure() => 'Session expired. Please login again.',

      ForbiddenFailure() => 'You do not have permission.',

      NotFoundFailure() => 'Requested resource not found.',

      BadRequestFailure() => 'Invalid request.',

      ServerFailure() => 'Server is unavailable.',

      _ => 'Something went wrong.',
    };
  }
}
