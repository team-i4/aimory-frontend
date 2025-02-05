import 'package:json_annotation/json_annotation.dart';

part 'teacher_model.g.dart'; // JSON 직렬화 자동 생성 파일

@JsonSerializable()
class TeacherModel {
  final int id;
  final int centerId;
  final int classroomId;
  final String name;
  final String email;
  final String? profileImageUrl;

  TeacherModel({
    required this.id,
    required this.centerId,
    required this.classroomId,
    required this.name,
    required this.email,
    this.profileImageUrl,
  });

  // JSON 변환
  factory TeacherModel.fromJson(Map<String, dynamic> json) => _$TeacherModelFromJson(json);
  Map<String, dynamic> toJson() => _$TeacherModelToJson(this);
}