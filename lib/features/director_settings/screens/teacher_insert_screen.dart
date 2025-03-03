import 'dart:developer';

import 'package:aimory_app/core/const/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';

class TeacherInsertScreen extends ConsumerWidget {
  const TeacherInsertScreen({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_YELLOW,
        centerTitle: true,
        title: const Text("담임교사 등록", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
        leading: IconButton(icon: const Icon(Icons.keyboard_backspace), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text('교사 이름'),
                const SizedBox(height: 8),
                TextFormField(
                  // controller: emailController,
                  decoration: CustomInputDecoration.basic(
                    hintText: '교사 이름을 입력하세요.',
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0), // 아이템 간 간격 추가
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12), // 둥근 테두리
                    border: Border.all(color: BORDER_GREY_COLOR, width: 1), // 개별 테두리
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 아이 이름
                      Text(
                        "김지은",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      // X 삭제 버튼
                      IconButton(
                        icon: Icon(Icons.close, color: MAIN_DARK_GREY),
                        onPressed: () {
                          // TODO: 삭제 리스너 달기
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                CustomButton(
                  text: '등록하기',
                  onPressed: () {
                    //TODO: 등록하기 이벤트 리스너
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