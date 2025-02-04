import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../../core/util/secure_storage.dart';
import '../models/notice_model.dart';
import '../provider/notice_provider.dart';

part 'notice_service.g.dart';

@RestApi(baseUrl: "https://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class NoticeService {
  factory NoticeService(Dio dio, {String baseUrl}) = _NoticeService;

  /// ✅ 공지사항 생성 API
  @POST("/notices")
  @MultiPart()
  Future<NoticeModel> createNotice(
      @Header("apiToken") String token,
      @Part(name: "data") String noticeJson,
      @Part(name: "images") List<MultipartFile>? images,
      );

  /// ✅ 공지사항 전체 조회 API
  @GET("/notices")
  Future<dynamic> getNotices(@Header("apiToken") String token);

  /// ✅ 공지사항 단일 조회 API
  @GET("/notices/{notice_id}")
  Future<NoticeModel> getNoticeById(
      @Header("apiToken") String token,
      @Path("notice_id") int noticeId,
      );

  /// ✅ 공지사항 삭제 API
  @DELETE("/notices")
  Future<void> deleteNotices(
      @Header("apiToken") String token,
      @Body() Map<String, dynamic> requestBody,
      );
}

/// ✅ 공지사항 리스트를 관리하는 FutureProvider
final noticeListProvider = FutureProvider<List<NoticeModel>>((ref) async {
  final service = ref.read(noticeServiceProvider);
  final token = await SecureStorage.readToken();
  if (token == null) {
    throw Exception("토큰이 존재하지 않습니다.");
  }

  final rawResponse = await service.getNotices("Bearer $token");

  // 🔹 응답이 `Map<String, dynamic>`이면 `{ "notices": [...] }` 형태일 가능성 높음
  if (rawResponse is Map<String, dynamic> && rawResponse.containsKey("notices")) {
    final noticesList = rawResponse["notices"];
    if (noticesList is List) {
      return noticesList.map((item) => NoticeModel.fromJson(item as Map<String, dynamic>)).toList();
    }
  }

  throw Exception("공지사항 데이터를 불러올 수 없습니다.");
});