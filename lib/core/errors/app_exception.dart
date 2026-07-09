import 'package:self/core/errors/failure.dart';

/// Its only job is wrapping a Failure so we can throw it.
class AppException {
  final Failure failure;

  const AppException(this.failure);
}
