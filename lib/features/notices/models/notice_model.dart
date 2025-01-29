import 'package:json_annotation/json_annotation.dart';

part 'notice_model.g.dart';

@JsonSerializable()
class NoticeModel {
  final int? id; // 응답 시 존재
  final int centerId; // 요청 & 응답 공통
  final List<String>? images; // 응답 시 존재
  final String title;
  final String content;
  final String? date;
  final String? createdAt; // 응답 시 존재
  final String? updatedAt; // 응답 시 존재

  NoticeModel({
    this.id,
    required this.centerId,
    this.images,
    required this.title,
    required this.content,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  /// ✅ JSON → Dart 객체 변환 (API 응답 파싱)
  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);

  /// ✅ Dart 객체 → JSON 변환 (API 요청 보낼 때 사용)
  Map<String, dynamic> toJson() => _$NoticeModelToJson(this);
}