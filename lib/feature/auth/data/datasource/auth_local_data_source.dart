import '../../../../core/storage/secure_storage_service.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveAccessToken(String token);

  Future<void> saveRefreshToken(String token);

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  final SecureStorageService _storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  @override
  Future<void> saveAccessToken(String token) {
    return _storage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<void> saveRefreshToken(String token) {
    return _storage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<String?> getAccessToken() {
    return _storage.read(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() {
    return _storage.read(_refreshTokenKey);
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(_accessTokenKey);
    await _storage.delete(_refreshTokenKey);
  }
}
