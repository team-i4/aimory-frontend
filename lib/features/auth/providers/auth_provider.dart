import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/signup_request.dart';
import '../services/auth_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  return dio;
});

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.read(dioProvider);
  return AuthService(dio);
});

final registerProvider = FutureProvider.family.autoDispose<void, SignupRequest>((ref, request) async {
  final authService = ref.read(authServiceProvider);
  await authService.signup(request);
});