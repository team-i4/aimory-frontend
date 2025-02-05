import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/search_model.dart'; // ✅ 모델 파일 하나로 합쳐진 것 적용

part 'search_service.g.dart';

@RestApi(baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class SearchService {
  factory SearchService(Dio dio, {String baseUrl}) = _SearchService;

  @POST("/search")
  Future<SearchResponse> search(
      @Header("Authorization") String token,
      @Body() SearchRequest request);
}