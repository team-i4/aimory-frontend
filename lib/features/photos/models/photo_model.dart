import 'dart:convert';

class PhotoModel {
  final int photoId;
  final String imageUrl;
  final int childId;

  PhotoModel({
    required this.photoId,
    required this.imageUrl,
    required this.childId,
  });

  /// ✅ JSON에서 객체로 변환하는 메서드
  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      photoId: json["photoId"],
      imageUrl: json["imageUrl"],
      childId: json["childId"],
    );
  }

  /// ✅ 객체를 JSON으로 변환하는 메서드 추가!
  Map<String, dynamic> toJson() {
    return {
      "photoId": photoId,
      "imageUrl": imageUrl,
      "childId": childId,
    };
  }
}