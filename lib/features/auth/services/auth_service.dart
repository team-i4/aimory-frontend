import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/signup_request.dart';
import '../models/signup_response.dart';

part 'auth_service.g.dart'; // Retrofit 자동 생성 파일

@RestApi(baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  /// 회원가입 API
  @POST("/signup")
  Future<SignupResponse> signup(@Body() SignupRequest request);
}