import 'dart:core';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  // Access Token 저장
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // 로그인한 선생님의 ID 저장
  static Future<void> saveTeacherId(int teacherId) async {
    await _storage.write(key: 'teacher_id', value: teacherId.toString());
  }

  // Access Token 읽기
  static Future<String?> readToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // 로그인한 선생님의 ID 읽기
  static Future<int?> readTeacherId() async {
    String? id = await _storage.read(key: 'teacher_id');
    return id != null ? int.parse(id) : null;
  }

  // Access Token & teacherId 삭제 (로그아웃 시 사용)
  static Future<void> deleteAuthData() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'teacher_id');
  }
}