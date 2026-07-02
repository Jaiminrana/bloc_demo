import 'package:dio/dio.dart';

class DioFactory {
  DioFactory._();

  static Dio create() {
    final duration30Sec = Duration(seconds: 30);
    return Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com',
        connectTimeout: duration30Sec,
        receiveTimeout: duration30Sec,
        sendTimeout: duration30Sec,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'appplication/json',
        },
      ),
    );
  }
}
