import 'dart:developer';

import 'package:aimory_app/core/const/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';
import '../models/signup_request.dart';
import '../providers/auth_provider.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  Future<void> _showConfirmationDialog(
      BuildContext context, WidgetRef ref, SignupRequest request) async {
    // 키보드 포커스 해제
    FocusScope.of(context).unfocus();
    // 첫 번째 모달: 회원가입 완료 확인
    final bool? shouldProceed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder( // 모서리 둥글게 설정
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white, // 배경색 흰색
          title: const Text(
            '회원가입 확인',
            style: TextStyle(color: MAIN_DARK_GREY),
          ),
          content: const Text(
            '회원가입을 완료하시겠습니까?',
            style: TextStyle(color: MAIN_DARK_GREY),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // 취소 선택
              },
              child: const Text(
                '취소',
                style: TextStyle(color: MAIN_DARK_GREY),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true); // 완료 선택
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DARK_GREY_COLOR, // 완료 버튼 배경 검정
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 버튼 모서리 둥글게
                ),
              ),
              child: const Text('완료', style: TextStyle(color: Colors.white)), // 글씨 흰색
            ),
          ],
        );
      },
    );

    if (shouldProceed == true) {
      // 회원가입 처리 중 로딩 모달 띄우기
      _showLoadingDialog(context);

      try {
        // API 호출
        final authService = ref.read(authServiceProvider);
        final response = await authService.signup(request);

        // 로딩 모달 닫기
        Navigator.pop(context);

        // 성공 모달 띄우기
        await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.white,
              title: const Text(
                '회원가입 성공',
                style: TextStyle(color: DARK_GREY_COLOR),
              ),
              content: Text(
                '${response.name}님, 회원가입이 완료되었습니다.',
                style: const TextStyle(color: DARK_GREY_COLOR),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // 성공 모달 닫기
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DARK_GREY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('확인', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );

        // 로그인 화면으로 이동
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        // 에러 발생 시 처리
        Navigator.pop(context); // 로딩 모달 닫기
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: $e')),
        );
        log('회원가입 실패: $e', name: 'SignUp');
      }
    }
  }

  void _showLoadingDialog(BuildContext context) {
    // 로딩 모달
    showDialog(
      context: context,
      barrierDismissible: false, // 로딩 중에는 닫을 수 없도록 설정
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TextEditingController 초기화
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController(); // 비밀번호 확인 필드
    final roleController = ValueNotifier<String>('PARENT'); // 역할 선택 값 관리
    final centerController = ValueNotifier<int>(1); // 초기값: 1

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '회원가입',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('어린이집'),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: centerController.value, // centerController의 초기값
                  items: [
                    DropdownMenuItem(
                      value: 1, // 값이 초기값과 일치해야 함
                      child: Text('햇님어린이집'),
                    ),
                  ],
                  onChanged: (value) {
                    centerController.value = value ?? 1;
                  },
                  decoration: CustomInputDecoration.basic(
                    hintText: '어린이집을 선택하세요.', // 힌트 문구
                  ),
                ),
                const SizedBox(height: 16),
                const Text('역할'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: roleController.value, // 기본값 설정
                  items: [
                    DropdownMenuItem(
                      value: 'TEACHER',
                      child: Text('교사'),
                    ),
                    DropdownMenuItem(
                      value: 'PARENT',
                      child: Text('부모님'),
                    ),
                  ],
                  onChanged: (value) {
                    roleController.value = value ?? 'PARENT'; // 선택값 업데이트
                  },
                  decoration: CustomInputDecoration.basic(
                    hintText: '역할을 선택하세요.',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('이메일'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  decoration: CustomInputDecoration.basic(
                    hintText: '이메일을 입력하세요.',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('이름'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: CustomInputDecoration.basic(
                    hintText: '이름을 입력하세요.',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('비밀번호'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: CustomInputDecoration.basic(
                    hintText: '비밀번호',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('비밀번호 확인'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: CustomInputDecoration.basic(
                    hintText: '비밀번호 확인',
                  ),
                ),

                const SizedBox(height: 24),
                CustomButton(
                  text: '회원가입',
                  onPressed: () {
                    // 입력값 검증
                    if (passwordController.text != confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("비밀번호가 일치하지 않습니다.")),
                      );
                      return;
                    }

                    // SignupRequest 생성
                    final request = SignupRequest(
                      email: emailController.text,
                      password: passwordController.text,
                      name: nameController.text,
                      role: roleController.value,
                      centerId: centerController.value,
                    );

                    // 확인 모달 띄우기
                    _showConfirmationDialog(context, ref, request);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}