import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'note_image_service.g.dart';

@RestApi(baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class NoteImageService {
  factory NoteImageService(Dio dio, {String baseUrl}) = _NoteImageService;

  /// ✅ AI 그림 생성 API
  @POST("/note-images")
  Future<Map<String, dynamic>> generateAiImage(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> request,
      );

  /// ✅ note_image 테이블에 이미지 저장
  @POST("/note-image/save")
  Future<void> saveNoteImage(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> data,
      );
}