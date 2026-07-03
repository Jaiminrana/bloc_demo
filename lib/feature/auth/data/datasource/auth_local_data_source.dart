import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveAccessToken(String token);

  Future<void> saveRefreshToken(String token);

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _flutterSecuredStorage;

  AuthLocalDataSourceImpl(this._flutterSecuredStorage);

  @override
  Future<void> clearToken() {
    // TODO: implement clearToken
    throw UnimplementedError();
  }

  @override
  Future<String?> getAccessToken() {
    // TODO: implement getAccessToken
    throw UnimplementedError();
  }

  @override
  Future<String?> getRefreshToken() {
    // TODO: implement getRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<void> saveAccessToken(String token) {
    // TODO: implement saveAccessToken
    throw UnimplementedError();
  }

  @override
  Future<void> saveRefreshToken(String token) {
    // TODO: implement saveRefreshToken
    throw UnimplementedError();
  }
}
