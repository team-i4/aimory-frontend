import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'note_image_service.g.dart';

@RestApi(baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class NoteImageService {
  factory NoteImageService(Dio dio, {String baseUrl}) = _NoteImageService;

  /// ✅ AI 그림 생성 API
  @POST("/note-images")
  Future<Map<String, String>> generateNoteImage(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> requestBody, // childId, content 전달
      );
}