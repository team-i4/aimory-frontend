import 'package:flutter/cupertino.dart';

class TeacherNoticeListScreen extends StatelessWidget {
  const TeacherNoticeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("교사 공지사항 화면", style: TextStyle(fontSize: 24)),
    );
  }
}