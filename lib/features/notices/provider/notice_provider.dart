import 'package:aimory_app/features/notices/mock/notice_mock_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/notice_model.dart';
import '../services/notice_service.dart';
import '../../../core/util/secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com", // 실제 API URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(LogInterceptor(responseBody: true)); // 디버깅을 위해 로그 추가

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

  return await service.getNotices("Bearer $token"); // ✅ 변경된 API 사용
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

