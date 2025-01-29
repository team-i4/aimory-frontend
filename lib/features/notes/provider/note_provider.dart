import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';
import '../../../core/util/secure_storage.dart';

// ✅ Dio 인스턴스 제공
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  return dio;
});

// ✅ NoteService 인스턴스 제공
final noteServiceProvider = Provider<NoteService>((ref) {
  final dio = ref.read(dioProvider);
  return NoteService(dio);
});

// ✅ 알림장 생성 Provider
final noteCreateProvider = FutureProvider.autoDispose
    .family<NoteModel, NoteModel>((ref, note) async {
  final service = ref.read(noteServiceProvider);
  final token = await SecureStorage.readToken();
  if (token == null) throw Exception("로그인이 필요합니다.");
  return service.createNote("Bearer $token", note);
});