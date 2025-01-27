import 'package:aimory_app/core/screens/tab_screen.dart';
import 'package:aimory_app/features/auth/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 추가

import 'features/auth/screens/signup_screen.dart';
import 'features/home/screens/parent_home_screen.dart';

void main() {
  runApp(
    const ProviderScope( // ProviderScope로 루트를 감쌈
      child: AimoryApp(),
    ),
  );
}

class AimoryApp extends StatelessWidget {
  const AimoryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'pretendard', // 기본 폰트 설정
        scaffoldBackgroundColor: Colors.white,
      ),
      // home: TabScreen(key: TabScreen.tabScreenKey),
      // home: SignInScreen(), // 시작 화면 설정
      initialRoute: '/signin', // 앱 시작 경로
      routes: {
        '/signin': (context) => const SignInScreen(), // 로그인 화면
        '/signup': (context) => const SignUpScreen(), // 회원가입 화면
      },
    );
  }
}