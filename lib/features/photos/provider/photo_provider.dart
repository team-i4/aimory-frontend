import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/photo_model.dart';
import '../services/photo_service.dart';
import '../../../core/util/secure_storage.dart';

// final dioProvider = Provider<Dio>((ref) {
//   final dio = Dio(BaseOptions(
//     baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com",
//   ));
//   return dio;
// });


final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com",
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await SecureStorage.readToken();
      if (token == null) {
        handler.reject(DioError(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 401,
            statusMessage: "Unauthorized: 토큰이 없습니다.",
          ),
        ));
        return;
      }

      options.headers["Authorization"] = "Bearer $token";
      handler.next(options);
    },
    onError: (DioError e, handler) async {
      if (e.response?.statusCode == 401) {
        print("❌ 401 오류 발생: 토큰 재발급 시도");
        await SecureStorage.deleteAuthData(); // 기존 토큰 삭제
        handler.reject(e);
      } else {
        handler.next(e);
      }
    },
  ));

  return dio;
});


// final photoUploadProvider = FutureProvider.family<bool, File>((ref, file) async {
//   final token = await SecureStorage.readToken();
//   if (token == null) {
//     throw Exception("❌ 토큰이 없습니다.");
//   }
//
//   try {
//     final fileData = await MultipartFile.fromFile(file.path, filename: file.path.split('/').last);
//
//     // 🔥 Authorization 헤더 직접 추가
//     final response = await dio.post(
//       "/photos",
//       data: FormData.fromMap({
//         "files": [fileData],  // 🔹 key를 서버 스펙에 맞춰야 함
//       }),
//       options: Options(
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "multipart/form-data",
//         },
//       ),
//     );
//
//     debugPrint("✅ 사진 업로드 성공: ${response.data}");
//     ref.invalidate(photoListProvider); // ✅ 업로드 후 새로고침
//     return true;
//   } catch (e) {
//     debugPrint("❌ 사진 업로드 실패: $e");
//     return false;
//   }
// });


final photoUploadProvider = FutureProvider.family<bool, List<File>>((ref, files) async {
  final service = ref.read(photoServiceProvider);
  final token = await SecureStorage.readToken();

  if (token == null) {
    print("❌ 토큰이 없습니다. 다시 로그인 필요.");
    throw Exception("❌ 인증 토큰이 없습니다. 다시 로그인해주세요.");
  }

  try {
    final List<MultipartFile> multipartImages = await Future.wait(
        files.map((file) async => MultipartFile.fromFile(file.path, filename: file.path.split('/').last))
    );

    print("🟡 업로드 요청 - 파일 개수: ${multipartImages.length}");

    final response = await service.uploadPhotos("Bearer $token", multipartImages);

    print("✅ 사진 업로드 성공: ${response}");
    return true;
  } catch (e) {
    print("❌ 사진 업로드 실패: $e");
    if (e is DioError && e.response?.statusCode == 401) {
      await SecureStorage.deleteAuthData();
      print("🔄 토큰 만료: 로그아웃 처리");
    }
    return false;
  }
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

  debugPrint("🟡 저장된 토큰: $token");

  if (token == null) {
    throw Exception("❌ 토큰이 없습니다.");
  }

  final rawResponse = await service.getPhotos("Bearer $token");
  debugPrint("📸 사진첩 API 원본 응답: $rawResponse");

  if (rawResponse is Map<String, dynamic> && rawResponse.containsKey("photos")) {
    final photosList = rawResponse["photos"];
    debugPrint("📸 응답에서 추출한 photos 데이터: $photosList");

    if (photosList is List) {
      return photosList.map((item) => PhotoModel.fromJson(item as Map<String, dynamic>)).toList();
    }
  }

  throw Exception("❌ 사진 데이터를 불러올 수 없습니다. 응답 확인 필요");
});