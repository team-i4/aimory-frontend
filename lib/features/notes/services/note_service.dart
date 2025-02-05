import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/note_model.dart';

part 'note_service.g.dart';

@RestApi(baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class NoteService {
  factory NoteService(Dio dio, {String baseUrl}) = _NoteService;

  // 알림장 생성 API
  @POST("/notes")
  Future<void> createNote(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> noteData, // ✅ NoteModel 대신 Map<String, dynamic> 사용
      );

  // 알림장 전체 조회 API
  @GET("/notes")
  Future<dynamic> fetchNotes(
      @Header("Authorization") String token,
      );

  // 알림장 단일 조회 API
  @ GET("/notes/{note_id}")
  Future<NoteModel> fetchNoteDetail(
      @Header("Authorization") String token,
      @Path("note_id") int noteId,
      );

  // 알림장 삭제 API
  @DELETE("/notes")
  Future<void> deleteNotes(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> noteIds, // { "data": [noteId] } 형태로 전송
      );
}