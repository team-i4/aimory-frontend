import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class NoticeMockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path == "/notices") { // ✅ 공지사항 목록 조회 요청 시 Mock 데이터 반환
      final jsonString = await rootBundle.loadString('/dummy_data.json');
      final jsonData = jsonDecode(jsonString);

      return handler.resolve(
        Response(
          requestOptions: options,
          data: jsonData,
          statusCode: 200,
        ),
      );
    }

    return super.onRequest(options, handler);
  }
}