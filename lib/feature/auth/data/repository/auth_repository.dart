import 'dart:async';

import 'package:self/core/errors/app_exception.dart';
import 'package:self/core/errors/failures.dart';
import 'package:self/core/errors/network_executor.dart';
import 'package:self/feature/auth/data/datasource/auth_local_data_source.dart';
import 'package:self/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:self/feature/auth/data/models/login_request_model.dart';
import 'package:self/feature/auth/data/models/user_model.dart';

abstract interface class AuthRepository {
  Future<UserModel?> login(LoginRequestModel request);

  Future<void> logout();

  Future<bool> hasSession();

  Future<void> validateSession();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<UserModel?> login(LoginRequestModel request) async {
    final user = await NetworkExecutor.execute(
      () => _remoteDataSource.login(request),
    );

    if (user.accessToken == null || user.refreshToken == null) return null;

    await _localDataSource.saveAccessToken(user.accessToken!);
    await _localDataSource.saveRefreshToken(user.refreshToken!);

    return user;
  }

  @override
  Future<void> logout() async {
    await NetworkExecutor.execute(() => _remoteDataSource.logout());

    //await _remoteDataSource.logout();
    //await _localDataSource.clearToken();
  }

  @override
  Future<bool> hasSession() async {
    final refreshToken = await _localDataSource.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Future<void> validateSession() async {
    final refreshToken = await _localDataSource.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      throw AppException(const UnAuthorizedFailure());
    }

    final newToken = await NetworkExecutor.execute(
      () => _remoteDataSource.refreshToken(refreshToken),
    );

    await _localDataSource.saveAccessToken(newToken.accessToken);
    await _localDataSource.saveRefreshToken(newToken.refreshToken);
  }
}
