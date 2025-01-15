class Photo {
  final int photoId;
  final String imageUrl;

  Photo({
    required this.photoId,
    required this.imageUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      photoId: json['photoId'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }
}