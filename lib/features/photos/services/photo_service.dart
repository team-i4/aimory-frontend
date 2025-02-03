import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/photo_model.dart';

part 'photo_service.g.dart';

@RestApi(baseUrl: "https://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class PhotoService {
  factory PhotoService(Dio dio, {String baseUrl}) = _PhotoService;

  @GET("/photos")
  Future<List<PhotoModel>> getPhotos(@Header("Authorization") String token);
}