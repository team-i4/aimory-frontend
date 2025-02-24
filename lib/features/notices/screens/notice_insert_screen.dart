import 'dart:convert';
import 'dart:io';

import 'package:aimory_app/core/const/colors.dart';
import 'package:aimory_app/core/util/secure_storage.dart';
import 'package:aimory_app/core/widgets/custom_yellow_button.dart';
import 'package:aimory_app/features/notices/models/notice_model.dart';
import 'package:aimory_app/features/notices/services/notice_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';
import '../../../core/widgets/multi_image_picker.dart';
import 'package:dio/dio.dart';

// import '../../auth/providers/auth_provider.dart';
// import '../mock/notice_mock_interceptor.dart';
import '../provider/notice_provider.dart' as provider;
import '../services/notice_service.dart' as service;

class NoticeInsertScreen extends ConsumerStatefulWidget {
  final NoticeModel? notice; // 수정 시 기존 데이터를 받기 위한
  const NoticeInsertScreen({Key? key, this.notice}) : super(key: key);

  @override
  ConsumerState<NoticeInsertScreen> createState() => _NoticeInsertScreenState();
}

class _NoticeInsertScreenState extends ConsumerState<NoticeInsertScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<File> _selectedImages = [];
  int? _noticeId;

  @override void initState() {
    super.initState();
    if(widget.notice != null) {
      _noticeId = widget.notice!.id;
      _titleController.text = widget.notice!.title;
      _contentController.text = widget.notice!.content;
      _dateController.text = widget.notice!.date ?? "";

    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<List<MultipartFile>> _convertFilesToMultipart(List<File> files) async {
    return Future.wait(files.map((file) async {
      return await MultipartFile.fromFile(file.path, filename: file.path
          .split('/')
          .last);
    }));
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
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.purple),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: const Text(
                    "날짜 선택",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
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
                        _dateController.text = DateFormat('yyyy-MM-dd').format(
                            newDate);
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ✅ 공지사항 수정 함수
  Future<bool> _updateNotice(NoticeService noticeService) async {
    if (_noticeId == null) return false;

    String title = _titleController.text.trim();
    String content = _contentController.text.trim();
    String date = _dateController.text.trim();
    String? token = await SecureStorage.readToken();

    if (token == null || title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("필수 항목을 입력하세요.")));
      return false;
    }

    final noticeData = {
      "title": title,
      "content": content,
      "date": date.isNotEmpty ? date : null,
    };

    try {
      await noticeService.updateNotice("Bearer $token", _noticeId!, noticeData);
      await _showSuccessDialog("공지사항이 수정되었습니다.");
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("공지사항 수정 실패: $e")));
      return false;
    }
  }

  /// 🔹 기존의 _createNotice()를 _updateNotice()와 함께 사용하도록 변경
  Future<void> _onSubmit() async {
    final noticeService = ref.read(provider.noticeServiceProvider);

    bool isSuccess;
    if (_noticeId != null) {
      isSuccess = await _updateNotice(noticeService); // 🔹 수정하기
    } else {
      isSuccess = await _createNotice(noticeService); // 🔹 새로 생성
    }

    if (isSuccess) {
      ref.invalidate(noticeListProvider); // ✅ 공지사항 목록 새로고침
      Navigator.pop(context, true);
    }
  }

  /// ✅ 공지사항 생성 함수
  Future<bool> _createNotice(NoticeService noticeService) async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();
    String? date = _dateController.text.trim().isEmpty ? null : _dateController.text.trim();
    String? token = await SecureStorage.readToken();
    int? centerId = await SecureStorage.readCenterId();
    String? role = await SecureStorage.readUserRole();

    if (token == null || token.isEmpty || centerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("로그인이 필요합니다.")));
      return false;
    }

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("제목과 내용을 입력하세요.")));
      return false;
    }

    if (role != "TEACHER") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("선생님만 공지사항을 등록할 수 있습니다.")));
      return false;
    }

    bool? isConfirmed = await _showConfirmDialog();
    if (isConfirmed != true) return false;

    try {
      final notice = NoticeModel(centerId: centerId, title: title, content: content, date: date);
      final List<MultipartFile> multipartImages = await _convertFilesToMultipart(_selectedImages);
      final noticeJson = jsonEncode(notice.toJson());

      await noticeService.createNotice("Bearer $token", noticeJson, multipartImages);

      await _showSuccessDialog("공지사항 등록 성공하였습니다.");
      return true; // ✅ 성공 시 true 반환
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("공지사항 생성 실패: $e")));
      return false; // ✅ 실패 시 false 반환
    }
  }

  Future<bool?> _showConfirmDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          title: const Text(
              "공지사항 등록", style: TextStyle(color: DARK_GREY_COLOR)),
          content: const Text(
              "공지사항을 등록하시겠습니까?", style: TextStyle(color: DARK_GREY_COLOR)),
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

  /// 공지사항 등록 성공 다이얼로그
  Future<void> _showSuccessDialog(String s) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          title: const Text("공지사항 등록 완료", style: TextStyle(color: DARK_GREY_COLOR)),
          content: const Text("공지사항이 성공적으로 등록되었습니다.", style: TextStyle(color: DARK_GREY_COLOR)),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Navigator.pop(context); // ✅ 다이얼로그 닫기
                Navigator.pop(context, true); // ✅ 리스트 화면으로 이동 (true 반환)
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

  @override
  Widget build(BuildContext context) {
    final dio = ref.watch(provider.dioProvider);
    final _noticeService = NoticeService(dio);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: MAIN_YELLOW,
        centerTitle: true,
        title: Text(_noticeId == null ? "공지사항 등록" : "공지사항 수정",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
        leading: IconButton(icon: const Icon(Icons.keyboard_backspace),
            onPressed: () => Navigator.pop(context)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // ✅ 화면 터치하면 키보드 숨기기
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ✅ 키보드가 올라와도 UI가 자동 조정됨
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: CustomInputDecoration.basic(hintText: "날짜"),
                      onTap: () => _openCustomDatePicker(context),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: CustomInputDecoration.basic(
                          hintText: "제목을 입력하세요."),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contentController,
                      maxLines: 10,
                      decoration: CustomInputDecoration.basic(
                          hintText: "공지사항 내용을 써주세요."),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              // 이미지 추가 버튼 및 리스트
              if (_selectedImages.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _selectedImages
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    File image = entry.value;
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(image, width: 100,
                              height: 100,
                              fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: const CircleAvatar(radius: 10,
                                backgroundColor: MAIN_YELLOW,
                                child: Icon(Icons.close, color: MAIN_DARK_GREY,
                                    size: 14)),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MultiImagePicker(
                      onImagesPicked: (pickedFiles) {
                        setState(() {
                          _selectedImages.addAll(
                              pickedFiles.map((file) => File(file.path)));
                        });
                      },
                      builder: (context, pickImages) => CustomYellowButton(text: '사진추가', onPressed: pickImages),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: _noticeId == null ? "등록하기" : "수정하기",
                onPressed: () async {
                  ref.invalidate(provider.noticeListProvider); // ✅ provider에서 불러오기
                  final noticeService = NoticeService(dio); // ✅ NoticeService 인스턴스 생성

                  bool isSuccess = await _createNotice(noticeService);

                  if (isSuccess) {
                    ref.invalidate(noticeListProvider); // ✅ 기존 데이터 삭제
                    Navigator.pop(context, true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}