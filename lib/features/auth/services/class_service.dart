import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/class_model.dart';

part 'class_service.g.dart';

@RestApi(baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class ClassService {
  factory ClassService(Dio dio, {String baseUrl}) = _ClassService;

  @POST("/teachers/{teacher_id}")
  Future<CreateClassResponse> createClass(
      @Path("teacher_id") int teacherId,
      @Body() CreateClassRequest request
      );
}