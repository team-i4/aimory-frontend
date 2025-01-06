import 'package:flutter/cupertino.dart';

class ParentNoteListScreen extends StatelessWidget {
  const ParentNoteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("학부모 알림장 화면", style: TextStyle(fontSize: 24)),
    );
  }
}