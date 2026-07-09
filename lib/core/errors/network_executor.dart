import 'package:self/core/errors/app_exception.dart';
import 'package:self/core/errors/error_mapper.dart';

class NetworkExecutor {
  const NetworkExecutor._();

  static Future<T> execute<T>(Future<T> Function() request) async {
    try {
      return await request();
    } catch (e) {
      throw AppException(ErrorMapper.map(e));
    }
  }
}
