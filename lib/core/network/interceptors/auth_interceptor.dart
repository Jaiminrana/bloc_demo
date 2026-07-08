import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:self/feature/auth/data/datasource/auth_local_data_source.dart';
import 'package:self/feature/auth/data/models/refresh_response_model.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource _localDataSource;
  final Dio _refreshDio;

  //shared Future for concurrent 401s from multiple APIs.
  Future<String?>? _tokenRefreshFuture;

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
    ///Suppose /auth/refresh returns 401.
    /// Your interceptor will intercept that request too.
    /// You don't want:
    /// 401
    /// ↓
    /// refresh
    /// ↓
    /// 401
    /// ↓
    /// refresh
    /// ↓
    /// 401
    /// Infinite loop.
    if (err.requestOptions.path == '/auth/refresh') {
      return handler.next(err);
    }

    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    debugPrint('================>>>401 Occurred!!!');

    final accessToken = await _getOrRefreshAccessToken();

    if (accessToken == null) {
      await _logout();
      return handler.next(err);
    }

    try {
      final retryResponse = await _retryRequest(
        err.requestOptions,
        accessToken,
      );
      return handler.resolve(retryResponse);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  Future<String?> _getOrRefreshAccessToken() async {
    if (_tokenRefreshFuture != null) {
      debugPrint('[AuthInterceptor] Waiting for ongoing token refresh');
      return _tokenRefreshFuture;
    }

    _tokenRefreshFuture = _refreshAccessToken();

    try {
      return await _tokenRefreshFuture;
    } finally {
      _tokenRefreshFuture = null;
    }
  }

  Future<String?> _refreshAccessToken() async {
    debugPrint('================>>>Refreshing access token...');
    final refreshToken = await _localDataSource.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      debugPrint('================>>>Refresh token not found, Refresh failed');
      return null;
    }

    try {
      final response = await _refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken, 'expiresInMins': 30},
      );

      final refreshResponse = RefreshResponseModel.fromJson(response.data);

      await _localDataSource.saveAccessToken(refreshResponse.accessToken);

      await _localDataSource.saveRefreshToken(refreshResponse.refreshToken);
      debugPrint('================>>>Refresh succeeded');
      return refreshResponse.accessToken;
    } catch (_) {
      debugPrint('================>>>Refresh failed');
      return null;
    }
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String accessToken,
  ) async {
    debugPrint(
      '[AuthInterceptor] Retrying ${requestOptions.method} ${requestOptions.path}',
    );

    requestOptions.headers['Authorization'] = 'Bearer $accessToken';

    return _refreshDio.fetch(requestOptions);
  }

  Future<void> _logout() async {
    await _localDataSource.clearToken();
  }
}
