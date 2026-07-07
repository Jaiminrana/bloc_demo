import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:self/feature/auth/data/datasource/auth_local_data_source.dart';
import 'package:self/feature/auth/data/models/refresh_response_model.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource _localDataSource;
  final Dio _refreshDio;

  AuthInterceptor(this._localDataSource, this._refreshDio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _localDataSource.getAccessToken();

    final path = options.path;

    if (path == '/auth/login' || path == '/auth/refresh') {
      return handler.next(options);
    }

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final refreshToken = await _localDataSource.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return handler.next(err);
    }

    debugPrint('401 Occurred!!! --> Refresh Token Found: $refreshToken');

    try {
      final response = await _refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken, 'expiresInMins': 30},
      );

      final refreshResponse = RefreshResponseModel.fromJson(response.data);

      await _localDataSource.saveAccessToken(refreshResponse.accessToken);

      await _localDataSource.saveRefreshToken(refreshResponse.refreshToken);

      final requestOptions = err.requestOptions;

      requestOptions.headers['Authorization'] =
          'Bearer ${refreshResponse.accessToken}';

      final retryResponse = await _refreshDio.fetch(requestOptions);

      return handler.resolve(retryResponse);
    } catch (_) {
      await _localDataSource.clearToken();
      return handler.next(err);
    }
  }
}
