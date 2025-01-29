import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/notice_model.dart';
import '../services/notice_service.dart';
import '../../../core/util/secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
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

