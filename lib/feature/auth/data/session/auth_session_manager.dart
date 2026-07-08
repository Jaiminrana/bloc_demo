import 'package:self/feature/auth/data/datasource/auth_local_data_source.dart';
import 'package:self/feature/auth/data/datasource/auth_remote_datasource.dart';

class AuthSessionManager {
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthSessionManager(this._authRemoteDataSource, this._authLocalDataSource);

  Future<String?> getAccessToken() async {
    return await _authLocalDataSource.getAccessToken();
  }

  Future<void> clearSession() async {
    return await _authLocalDataSource.clearToken();
  }

  Future<String?> refreshSession() async {
    final refreshToken = await _authLocalDataSource.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    final newTokens = await _authRemoteDataSource.refreshToken(refreshToken);

    await _authLocalDataSource.saveAccessToken(newTokens.accessToken);
    await _authLocalDataSource.saveRefreshToken(newTokens.refreshToken);

    return newTokens.accessToken;
  }
}
