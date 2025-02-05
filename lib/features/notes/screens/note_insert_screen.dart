import 'dart:io';
import 'package:aimory_app/core/const/colors.dart';
import 'package:aimory_app/core/util/secure_storage.dart';
import 'package:aimory_app/core/widgets/custom_yellow_button.dart';
import 'package:aimory_app/features/notes/models/note_model.dart';
import 'package:aimory_app/features/notes/services/note_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';
import '../provider/note_provider.dart';
import '../services/note_image_service.dart';

class NoteInsertScreen extends ConsumerStatefulWidget {
  const NoteInsertScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NoteInsertScreen> createState() => _NoteInsertScreenState();
}

class _NoteInsertScreenState extends ConsumerState<NoteInsertScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _previewImageUrl; // ✅ AI 생성 이미지 URL
  bool _showPreviewImage = false; // ✅ AI 생성 이미지 표시 여부
  String? selectedChild;
  bool _isLoading = false; // ✅ AI 그림 생성 로딩 상태 변수

  final Dio _dio = Dio();
  late NoteService _noteService;
  late NoteImageService _noteImageService;

  @override
  void initState() {
    super.initState();
    _noteService = NoteService(_dio);
    _noteImageService = NoteImageService(_dio);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _removePreviewImage() {
    setState(() {
      _previewImageUrl = null;
      _showPreviewImage = false;
    });
  }

  /// ✅ 알림장 등록 확인 다이얼로그
  Future<bool?> _showRegisterConfirmDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          title: const Text("알림장 등록", style: TextStyle(color: DARK_GREY_COLOR)),
          content: const Text("알림장을 등록하시겠습니까?", style: TextStyle(color: DARK_GREY_COLOR)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("취소", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: DARK_GREY_COLOR,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("확인", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  /// ✅ 알림장 등록 성공 다이얼로그
  Future<void> _showRegisterSuccessDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          title: const Text("알림장 등록 완료", style: TextStyle(color: DARK_GREY_COLOR)),
          content: const Text("알림장이 성공적으로 등록되었습니다.", style: TextStyle(color: DARK_GREY_COLOR)),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DARK_GREY_COLOR,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("확인", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _openCustomDatePicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MID_GREY_COLOR,
              onPrimary: Colors.white,
              onSurface: BLACK_COLOR,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: const Text("날짜 선택", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              SizedBox(
                height: 360,
                child: CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                      _dateController.text = DateFormat('yyyy-MM-dd').format(newDate);
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ✅ **AI 그림 생성 API 호출**
  Future<void> _generateAiImage() async {
    if (selectedChild == null || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("원아명과 내용을 입력하세요.")),
      );
      return;
    }

    setState(() {
      _isLoading = true; // ✅ 로딩 상태 시작
    });


    try {
      String? token = await SecureStorage.readToken();
      if (token == null) {
        throw Exception("로그인이 필요합니다.");
      }

      final response = await _noteImageService.generateAiImage(
        "Bearer $token",
        {
          "childId": int.parse(selectedChild!),
          "content": _contentController.text.trim(),
        },
      );

      setState(() {
        _previewImageUrl = response.image;
        _showPreviewImage = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("AI 그림 생성 실패: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // ✅ 로딩 상태 종료
      });
    }
  }

  /// ✅ **알림장 등록 API 호출 (Provider 사용)**
  Future<void> _createNote() async {
    if (selectedChild == null || _contentController.text.trim().isEmpty || _previewImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("필수 항목을 입력하세요.")),
      );
      return;
    }

    final requestData = {
      "childId": int.parse(selectedChild!),
      "content": _contentController.text.trim(),
      "date": _dateController.text,
      "image": _previewImageUrl!,
    };


    final confirm = await _showRegisterConfirmDialog();

    try {
      await ref.read(noteCreateProvider(requestData).future);

      await _showRegisterSuccessDialog();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("알림장이 성공적으로 등록되었습니다.")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("알림장 등록 실패: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_YELLOW,
        centerTitle: true,
        title: const Text("알림장", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
        leading: IconButton(icon: const Icon(Icons.keyboard_backspace), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: CustomInputDecoration.basic(hintText: '원아명'),
                    items: const [
                      DropdownMenuItem(value: '2', child: Text('신승훈')),
                      DropdownMenuItem(value: '3', child: Text('성보미')),
                      DropdownMenuItem(value: '4', child: Text('박선영')),
                      DropdownMenuItem(value: '5', child: Text('문수현')),
                    ],
                    onChanged: (value) => setState(() => selectedChild = value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: CustomInputDecoration.basic(hintText: '날짜'),
                    onTap: () => _openCustomDatePicker(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              maxLines: 10,
              decoration: CustomInputDecoration.basic(hintText: '알림장 내용을 써주세요.'),
            ),
            const SizedBox(height: 16),

            // ✅ AI 그림 미리보기 유지
            if (_showPreviewImage && _previewImageUrl != null)
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(_previewImageUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _removePreviewImage,
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: MAIN_YELLOW,
                        child: Icon(Icons.close, color: MAIN_DARK_GREY, size: 16),
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 16),

            CustomYellowButton(text: 'AI 그림 생성', onPressed: _generateAiImage),

            const SizedBox(height: 16),
            CustomButton(text: "등록하기", onPressed: _createNote),
          ],
        ),
      ),
    );
  }
}