import 'package:aimory_app/features/notices/mock/notice_mock_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/notice_model.dart';
import '../services/notice_service.dart';
import '../../../core/util/secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  // Mock Data로 먼저 테스트를 위한 작업

  bool useMockApi = true; // 실제 API 사용 여부 결정 (true: Mock, false: 실제 API)

  if (useMockApi) {
    // Mock Interceptor
    dio.interceptors.add(NoticeMockInterceptor());
  }

  return dio;
});

final noticeServiceProvider = Provider<NoticeService>((ref) {
  final dio = ref.read(dioProvider);
  return NoticeService(dio);
});

/// ✅ 공지사항 리스트를 관리하는 FutureProvider
final noticeListProvider = FutureProvider<List<NoticeModel>>((ref) async {
  final service = ref.read(noticeServiceProvider);
  final token = await SecureStorage.readToken();
  if (token == null) {
    throw Exception("토큰이 존재하지 않습니다.");
  }
  return service.getNotices("Bearer $token");
});

/// ✅ 공지사항 단일 조회 추가
final noticeDetailProvider = FutureProvider.family<NoticeModel, int>((ref, noticeId) async {
  final service = ref.read(noticeServiceProvider);
  final token = await SecureStorage.readToken();
  if (token == null) {
    throw Exception("토큰이 존재하지 않습니다.");
  }
  return service.getNoticeById("Bearer $token", noticeId);
});

