import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  // ✅ JWT Access Token 저장
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // ✅ 로그인한 사용자의 역할(role) 저장
  static Future<void> saveUserRole(String role) async {
    await _storage.write(key: 'user_role', value: role);
  }

  // ✅ 로그인한 사용자의 Center ID 저장
  static Future<void> saveCenterId(int centerId) async {
    await _storage.write(key: 'center_id', value: centerId.toString());
  }

  // ✅ 로그인한 사용자의 Teacher ID 저장
  static Future<void> saveTeacherId(int teacherId) async {
    await _storage.write(key: 'teacher_id', value: teacherId.toString());
  }

  // ✅ JWT Access Token 읽기

  static Future<String?> readToken() async {
    final token = await _storage.read(key: "jwt_token");
    if (token == null) return null;

    // ✅ 토큰의 만료 시간 확인
    final payload = token.split('.')[1];
    final decoded = utf8.decode(base64Url.decode(base64Url.normalize(payload)));
    final exp = jsonDecode(decoded)["exp"];

    if (exp != null && DateTime.fromMillisecondsSinceEpoch(exp * 1000).isBefore(DateTime.now())) {
      print("❌ 토큰이 만료됨. 자동 로그아웃.");
      await deleteAuthData();
      return null;
    }

    return token;
  }

  // static Future<String?> readToken() async {
  //   return await _storage.read(key: 'jwt_token');
  // }

  // ✅ 역할(role) 읽기
  static Future<String?> readUserRole() async {
    return await _storage.read(key: 'user_role');
  }

  // ✅ Center ID 읽기
  static Future<int?> readCenterId() async {
    String? id = await _storage.read(key: 'center_id');
    return id != null ? int.parse(id) : null;
  }

  // ✅ Teacher ID 읽기
  static Future<int?> readTeacherId() async {
    String? id = await _storage.read(key: 'teacher_id');
    return id != null ? int.parse(id) : null;
  }

  // ✅ 모든 인증 정보 삭제 (로그아웃 시)
  static Future<void> deleteAuthData() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'user_role');
    await _storage.delete(key: 'center_id');
    await _storage.delete(key: 'teacher_id');
  }
}