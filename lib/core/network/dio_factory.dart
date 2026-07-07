import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:self/core/network/interceptors/auth_interceptor.dart';
import 'package:self/core/network/interceptors/logger_interceptor.dart';
import 'package:self/feature/auth/data/datasource/auth_local_data_source.dart';

class DioFactory {
  DioFactory._();

  static Dio create(AuthLocalDataSource authLocalDataSource) {
    final duration30Sec = Duration(seconds: 30);
    final baseOptions = BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: duration30Sec,
      receiveTimeout: duration30Sec,
      sendTimeout: duration30Sec,
    );
    final dio = Dio(baseOptions);
    // Refresh Dio (no AuthInterceptor)
    final refreshDio = Dio(baseOptions);

    dio.interceptors.add(AuthInterceptor(authLocalDataSource, refreshDio));

    if (kDebugMode) {
      dio.interceptors.add(LoggerInterceptor.create());
      refreshDio.interceptors.add(LoggerInterceptor.create());
    }
    return dio;
  }
}
