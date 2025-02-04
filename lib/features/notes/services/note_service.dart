import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/note_model.dart';

part 'note_service.g.dart';

@RestApi(baseUrl: "https://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class NoteService {
  factory NoteService(Dio dio, {String baseUrl}) = _NoteService;

  // 알림장 생성 API
  @POST("/notes")
  Future<NoteModel> createNote(
      @Header("apiToken") String token,
      @Body() NoteModel note, // JSON 변환 없이 NoteModel 객체를 바로 사용 가능!
      );

  // 알림장 전체 조회 API
  @GET("/notes")
  Future<List<NoteModel>> fetchNotes(
      @Header("apiToken") String token,
      );

  // 알림장 단일 조회 API
  @ GET("/notes/{note_id}")
  Future<NoteModel> fetchNoteDetail(
      @Header("apiToken") String token,
      @Path("note_id") int noteId,
      );
}