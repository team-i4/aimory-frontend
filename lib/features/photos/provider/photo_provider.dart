import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/photo_model.dart';
import '../services/photo_service.dart';
import '../../../core/util/secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com",
  ));
  return dio;
});

final photoDeleteProvider = FutureProvider.family<bool, List<int>>((ref, photoIds) async {
  final service = ref.read(photoServiceProvider);
  final token = await SecureStorage.readToken();
  if (token == null) {
    throw Exception("❌ 토큰이 없습니다.");
  }

  try {
    final response = await service.deletePhotos("Bearer $token", {"data": photoIds});
    debugPrint("✅ 사진 삭제 성공: $photoIds");
    return true; // ✅ 성공 시 true 반환
  } catch (e) {
    debugPrint("❌ 사진 삭제 실패: $e");
    return false; // ❌ 실패 시 false 반환
  }
});

final photoServiceProvider = Provider<PhotoService>((ref) {
  final dio = ref.read(dioProvider);
  return PhotoService(dio);
});

final photoListProvider = FutureProvider<List<PhotoModel>>((ref) async {
  final service = ref.read(photoServiceProvider);
  final token = await SecureStorage.readToken();
  if (token == null) {
    throw Exception("토큰이 존재하지 않습니다.");
  }

  final rawResponse = await service.getPhotos("Bearer $token");
  debugPrint("📸 사진첩 API 원본 응답: $rawResponse");

  // 🔹 응답이 `Map<String, dynamic>`이면 `{ "photos": [...] }` 형태일 가능성 높음
  if (rawResponse is Map<String, dynamic> && rawResponse.containsKey("photos")) {
    final photosList = rawResponse["photos"];
    if (photosList is List) {
      return photosList.map((item) => PhotoModel.fromJson(item as Map<String, dynamic>)).toList();
    }
  }

  throw Exception("사진 데이터를 불러올 수 없습니다.");
});