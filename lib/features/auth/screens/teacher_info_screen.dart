import 'package:flutter/cupertino.dart';

class TeacherInfoScreen extends StatelessWidget {
  const TeacherInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("학부모 정보 수정 화면", style: TextStyle(fontSize: 24)),
    );
  }
}