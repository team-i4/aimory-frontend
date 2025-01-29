import 'dart:io';
import 'package:aimory_app/core/const/colors.dart';
import 'package:aimory_app/core/util/secure_storage.dart';
import 'package:aimory_app/features/notes/models/note_model.dart';
import 'package:aimory_app/features/notes/services/note_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';
import '../../../core/widgets/multi_image_picker.dart';
import '../services/note_image_service.dart';

class NoteInsertScreen extends StatefulWidget {
  const NoteInsertScreen({Key? key}) : super(key: key);

  @override
  State<NoteInsertScreen> createState() => _NoteInsertScreenState();
}

class _NoteInsertScreenState extends State<NoteInsertScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<File> _selectedImages = [];
  String? _previewImageUrl; // ✅ AI 생성 이미지 URL
  bool _showPreviewImage = false; // ✅ AI 생성 이미지 표시 여부
  String? selectedChild;

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

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removePreviewImage() {
    setState(() {
      _previewImageUrl = null;
      _showPreviewImage = false;
    });
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
    }
  }

  /// ✅ **알림장 등록 API 호출**
  Future<void> _createNote() async {
    if (selectedChild == null || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("원아명과 내용을 입력하세요.")),
      );
      return;
    }

    String? token = await SecureStorage.readToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("로그인이 필요합니다.")),
      );
      return;
    }

    try {
      final NoteModel newNote = NoteModel(
        childId: int.parse(selectedChild!),
        content: _contentController.text.trim(),
        date: _dateController.text,
      );

      await _noteService.createNote(
        "Bearer $token",
        newNote,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("알림장이 성공적으로 등록되었습니다.")),
      );
      Navigator.pop(context);
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
                      DropdownMenuItem(value: '1', child: Text('아이 1')),
                      DropdownMenuItem(value: '2', child: Text('아이 2')),
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

            // ✅ 기존 이미지 리스트 유지
            if (_selectedImages.isNotEmpty)
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _selectedImages.asMap().entries.map((entry) {
                  int index = entry.key;
                  File image = entry.value;
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: MAIN_YELLOW,
                            child: Icon(Icons.close, color: MAIN_DARK_GREY, size: 14),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),

            // ✅ AI 그림 미리보기 유지
            if (_showPreviewImage && _previewImageUrl == null)
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey.shade300,
                    child: Image.asset('assets/img/notice_img_sample.jpg', fit: BoxFit.cover),
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
            MultiImagePicker(
              onImagesPicked: (pickedFiles) {
                setState(() {
                  _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
                });
              },
              builder: (context, pickImages) => ElevatedButton(
                onPressed: pickImages,
                style: ElevatedButton.styleFrom(backgroundColor: MAIN_YELLOW),
                child: const Text("사진 추가"),
              ),
            ),

            const SizedBox(height: 16),
            CustomButton(text: "등록하기", onPressed: _createNote),
          ],
        ),
      ),
    );
  }
}