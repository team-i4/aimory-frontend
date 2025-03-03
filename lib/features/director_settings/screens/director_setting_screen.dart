import 'dart:developer';

import 'package:aimory_app/core/const/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';
import 'center_setting_screen.dart';
import 'class_setting_screen.dart';

class DirectorSettingScreen extends ConsumerWidget {
  const DirectorSettingScreen({super.key});

  // Future<void> _showConfirmationDialog(
  //     BuildContext context, WidgetRef ref, SignupRequest request) async {
  //   // 키보드 포커스 해제
  //   FocusScope.of(context).unfocus();
  //   // 첫 번째 모달: 회원가입 완료 확인
  //   final bool? shouldProceed = await showDialog<bool>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder( // 모서리 둥글게 설정
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         backgroundColor: Colors.white, // 배경색 흰색
  //         title: const Text(
  //           '회원가입 확인',
  //           style: TextStyle(color: MAIN_DARK_GREY),
  //         ),
  //         content: const Text(
  //           '회원가입을 완료하시겠습니까?',
  //           style: TextStyle(color: MAIN_DARK_GREY),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context, false); // 취소 선택
  //             },
  //             child: const Text(
  //               '취소',
  //               style: TextStyle(color: MAIN_DARK_GREY),
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.pop(context, true); // 완료 선택
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: DARK_GREY_COLOR, // 완료 버튼 배경 검정
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8), // 버튼 모서리 둥글게
  //               ),
  //             ),
  //             child: const Text('완료', style: TextStyle(color: Colors.white)), // 글씨 흰색
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //
  //   if (shouldProceed == true) {
  //     // 회원가입 처리 중 로딩 모달 띄우기
  //     _showLoadingDialog(context);
  //
  //     try {
  //       // API 호출
  //       final authService = ref.read(authServiceProvider);
  //       final response = await authService.signup(request);
  //
  //       // 로딩 모달 닫기
  //       Navigator.pop(context);
  //
  //       // 성공 모달 띄우기
  //       await showDialog<void>(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             backgroundColor: Colors.white,
  //             title: const Text(
  //               '회원가입 성공',
  //               style: TextStyle(color: DARK_GREY_COLOR),
  //             ),
  //             content: Text(
  //               '${response.name}님, 회원가입이 완료되었습니다.',
  //               style: const TextStyle(color: DARK_GREY_COLOR),
  //             ),
  //             actions: [
  //               ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.pop(context); // 성공 모달 닫기
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: DARK_GREY_COLOR,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                 ),
  //                 child: const Text('확인', style: TextStyle(color: Colors.white)),
  //               ),
  //             ],
  //           );
  //         },
  //       );

  //       // 로그인 화면으로 이동
  //       Navigator.pushReplacementNamed(context, '/login');
  //     } catch (e) {
  //       // 에러 발생 시 처리
  //       Navigator.pop(context); // 로딩 모달 닫기
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('회원가입 실패: $e')),
  //       );
  //       log('회원가입 실패: $e', name: 'SignUp');
  //     }
  //   }
  // }

  // void _showLoadingDialog(BuildContext context) {
  //   // 로딩 모달
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // 로딩 중에는 닫을 수 없도록 설정
  //     builder: (BuildContext context) {
  //       return const Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     },
  //   );
  // }


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_YELLOW,
        centerTitle: true,
        title: const Text("관리자 설정", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
        leading: IconButton(icon: const Icon(Icons.keyboard_backspace), onPressed: () => Navigator.pop(context)),
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
                Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: MAIN_LIGHT_YELLOW,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: BORDER_GREY_COLOR, width: 1),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("소속", style: TextStyle(fontSize: 16),),
                        SizedBox(height: 8),
                        Text("햇님어린이집", style: TextStyle(fontSize: 18),),
                        SizedBox(height: 16),
                        Text("연락처", style: TextStyle(fontSize: 16),),
                        SizedBox(height: 8),
                        Text("02-2222-2222", style: TextStyle(fontSize: 18),),
                        SizedBox(height: 16),
                        Text("반", style: TextStyle(fontSize: 16),),
                        SizedBox(height: 8),
                        Text("장미반 구름반 햇님반 달님반", style: TextStyle(fontSize: 18),),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: '어린이집 설정',
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CenterSettingScreen()),
                    );
                  },
                ),
                const SizedBox(height: 8,),
                CustomButton(
                  text: '반 설정',
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ClassSettingScreen()),
                    );
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