import 'package:flutter/cupertino.dart';

class ParentNoticeListScreen extends StatelessWidget {
  const ParentNoticeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("학부모 공지사항 화면", style: TextStyle(fontSize: 24)),
    );
  }
}