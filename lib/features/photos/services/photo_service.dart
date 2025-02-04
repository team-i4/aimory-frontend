import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:retrofit/retrofit.dart';
import '../models/photo_model.dart';

part 'photo_service.g.dart';

@RestApi(baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class PhotoService {
  factory PhotoService(Dio dio, {String baseUrl}) = _PhotoService;

  @GET("/photos")
  Future<dynamic> getPhotos(@Header("Authorization") String token);

  @POST("/photos")
  @MultiPart()
  Future<dynamic> uploadPhotos(
      @Header("apiToken") String token,
      @Part() List<MultipartFile> files,
      );

  @GET("/photos/child")
  Future<dynamic> getPhotosByChild(
      @Header("Authorization") String token,
      @Query("childId") int childId,
      );

  @DELETE("/photos")
  Future<dynamic> deletePhotos(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> requestBody,
      );
}

// ✅ Dio 인스턴스에서 요청/응답 로그 출력
final dio = Dio(BaseOptions(baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com"))
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      debugPrint("📤 요청 URL: ${options.uri}");
      debugPrint("📤 요청 헤더: ${options.headers}");
      return handler.next(options);
    },
    onResponse: (response, handler) {
      debugPrint("✅ 응답 상태 코드: ${response.statusCode}");
      debugPrint("✅ 응답 데이터: ${response.data}");
      return handler.next(response);
    },
    onError: (DioError e, handler) {
      debugPrint("❌ API 요청 실패: ${e.response?.statusCode}");
      debugPrint("❌ 오류 메시지: ${e.message}");
      return handler.next(e);
    },
  ));