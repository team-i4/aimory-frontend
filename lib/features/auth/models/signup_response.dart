class SignupResponse {
  final int id;
  final String email;
  final String name;
  final String role;
  final int centerId;

  SignupResponse({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.centerId,
  });

  // JSON 파싱 함수
  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      centerId: json['centerId'],
    );
  }
}