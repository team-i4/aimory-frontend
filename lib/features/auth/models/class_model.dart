class CreateClassRequest {
  final String name;
  final int teacherId;

  CreateClassRequest({required this.name, required this.teacherId});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "teacherId": teacherId,
    };
  }
}

class CreateClassResponse {
  final int id;
  final String name;
  final int teacherId;

  CreateClassResponse({
    required this.id,
    required this.name,
    required this.teacherId,
  });

  factory CreateClassResponse.fromJson(Map<String, dynamic> json) {
    return CreateClassResponse(
      id: json['id'],
      name: json['name'],
      teacherId: json['teacherId'],
    );
  }
}