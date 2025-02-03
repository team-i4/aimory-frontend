import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';

class PhotoDetailScreen extends StatelessWidget {
  final String imageUrl; // 사진 URL
  final String title; // 제목
  final String date; // 날짜
  final String role; // 사용자 역할 (parent/teacher)

  const PhotoDetailScreen({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              date,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16.0,),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                // borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          if (role == 'teacher') // 역할이 'teacher'일 때만 삭제 버튼 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outlined, color: BLACK_COLOR),
                  onPressed: () {
                    // 삭제 기능 구현
                  },
                ),
                const SizedBox(width: 16.0),
              ],
            ),
        ],
      ),
    );
  }
}