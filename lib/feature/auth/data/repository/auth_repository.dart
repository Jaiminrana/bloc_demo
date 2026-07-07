import 'package:self/feature/auth/data/datasource/auth_local_data_source.dart';
import 'package:self/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:self/feature/auth/data/models/login_request_model.dart';
import 'package:self/feature/auth/data/models/user_model.dart';

abstract interface class AuthRepository {
  Future<UserModel?> login(LoginRequestModel request);

  Future<UserModel?> checkAuthStatus();

  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<UserModel?> login(LoginRequestModel request) async {
    final user = await _remoteDataSource.login(request);

    if (user.accessToken == null || user.refreshToken == null) return null;

    await _localDataSource.saveAccessToken(user.accessToken!);
    await _localDataSource.saveRefreshToken(user.refreshToken!);

    return user;
  }

  @override
  Future<UserModel?> checkAuthStatus() async {
    final refreshToken = await _localDataSource.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      final newToken = await _remoteDataSource.refreshToken(refreshToken);

      await _localDataSource.saveAccessToken(newToken.accessToken);
      await _localDataSource.saveRefreshToken(newToken.refreshToken);

      final user = await _remoteDataSource.getCurrentUser(newToken.accessToken);
      return user;
    } catch (_) {
      _localDataSource.clearToken();
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearToken();
  }
}
