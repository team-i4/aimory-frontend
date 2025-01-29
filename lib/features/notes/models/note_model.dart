import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart'; // ✅ 자동 생성 파일 (빌드 후 생성됨)

@JsonSerializable() // ✅ JSON 직렬화 가능하도록 설정
class NoteModel {
  final int? id;
  final int childId;
  final String? childName;
  final String? childClass;
  final String content;
  final String? image;
  final String date;
  final String? createdAt;
  final String? updatedAt;

  NoteModel({
    this.id,
    required this.childId,
    this.childName,
    this.childClass,
    required this.content,
    this.image,
    required this.date,
    this.createdAt,
    this.updatedAt,
  });

  // ✅ JSON 직렬화 및 역직렬화 추가
  factory NoteModel.fromJson(Map<String, dynamic> json) => _$NoteModelFromJson(json);
  Map<String, dynamic> toJson() => _$NoteModelToJson(this);
}