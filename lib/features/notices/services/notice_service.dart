import 'dart:convert';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/notice_model.dart';

part 'notice_service.g.dart';

@RestApi()
abstract class NoticeService {
  factory NoticeService(Dio dio, {String baseUrl}) = _NoticeService;

  /// ✅ 공지사항 생성 API
  @POST("/notices")
  @MultiPart()
  Future<NoticeModel> createNotice(
      @Header("Authorization") String token,
      @Part(name: "data") String noticeJson, // JSON 문자열
      @Part(name: "images") List<MultipartFile>? images, // 이미지 업로드
      );

  /// ✅ 공지사항 전체 조회 API
  @GET("/notices")
  Future<List<NoticeModel>> getNotices(@Header("Authorization") String token);

  /// ✅ 공지사항 단일 조회 API
  @GET("/notices/{notice_id}")
  Future<NoticeModel> getNoticeById(
      @Header("Authorization") String token,
      @Path("notice_id") int noticeId,
      );

  /// ✅ 공지사항 삭제 API (여러 개 삭제 가능)
  @DELETE("/notices")
  Future<void> deleteNotices(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> requestBody, // 백엔드가 Body를 받는 경우 유지
      );
}