import 'dart:io';

import 'package:aimory_app/core/const/colors.dart';
import 'package:aimory_app/features/auth/screens/teacher_info_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/util/auth_interceptor.dart';
import '../../../core/util/secure_storage.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';
import '../../../core/widgets/photo_picker.dart';
import '../models/class_model.dart';
import '../services/class_service.dart';

class CenterInfoInsertScreen extends StatefulWidget {
  const CenterInfoInsertScreen({Key? key}) : super(key: key);

  @override
  State<CenterInfoInsertScreen> createState() => _CenterInfoInsertScreenState();
}

class _CenterInfoInsertScreenState extends State<CenterInfoInsertScreen> {
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _centerController = TextEditingController();
  File? _selectedImage;
  final Dio _dio = Dio();
  late ClassService _classService;

  @override
  void initState() {
    super.initState();
    _dio.interceptors.add(AuthInterceptor(dio: _dio)); // Access Token 자동 추가
    _classService = ClassService(_dio);
  }

  @override
  void dispose() {
    _classController.dispose();
    _centerController.dispose();
    super.dispose();
  }

  // 반 생성 요청 함수 (AlertDialog 확인 후 실행)
  Future<void> _createClass() async {
    String className = _classController.text.trim();
    String centerName = _centerController.text.trim();
    String? token = await SecureStorage.readToken();
    int? teacherId = await SecureStorage.readTeacherId(); // 저장된 teacherId 가져오기

    if (className.isEmpty || centerName.isEmpty || token == null || teacherId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("소속과 반 이름을 입력하세요.")),
      );
      return;
    }

    try {
      final request = CreateClassRequest(name: className, teacherId: teacherId);
      final response = await _classService.createClass(teacherId, request);

      // 성공하면 AlertDialog로 메시지 표시 후 TeacherInfoScreen으로 이동
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.white,
            title: const Text(
              '반 생성 완료',
              style: TextStyle(color: DARK_GREY_COLOR),
            ),
            content: Text(
              '${response.name} 반이 생성되었습니다.',
              style: const TextStyle(color: DARK_GREY_COLOR),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // ✅ AlertDialog 닫기
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TeacherInfoScreen()), // ✅ TeacherInfoScreen으로 이동
                  );
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("반 생성 실패: $e")),
      );
    }
  }

  // 등록 버튼 클릭 시 실행 → AlertDialog 표시
  Future<void> _showConfirmDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            '반 생성 확인',
            style: TextStyle(color: DARK_GREY_COLOR),
          ),
          content: const Text(
            '정말 반을 생성하시겠습니까?',
            style: TextStyle(color: DARK_GREY_COLOR),
          ),
          actions: [
            // 취소 버튼: AlertDialog 닫고 뒤로 가기
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // 뒤로 가기
              },
              child: const Text(
                '취소',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            // 확인 버튼: 반 생성 요청 실행
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // AlertDialog 닫기
                _createClass(); // 반 생성 실행
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '소속 정보 등록',
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
            const Text('소속 (어린이집)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _centerController,
              decoration: CustomInputDecoration.basic(
                hintText: '소속을 입력하세요.',
              ),
            ),
            const SizedBox(height: 16),
            const Text('반'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _classController,
              decoration: CustomInputDecoration.basic(
                hintText: '해당 반을 입력하세요.',
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: '등록하기',
              onPressed: _showConfirmDialog, // 등록 버튼 클릭 시 AlertDialog 표시
            ),
          ],
        ),
      ),
    );
  }
}