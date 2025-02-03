class PhotoModel {
  final int photoId;
  final String imageUrl;
  final int childId;
  final String childName; // ✅ 원아 이름 (Null 방지)
  final String createdAt; // ✅ 업로드 날짜

  PhotoModel({
    required this.photoId,
    required this.imageUrl,
    required this.childId,
    required this.childName,
    required this.createdAt,
  });

  /// ✅ JSON에서 객체로 변환하는 메서드
  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      photoId: json["photoId"] ?? 0,
      imageUrl: json["imageUrl"] ?? "",
      childId: json["childId"] ?? 0,
      childName: json["childName"] ?? "이름 없음", // ✅ null 방지
      createdAt: json["createdAt"] ?? "날짜 없음", // ✅ null 방지
    );
  }

  /// ✅ 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      "photoId": photoId,
      "imageUrl": imageUrl,
      "childId": childId,
      "childName": childName,
      "createdAt": createdAt,
    };
  }
}