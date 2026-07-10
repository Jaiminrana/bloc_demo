import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<Response> post(String path, {Object? data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {Object? data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> get(String path, {Options? options}) {
    return _dio.get(path, options: options);
  }
}
