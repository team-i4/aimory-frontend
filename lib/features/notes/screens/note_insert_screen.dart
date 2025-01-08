import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';

class NoteInsertScreen extends StatefulWidget {
  const NoteInsertScreen({Key? key}) : super(key: key);

  @override
  State<NoteInsertScreen> createState() => _NoteInsertScreenState();
}

class _NoteInsertScreenState extends State<NoteInsertScreen> {
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
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
                    onTap: () => _selectDate(context),
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