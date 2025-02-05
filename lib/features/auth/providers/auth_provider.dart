import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/signup_request.dart';
import '../services/auth_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  return dio;
});

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.read(dioProvider);
  return AuthService(dio);
});

final registerProvider = FutureProvider.family.autoDispose<void, SignupRequest>((ref, request) async {
  final authService = ref.read(authServiceProvider);
  await authService.signup(request);
});


// ✅ 인증 토큰을 관리하는 StateProvider
final authTokenProvider = StateProvider<String?>((ref) => null);

// ✅ SharedPreferences에 토큰 저장
Future<void> saveTokenToStorage(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("auth_token", token);
}

// ✅ 앱 실행 시 저장된 토큰 불러오기
final storedTokenProvider = FutureProvider<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("auth_token");
  if (token != null) {
    ref.read(authTokenProvider.notifier).state = token;
    debugPrint("✅ 앱 실행 후 저장된 토큰 불러옴: $token");
  }
  return token;
});
