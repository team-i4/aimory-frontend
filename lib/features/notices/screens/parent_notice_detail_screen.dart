import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';
import '../models/notice_model.dart';

class ParentNoticeDetailScreen extends StatelessWidget {

  final Notice notice; // Notice 데이터 전달받음
  // 생성자에서 Note 데이터 초기화
  const ParentNoticeDetailScreen({Key? key, required this.notice}) : super(key: key);


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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  notice.date, // 전달받은 Notice 데이터의 날짜 표시
                  style: TextStyle(fontSize: 16, color: LIGHT_GREY_COLOR),
                ),
                SizedBox(width: 10.0,),
              ],
            ),

            SizedBox(height: 16),
            Text(
              notice.name, // 전달받은 Note 데이터의 이름 표시
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                notice.imageUrl, // 전달받은 Note 데이터의 이미지 URL
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 16),
            Text(
              notice.description, // 전달받은 Note 데이터의 설명 표시
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}