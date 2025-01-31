import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/note_model.dart';

part 'note_service.g.dart';

@RestApi(baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class NoteService {
  factory NoteService(Dio dio, {String baseUrl}) = _NoteService;

  /// ✅ 알림장 생성 API
  @POST("/notes")
  Future<NoteModel> createNote(
      @Header("Authorization") String token,
      @Body() NoteModel note, // ✅ 이제 JSON 변환 없이 NoteModel 객체를 바로 사용 가능!
      );

  // 알림장 전체 조회 API
  @GET("/notes")
  Future<List<NoteModel>> fetchNotes(
      @Header("Authorization") String token,
      );
}