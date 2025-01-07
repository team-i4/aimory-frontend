import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';
import '../appbar/parent_home_app_bar.dart';
import '../appbar/teacher_home_app_bar.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({Key? key}) : super(key: key);

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
                  const ParentHomeAppBar(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                    child: Column(
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
                  ),
                  // 메인화면 광고 배너 부분
                  Container(
                    child: Image.asset(
                      'assets/img/banner_sample.png', // 로고 이미지 경로
                      height: 90,
                    ),
                  ),

                  const SizedBox(height: 40.0,),

                  // 우리아이 알림장
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 우리아이 알림장 타이틀 / 더보기 버튼
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "우리아이 알림장",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            Row(
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
                        const SizedBox(height: 20.0),

                        // 가로 스크롤 리스트
                        SizedBox(
                          height: 200, // 높이 제한
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: BORDER_GREY_COLOR, width: 1),
                                    ),
                                    width: 200, // 카드 너비
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 24,
                                              backgroundImage: AssetImage('assets/img/girl_sample.jpg'), // 샘플 이미지
                                            ),
                                            const SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "이채아",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  "해바라기 반",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: MAIN_DARK_GREY,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Divider(), // 구분선
                                        const SizedBox(height: 8),
                                        Text(
                                          "오늘 우리 채아는 오전 간식을 아주 잘 먹고 나서 활기차게 놀이를 즐기며 시간을 보냈습니다.",
                                          style: TextStyle(fontSize: 14),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
                  ),
                  const SizedBox(height: 40.0,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 우리반 앨범
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 우리반 앨범
                            Text(
                              "우리아이 앨범",
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
                  ),

                  const SizedBox(height: 40.0,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}