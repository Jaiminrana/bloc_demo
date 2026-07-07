import 'package:dio/dio.dart';
import 'package:self/core/network/api_client.dart';
import 'package:self/feature/auth/data/models/login_request_model.dart';
import 'package:self/feature/auth/data/models/refresh_response_model.dart';
import 'package:self/feature/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> login(LoginRequestModel request);

  Future<void> logout();

  Future<RefreshResponseModel> refreshToken(String refreshToken);

  Future<UserModel> getCurrentUser(String accessToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserModel> login(LoginRequestModel request) async {
    final response = await _apiClient.post(
      '/auth/login',
      data: request.toJson(),
    );

    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<RefreshResponseModel> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken, 'expiresInMins': 30},
    );

    return RefreshResponseModel.fromJson(response.data);
  }

  @override
  Future<UserModel> getCurrentUser(String accessToken) async {
    final response = await _apiClient.get(
      '/user/me',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    return UserModel.fromJson(response.data);
  }
}
