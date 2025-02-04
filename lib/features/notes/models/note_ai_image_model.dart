import 'package:json_annotation/json_annotation.dart';

part 'note_ai_image_model.g.dart';

@JsonSerializable()
class NoteAiImageModel {
  final String image; // AI가 생성한 이미지 URL

  // ✅ 기본 생성자
  NoteAiImageModel({required this.image});

  // ✅ JSON 변환 메서드 추가
  factory NoteAiImageModel.fromJson(Map<String, dynamic> json) => _$NoteAiImageModelFromJson(json);
  Map<String, dynamic> toJson() => _$NoteAiImageModelToJson(this);
}