import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('역할'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              items: [
                DropdownMenuItem(
                  value: 'user',
                  child: Text('사용자'),
                ),
                DropdownMenuItem(
                  value: 'admin',
                  child: Text('관리자'),
                ),
              ],
              onChanged: (value) {},

              decoration: CustomInputDecoration.basic(
                  hintText: '역할을 선택하세요.',
              ),
            ),
            const SizedBox(height: 16),
            const Text('이름'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: CustomInputDecoration.basic(
                hintText: '이름을 입력하세요.',
              ),
            ),
            const SizedBox(height: 16),
            const Text('비밀번호'),
            const SizedBox(height: 8),
            TextFormField(
              obscureText: true,
              decoration: CustomInputDecoration.basic(
                hintText: '비밀번호',
              ),
            ),
            const SizedBox(height: 16),
            const Text('비밀번호 확인'),
            const SizedBox(height: 8),
            TextFormField(
              obscureText: true,
              decoration: CustomInputDecoration.basic(
                hintText: '비밀번호 확인',
              ),
            ),
            const SizedBox(height: 16),
            const Text('이메일'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: CustomInputDecoration.basic(
                hintText: '이메일을 입력하세요.',
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: '회원가입',
              onPressed: () {
                print('회원가입 버튼 클릭');
              },
            ),
          ],
        ),
      ),
    );
  }
}