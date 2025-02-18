import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/teacher_model.dart';

part 'teacher_service.g.dart';

@RestApi(baseUrl: "http://aimory.ap-northeast-2.elasticbeanstalk.com")
abstract class TeacherService {
  factory TeacherService(Dio dio, {String baseUrl}) = _TeacherService;

  @GET("/teacher")
  Future<TeacherModel> fetchTeacherInfo(@Header("Authorization") String token);

  @PUT("/teacher")
  @MultiPart()
  Future<TeacherModel> updateTeacherInfo(
      @Header("Authorization") String token,
      @Part(name: "image") File? image,
      @Part(name: "classroomId") int classroomId,
      @Part(name: "oldPassword") String? oldPassword,
      @Part(name: "newPassword") String? newPassword,
      );
}