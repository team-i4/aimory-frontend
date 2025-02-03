// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteModel _$NoteModelFromJson(Map<String, dynamic> json) => NoteModel(
      id: (json['id'] as num?)?.toInt(),
      childId: (json['childId'] as num).toInt(),
      childName: json['childName'] as String?,
      childClass: json['childClass'] as String?,
      content: json['content'] as String,
      image: json['image'] as String?,
      date: json['date'] as String,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$NoteModelToJson(NoteModel instance) => <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'childName': instance.childName,
      'childClass': instance.childClass,
      'content': instance.content,
      'image': instance.image,
      'date': instance.date,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
