import 'package:flutter/material.dart';

import '../../../core/const/colors.dart';

class TeacherAlbumScreen extends StatelessWidget {
  const TeacherAlbumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: F4_GREY_COLOR,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // 버튼을 오른쪽 정렬
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const PhotoInsertScreen()),
                    // );
                  }, // 사진 추가 버튼 기능
                  label: const Text(
                    "사진 추가하기",
                    style: TextStyle(
                      color: DARK_GREY_COLOR,
                      fontSize: 14,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: MID_GREY_COLOR, // 테두리 색상
                        width: 1, // 테두리 두께
                      ),
                    ),
                  ),
                  icon: Icon(Icons.add, color: DARK_GREY_COLOR), // 아이콘 추가
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // 사진첩 그리드뷰
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 줄에 두 개의 아이템
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 1, // 정사각형 비율
              ),
              itemCount: 4, // 그리드 아이템 개수
              itemBuilder: (context, index) {
                final titles = ['전체(222)', '이채은(222)', '송유리(222)', '권재아(222)'];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 120,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 8),
                    Text(
                      titles[index],
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}