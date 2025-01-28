import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  // JWT 토큰 저장
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // JWT 토큰 읽기
  static Future<String?> readToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // JWT 토큰 삭제
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }
}