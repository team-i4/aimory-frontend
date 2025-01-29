import 'dart:convert'; // ✅ jsonEncode 사용을 위해 추가

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/notice_model.dart';

part 'notice_service.g.dart';

@RestApi(baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class NoticeService {
  factory NoticeService(Dio dio, {String baseUrl}) = _NoticeService;

  /// ✅ 공지사항 생성 API
  @POST("/notices")
  @MultiPart()
  Future<NoticeModel> createNotice(
      @Header("Authorization") String token,
      @Part(name: "data") String noticeJson, // JSON 문자열로 변경
      @Part(name: "images") List<MultipartFile>? images, //  이미지 업로드 추가
      );

  /// ✅ 공지사항 전체 조회 API
  @GET("/notices")
  Future<List<NoticeModel>> getNotices(@Header("Authorization") String token);

  /// ✅ 공지사항 단일 조회 API 추가
  @GET("/notices/{notice_id}")
  Future<NoticeModel> getNoticeById(
      @Header("Authorization") String token,
      @Path("notice_id") int noticeId,
      );

  /// ✅ 공지사항 삭제 API (여러 개 삭제 가능)
  @DELETE("/notices")
  Future<List<int>> deleteNotices(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> data, // {"data": [공지사항 ID 목록]}
      );


}