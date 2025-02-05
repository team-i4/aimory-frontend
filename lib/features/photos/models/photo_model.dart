class PhotoModel {
  final int photoId;
  final String imageUrl;
  final List<int> childIds; // ✅ 여러 childId 처리
  final List<String> childNames; // ✅ 여러 childName 처리
  final String createdAt;

  PhotoModel({
    required this.photoId,
    required this.imageUrl,
    required this.childIds,
    required this.childNames,
    required this.createdAt,
  });

  /// ✅ JSON에서 객체로 변환하는 메서드
  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      photoId: json["photoId"] ?? 0,
      imageUrl: json["imageUrl"] ?? "",
      childIds: List<int>.from(json["childIds"] ?? []), // ✅ 여러 ID 처리
      childNames: List<String>.from(json["childNames"] ?? []), // ✅ 여러 이름 처리
      createdAt: json["createdAt"] ?? "날짜 없음",
    );
  }

  /// ✅ 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      "photoId": photoId,
      "imageUrl": imageUrl,
      "childIds": childIds,
      "childNames": childNames,
      "createdAt": createdAt,
    };
  }
}