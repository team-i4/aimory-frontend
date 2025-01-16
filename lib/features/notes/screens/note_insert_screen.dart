import 'dart:io';

import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';
import '../../../core/widgets/multi_image_picker.dart';

class NoteInsertScreen extends StatefulWidget {
  const NoteInsertScreen({Key? key}) : super(key: key);

  @override
  State<NoteInsertScreen> createState() => _NoteInsertScreenState();
}

class _NoteInsertScreenState extends State<NoteInsertScreen> {
  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<File> _selectedImages = [];

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _openCustomDatePicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true, // 화면 크기에 따라 모달 높이 조정 가능
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MID_GREY_COLOR, // 선택된 날짜 색상
              onPrimary: Colors.white, // 선택된 날짜의 텍스트 색상
              onSurface: BLACK_COLOR, // 기본 텍스트 색상
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.purple, // "취소", "확인" 버튼 색상
              ),
            ),
          ),
          child: SingleChildScrollView( // 스크롤 가능하도록
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: const Text(
                    "날짜 선택",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 360, // 달력 높이 조절
                  child: CalendarDatePicker(
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    onDateChanged: (DateTime newDate) {
                      setState(() {
                        _selectedDate = newDate;
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(newDate); // 날짜 포맷 변경
                      });
                      Navigator.pop(context); // 날짜 선택 후 모달 닫기
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_YELLOW,
        centerTitle: true,
        title: const Text(
          '알림장',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                    decoration: CustomInputDecoration.basic(
                      hintText: '반분류',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'option1', child: Text('Option 1')),
                      DropdownMenuItem(value: 'option2', child: Text('Option 2')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: CustomInputDecoration.basic(
                      hintText: '날짜',
                    ),
                    onTap: () => _openCustomDatePicker(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 10,
              decoration: CustomInputDecoration.basic(
                hintText: '알림장 내용을 써주세요.',
              ),
            ),
            const SizedBox(height: 16),
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
                            child: Icon(
                              Icons.close,
                              color: MAIN_DARK_GREY,
                              size: 14,
                            ),
                          ),
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
                        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
                      });
                    },
                    builder: (context, pickImages) => ElevatedButton(
                      onPressed: pickImages,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        backgroundColor: MAIN_YELLOW,
                        foregroundColor: BLACK_COLOR,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('사진추가'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      backgroundColor: BLACK_COLOR,
                      foregroundColor: MAIN_YELLOW,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('AI 그림 생성'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: '사진 등록하기',
              onPressed: () {
                print('사진 등록하기 버튼 클릭');
              },
            ),
          ],
        ),
      ),
    );
  }
}
