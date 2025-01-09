import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';

class NoteUpdateScreen extends StatefulWidget {
  const NoteUpdateScreen({Key? key}) : super(key: key);

  @override
  State<NoteUpdateScreen> createState() => _NoteUpdateScreenState();
}

class _NoteUpdateScreenState extends State<NoteUpdateScreen> {
  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _openCustomDatePicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
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
      body: Padding(
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
            const Text('file_name_01.jpg'),
            const Text('file_name_02.jpg'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
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
            const Spacer(),
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