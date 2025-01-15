import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';

class TeacherPhotoListScreen extends StatelessWidget {

  final String childName; // 원아 이름
  final int photoCount; // 원아 사진 개수
  final List<String> photos; // 사진 URL 리스트

  const TeacherPhotoListScreen({
    Key? key,
    required this.childName,
    required this.photoCount,
    required this.photos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '사진첩',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 정보 (사진 개수, 원아 이름)
            Text(
              '$photoCount개',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              childName,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // 사진 ListView
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 한 줄에 세 개의 사진
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: LIGHT_GREY_COLOR, // 기본 배경색
                      image: photos[index].isNotEmpty
                          ? DecorationImage(
                        image: AssetImage(photos[index]), // 로컬 이미지 표시
                        fit: BoxFit.cover,
                      )
                          : null, // 사진이 없는 경우 빈 박스
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}