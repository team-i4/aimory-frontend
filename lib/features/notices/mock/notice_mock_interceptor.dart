import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class NoticeMockInterceptor extends Interceptor {
  static List<dynamic>? cachedData; // ✅ JSON 캐싱을 위한 리스트

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (cachedData == null) {
      // JSON 데이터 한 번만 로드하여 캐싱
      final jsonString = await rootBundle.loadString('assets/mock/notice_dummy_data.json');
      cachedData = jsonDecode(jsonString);
    }

    if (options.method == "GET" && options.path == "/notices") {
      // 공지사항 목록 조회 (GET /notices)
      return handler.resolve(
        Response(
          requestOptions: options,
          data: cachedData, // ✅ Mock 데이터 반환
          statusCode: 200,
        ),
      );
    } else if (options.method == "POST" && options.path == "/notices") {
      // 공지사항 생성 (POST /notices)
      try {
        final requestData = jsonDecode(options.data["data"]); // JSON 파싱
        final newNotice = {
          "id": cachedData!.isNotEmpty ? cachedData!.last["id"] + 1 : 1, // 자동 증가 ID
          "centerId": requestData["centerId"],
          "title": requestData["title"],
          "content": requestData["content"],
          "date": requestData["date"] ?? "2024-02-01",
          "images": requestData["images"] ?? [],
          "createdAt": DateTime.now().toIso8601String(),
          "updatedAt": DateTime.now().toIso8601String(),
        };

        cachedData!.add(newNotice); // 리스트에 추가하여 새로운 공지사항 반영

        return handler.resolve(
          Response(
            requestOptions: options,
            data: newNotice, // 생성된 공지사항 데이터 반환
            statusCode: 201, // Created
          ),
        );
      } catch (e) {
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