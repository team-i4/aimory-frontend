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

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'],
      centerId: json['centerId'],
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      title: json['title'],
      content: json['content'],
      date: json['date'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "centerId": centerId,
      "title": title,
      "content": content,
      "date": date,
    };
  }
}