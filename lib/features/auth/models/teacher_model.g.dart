// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherModel _$TeacherModelFromJson(Map<String, dynamic> json) => TeacherModel(
      id: (json['id'] as num).toInt(),
      centerId: (json['centerId'] as num).toInt(),
      classroomId: (json['classroomId'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$TeacherModelToJson(TeacherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'centerId': instance.centerId,
      'classroomId': instance.classroomId,
      'name': instance.name,
      'email': instance.email,
      'profileImageUrl': instance.profileImageUrl,
    };
