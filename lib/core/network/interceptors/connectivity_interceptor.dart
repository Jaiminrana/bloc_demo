import 'package:dio/dio.dart';
import 'package:self/core/errors/app_exception.dart';
import 'package:self/core/errors/failures.dart';
import 'package:self/core/network/connectivity/connectivity_service.dart';

class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor(this._connectivityService);

  final ConnectivityService _connectivityService;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Skip connectivity check if requested
    final skipCheck = options.extra['skipConnectivityCheck'] as bool? ?? false;

    if (skipCheck) {
      handler.next(options);
      return;
    }

    if (!_connectivityService.isConnected) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: AppException(NoInternetFailure()),
          type: DioExceptionType.connectionError,
        ),
      );

      return;
    }

    handler.next(options);
  }
}
