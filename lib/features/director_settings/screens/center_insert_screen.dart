import 'dart:developer';

import 'package:aimory_app/core/const/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';

class CenterInsertScreen extends ConsumerWidget {
  const CenterInsertScreen({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_YELLOW,
        centerTitle: true,
        title: const Text("어린이집 정보 등록", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
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
                const Text('소속'),
                const SizedBox(height: 8),
                TextFormField(
                  // controller: emailController,
                  decoration: CustomInputDecoration.basic(
                    hintText: '어린이집명을 입력하세요.',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('연락처'),
                const SizedBox(height: 8),
                TextFormField(
                  // controller: nameController,
                  decoration: CustomInputDecoration.basic(
                    hintText: '연락처을 입력하세요.',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('주소'),
                const SizedBox(height: 8),
                TextFormField(
                  // controller: passwordController,
                  obscureText: true,
                  decoration: CustomInputDecoration.basic(
                    hintText: '주소를 입력하세요.',
                  ),
                ),

                const SizedBox(height: 24),
                CustomButton(
                  text: '어린이집 등록하기',
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