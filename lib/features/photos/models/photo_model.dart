class PhotoModel {
  final int photoId;
  final String imageUrl;
  final int childId;

  PhotoModel({required this.photoId, required this.imageUrl, required this.childId});

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      photoId: json['photoId'],
      imageUrl: json['imageUrl'],
      childId: json['childId'],
    );
  }
}