import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _flutterSecuredStorage;

  SecureStorageService() : _flutterSecuredStorage = FlutterSecureStorage();

  Future<void> write({required String key, required String value}) async {
    await _flutterSecuredStorage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return _flutterSecuredStorage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _flutterSecuredStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _flutterSecuredStorage.deleteAll();
  }

  Future<bool> contains(String key) async {
    return await _flutterSecuredStorage.containsKey(key: key);
  }
}
