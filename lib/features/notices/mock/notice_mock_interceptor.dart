import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class NoticeMockInterceptor extends Interceptor {
  static List<dynamic>? cachedData; // JSON 캐싱을 위한
  static const String mockToken = "mock_auth_token"; // 테스트용 토큰

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint("📡 [MOCK INTERCEPTOR] 요청 감지됨: ${options.method} ${options.path}");
    debugPrint("📡 [MOCK INTERCEPTOR] 요청 헤더: ${options.headers}");
    debugPrint("📡 [MOCK INTERCEPTOR] 요청 데이터: ${options.data}");

    if (cachedData == null) {
      try {
        final jsonString = await rootBundle.loadString('assets/mock/notice_dummy_data.json');
        cachedData = jsonDecode(jsonString);
        debugPrint("✅ [MOCK] 공지사항 데이터 로드 완료");
      } catch (e) {
        debugPrint("🚨 [MOCK] JSON 파일 로드 실패: $e");
      }
    }

    // ✅ 요청 헤더에서 Authorization 토큰 가져오기
    final String? token = options.headers["Authorization"];
    debugPrint("🔍 요청 헤더 토큰 확인: $token");

    if (options.path == "/notices") {
      // 공지사항 전체 목록 조회
      return handler.resolve(
        Response(
          requestOptions: options,
          data: cachedData,
          statusCode: 200,
        ),
      );
    } else if (options.path.startsWith("/notices/")) {
      // 공지사항 단일 조회
      final noticeId = int.tryParse(options.path.split("/").last);
      if (noticeId == null) {
        debugPrint("🚨 [MOCK] 잘못된 ID 형식!");
        return handler.reject(DioException(
          requestOptions: options,
          error: "ID가 올바르지 않습니다.",
          type: DioExceptionType.badResponse,
        ));
      }

      final notice = cachedData?.firstWhere(
            (n) => n["id"] == noticeId,
        orElse: () => null,
      );

      if (notice == null) {
        debugPrint("🚨 [MOCK] 해당 ID의 공지사항을 찾을 수 없음: $noticeId");
        return handler.reject(DioException(
          requestOptions: options,
          error: "공지사항을 찾을 수 없습니다.",
          type: DioExceptionType.badResponse,
        ));
      }

      debugPrint("✅ [MOCK] 공지사항 단일 조회 성공: ID = $noticeId");
      return handler.resolve(
        Response(
          requestOptions: options,
          data: notice,
          statusCode: 200,
        ),
      );
    } else if (options.method == "POST" && options.path == "/notices") {
      debugPrint("📡 [MOCK] 공지사항 생성 요청 감지됨");

      if (token == null || !token.startsWith("Bearer ")) {
        return handler.reject(DioException(
          requestOptions: options,
          error: "로그인이 필요합니다. (잘못된 토큰 형식)",
          type: DioExceptionType.badResponse,
        ));
      }

      try {
        // JSON 데이터 변환
        final requestData = options.data is String ? jsonDecode(options.data) : options.data;

        final newNoticeId = cachedData != null && cachedData!.isNotEmpty
            ? (cachedData!.last["id"] as int) + 1
            : 1;

        final newNotice = {
          "id": newNoticeId,
          "centerId": requestData["centerId"],
          "title": requestData["title"],
          "content": requestData["content"],
          "date": requestData["date"] ?? "2024-02-01",
          "images": requestData["images"] ?? [],
          "createdAt": DateTime.now().toIso8601String(),
          "updatedAt": DateTime.now().toIso8601String(),
        };

        cachedData ??= []; // ✅ 캐시 데이터가 null이면 빈 리스트로 초기화
        cachedData!.add(newNotice); // ✅ 리스트에 추가하여 새로운 공지사항 반영

        debugPrint("✅ [MOCK] 공지사항 생성 성공! 추가된 공지사항: $newNotice");

        return handler.resolve(
          Response(requestOptions: options, data: newNotice, statusCode: 201),
        );
      } catch (e) {
        debugPrint("🚨 [MOCK] 공지사항 생성 중 JSON 파싱 오류 발생: $e");
        return handler.reject(DioException(
          requestOptions: options,
          error: "잘못된 요청 데이터: ${e.toString()}",
          type: DioExceptionType.badResponse,
        ));
      }
    }

    return super.onRequest(options, handler);
  }
}