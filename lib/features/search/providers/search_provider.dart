import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/util/secure_storage.dart';
import '../models/search_model.dart'; // ✅ 모델 파일 하나로 합쳐진 것 적용
import '../services/search_service.dart';

// ✅ Dio Provider (토큰 자동 추가)
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  // 기본적으로 Authorization 헤더를 추가할 수도 있음
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await SecureStorage.readToken();// 🔽 토큰을 읽어옴
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
  ));

  return dio;
});

// ✅ SearchService Provider
final searchServiceProvider = Provider<SearchService>((ref) {
  final dio = ref.read(dioProvider);
  return SearchService(dio);
});

// ✅ 검색 API 호출 Provider
final searchProvider = FutureProvider.family<SearchResponse, String>((ref, query) async {
  final service = ref.read(searchServiceProvider);
  final token = await SecureStorage.readToken(); // ✅ 토큰 불러오기

  if (token == null) {
    throw Exception("🔴 인증 토큰이 없습니다! 로그인 후 다시 시도하세요.");
  }

  final request = SearchRequest(content: query);
  return service.search("Bearer $token", request);
});
