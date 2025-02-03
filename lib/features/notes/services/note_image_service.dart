import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/note_ai_image_model.dart';

part 'note_image_service.g.dart';

@RestApi(baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class NoteImageService {
  factory NoteImageService(Dio dio, {String baseUrl}) = _NoteImageService;

  /// ✅ AI 그림 생성 API (NoteAiImageModel 사용)
  @POST("/note-images")
  Future<NoteAiImageModel> generateAiImage(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> request,
      );
}