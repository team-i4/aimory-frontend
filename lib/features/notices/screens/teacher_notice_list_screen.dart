import 'package:aimory_app/features/notices/screens/teacher_notice_detail_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/const/colors.dart';
import '../../../core/widgets/swipe_to_delete.dart';
import '../models/notice_model.dart';
import 'notice_insert_screen.dart';

class TeacherNoticeListScreen extends StatefulWidget {
  @override
  _TeacherNoticeListScreenState createState() => _TeacherNoticeListScreenState();
}

class _TeacherNoticeListScreenState extends State<TeacherNoticeListScreen> {
  // Notice 데이터 리스트 생성
  List<Notice> items = List.generate(
    13,
        (index) => Notice(
      name: '원장 $index', // 이름
      date: '2025.01.0${index + 1}', // 날짜
      description:
      '오늘 우리 채아는 오전 간식을 아주 잘 먹고 나서 활기차게 놀이를 즐기며 시간을 보냈어요. 블록을 쌓고 무너뜨리며 상상력을 발휘했고, 동생과 함께 장난감 기차를 가지고 놀면서 사이좋게 웃음소리도 가득했답니다.',
      imageUrl: 'assets/img/notice_img_sample.jpg', // 이미지 URL
    ),
  );

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
                  '${items.length}개', // 공지사항 개수
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NoticeInsertScreen()),
                      );
                    }, // 공지사항 추가 버튼 기능
                    label: const Text(
                      "공지사항 작성하기",
                      style: TextStyle(
                          color: DARK_GREY_COLOR,
                          fontSize: 14
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: MID_GREY_COLOR, // 테두리 색상
                            width: 1, // 테두리 두께
                          )
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
                      // 삭제 기능 구현
                      items.removeAt(index); // 리스트에서 아이템 삭제
                    });
                  },
                  child: GestureDetector(
                    // 리스트 아이템 클릭 시 NoteDetailScreen으로 이동
                    onTap: () async {
                      // 삭제 상태 확인 후 리스트에서 삭제
                      bool? isDeleted = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TeacherNoticeDetailScreen(notice: items[index]),
                        ),
                      );

                      if (isDeleted == true) {
                        setState(() {
                          items.removeAt(index); // 삭제된 항목 리스트에서 제거
                        });
                      }
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
                        children: [// 이미지
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              items[index].imageUrl, // 이미지 URL
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 15.0,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items[index].name,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  items[index].date,
                                  style: TextStyle(fontSize: 12, color: LIGHT_GREY_COLOR),
                                ),
                                Text(
                                  items[index].description,
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