import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/teacher_model.dart';
import '../services/teacher_service.dart';
import '../../../core/util/secure_storage.dart';

// Dio 인스턴스 제공
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.interceptors.add(LogInterceptor(responseBody: true));
  return dio;
});

// TeacherService 인스턴스 제공
final teacherServiceProvider = Provider<TeacherService>((ref) {
  final dio = ref.read(dioProvider);
  return TeacherService(dio);
});

// 선생님 정보 조회 Provider
final teacherInfoProvider = FutureProvider<TeacherModel>((ref) async {
  final service = ref.read(teacherServiceProvider);
  final token = await SecureStorage.readToken();


  if (token == null) {
  debugPrint("🔴 [teacherInfoProvider] 로그인 토큰이 없습니다.");
  throw Exception("로그인이 필요합니다.");
  }

  debugPrint("🟡 [teacherInfoProvider] API 요청 시작: /teacher");

  try {
  final teacher = await service.fetchTeacherInfo("Bearer $token");
  debugPrint("🟢 [teacherInfoProvider] API 응답: $teacher");
  return teacher;
  } catch (e, stack) {
    debugPrint("❌ [teacherInfoProvider] API 요청 실패: $e");
  print(stack);
  throw Exception("API 요청 중 오류가 발생했습니다.");
}
});


// 선생님 정보 업데이트 Provider
final teacherUpdateProvider = FutureProvider.family<TeacherModel, Map<String, dynamic>>((ref, requestData) async {
  final service = ref.read(teacherServiceProvider);
  final token = await SecureStorage.readToken();
  if (token == null) throw Exception("로그인이 필요합니다.");

  return service.updateTeacherInfo(
    "Bearer $token",
    requestData["image"],
    requestData["classroomId"],
    requestData["oldPassword"],
    requestData["newPassword"],
  );
});