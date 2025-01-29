import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'note_image_service.g.dart';

@RestApi(baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class NoteImageService {
  factory NoteImageService(Dio dio, {String baseUrl}) = _NoteImageService;

  /// ✅ 알림장 ID에 연결된 이미지 URL 저장
  @POST("/note-images")
  Future<void> saveNoteImage(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> imageData,
      );
}