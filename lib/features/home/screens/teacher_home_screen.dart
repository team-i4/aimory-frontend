import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';
import '../../../core/screens/tab_screen.dart';
import '../../notices/models/notice_model.dart';
import '../../notices/screens/teacher_notice_detail_screen.dart';
import '../../notices/screens/teacher_notice_list_screen.dart';
import '../../photos/screens/teacher_album_screen.dart';
import '../appbar/teacher_home_app_bar.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final List<Notice> noticeItems = List.generate(
      3, // 3개의 샘플 데이터만 표시
          (index) => Notice(
        name: '원장 $index',
        date: '2025.01.0${index + 1}',
        description:
        '오늘 우리 채아는 오전 간식을 아주 잘 먹고 나서 활기차게 놀이를 즐기며 시간을 보냈어요.',
        imageUrl: 'assets/img/notice_img_sample.jpg',
      ),
    );

    // 우리반 앨범 샘플 데이터를 정의
    final List<String> allPhotos = List.generate(
      9,
          (index) => 'https://static.rocketpunch.com/images/jibmusil/index/pc-section5-mood1-min.jpg',
    );

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
                  // 전체 알림장
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
                              "공지사항",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {
                                TabScreen.tabScreenKey.currentState?.changeTab(1); // "공지사항" 탭으로 이동
                              },
                              child: Row(
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
                            itemCount: noticeItems.length, // 데이터 개수
                            itemBuilder: (context, index) {
                              final notice = noticeItems[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TeacherNoticeDetailScreen(notice: notice),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(0), // 카드 외부 여백
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white, // 배경색
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(notice.name),
                                        subtitle: Text(notice.date),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                                        height: 1,
                                        color: BORDER_GREY_COLOR,
                                      ),
                                    ],
                                  ),
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
                    width: double.infinity,
                    child: Image.asset(
                      'assets/img/banner_sample.png', // 로고 이미지 경로
                      height: 90,
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
                              "우리반 앨범",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {
                                TabScreen.tabScreenKey.currentState?.changeTab(3); // "사진첩" 탭으로 이동
                              },
                              child: Row(
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
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: allPhotos.length, // 샘플 이미지 개수
                          itemBuilder: (context, index) {
                            final photoUrl = allPhotos[index];
                            return Container(decoration: BoxDecoration(
                              color: LIGHT_GREY_COLOR,
                              image: DecorationImage(
                                image: NetworkImage(photoUrl),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
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