import 'package:flutter/material.dart';

import '../../../core/const/colors.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MAIN_YELLOW, // 배경색
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50), // 로고 위 여백
                // 로고 이미지
                Image.asset(
                  'assets/img/aimory_calendar_logo.png', // 로고 파일 경로
                  height: 120,
                ),
                const SizedBox(height: 60), // 로고 아래 여백
                // 이메일 입력 필드
                TextField(
                  decoration: InputDecoration(
                    hintText: '이메일 입력',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 15), // 필드 간 여백
                // 비밀번호 입력 필드
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '비밀번호 입력',
                    suffixIcon: Icon(Icons.visibility),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10), // 필드 아래 여백
                // 이메일 저장 및 비밀번호 찾기
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        const Text('이메일 저장'),
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          '이메일 찾기',
                        ),
                        SizedBox(width: 8),
                        Text('|'),
                        SizedBox(width: 8),
                        Text(
                          '비밀번호 찾기',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20), // 버튼 위 여백
                // 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DARK_GREY_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30), // 하단 텍스트 여백
                // 회원가입 링크
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
