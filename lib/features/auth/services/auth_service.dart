import 'package:flutter/cupertino.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../models/signup_request.dart';
import '../models/signup_response.dart';
import '../models/signin_request.dart'; // 로그인 요청 모델 추가
import '../models/signin_response.dart'; // 로그인 응답 모델 추가
import 'package:aimory_app/core/util/secure_storage.dart';

part 'auth_service.g.dart'; // Retrofit 자동 생성 파일

@RestApi(baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  /// 회원가입 API
  @POST("/signup")
  Future<SignupResponse> signup(@Body() SignupRequest request);

  /// 로그인 API
  @POST("/login")
  Future<SigninResponse> login(@Body() SigninRequest request);
}

/// 로그인 요청을 수행하는 함수 (SecureStorage 활용)
Future<bool> performLogin(AuthService authService, String email, String password) async {
  try {
    final request = SigninRequest(email: email, password: password);
    final response = await authService.login(request);

    if (response.apiToken.isNotEmpty) {

      await SecureStorage.saveToken(response.apiToken); // Access Token 저장
      await SecureStorage.saveUserRole(response.member.role);
      await SecureStorage.saveTeacherId(response.member.id); // teacherId 저장

      // centerId 저장 추가 (누락된 경우에 저장)
      if(response.member.centerId != null) {
        await SecureStorage.saveCenterId(response.member.centerId);
      }
      debugPrint("로그인 성공! Access Token: ${response.apiToken}");
      debugPrint("사용자 정보: ${response.member.name} (${response.member.role})");
      debugPrint("🔍 Center ID 저장됨: ${response.member.centerId}");

      return true;
    } else {
      debugPrint("로그인 실패: 응답에 토큰이 없습니다.");
      return false;
    }
  } catch (e) {
    debugPrint("로그인 요청 중 오류 발생: $e");
    return false;
  }
}