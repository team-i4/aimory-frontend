import 'package:flutter/material.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("학부모 홈 화면", style: TextStyle(fontSize: 24)),
    );
  }
}