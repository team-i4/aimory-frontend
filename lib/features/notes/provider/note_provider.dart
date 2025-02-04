import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';
import '../../../core/util/secure_storage.dart';

// Dio 인스턴스 제공
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  return dio;
});

// NoteService 인스턴스 제공
final noteServiceProvider = Provider<NoteService>((ref) {
  final dio = ref.read(dioProvider);
  return NoteService(dio);
});

// 알림장 생성 Provider
final noteListProvider = FutureProvider<List<NoteModel>>((ref) async {
  final service = ref.read(noteServiceProvider);
  final token = await SecureStorage.readToken();
  if (token == null) throw Exception("로그인이 필요합니다.");

  final rawResponse = await service.fetchNotes("Bearer $token");

  if (rawResponse is Map<String, dynamic> && rawResponse.containsKey("notes")) {
    final List<dynamic> notesJson = rawResponse["notes"];
    return notesJson.map((json) => NoteModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  throw Exception("알림장 데이터를 불러올 수 없습니다.");
});

// 알림장 단일 조회 Provider
final noteDetailProvider = FutureProvider.autoDispose.family<NoteModel, int>((ref, noteId) async {
  final service = ref.read(noteServiceProvider);
  final token = await SecureStorage.readToken();
  if (token == null) throw Exception("로그인이 필요합니다.");

  return service.fetchNoteDetail("Bearer $token", noteId);
});

