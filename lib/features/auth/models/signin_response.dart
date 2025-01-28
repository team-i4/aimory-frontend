class SigninResponse {
  final String apiToken; // Access Token
  final Member member; // 사용자 정보

  SigninResponse({
    required this.apiToken,
    required this.member,
  });

  factory SigninResponse.fromJson(Map<String, dynamic> json) {
    return SigninResponse(
      apiToken: json['apiToken'], // Access Token 저장
      member: Member.fromJson(json['member']), // 사용자 정보 저장
    );
  }
}

// 사용자 정보를 담는 모델 (🔄 추가됨)
class Member {
  final int id;
  final int centerId;
  final String email;
  final String name;
  final String role;

  Member({
    required this.id,
    required this.centerId,
    required this.email,
    required this.name,
    required this.role,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      centerId: json['centerId'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
    );
  }
}