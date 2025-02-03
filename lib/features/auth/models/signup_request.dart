class SignupRequest {
  final String email;
  final String password;
  final String name;
  final String role;
  final int centerId;

  SignupRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    required this.centerId,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "name": name,
    "role": role,
    "centerId": centerId,
  };
}