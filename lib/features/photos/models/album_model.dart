class Album {
  final int childId;
  final String name;
  final String profileImageUrl;
  final int count;

  Album({
    required this.childId,
    required this.name,
    required this.profileImageUrl,
    required this.count,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      childId: json['childId'] as int,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      count: json['count'] as int,
    );
  }
}