import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:self/core/network/connectivity/connectivity_service.dart';
import 'package:self/core/network/interceptors/auth_interceptor.dart';
import 'package:self/core/network/interceptors/connectivity_interceptor.dart';
import 'package:self/core/network/interceptors/logger_interceptor.dart';
import 'package:self/feature/auth/data/datasource/auth_local_data_source.dart';

class DioFactory {
  DioFactory._();

  static BaseOptions _baseOptions() {
    const duration30Sec = Duration(seconds: 30);

    return BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: duration30Sec,
      receiveTimeout: duration30Sec,
      sendTimeout: duration30Sec,
    );
  }

  static Dio createMainDio({
    required AuthLocalDataSource authLocalDataSource,
    required ConnectivityService connectivityService,
  }) {
    final dio = Dio(_baseOptions());
    final refreshDio = createRefreshDio();

    dio.interceptors.addAll([
      ConnectivityInterceptor(connectivityService),
      AuthInterceptor(authLocalDataSource, refreshDio),
    ]);

    _addLogger(dio);
    return dio;
  }

  static Dio createRefreshDio() {
    final dio = Dio(_baseOptions());

    _addLogger(dio);

    return dio;
  }

  static Dio createPingDio() {
    final dio = Dio(_baseOptions());

    _addLogger(dio);

    return dio;
  }

  static void _addLogger(Dio dio) {
    if (kDebugMode) {
      dio.interceptors.add(LoggerInterceptor.create());
    }
  }
}
