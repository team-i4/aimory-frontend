import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class NoticeMockInterceptor extends Interceptor {
  static List<dynamic>? cachedData; // JSON 캐싱을 위한

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (cachedData == null) {
      // JSON 데이터 한 번만 로드하여 캐싱
      final jsonString = await rootBundle.loadString('assets/mock/notice_dummy_data.json');
      cachedData = jsonDecode(jsonString);
    }


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
      //  공지사항 단일 조회
      final noticeId = int.tryParse(options.path.split("/").last); // ID 추출
      if (noticeId == null) {
        return handler.reject(DioException(
          requestOptions: options,
          error: "ID가 올바르지 않습니다.",
          type: DioExceptionType.badResponse,
        ));
      }

      final notice = cachedData!.firstWhere(
            (n) => n["id"] == noticeId,
        orElse: () => null,
      );

      if (notice == null) {
        return handler.reject(DioError(
          requestOptions: options,
          error: "공지사항을 찾을 수 없습니다.",
          type: DioErrorType.badResponse,
        ));
      }

      return handler.resolve(
        Response(
          requestOptions: options,
          data: notice,
          statusCode: 200,
        ),
      );
    }

    return super.onRequest(options, handler);
  }
}