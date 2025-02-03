import 'package:aimory_app/core/screens/tab_screen.dart';
import 'package:aimory_app/features/auth/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 추가

import 'core/util/secure_storage.dart';
import 'features/auth/screens/signup_screen.dart';

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
      home: FutureBuilder<String?>(
        future: SecureStorage.readToken(), // 저장된 JWT 토큰 확인
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터를 불러오는 동안 로딩 표시
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            // 토큰이 있으면 홈 화면으로 이동
            return const TabScreen(); // 홈 화면
          }
          // 토큰이 없으면 로그인 화면 표시
          return const SignInScreen();
        },
      ),
      initialRoute: '/login', // 앱 시작 경로
      routes: {
        '/login': (context) => const SignInScreen(), // 로그인 화면
        '/signup': (context) => const SignUpScreen(), // 회원가입 화면
        '/home': (context) => const TabScreen(),
      },
    );
  }
}