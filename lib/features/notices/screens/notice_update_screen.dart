import 'dart:convert';
import 'dart:io';

import 'package:aimory_app/core/const/colors.dart';
import 'package:aimory_app/core/util/secure_storage.dart';
import 'package:aimory_app/core/widgets/custom_yellow_button.dart';
import 'package:aimory_app/features/notices/models/notice_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';
import '../../../core/widgets/multi_image_picker.dart';
import 'package:dio/dio.dart';

import '../../auth/providers/auth_provider.dart';
import '../mock/notice_mock_interceptor.dart';

import '../provider/notice_provider.dart' as provider;
import '../services/notice_service.dart' as service;

class NoticeUpdateScreen extends ConsumerStatefulWidget {
  final NoticeModel? notice;
  const NoticeUpdateScreen({Key? key, this.notice}) : super(key: key);

  @override
  ConsumerState<NoticeUpdateScreen> createState() => _NoticeUpdateScreenState();
}

class _NoticeUpdateScreenState extends ConsumerState<NoticeUpdateScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int? _noticeId;

  @override
  void initState() {
    super.initState();
    if (widget.notice != null) {
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

  // Future<void> _onUpdatePressed() async {
  //
  //   bool? isConfirmed = await _showConfirmDialog();
  //   if (isConfirmed == true) {
  //     bool isSuccess = await _updateNotice(_noticeService);
  //     if (isSuccess) {
  //       await _showSuccessDialog();
  //     }
  //   }
  // }

  /// ✅ 공지사항 수정 함수
  Future<bool> _updateNotice(service.NoticeService noticeService) async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();
    String? date = _dateController.text.trim().isEmpty ? null : _dateController.text.trim();
    String? token = await SecureStorage.readToken();


    if (token == null || title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("필수 항목을 입력하세요.")));
      return false;
    }

    try {
      if (_noticeId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("공지사항 ID가 없습니다.")));
        return false;
      }

      // ✅ NoticeModel 객체 생성 후 toJson() 사용
      final updatedNotice = NoticeModel(
        id: _noticeId,
        centerId: widget.notice!.centerId,
        title: title,
        content: content,
        date: date,
        images: widget.notice!.images, // 기존 이미지 유지
      ).toJson();

      await noticeService.updateNotice("Bearer $token", _noticeId!, updatedNotice);
      await _showConfirmDialog();
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("공지사항 수정 실패: $e")));
      return false;
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
              "공지사항 수정", style: TextStyle(color: DARK_GREY_COLOR)),
          content: const Text(
              "공지사항을 수정하시겠습니까?", style: TextStyle(color: DARK_GREY_COLOR)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("취소", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.pop(context, true);
                _showSuccessDialog();
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

  /// ✅ 공지사항 수정 완료 다이얼로그
  Future<void> _showSuccessDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          title: const Text("공지사항 수정 완료", style: TextStyle(color: DARK_GREY_COLOR)),
          content: const Text("공지사항이 성공적으로 수정되었습니다.", style: TextStyle(color: DARK_GREY_COLOR)),
          actions: [
            ElevatedButton(
              onPressed: () {
                ref.invalidate(provider.noticeListProvider);
                Navigator.pop(context, true); // ✅ 다이얼로그 닫기 및 이전 화면으로 이동
                Navigator.pop(context, true); // ✅ 다이얼로그 닫기 및 이전 화면으로 이동
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
    final dio = ref.watch(dioProvider);
    final _noticeService = service.NoticeService(dio);

    // 🔹 공지사항 ID가 없으면 API 요청을 보내지 않음
    final noticeDetail = _noticeId == null
        ? null
        : ref.watch(provider.noticeDetailProvider(_noticeId!));


    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: MAIN_YELLOW,
        centerTitle: true,
        title: const Text("공지사항 수정",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
        leading: IconButton(icon: const Icon(Icons.keyboard_backspace),
            onPressed: () => Navigator.pop(context)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // ✅ 화면 터치하면 키보드 숨기기
        child: _noticeId == null
            ? Center(child: Text("공지사항 ID가 없습니다."))
            : noticeDetail!.when(
          data: (notice) {
            debugPrint("📌 공지사항 데이터: ${jsonEncode(notice.toJson())}"); // ✅ API 응답 JSON 출력

            // _titleController.text = notice.title;
            // _contentController.text = notice.content;
            // _dateController.text = notice.date ?? "";

            return SingleChildScrollView(
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

                  const SizedBox(height: 16),
                  CustomButton(
                    text: "수정하기",
                    onPressed: () async {
                      bool isSuccess = await _updateNotice(_noticeService);
                      if (isSuccess) {
                        ref.invalidate(provider.noticeListProvider); //  기존 공지사항 목록 새로고침
                        ref.invalidate(provider.noticeDetailProvider(_noticeId!)); //  공지사항 상세 정보도 새로고침
                        Navigator.pop(context, true);
                      }
                    },
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()), // 🔹 로딩 중 표시
          error: (err, stack) => Center(child: Text("공지사항을 불러올 수 없습니다.")), // 🔹 에러 표시
        ),

      ),
    );
  }
}