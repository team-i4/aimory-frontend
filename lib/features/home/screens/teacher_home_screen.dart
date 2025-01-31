import 'package:aimory_app/core/const/colors.dart';
import 'package:aimory_app/features/notices/provider/notice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/screens/tab_screen.dart';
import '../../notices/screens/teacher_notice_detail_screen.dart';
import '../appbar/teacher_home_app_bar.dart';

class TeacherHomeScreen extends ConsumerWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeListAsync = ref.watch(noticeListProvider); // ✅ 공지사항 목록 Provider 호출

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
                  // ✅ TeacherHomeAppBar 포함
                  const TeacherHomeAppBar(),

                  // ✅ 공지사항 리스트
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ✅ 전체 공지사항 제목
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
                        const SizedBox(height: 20),

                        // ✅ 공지사항 API 연동
                        noticeListAsync.when(
                          data: (notices) => Container(
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
                              itemCount: notices.length, // ✅ API에서 가져온 데이터 개수
                              itemBuilder: (context, index) {
                                final notice = notices[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TeacherNoticeDetailScreen(noticeId: notice.id ?? 0),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white, // 배경색
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(notice.title),
                                          subtitle: Text(notice.title),
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
                          loading: () => Center(child: CircularProgressIndicator()), // ✅ 로딩 상태
                          error: (err, stack) => Center(child: Text("공지사항을 불러올 수 없습니다. 🚨")), // ✅ 에러 처리
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // ✅ 메인화면 광고 배너 부분
                  Container(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/img/banner_sample.png',
                      height: 90,
                    ),
                  ),

                  const SizedBox(height: 40.0,),

                  // ✅ 우리반 앨범 UI 유지
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "우리반 앨범",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {
                                TabScreen.tabScreenKey.currentState?.changeTab(3);
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

                        // ✅ 우리반 앨범 GridView 유지
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: 9, // ✅ 샘플 이미지 개수 유지
                          itemBuilder: (context, index) {
                            final photoUrl = 'https://static.rocketpunch.com/images/jibmusil/index/pc-section5-mood1-min.jpg';
                            return Container(
                              decoration: BoxDecoration(
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

                  const SizedBox(height: 40.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}