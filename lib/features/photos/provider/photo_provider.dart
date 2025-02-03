import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/photo_service.dart';
import '../models/photo_model.dart';
import '../../../core/util/secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.interceptors.add(LogInterceptor(responseBody: true)); // 로그 추가
  return dio;
});

final photoServiceProvider = Provider<PhotoService>((ref) {
  final dio = ref.watch(dioProvider);
  return PhotoService(dio);
});

final photoListProvider = FutureProvider<List<PhotoModel>>((ref) async {
  final service = ref.read(photoServiceProvider);
  final token = await SecureStorage.readToken();
  if (token == null) {
    throw Exception("토큰이 존재하지 않습니다.");
  }

  return await service.getPhotos("Bearer $token");
});