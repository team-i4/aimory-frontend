import 'dart:io';

import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';
import '../../../core/widgets/photo_picker.dart';

class CenterInfoUpdateScreen extends StatefulWidget {
  const CenterInfoUpdateScreen({Key? key}) : super(key: key);

  @override
  State<CenterInfoUpdateScreen> createState() => _CenterInfoUpdateScreenState();
}

class _CenterInfoUpdateScreenState extends State<CenterInfoUpdateScreen> {
  final TextEditingController _dateController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '소속 정보 수정',
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhotoPicker(
              onImagePicked: (image) {
                setState(() {
                  _selectedImage = image;
                });
              },
              builder: (context, image) {
                return Center(
                  heightFactor: 1.5,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    backgroundImage: image != null ? FileImage(image) : null,
                    child: image == null
                        ? const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    )
                        : null,
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
            const Text('소속'),
            const SizedBox(height: 8),

            TextFormField(
              readOnly: true, // 수정 불가능하도록 설정
              initialValue: null, // TODO: 유저 이름 데이터 표시
              decoration: CustomInputDecoration.basic(
                hintText: '현재 소속',
              ),
            ),
            const SizedBox(height: 16),
            const Text('반'),
            const SizedBox(height: 8),
            TextFormField(
              obscureText: true,
              decoration: CustomInputDecoration.basic(
                hintText: '해당 반',
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: '수정하기',
              onPressed: () {
                // TODO : 클릭 시 이벤트
                print('수정하기 버튼 클릭');
              },
            ),
          ],
        ),
      ),
    );
  }
}
