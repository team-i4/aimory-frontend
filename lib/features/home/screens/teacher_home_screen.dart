import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';
import '../appbar/teacher_home_app_bar.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 스크롤 가능한 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TeacherHomeAppBar 포함
                  const TeacherHomeAppBar(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // 전체 알림장
                                Text(
                                  "전체 알림장",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "더보기",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: MAIN_DARK_GREY,
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                      color: MAIN_DARK_GREY,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 20,),
                            Container(
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: BORDER_GREY_COLOR, width: 1),
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 3, // 샘플 데이터 개수
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(0), // 카드 외부 여백
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white, // 배경색
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text("공지사항 제목 $index"),
                                          subtitle: Text("2024.05.26"),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                                          height: 1,
                                          color: BORDER_GREY_COLOR,
                                        ),
                                      ],
                                    ),

                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 우리반 앨범
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // 우리반 앨범
                                Text(
                                  "우리반 앨범",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "더보기",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: MAIN_DARK_GREY,
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                      color: MAIN_DARK_GREY,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: 9, // 샘플 이미지 개수
                              itemBuilder: (context, index) {
                                return Container(
                                  color: BORDER_GREY_COLOR, // 샘플 이미지
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 50,),
                      ],
                    ),
                  ),
                ],
              ),
              // child: Padding(
              //   padding: const EdgeInsets.all(16.0),

              ),
            ),
        ],
      ),
    );
  }
}