import 'package:flutter/material.dart';

import '../../../core/const/colors.dart';
import '../../../core/widgets/swipe_to_delete.dart';

class TeacherNoteListScreen extends StatefulWidget {
  @override

  _TeacherNoteListScreen createState() => _TeacherNoteListScreen();
}

class _TeacherNoteListScreen extends State<TeacherNoteListScreen> {
  List<String> items = List.generate(13, (index) => '이채아');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: F4_GREY_COLOR,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '16개',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {}, // 알림장 추가 버튼 기능
                    icon: const Icon(Icons.add, size: 14, color: DARK_GREY_COLOR),
                    label: const Text(
                      "알림장 작성하기",
                      style: TextStyle(
                          color: DARK_GREY_COLOR,
                          fontSize: 12
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0,),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return SwipeToDelete(
                  onDelete: () {
                    setState(() {
                      items.removeAt(index);
                    });
                  },
                  child : Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: BORDER_GREY_COLOR, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/img/girl_sample.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 15.0,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "이채아",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "2025.01.05",
                                style: TextStyle(fontSize: 12, color: LIGHT_GREY_COLOR),
                              ),
                              Text(
                                "오늘 우리 채아는 오전 간식을 아주 잘 먹고 나서 활기차게 놀이를 즐기며 시간을 보냈어요. 블록을 쌓고 무너뜨리며 상상력을 발휘했고, 동생과 함께 장난감 기차를 가지고 놀면서 사이좋게 웃음소리도 가득했답니다.",
                                style: TextStyle(fontSize: 14),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.more_vert, size: 16.0,),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class zzzzz {
}