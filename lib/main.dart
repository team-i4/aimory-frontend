import 'package:aimory_app/core/screens/tab_screen.dart';
import 'package:aimory_app/features/auth/screens/signin_screen.dart';
import 'package:flutter/material.dart';

import 'features/home/screens/parent_home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'pretendard', // 기본 폰트 설정
        scaffoldBackgroundColor: Colors.white,
      ),
      home: TabScreen(key: TabScreen.tabScreenKey),
      // home: SignInScreen(),
    ),
  );
}
