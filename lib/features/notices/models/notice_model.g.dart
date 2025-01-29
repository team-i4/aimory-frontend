// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeModel _$NoticeModelFromJson(Map<String, dynamic> json) => NoticeModel(
      id: (json['id'] as num?)?.toInt(),
      centerId: (json['centerId'] as num).toInt(),
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      title: json['title'] as String,
      content: json['content'] as String,
      date: json['date'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$NoticeModelToJson(NoticeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'centerId': instance.centerId,
      'images': instance.images,
      'title': instance.title,
      'content': instance.content,
      'date': instance.date,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
