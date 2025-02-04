import 'package:flutter/material.dart';

import '../const/colors.dart';

class CustomYellowButton extends StatelessWidget {
  final String text; // 버튼 텍스트
  final VoidCallback onPressed; // 버튼 동작

  const CustomYellowButton({
    Key? key,
    required this.text,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: MAIN_YELLOW,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: DARK_GREY_COLOR,
          ), // 기본 텍스트 스타일,
        ),
      ),
    );
  }
}