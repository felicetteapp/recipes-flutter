import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FRSecureStorage {
  FRSecureStorage._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  static Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  static Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }
}
